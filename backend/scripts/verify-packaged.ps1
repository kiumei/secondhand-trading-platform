#Requires -Version 7.0
[CmdletBinding()]
param(
    [string]$JarPath = (Join-Path $PSScriptRoot '../target/secondhand-backend-0.0.1-SNAPSHOT.jar')
)
$ErrorActionPreference = 'Stop'
$jar = (Resolve-Path -LiteralPath $JarPath).Path
$java = (Get-Command java -ErrorAction Stop).Source
$logDirectory = Join-Path (Split-Path $jar -Parent) 'packaged-verification'
New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
$runId = [Guid]::NewGuid().ToString('N')
$stdout = Join-Path $logDirectory ($runId + '.stdout.log')
$stderr = Join-Path $logDirectory ($runId + '.stderr.log')
$process = $null
function Assert-Response($Response, [int]$Status, [string]$Code) {
    if ([int]$Response.StatusCode -ne $Status) { throw "Expected HTTP $Status, got $($Response.StatusCode)" }
    $body = $Response.Content | ConvertFrom-Json
    if ($body.code -ne $Code) { throw "Expected code $Code, got $($body.code)" }
    return $body
}
try {
    $process = Start-Process -FilePath $java -ArgumentList @('-jar', ('"' + $jar + '"'),
        '--spring.profiles.active=local', '--server.address=127.0.0.1', '--server.port=0') `
        -PassThru -WindowStyle Hidden -RedirectStandardOutput $stdout -RedirectStandardError $stderr
    $deadline = [DateTime]::UtcNow.AddSeconds(45)
    $baseUrl = $null
    while ([DateTime]::UtcNow -lt $deadline) {
        $process.Refresh()
        if ($process.HasExited) { throw "Application exited before startup; inspect $stdout and $stderr" }
        $log = Get-Content -LiteralPath $stdout -Raw -ErrorAction SilentlyContinue
        if ($log -match 'Tomcat started on port (\d+)') {
            $baseUrl = 'http://127.0.0.1:' + $Matches[1]
            break
        }
        Start-Sleep -Milliseconds 200
    }
    if (-not $baseUrl) { throw "Startup timed out; inspect $stdout and $stderr" }
    $health = Assert-Response (Invoke-WebRequest "$baseUrl/api/health" -TimeoutSec 5 -SkipHttpErrorCheck) 200 'OK'
    if ($health.data.status -ne 'UP') { throw 'Health status is not UP' }
    $csrf = Assert-Response (Invoke-WebRequest "$baseUrl/api/auth/csrf" -SessionVariable browser -TimeoutSec 5 -SkipHttpErrorCheck) 200 'OK'
    if (-not $csrf.data.token -or -not $csrf.data.headerName) { throw 'CSRF response is incomplete' }
    Assert-Response (Invoke-WebRequest "$baseUrl/api/users/me" -WebSession $browser -TimeoutSec 5 -SkipHttpErrorCheck) 401 'UNAUTHENTICATED' | Out-Null
    Assert-Response (Invoke-WebRequest "$baseUrl/api/auth/logout" -Method Post -WebSession $browser -TimeoutSec 5 -SkipHttpErrorCheck) 403 'FORBIDDEN' | Out-Null
    $headers = @{}
    $headers[$csrf.data.headerName] = $csrf.data.token
    Assert-Response (Invoke-WebRequest "$baseUrl/api/auth/logout" -Method Post -Headers $headers -WebSession $browser -TimeoutSec 5 -SkipHttpErrorCheck) 200 'OK' | Out-Null
    Assert-Response (Invoke-WebRequest "$baseUrl/api/auth/logout" -Method Post -Headers $headers -WebSession $browser -TimeoutSec 5 -SkipHttpErrorCheck) 403 'FORBIDDEN' | Out-Null
    $renewed = Assert-Response (Invoke-WebRequest "$baseUrl/api/auth/csrf" -WebSession $browser -TimeoutSec 5 -SkipHttpErrorCheck) 200 'OK'
    if ($renewed.data.token -eq $csrf.data.token) { throw 'Logout did not invalidate CSRF token' }
    [pscustomobject]@{
        result = 'PASS'
        jar = $jar
        profile = 'local'
        checks = @('packaged-startup', 'health', 'csrf', 'unauthorized-json', 'csrf-required', 'logout', 'old-token-rejected', 'new-token')
        databaseVerified = $false
        stdout = $stdout
        stderr = $stderr
    } | ConvertTo-Json -Depth 3
}
finally {
    if ($null -ne $process) {
        $process.Refresh()
        if (-not $process.HasExited) {
            $process.Kill($true)
            if (-not $process.WaitForExit(5000)) {
                throw "Unable to stop packaged application PID $($process.Id)"
            }
        }
        $process.Dispose()
    }
}
