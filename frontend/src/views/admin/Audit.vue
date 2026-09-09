<script setup lang="ts">
import { ref, onMounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { listGoods, updateGoodsStatus, updateGoods } from '@/api/goods'
import { getUser } from '@/api/user'
import { categoryGroups } from '@/constants/categories'
import type { Goods, TradeType, QualityLevel } from '@/types'

const goods = ref<Goods[]>([])
const sellers = ref<Record<string, string>>({})
const loading = ref(false)

const statusText: Record<number, string> = {
  0: '待审核',
  1: '上架',
  2: '已下架',
  3: '已售出',
  4: '已驳回',
}
const statusType: Record<number, 'success' | 'info' | 'warning' | 'danger'> = {
  0: 'warning',
  1: 'success',
  2: 'info',
  3: 'info',
  4: 'danger',
}

const qualityLevels: { value: QualityLevel; label: string }[] = [
  { value: 1, label: '全新' },
  { value: 2, label: '9成新' },
  { value: 3, label: '8成新' },
  { value: 4, label: '7成新' },
  { value: 5, label: '6成新及以下' },
]

const categoryOptions = categoryGroups.map((g) => ({
  value: g.cateId,
  label: g.cateName,
  children: g.children.map((c) => ({ value: c.cateId, label: c.cateName })),
}))

// 编辑弹窗
const editVisible = ref(false)
const editForm = reactive({
  goodsId: '',
  title: '',
  categoryPath: [] as string[],
  sellPrice: 0,
  originalPrice: undefined as number | undefined,
  tradeType: 2 as TradeType,
  qualityLevel: 1 as QualityLevel,
  goodsDesc: '',
})

async function load() {
  loading.value = true
  goods.value = await listGoods()
  for (const g of goods.value) {
    const u = await getUser(g.publishUserId)
    if (u) sellers.value[g.publishUserId] = u.userName
  }
  loading.value = false
}

async function approve(g: Goods) {
  await updateGoodsStatus(g.goodsId, 1)
  ElMessage.success('已通过')
  load()
}

async function reject(g: Goods) {
  const { value } = await ElMessageBox.prompt('驳回原因', '驳回', {
    confirmButtonText: '驳回',
    cancelButtonText: '取消',
  })
  await updateGoodsStatus(g.goodsId, 4, value)
  ElMessage.success('已驳回')
  load()
}

async function off(g: Goods) {
  await updateGoodsStatus(g.goodsId, 2)
  ElMessage.success('已下架')
  load()
}

function openEdit(g: Goods) {
  editForm.goodsId = g.goodsId
  editForm.title = g.title
  editForm.sellPrice = g.sellPrice
  editForm.originalPrice = g.originalPrice
  editForm.tradeType = g.tradeType
  editForm.qualityLevel = g.qualityLevel ?? 1
  editForm.goodsDesc = g.goodsDesc
  const parent = categoryGroups.find((x) => x.children.some((c) => c.cateId === g.cateId))
  editForm.categoryPath = parent ? [parent.cateId, g.cateId] : []
  editVisible.value = true
}

async function saveEdit() {
  if (!editForm.title.trim() || !editForm.categoryPath.length || editForm.sellPrice <= 0) {
    ElMessage.warning('请填写完整信息')
    return
  }
  const cateId = editForm.categoryPath[editForm.categoryPath.length - 1] ?? ''
  await updateGoods(editForm.goodsId, {
    title: editForm.title.trim(),
    goodsDesc: editForm.goodsDesc,
    sellPrice: editForm.sellPrice,
    originalPrice: editForm.originalPrice,
    cateId,
    tradeType: editForm.tradeType,
    qualityLevel: editForm.qualityLevel,
  })
  ElMessage.success('已保存，商品仍处于待审核')
  editVisible.value = false
  load()
}

onMounted(load)
</script>

<template>
  <div class="audit">
    <el-table v-loading="loading" :data="goods" style="width: 100%">
      <el-table-column label="图片" width="80">
        <template #default="{ row }">
          <el-image :src="row.images[0]" style="width: 50px; height: 50px" fit="cover" />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" min-width="200" show-overflow-tooltip />
      <el-table-column label="价格" width="100">
        <template #default="{ row }">
          <span class="price">¥{{ row.sellPrice }}</span>
        </template>
      </el-table-column>
      <el-table-column label="卖家" width="110">
        <template #default="{ row }">{{ sellers[row.publishUserId] }}</template>
      </el-table-column>
      <el-table-column label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="statusType[row.goodsStatus]">{{ statusText[row.goodsStatus] }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="240" fixed="right">
        <template #default="{ row }">
          <el-button v-if="row.goodsStatus === 0" type="primary" size="small" @click="openEdit(row)">编辑</el-button>
          <el-button v-if="row.goodsStatus === 0" type="success" size="small" @click="approve(row)">通过</el-button>
          <el-button v-if="row.goodsStatus === 0" type="danger" size="small" @click="reject(row)">驳回</el-button>
          <el-button v-if="row.goodsStatus === 1" type="warning" size="small" @click="off(row)">下架</el-button>
          <el-tooltip v-if="row.goodsStatus === 4 && row.rejectReason" :content="row.rejectReason">
            <el-button size="small" disabled>原因</el-button>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>

    <!-- 编辑待审核商品 -->
    <el-dialog v-model="editVisible" title="修改商品信息" width="560px">
      <el-form label-width="80px">
        <el-form-item label="商品名称">
          <el-input v-model="editForm.title" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="商品分类">
          <el-cascader
            v-model="editForm.categoryPath"
            :options="categoryOptions"
            :props="{ expandTrigger: 'hover' }"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="成色">
          <el-select v-model="editForm.qualityLevel" style="width: 100%">
            <el-option v-for="q in qualityLevels" :key="q.value" :label="q.label" :value="q.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="售价">
          <el-input-number v-model="editForm.sellPrice" :min="0" :precision="2" :controls="false" style="width: 200px" />
          <span style="margin-left: 8px; color: var(--text-sub)">元</span>
        </el-form-item>
        <el-form-item label="原价">
          <el-input-number v-model="editForm.originalPrice" :min="0" :precision="2" :controls="false" style="width: 200px" />
          <span style="margin-left: 8px; color: var(--text-sub)">元（选填）</span>
        </el-form-item>
        <el-form-item label="交易方式">
          <el-radio-group v-model="editForm.tradeType">
            <el-radio-button :value="1">邮寄</el-radio-button>
            <el-radio-button :value="2">自提</el-radio-button>
            <el-radio-button :value="3">两者均可</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="商品描述">
          <el-input v-model="editForm.goodsDesc" type="textarea" :rows="4" maxlength="500" show-word-limit />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editVisible = false">取消</el-button>
        <el-button type="primary" @click="saveEdit">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>
