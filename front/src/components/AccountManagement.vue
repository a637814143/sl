<template>
  <div class="account-panel">
    <transition name="toast-slide">
      <div v-if="toast.visible" class="account-toast" :class="toast.tone">
        {{ toast.message }}
      </div>
    </transition>

    <template v-if="view === 'landing'">
      <section class="account-hero">
        <p class="eyebrow">账户体系</p>
        <h2>账号管理中心</h2>
        <small>统一创建、编辑与停用账号，保障门店与顾客体验。</small>
      </section>
      <div class="account-type-grid">
        <article v-for="type in accountTypes" :key="type.value" class="account-type-card" @click="openRole(type.value)">
          <div class="type-head">
            <div class="type-icon">{{ type.icon }}</div>
            <div>
              <p class="card-label">{{ type.label }}</p>
              <h3>{{ type.subtitle }}</h3>
            </div>
          </div>
          <p class="type-desc">{{ type.desc }}</p>
          <div class="type-meta">
            <div>
              <p>当前数量</p>
              <strong>{{ accountStats[type.value] || 0 }}</strong>
            </div>
            <button class="primary ghost" type="button">进入管理 →</button>
          </div>
        </article>
      </div>
    </template>

    <template v-else>
      <header class="account-list-header">
        <div class="header-info">
          <button class="ghost back-link" type="button" @click="openLanding">← 返回</button>
          <div>
            <p class="eyebrow">当前分类</p>
            <h3>{{ currentRoleLabel }}</h3>
          </div>
        </div>
        <div class="header-chip">
          共 <strong>{{ accounts.length }}</strong> 个账号
        </div>
        <button class="primary" type="button" @click="openCreateForm">+ 新增账号</button>
      </header>

      <form class="account-filters" @submit.prevent="handleSearch">
        <div class="input-shell">
          <span class="input-icon">🔍</span>
          <input v-model="keyword" type="search" placeholder="搜索用户名 / 显示名 / 手机号" />
        </div>
        <button class="ghost" type="submit">搜索</button>
      </form>

      <p class="feedback" v-if="accountError">{{ accountError }}</p>
      <div v-else-if="accountLoading" class="account-skeleton">
        <div v-for="n in 3" :key="n" class="skeleton-row">
          <div class="shimmer avatar"></div>
          <div class="shimmer line"></div>
        </div>
      </div>
      <ul v-else-if="accounts.length" class="account-list">
        <li v-for="user in accounts" :key="user.id">
          <div class="account-avatar" :data-role="user.role">
            {{ avatarInitial(user) }}
          </div>
          <div class="account-meta">
            <div class="meta-head">
              <strong>{{ user.displayName || user.username }}</strong>
              <span class="role-pill" :class="roleClass(user.role)">{{ roleLabels[user.role] || user.role }}</span>
            </div>
            <p>{{ user.username }}</p>
            <small>
              {{ user.phone || '未绑定手机号' }}
              <template v-if="user.role === 'MERCHANT'">
                · {{ user.merchantName || '未绑定门店' }}
              </template>
            </small>
          </div>
          <div class="account-actions">
            <button class="ghost" type="button" @click="openEditForm(user)">编辑</button>
            <button class="ghost danger" type="button" @click="requestDelete(user)">删除</button>
          </div>
        </li>
      </ul>
      <div v-else class="account-empty">
        <p>暂无账号</p>
        <small>点击右上角即可创建第一位{{ currentRoleLabel }}。</small>
      </div>
    </template>

    <div v-if="formVisible" class="account-dialog">
      <div class="dialog-card">
        <header>
          <div>
            <p class="eyebrow">{{ formMode === 'create' ? '创建账号' : '编辑账号' }}</p>
            <h3>{{ form.displayName || form.username || '填写信息' }}</h3>
          </div>
          <button class="ghost" type="button" @click="closeForm">×</button>
        </header>
        <form @submit.prevent="submitForm">
          <section class="form-group">
            <p class="group-title">基础信息</p>
            <label>
              <span>所属角色</span>
              <select v-model="form.role">
                <option v-for="type in accountTypes" :key="type.value" :value="type.value">
                  {{ type.label }}
                </option>
              </select>
            </label>
            <label>
              <span>登录账号</span>
              <input v-model="form.username" type="text" placeholder="请输入用户名" :disabled="formMode === 'edit'" />
            </label>
            <label>
              <span>显示名称</span>
              <input v-model="form.displayName" type="text" placeholder="在小程序中显示的昵称" />
            </label>
          </section>

          <section class="form-group">
            <p class="group-title">安全与联系方式</p>
            <label>
              <span>{{ formMode === 'create' ? '初始密码' : '重置密码（可选）' }}</span>
              <input v-model="form.password" type="password" placeholder="至少 6 位" />
            </label>
            <label>
              <span>手机号（可选）</span>
              <input v-model="form.phone" type="tel" placeholder="请输入手机号" />
            </label>
            <label>
              <span>性别（可选）</span>
              <select v-model="form.gender">
                <option value="">未选择</option>
                <option v-for="option in genderOptions" :key="option" :value="option">{{ option }}</option>
              </select>
            </label>
          </section>

          <section class="form-group" v-if="form.role === 'MERCHANT'">
            <p class="group-title">门店权限</p>
            <label>
              <span>绑定门店</span>
              <select v-model="form.merchantId">
                <option value="">请选择门店</option>
                <option v-for="merchant in merchants" :key="merchant.id" :value="merchant.id">
                  {{ merchant.name }}
                </option>
              </select>
            </label>
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

    <div v-if="deleteDialogVisible" class="account-dialog">
      <div class="dialog-card confirm">
        <header>
          <div>
            <p class="eyebrow">删除账号</p>
            <h3>{{ deleteTarget?.displayName || deleteTarget?.username }}</h3>
          </div>
          <button class="ghost" type="button" @click="closeDeleteDialog">×</button>
        </header>
        <p>删除后该账号将无法登录，操作不可撤销，请确认。</p>
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
import { fetchAdminUsers, createAdminUser, updateAdminUser, deleteAdminUser, fetchMerchants } from '../services/api'

const accountTypes = [
  { value: 'CUSTOMER', label: '顾客账号', subtitle: '会员与到店客人', desc: '用于小程序自助下单与预订。', icon: '🧋' },
  { value: 'MERCHANT', label: '商家账号', subtitle: '门店经营团队', desc: '管理门店菜单、订单与库存。', icon: '🏪' },
  { value: 'ADMIN', label: '管理员账号', subtitle: '总部运营团队', desc: '拥有全局配置与审核能力。', icon: '🛡️' }
]

const roleLabels = accountTypes.reduce((acc, cur) => {
  acc[cur.value] = cur.label
  return acc
}, {})

const genderOptions = ['女', '男', '保密']

const view = ref('landing')
const activeRole = ref('CUSTOMER')
const keyword = ref('')
const accountLoading = ref(false)
const accountError = ref('')
const accounts = ref([])
const actionPending = ref('')
const accountStats = reactive({
  CUSTOMER: 0,
  MERCHANT: 0,
  ADMIN: 0
})

const formVisible = ref(false)
const formMode = ref('create')
const formSubmitting = ref(false)
const formError = ref('')
const merchants = ref([])
const deleteDialogVisible = ref(false)
const deleteTarget = ref(null)
const toast = reactive({
  visible: false,
  message: '',
  tone: 'info'
})
const form = reactive({
  id: null,
  username: '',
  displayName: '',
  password: '',
  role: 'CUSTOMER',
  phone: '',
  gender: '',
  merchantId: ''
})

const currentRoleLabel = computed(() => roleLabels[activeRole.value] || '账号管理')

const avatarInitial = (user) => {
  const source = user.displayName || user.username || '账号'
  return source.trim().charAt(0).toUpperCase()
}

const roleClass = (role) => (role ? role.toLowerCase() : 'default')

const openLanding = () => {
  view.value = 'landing'
  accountError.value = ''
}

const openRole = (role) => {
  activeRole.value = role
  keyword.value = ''
  view.value = 'list'
  loadAccounts()
}

const loadAccounts = async () => {
  if (view.value !== 'list') return
  accountLoading.value = true
  accountError.value = ''
  try {
    const list = await fetchAdminUsers({
      role: activeRole.value,
      keyword: keyword.value || undefined
    })
    accounts.value = Array.isArray(list) ? list : []
    accountStats[activeRole.value] = accounts.value.length
  } catch (error) {
    accountError.value = error.response?.data?.message || '加载账号失败，请稍后重试'
  } finally {
    accountLoading.value = false
  }
}

const handleSearch = () => {
  loadAccounts()
}

const resetForm = () => {
  form.id = null
  form.username = ''
  form.displayName = ''
  form.password = ''
  form.role = activeRole.value
  form.phone = ''
  form.gender = ''
  form.merchantId = ''
  formError.value = ''
}

const openCreateForm = () => {
  formMode.value = 'create'
  resetForm()
  formVisible.value = true
}

const openEditForm = (user) => {
  formMode.value = 'edit'
  form.id = user.id
  form.username = user.username
  form.displayName = user.displayName || ''
  form.password = ''
  form.role = user.role
  form.phone = user.phone || ''
  form.gender = user.gender || ''
  form.merchantId = user.merchantId || ''
  formError.value = ''
  formVisible.value = true
}

const closeForm = () => {
  formVisible.value = false
  formSubmitting.value = false
}

const validateForm = () => {
  if (!form.displayName.trim()) {
    formError.value = '请填写显示名称'
    return false
  }
  if (formMode.value === 'create') {
    if (!form.username.trim()) {
      formError.value = '请填写登录账号'
      return false
    }
    if (!form.password.trim() || form.password.length < 6) {
      formError.value = '初始密码至少 6 位'
      return false
    }
  }
  if (formMode.value === 'edit' && form.password && form.password.length < 6) {
    formError.value = '重置密码至少 6 位'
    return false
  }
  if (form.role === 'MERCHANT' && !form.merchantId) {
    formError.value = '商家账号需要选择门店'
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
      await createAdminUser(buildCreatePayload())
      showToast('已创建账号', 'success')
    } else {
      await updateAdminUser(form.id, buildUpdatePayload())
      showToast('账号信息已更新', 'success')
    }
    closeForm()
    await loadAccounts()
  } catch (error) {
    formError.value = error.response?.data?.message || '提交失败，请稍后再试'
  } finally {
    formSubmitting.value = false
  }
}

const buildCreatePayload = () => {
  return {
    username: form.username.trim(),
    displayName: form.displayName.trim(),
    password: form.password,
    role: form.role,
    phone: form.phone || undefined,
    gender: form.gender || undefined,
    merchantId: form.role === 'MERCHANT' ? Number(form.merchantId) : undefined
  }
}

const buildUpdatePayload = () => {
  const payload = {
    displayName: form.displayName.trim(),
    role: form.role,
    phone: form.phone || undefined,
    gender: form.gender || undefined,
    merchantId: form.role === 'MERCHANT' ? Number(form.merchantId) : undefined
  }
  if (form.password) {
    payload.password = form.password
  }
  return payload
}

const requestDelete = (user) => {
  deleteTarget.value = user
  deleteDialogVisible.value = true
  formError.value = ''
}

const closeDeleteDialog = () => {
  deleteDialogVisible.value = false
  deleteTarget.value = null
}

const confirmDelete = async () => {
  if (!deleteTarget.value) return
  actionPending.value = deleteTarget.value.id
  try {
    await deleteAdminUser(deleteTarget.value.id)
    showToast('账号已删除', 'danger')
    await loadAccounts()
  } catch (error) {
    showToast(error.response?.data?.message || '删除失败，请稍后再试', 'danger')
  } finally {
    actionPending.value = ''
    closeDeleteDialog()
  }
}

const showToast = (message, tone = 'info') => {
  toast.message = message
  toast.tone = tone
  toast.visible = true
  setTimeout(() => {
    toast.visible = false
  }, 2600)
}

onMounted(async () => {
  try {
    merchants.value = await fetchMerchants()
  } catch (error) {
    console.warn('加载门店列表失败', error)
  }
})

watch(
  () => form.role,
  (role) => {
    if (role !== 'MERCHANT') {
      form.merchantId = ''
    }
  }
)
</script>

<style scoped>
.account-panel {
  display: flex;
  flex-direction: column;
  gap: 16px;
  position: relative;
}

.account-toast {
  position: absolute;
  top: -8px;
  left: 50%;
  transform: translate(-50%, -100%);
  padding: 10px 16px;
  border-radius: 999px;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.35);
  font-size: 0.85rem;
  background: rgba(30, 64, 175, 0.95);
  color: #f8fafc;
  z-index: 5;
}

.account-toast.success {
  background: rgba(16, 185, 129, 0.95);
}

.account-toast.danger {
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

.account-hero {
  padding: 18px 20px;
  border-radius: 18px;
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.25), rgba(147, 197, 253, 0.1));
  border: 1px solid rgba(96, 165, 250, 0.4);
  box-shadow: inset 0 0 30px rgba(15, 23, 42, 0.25);
}

.account-type-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 16px;
}

.account-type-card {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  padding: 18px;
  background: rgba(15, 23, 42, 0.85);
  display: flex;
  flex-direction: column;
  gap: 16px;
  cursor: pointer;
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.45);
  transition: transform 0.25s ease, border-color 0.25s ease;
}

.account-type-card:hover {
  transform: translateY(-4px);
  border-color: rgba(148, 163, 184, 0.6);
}

.type-head {
  display: flex;
  gap: 12px;
  align-items: center;
}

.type-icon {
  width: 48px;
  height: 48px;
  border-radius: 16px;
  background: rgba(148, 163, 184, 0.15);
  display: grid;
  place-items: center;
  font-size: 1.5rem;
}

.type-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: rgba(248, 250, 252, 0.8);
}

.type-meta strong {
  font-size: 2rem;
}

.account-list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  padding: 12px 16px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.2);
}

.header-info {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-chip {
  padding: 6px 14px;
  border-radius: 999px;
  background: rgba(59, 130, 246, 0.15);
  color: rgba(191, 219, 254, 0.95);
}

.account-filters {
  display: flex;
  gap: 8px;
  align-items: center;
}

.account-filters .input-shell {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.3);
  background: rgba(15, 23, 42, 0.6);
}

.account-filters input {
  flex: 1;
  background: transparent;
  border: none;
  color: inherit;
}

.account-filters input:focus {
  outline: none;
}

.input-icon {
  font-size: 0.9rem;
  opacity: 0.7;
}

.account-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.account-list li {
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 14px 16px;
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 16px;
  background: rgba(15, 23, 42, 0.65);
  box-shadow: 0 16px 32px rgba(2, 6, 23, 0.5);
}

.account-avatar {
  width: 48px;
  height: 48px;
  border-radius: 14px;
  display: grid;
  place-items: center;
  font-weight: 600;
  background: rgba(148, 163, 184, 0.15);
}

.account-avatar[data-role='ADMIN'] {
  background: rgba(248, 250, 252, 0.1);
}

.account-avatar[data-role='MERCHANT'] {
  background: rgba(34, 197, 94, 0.18);
}

.account-avatar[data-role='CUSTOMER'] {
  background: rgba(59, 130, 246, 0.18);
}

.account-meta {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meta-head {
  display: flex;
  gap: 8px;
  align-items: center;
}

.role-pill {
  padding: 2px 8px;
  border-radius: 999px;
  font-size: 0.75rem;
  border: 1px solid rgba(148, 163, 184, 0.4);
}

.role-pill.merchant {
  border-color: rgba(34, 197, 94, 0.5);
  color: rgba(134, 239, 172, 0.95);
}

.role-pill.admin {
  border-color: rgba(248, 250, 252, 0.5);
}

.account-meta p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
}

.account-meta small {
  color: rgba(148, 163, 184, 0.8);
}

.account-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.account-actions .danger {
  color: #f87171;
}

.account-empty {
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  padding: 20px;
  text-align: center;
  color: rgba(148, 163, 184, 0.9);
}

.account-skeleton {
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

.shimmer.avatar {
  width: 48px;
  height: 48px;
}

.shimmer.line {
  flex: 1;
  height: 16px;
  border-radius: 8px;
}

.account-dialog {
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
}

.dialog-card header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dialog-card form {
  display: flex;
  flex-direction: column;
  gap: 12px;
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

.group-title {
  margin: 0;
  font-size: 0.9rem;
  color: rgba(148, 163, 184, 0.85);
}

.dialog-card label {
  display: flex;
  flex-direction: column;
  gap: 6px;
  font-size: 0.9rem;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.dialog-card.confirm {
  max-width: 360px;
}

.primary.danger {
  background: rgba(248, 113, 113, 0.2);
  color: #fecaca;
  border: 1px solid rgba(248, 113, 113, 0.4);
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
