<template>
  <div class="merchant-panel">
    <transition name="toast-slide">
      <div v-if="toast.visible" class="merchant-toast" :class="toast.tone">
        {{ toast.message }}
      </div>
    </transition>

    <section class="merchant-hero">
      <div>
        <p class="eyebrow">门店体系</p>
        <h2>商家管理</h2>
        <small>维护门店档案、位置信息与联系人。</small>
      </div>
      <button class="primary" type="button" @click="openCreateForm">+ 新增门店</button>
    </section>

    <div class="merchant-summary-grid">
      <article class="summary-card">
        <p>门店总数</p>
        <strong>{{ merchantStats.total }}</strong>
        <small>含已上线与候选门店</small>
      </article>
      <article class="summary-card">
        <p>已配置坐标</p>
        <strong>{{ merchantStats.withCoords }}</strong>
        <small>可用于定位与推荐</small>
      </article>
    </div>

    <form class="merchant-filters" @submit.prevent="handleSearch">
      <div class="input-shell">
        <span class="input-icon">🔎</span>
        <input v-model="keyword" type="search" placeholder="搜索门店名称 / 联系人 / 地址" />
      </div>
      <button class="ghost" type="submit">搜索</button>
    </form>

    <p class="feedback" v-if="merchantError">{{ merchantError }}</p>
    <div v-else-if="merchantLoading" class="merchant-skeleton">
      <div v-for="n in 3" :key="n" class="skeleton-row">
        <div class="shimmer avatar"></div>
        <div class="shimmer line"></div>
      </div>
    </div>
    <ul v-else-if="merchants.length" class="merchant-list">
      <li v-for="merchant in merchants" :key="merchant.id">
        <div class="merchant-badge">
          {{ merchant.name.charAt(0) }}
        </div>
        <div class="merchant-meta">
          <div class="meta-head">
            <strong>{{ merchant.name }}</strong>
            <span class="location-pill">{{ merchant.location }}</span>
          </div>
          <p>联系人：{{ merchant.contact }}</p>
          <small>{{ merchant.signatureStory || '暂无故事介绍' }}</small>
          <small v-if="merchant.latitude && merchant.longitude">
            坐标：{{ merchant.latitude }}, {{ merchant.longitude }}
          </small>
        </div>
        <div class="merchant-actions">
          <button class="ghost" type="button" @click="openEditForm(merchant)">编辑</button>
          <button class="ghost danger" type="button" @click="requestDelete(merchant)">删除</button>
        </div>
      </li>
    </ul>
    <div v-else class="merchant-empty">
      <p>暂无门店</p>
      <small>点击上方按钮创建第一家门店。</small>
    </div>

    <div v-if="formVisible" class="merchant-dialog">
      <div class="dialog-card">
        <header>
          <div>
            <p class="eyebrow">{{ formMode === 'create' ? '新增门店' : '编辑门店' }}</p>
            <h3>{{ form.name || '填写门店信息' }}</h3>
          </div>
          <button class="ghost" type="button" @click="closeForm">×</button>
        </header>
        <form @submit.prevent="submitForm">
          <section class="form-group">
            <p class="group-title">基础信息</p>
            <label>
              <span>门店名称</span>
              <input v-model="form.name" type="text" placeholder="请输入门店名称" />
            </label>
            <label>
              <span>联系人 / 电话</span>
              <input v-model="form.contact" type="text" placeholder="例：13800000000 / Noah" />
            </label>
            <label>
              <span>门店地址</span>
              <input v-model="form.location" type="text" placeholder="请输入详细地址" />
            </label>
          </section>

          <section class="form-group">
            <p class="group-title">门店故事（可选）</p>
            <label>
              <textarea v-model="form.signatureStory" rows="3" placeholder="门店亮点、招牌或服务理念"></textarea>
            </label>
          </section>

          <section class="form-group">
            <p class="group-title">定位信息（可选）</p>
            <div class="coords">
              <label>
                <span>纬度</span>
                <input v-model.number="form.latitude" type="number" step="0.000001" placeholder="23.12911" />
              </label>
              <label>
                <span>经度</span>
                <input v-model.number="form.longitude" type="number" step="0.000001" placeholder="113.264385" />
              </label>
            </div>
          </section>

          <p class="feedback" v-if="formError">{{ formError }}</p>
          <div class="dialog-actions">
            <button class="ghost" type="button" @click="closeForm">取消</button>
            <button class="primary" type="submit" :disabled="formSubmitting">
              {{ formSubmitting ? '提交中...' : '保存' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="deleteDialogVisible" class="merchant-dialog">
      <div class="dialog-card confirm">
        <header>
          <div>
            <p class="eyebrow">删除门店</p>
            <h3>{{ deleteTarget?.name }}</h3>
          </div>
          <button class="ghost" type="button" @click="closeDeleteDialog">×</button>
        </header>
        <p>删除后无法恢复，如仍有关联账号或商品会被阻止。</p>
        <div class="dialog-actions">
          <button class="ghost" type="button" @click="closeDeleteDialog">取消</button>
          <button class="primary danger" type="button" :disabled="actionPending" @click="confirmDelete">
            {{ actionPending ? '处理中...' : '确认删除' }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
import {
  fetchAdminMerchants,
  createAdminMerchant,
  updateAdminMerchant,
  deleteAdminMerchant
} from '../services/api'

const props = defineProps({
  onRefresh: {
    type: Function,
    default: null
  }
})

const merchants = ref([])
const merchantStats = computed(() => {
  const total = merchants.value.length
  const withCoords = merchants.value.filter((item) => item.latitude && item.longitude).length
  return { total, withCoords }
})
const merchantLoading = ref(false)
const merchantError = ref('')
const keyword = ref('')
const formVisible = ref(false)
const formMode = ref('create')
const formSubmitting = ref(false)
const formError = ref('')
const deleteDialogVisible = ref(false)
const deleteTarget = ref(null)
const actionPending = ref(false)
const toast = reactive({
  visible: false,
  message: '',
  tone: 'info'
})
const form = reactive({
  id: null,
  name: '',
  contact: '',
  location: '',
  signatureStory: '',
  latitude: '',
  longitude: ''
})

const loadMerchants = async () => {
  merchantLoading.value = true
  merchantError.value = ''
  try {
    const list = await fetchAdminMerchants({ keyword: keyword.value || undefined })
    merchants.value = Array.isArray(list) ? list : []
  } catch (error) {
    merchantError.value = error.response?.data?.message || '加载门店失败，请稍后再试'
  } finally {
    merchantLoading.value = false
  }
}

const handleSearch = () => {
  loadMerchants()
}

const resetForm = () => {
  form.id = null
  form.name = ''
  form.contact = ''
  form.location = ''
  form.signatureStory = ''
  form.latitude = ''
  form.longitude = ''
  formError.value = ''
}

const openCreateForm = () => {
  formMode.value = 'create'
  resetForm()
  formVisible.value = true
}

const openEditForm = (merchant) => {
  formMode.value = 'edit'
  form.id = merchant.id
  form.name = merchant.name
  form.contact = merchant.contact || ''
  form.location = merchant.location || ''
  form.signatureStory = merchant.signatureStory || ''
  form.latitude = merchant.latitude
  form.longitude = merchant.longitude
  formVisible.value = true
  formError.value = ''
}

const closeForm = () => {
  formVisible.value = false
  formSubmitting.value = false
}

const validateForm = () => {
  if (!form.name.trim()) {
    formError.value = '请填写门店名称'
    return false
  }
  if (!form.contact.trim()) {
    formError.value = '请填写联系人或电话'
    return false
  }
  if (!form.location.trim()) {
    formError.value = '请填写门店地址'
    return false
  }
  formError.value = ''
  return true
}

const submitForm = async () => {
  if (!validateForm()) return
  formSubmitting.value = true
  try {
    if (formMode.value === 'create') {
      await createAdminMerchant(buildPayload())
      showToast('已创建门店', 'success')
    } else {
      await updateAdminMerchant(form.id, buildPayload())
      showToast('门店信息已更新', 'success')
    }
    closeForm()
    await loadMerchants()
    props.onRefresh?.()
  } catch (error) {
    formError.value = error.response?.data?.message || '提交失败，请稍后再试'
  } finally {
    formSubmitting.value = false
  }
}

const buildPayload = () => {
  return {
    name: form.name.trim(),
    contact: form.contact.trim(),
    location: form.location.trim(),
    signatureStory: form.signatureStory || undefined,
    latitude: form.latitude === '' ? undefined : Number(form.latitude),
    longitude: form.longitude === '' ? undefined : Number(form.longitude)
  }
}

const requestDelete = (merchant) => {
  deleteTarget.value = merchant
  deleteDialogVisible.value = true
}

const closeDeleteDialog = () => {
  deleteDialogVisible.value = false
  deleteTarget.value = null
}

const confirmDelete = async () => {
  if (!deleteTarget.value) return
  actionPending.value = true
  try {
    await deleteAdminMerchant(deleteTarget.value.id)
    showToast('门店已删除', 'danger')
    await loadMerchants()
    props.onRefresh?.()
  } catch (error) {
    showToast(error.response?.data?.message || '删除失败，请稍后再试', 'danger')
  } finally {
    actionPending.value = false
    closeDeleteDialog()
  }
}

const showToast = (message, tone = 'info') => {
  toast.message = message
  toast.tone = tone
  toast.visible = true
  setTimeout(() => {
    toast.visible = false
  }, 2500)
}

onMounted(() => {
  loadMerchants()
})

watch(keyword, (value) => {
  if (!value) {
    loadMerchants()
  }
})
</script>

<style scoped>
.merchant-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
  position: relative;
}

.merchant-toast {
  position: absolute;
  top: -8px;
  left: 50%;
  transform: translate(-50%, -100%);
  padding: 10px 16px;
  border-radius: 999px;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.35);
  font-size: 0.85rem;
  background: rgba(59, 130, 246, 0.95);
  color: #f8fafc;
  z-index: 5;
}

.merchant-toast.success {
  background: rgba(16, 185, 129, 0.95);
}

.merchant-toast.danger {
  background: rgba(248, 113, 113, 0.95);
}

.toast-slide-enter-active,
.toast-slide-leave-active {
  transition: all 0.3s ease;
}

.toast-slide-enter-from,
.toast-slide-leave-to {
  opacity: 0;
  transform: translate(-50%, -160%);
}

.merchant-hero {
  padding: 20px;
  border-radius: 20px;
  background: linear-gradient(120deg, rgba(29, 78, 216, 0.6), rgba(2, 132, 199, 0.35));
  border: 1px solid rgba(99, 102, 241, 0.5);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  box-shadow: 0 24px 40px rgba(15, 23, 42, 0.55);
}

.merchant-summary-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px;
}

.summary-card {
  border-radius: 16px;
  border: 1px solid rgba(191, 219, 254, 0.2);
  padding: 14px 16px;
  background: rgba(15, 23, 42, 0.7);
  box-shadow: inset 0 0 20px rgba(15, 23, 42, 0.35);
}

.summary-card strong {
  font-size: 1.8rem;
  display: block;
}

.merchant-filters {
  display: flex;
  gap: 8px;
  align-items: center;
}

.merchant-filters .input-shell {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.3);
  background: rgba(15, 23, 42, 0.6);
}

.merchant-filters input {
  flex: 1;
  background: transparent;
  border: none;
  color: inherit;
}

.merchant-filters input:focus {
  outline: none;
}

.merchant-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.merchant-list li {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  padding: 16px;
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 16px;
  background: radial-gradient(circle at top left, rgba(59, 130, 246, 0.18), rgba(15, 23, 42, 0.8));
  box-shadow: 0 16px 32px rgba(2, 6, 23, 0.6);
}

.merchant-badge {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  background: rgba(59, 130, 246, 0.15);
  display: grid;
  place-items: center;
  font-weight: 600;
  font-size: 1.2rem;
}

.merchant-meta {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meta-head {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.location-pill {
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(59, 130, 246, 0.15);
  color: rgba(191, 219, 254, 0.95);
  font-size: 0.75rem;
}

.merchant-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.merchant-actions button {
  border-radius: 10px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  padding: 6px 10px;
}

.merchant-actions .danger {
  color: #fb7185;
}

.merchant-empty {
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  padding: 20px;
  text-align: center;
  color: rgba(148, 163, 184, 0.9);
}

.merchant-skeleton {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.skeleton-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.shimmer {
  background: linear-gradient(90deg, rgba(148, 163, 184, 0.1), rgba(148, 163, 184, 0.2), rgba(148, 163, 184, 0.1));
  background-size: 200% 100%;
  animation: shimmer 1.6s infinite;
  border-radius: 999px;
}

.merchant-dialog {
  position: fixed;
  inset: 0;
  background: rgba(2, 6, 23, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  z-index: 20;
}

.dialog-card {
  background: rgba(15, 23, 42, 0.95);
  border-radius: 20px;
  padding: 20px;
  width: min(420px, 100%);
  display: flex;
  flex-direction: column;
  gap: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  box-shadow: 0 24px 48px rgba(2, 6, 23, 0.65);
}

.dialog-card header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.form-group {
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 16px;
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  background: rgba(15, 23, 42, 0.5);
}

.coords {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.primary.danger {
  background: rgba(248, 113, 113, 0.2);
  color: #fecaca;
  border: 1px solid rgba(248, 113, 113, 0.4);
}

.dialog-card.confirm {
  max-width: 360px;
}

@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}
</style>
