package com.campus.secondhand.common;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

/** Controller 中使用 @Valid @ModelAttribute 绑定。 */
public class PageQuery {
    @Min(1)
    private int page = 1;
    @Min(1)
    @Max(50)
    private int pageSize = 10;

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public long getOffset() { return ((long) page - 1) * pageSize; }
}
