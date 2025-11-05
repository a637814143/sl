<template>
  <div class="mini-app">
    <header class="status-bar">8am 实验室 · 清晨饮品站</header>
    <main class="content">
      <section v-if="activeTab === 'home'" class="panel">
        <h1 class="heading">今日灵感饮品</h1>
        <p class="subheading">探索门店精选，随时加入你的晨间灵感单。</p>
        <ul class="drink-cards">
          <li v-for="drink in drinks" :key="drink.id" class="drink-card">
            <div class="card-hero" :style="withHero(drink.imageUrl)">
              <span class="badge" v-if="drink.flavorProfile">{{ drink.flavorProfile }}</span>
              <button class="availability" :class="{ off: !drink.available }">{{ drink.available ? '可点单' : '暂停售' }}</button>
            </div>
            <div class="card-body">
              <h2>{{ drink.name }}</h2>
              <p>{{ drink.description || '这是一杯等待命名的灵感。' }}</p>
              <strong class="price">¥ {{ Number(drink.price).toFixed(2) }}</strong>
            </div>
          </li>
        </ul>
      </section>

      <section v-else-if="activeTab === 'order'" class="panel">
        <div class="panel-header">
          <h1 class="heading">饮品管理</h1>
          <p class="subheading">新增、编辑或下架饮品，保持菜单新鲜。</p>
        </div>
        <form class="form" @submit.prevent="submitDrink">
          <div class="form-row">
            <label>饮品名称</label>
            <input v-model="drinkForm.name" type="text" placeholder="请输入饮品名称" />
            <span class="error" v-if="drinkErrors.name">{{ drinkErrors.name }}</span>
          </div>
          <div class="form-row">
            <label>价格</label>
            <input v-model="drinkForm.price" type="number" step="0.01" min="0" placeholder="例：28" />
            <span class="error" v-if="drinkErrors.price">{{ drinkErrors.price }}</span>
          </div>
          <div class="form-row">
            <label>风味标签</label>
            <input v-model="drinkForm.flavorProfile" type="text" placeholder="例：果酸 · 花香" />
          </div>
          <div class="form-row">
            <label>图片地址</label>
            <input v-model="drinkForm.imageUrl" type="url" placeholder="可选：饮品展示图" />
          </div>
          <div class="form-row">
            <label>饮品描述</label>
            <textarea v-model="drinkForm.description" rows="3" placeholder="一句话描述你的饮品故事"></textarea>
          </div>
          <div class="form-row inline">
            <label>当前状态</label>
            <label class="switch">
              <input v-model="drinkForm.available" type="checkbox" />
              <span class="slider"></span>
            </label>
            <span>{{ drinkForm.available ? '可售' : '停售' }}</span>
          </div>
          <div class="actions">
            <button class="primary" type="submit">{{ drinkForm.id ? '更新饮品' : '新增饮品' }}</button>
            <button class="ghost" type="button" v-if="drinkForm.id" @click="resetDrinkForm">取消编辑</button>
          </div>
        </form>

        <ul class="drink-list">
          <li v-for="drink in drinks" :key="drink.id" class="drink-item">
            <div>
              <h3>{{ drink.name }}</h3>
              <p class="meta">¥ {{ Number(drink.price).toFixed(2) }} · {{ drink.flavorProfile || '待定义风味' }}</p>
              <p class="desc">{{ drink.description || '—' }}</p>
            </div>
            <div class="item-actions">
              <button class="ghost" @click="editDrink(drink)">编辑</button>
              <button class="danger" @click="deleteDrink(drink.id)">删除</button>
            </div>
          </li>
        </ul>
      </section>

      <section v-else-if="activeTab === 'explore'" class="panel explore">
        <h1 class="heading">灵感实验室</h1>
        <p class="subheading">
          将新品提案、口味票选和会员活动放在这里，像小程序“发现”页一样承载灵感互动。
        </p>
        <div class="placeholder">
          <p>· 上传你的新品灵感草图</p>
          <p>· 发起一场“我心中的第一杯”投票</p>
          <p>· 分享门店幕后与手冲笔记</p>
        </div>
      </section>

      <section v-else class="panel profile">
        <h1 class="heading">帐号中心</h1>
        <p class="subheading">在这里完成注册或登录，和团队一起管理门店。</p>
        <div class="auth-card">
          <div class="tabs">
            <button :class="{ active: authMode === 'login' }" @click="setAuthMode('login')">登录</button>
            <button :class="{ active: authMode === 'register' }" @click="setAuthMode('register')">注册</button>
          </div>
          <form class="form" @submit.prevent="submitAuth">
            <div class="form-row">
              <label>用户名</label>
              <input v-model="authForm.username" type="text" placeholder="请输入用户名" autocomplete="username" />
              <span class="error" v-if="authErrors.username">{{ authErrors.username }}</span>
            </div>
            <div class="form-row" v-if="authMode === 'register'">
              <label>昵称</label>
              <input v-model="authForm.displayName" type="text" placeholder="用于展示的昵称" autocomplete="nickname" />
              <span class="error" v-if="authErrors.displayName">{{ authErrors.displayName }}</span>
            </div>
            <div class="form-row">
              <label>密码</label>
              <input v-model="authForm.password" type="password" placeholder="请输入密码" autocomplete="current-password" />
              <span class="error" v-if="authErrors.password">{{ authErrors.password }}</span>
            </div>
            <div class="actions">
              <button class="primary" type="submit">{{ authMode === 'login' ? '立即登录' : '立即注册' }}</button>
              <button class="ghost" type="button" v-if="authMode === 'register'" @click="setAuthMode('login')">已有帐号？去登录</button>
            </div>
          </form>
          <p class="feedback" v-if="authFeedback">{{ authFeedback }}</p>
          <div class="current-user" v-if="currentUser">
            <p>当前登录：<strong>{{ currentUser.displayName }}</strong>（{{ currentUser.username }}）</p>
          </div>
        </div>
      </section>
    </main>

    <nav class="tabbar">
      <button :class="{ active: activeTab === 'home' }" @click="activeTab = 'home'">
        <span class="icon">🏠</span>
        <span>首页</span>
      </button>
      <button :class="{ active: activeTab === 'order' }" @click="activeTab = 'order'">
        <span class="icon">🧾</span>
        <span>点单</span>
      </button>
      <button :class="{ active: activeTab === 'explore' }" @click="activeTab = 'explore'">
        <span class="icon">✨</span>
        <span>灵感</span>
      </button>
      <button :class="{ active: activeTab === 'profile' }" @click="activeTab = 'profile'">
        <span class="icon">👤</span>
        <span>主页</span>
      </button>
    </nav>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import {
  createDrink,
  deleteDrink as removeDrink,
  listDrinks,
  login,
  register,
  updateDrink as patchDrink
} from './services/api'

const activeTab = ref('home')
const drinks = ref([])
const drinkForm = reactive({
  id: null,
  name: '',
  price: '',
  description: '',
  imageUrl: '',
  flavorProfile: '',
  available: true
})
const drinkErrors = reactive({})

const authMode = ref('login')
const authForm = reactive({
  username: '',
  displayName: '',
  password: ''
})
const authErrors = reactive({})
const authFeedback = ref('')
const currentUser = ref(null)

const withHero = (image) => {
  if (!image) return ''
  return `background-image: url(${image});`
}

const resetDrinkForm = () => {
  drinkForm.id = null
  drinkForm.name = ''
  drinkForm.price = ''
  drinkForm.description = ''
  drinkForm.imageUrl = ''
  drinkForm.flavorProfile = ''
  drinkForm.available = true
  Object.keys(drinkErrors).forEach((key) => delete drinkErrors[key])
}

const editDrink = (drink) => {
  drinkForm.id = drink.id
  drinkForm.name = drink.name
  drinkForm.price = drink.price ? Number(drink.price) : ''
  drinkForm.description = drink.description
  drinkForm.imageUrl = drink.imageUrl
  drinkForm.flavorProfile = drink.flavorProfile
  drinkForm.available = drink.available
  activeTab.value = 'order'
}

const validateDrink = () => {
  const errors = {}
  if (!drinkForm.name) errors.name = '请填写饮品名称'
  if (!drinkForm.price || Number(drinkForm.price) <= 0) errors.price = '价格需大于0'
  return errors
}

const submitDrink = async () => {
  const errors = validateDrink()
  Object.keys(drinkErrors).forEach((key) => delete drinkErrors[key])
  Object.assign(drinkErrors, errors)
  if (Object.keys(errors).length) return

  const payload = {
    name: drinkForm.name,
    price: Number(drinkForm.price),
    description: drinkForm.description,
    imageUrl: drinkForm.imageUrl,
    flavorProfile: drinkForm.flavorProfile,
    available: drinkForm.available
  }

  try {
    if (drinkForm.id) {
      await patchDrink(drinkForm.id, payload)
    } else {
      await createDrink(payload)
    }
    await refreshDrinks()
    resetDrinkForm()
  } catch (error) {
    if (error.response?.data?.errors) {
      Object.assign(drinkErrors, error.response.data.errors)
    }
  }
}

const deleteDrink = async (id) => {
  if (!confirm('确定要删除这款饮品吗？')) return
  try {
    await removeDrink(id)
    await refreshDrinks()
    if (drinkForm.id === id) {
      resetDrinkForm()
    }
  } catch (error) {
    alert(error.response?.data?.message || '删除失败，请稍后再试')
  }
}

const refreshDrinks = async () => {
  drinks.value = await listDrinks()
}

const setAuthMode = (mode) => {
  authMode.value = mode
  authFeedback.value = ''
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
}

const validateAuth = () => {
  const errors = {}
  if (!authForm.username) errors.username = '请填写用户名'
  if (authMode.value === 'register' && !authForm.displayName) errors.displayName = '请填写昵称'
  if (!authForm.password) errors.password = '请填写密码'
  return errors
}

const submitAuth = async () => {
  const errors = validateAuth()
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
  Object.assign(authErrors, errors)
  if (Object.keys(errors).length) return

  try {
    const payload = {
      username: authForm.username,
      password: authForm.password
    }
    if (authMode.value === 'register') {
      payload.displayName = authForm.displayName
      const user = await register(payload)
      currentUser.value = user
      setAuthMode('login')
      authFeedback.value = '注册成功，已自动为你登录。'
    } else {
      const user = await login(payload)
      currentUser.value = user
      authFeedback.value = `欢迎回来，${user.displayName}`
    }
    authForm.password = ''
  } catch (error) {
    authFeedback.value = error.response?.data?.message || '操作失败，请稍后再试'
  }
}

onMounted(async () => {
  try {
    await refreshDrinks()
  } catch (error) {
    console.error('加载饮品失败', error)
  }
})
</script>

<style scoped>
.mini-app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background: linear-gradient(180deg, #0f172a 0%, #0b1120 45%, #111827 100%);
  color: #e2e8f0;
}

.status-bar {
  padding: 16px 20px;
  font-size: 0.9rem;
  letter-spacing: 0.08em;
  color: rgba(248, 250, 252, 0.7);
  text-transform: uppercase;
}

.content {
  flex: 1;
  overflow-y: auto;
  padding: 12px 16px 96px;
}

.panel {
  background: rgba(15, 23, 42, 0.75);
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(18px);
}

.heading {
  font-size: 1.6rem;
  margin-bottom: 4px;
}

.subheading {
  color: rgba(148, 163, 184, 0.9);
  font-size: 0.95rem;
  margin-bottom: 18px;
}

.drink-cards {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 18px;
}

.drink-card {
  border-radius: 18px;
  overflow: hidden;
  background: rgba(30, 41, 59, 0.8);
}

.card-hero {
  position: relative;
  height: 140px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-color: rgba(59, 130, 246, 0.4);
}

.badge {
  position: absolute;
  top: 14px;
  left: 14px;
  background: rgba(14, 165, 233, 0.8);
  color: #0f172a;
  padding: 4px 10px;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
}

.availability {
  position: absolute;
  bottom: 14px;
  right: 14px;
  background: rgba(96, 165, 250, 0.85);
  border: none;
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
  color: #0f172a;
}

.availability.off {
  background: rgba(248, 113, 113, 0.85);
  color: #fee2e2;
}

.card-body {
  padding: 16px;
}

.card-body h2 {
  margin: 0 0 8px;
  font-size: 1.2rem;
}

.card-body p {
  margin: 0 0 12px;
  color: rgba(148, 163, 184, 0.85);
  line-height: 1.5;
}

.price {
  font-size: 1.1rem;
  color: #f9fafb;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 14px;
  margin-bottom: 24px;
}

.form-row {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-row.inline {
  flex-direction: row;
  align-items: center;
  gap: 12px;
}

label {
  font-size: 0.9rem;
  color: rgba(148, 163, 184, 0.9);
}

input,
textarea {
  background: rgba(30, 41, 59, 0.75);
  border: 1px solid rgba(148, 163, 184, 0.2);
  border-radius: 12px;
  padding: 10px 12px;
  color: #f8fafc;
  font-size: 0.95rem;
}

textarea {
  resize: vertical;
}

.actions {
  display: flex;
  gap: 12px;
}

button {
  border: none;
  border-radius: 12px;
  padding: 10px 16px;
  font-size: 0.95rem;
  font-weight: 600;
  cursor: pointer;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

button:active {
  transform: scale(0.98);
}

.primary {
  background: linear-gradient(135deg, #38bdf8 0%, #6366f1 100%);
  color: #0f172a;
}

.ghost {
  background: rgba(148, 163, 184, 0.15);
  color: #e2e8f0;
}

.danger {
  background: rgba(248, 113, 113, 0.9);
  color: #0f172a;
}

.error {
  font-size: 0.8rem;
  color: #fca5a5;
}

.switch {
  position: relative;
  display: inline-block;
  width: 42px;
  height: 24px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(148, 163, 184, 0.4);
  transition: 0.2s;
  border-radius: 999px;
}

.slider:before {
  position: absolute;
  content: '';
  height: 18px;
  width: 18px;
  left: 4px;
  bottom: 3px;
  background-color: white;
  transition: 0.2s;
  border-radius: 50%;
}

.switch input:checked + .slider {
  background-color: #60a5fa;
}

.switch input:checked + .slider:before {
  transform: translateX(18px);
}

.drink-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.drink-item {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 16px;
  padding: 16px;
  border-radius: 16px;
  background: rgba(30, 41, 59, 0.65);
}

.drink-item h3 {
  margin: 0 0 6px;
}

.meta {
  color: rgba(148, 163, 184, 0.8);
  margin: 0 0 6px;
}

.desc {
  margin: 0;
  color: rgba(226, 232, 240, 0.85);
}

.item-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.explore .placeholder {
  border-radius: 16px;
  background: rgba(30, 41, 59, 0.55);
  padding: 20px;
  line-height: 1.6;
  color: rgba(226, 232, 240, 0.9);
}

.profile .auth-card {
  background: rgba(30, 41, 59, 0.7);
  border-radius: 18px;
  padding: 20px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.tabs {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  background: rgba(15, 23, 42, 0.6);
  border-radius: 14px;
  padding: 4px;
}

.tabs button {
  border-radius: 12px;
  padding: 10px 0;
  background: transparent;
  color: rgba(226, 232, 240, 0.7);
}

.tabs button.active {
  background: rgba(96, 165, 250, 0.25);
  color: #f8fafc;
}

.feedback {
  color: rgba(96, 165, 250, 0.9);
  font-size: 0.9rem;
}

.current-user {
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.9);
}

.tabbar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
  padding: 12px 16px 18px;
  background: rgba(15, 23, 42, 0.95);
  box-shadow: 0 -10px 30px rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(18px);
}

.tabbar button {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  background: transparent;
  color: rgba(226, 232, 240, 0.7);
}

.tabbar button.active {
  color: #f8fafc;
}

.icon {
  font-size: 1.4rem;
}

@media (min-width: 768px) {
  .content {
    padding: 24px 24px 120px;
  }

  .panel {
    max-width: 720px;
    margin: 0 auto;
  }
}
</style>
