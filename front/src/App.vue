<template>
  <div class="mini-app">
    <header class="status-bar">8am 实验室 · 清晨咖啡甜品站</header>
    <main class="content">
      <section v-if="activeTab === 'home'" class="panel">
        <div class="panel-header">
          <h1 class="heading">今日灵感咖啡甜品</h1>
          <p class="subheading">甄选门店咖啡与巴斯克甜点，随时加入你的晨间灵感单。</p>
        </div>
        <section class="hero-carousel">
          <article class="hero-slide">
            <span class="hero-kicker">咖啡 × 巴斯克</span>
            <h2>清晨唤醒灵感</h2>
            <p>从第一口咖啡到最后一块芝士蛋糕，让忙碌的一天也充满仪式感。</p>
          </article>
          <div class="hero-dots">
            <span class="dot active"></span>
            <span class="dot"></span>
            <span class="dot"></span>
          </div>
        </section>
        <section class="home-section">
          <header class="section-header">
            <h2>菜单分类</h2>
            <p>探索咖啡与甜品的灵感搭配</p>
          </header>
          <div class="category-grid">
            <article v-for="category in homeCategories" :key="category.label" class="category-card">
              <span class="category-icon" :style="{ background: category.accent }">{{ category.icon }}</span>
              <div>
                <h3>{{ category.label }}</h3>
                <p>{{ category.description }}</p>
              </div>
            </article>
          </div>
        </section>
        <section class="home-section">
          <header class="section-header">
            <h2>推荐咖啡 &amp; 甜品</h2>
            <p>今晨值得一试的灵感搭配</p>
          </header>
          <div class="featured-grid">
            <article v-for="drink in featuredDrinks" :key="`featured-${drink.id}`" class="featured-card">
              <div class="featured-media" :style="withHero(drink.imageUrl)"></div>
              <div class="featured-body">
                <div class="featured-meta">
                  <span class="featured-merchant">{{ drink.merchantName || '灵感门店' }}</span>
                  <span class="featured-badge" v-if="drink.flavorProfile">{{ drink.flavorProfile }}</span>
                </div>
                <h3>{{ drink.name }}</h3>
                <p>{{ drink.description || '这是一份等待命名的灵感配方。' }}</p>
                <div class="featured-footer">
                  <strong>¥ {{ Number(drink.price).toFixed(2) }}</strong>
                  <span>热卖中</span>
                </div>
              </div>
            </article>
            <p v-if="!featuredDrinks.length" class="empty-hint">暂无推荐，稍后再来看看吧。</p>
          </div>
        </section>
        <section v-if="moreDrinks.length" class="home-section">
          <header class="section-header">
            <h2>全部咖啡甜品</h2>
            <p>完整菜单随时浏览</p>
          </header>
        </section>
        <div v-if="isAdmin && adminOverview" class="dashboard-grid">
          <div class="dashboard-card">
            <h3>菜单项数</h3>
            <span>{{ adminOverview.drinkCount }}</span>
          </div>
          <div class="dashboard-card">
            <h3>门店数</h3>
            <span>{{ adminOverview.merchantCount }}</span>
          </div>
          <div class="dashboard-card">
            <h3>订单数</h3>
            <span>{{ adminOverview.orderCount }}</span>
          </div>
          <div class="dashboard-card">
            <h3>团队成员</h3>
            <span>{{ adminOverview.userCount }}</span>
          </div>
          <div class="dashboard-card highlight">
            <h3>人气口味</h3>
            <span>{{ adminOverview.topDrink }}</span>
          </div>
        </div>
        <div v-else-if="isMerchant && merchantSnapshot" class="dashboard-grid">
          <div class="dashboard-card">
            <h3>待接单</h3>
            <span>{{ merchantSnapshot.received }}</span>
          </div>
          <div class="dashboard-card">
            <h3>制作中</h3>
            <span>{{ merchantSnapshot.preparing }}</span>
          </div>
          <div class="dashboard-card">
            <h3>待交付</h3>
            <span>{{ merchantSnapshot.ready }}</span>
          </div>
          <div class="dashboard-card">
            <h3>已完成</h3>
            <span>{{ merchantSnapshot.completed }}</span>
          </div>
        </div>
        <ul class="drink-cards" v-if="moreDrinks.length">
          <li v-for="drink in moreDrinks" :key="drink.id" class="drink-card">
            <div class="card-hero" :style="withHero(drink.imageUrl)">
              <span class="badge" v-if="drink.flavorProfile">{{ drink.flavorProfile }}</span>
              <button class="availability">来自 {{ drink.merchantName }}</button>
            </div>
            <div class="card-body">
              <h2>{{ drink.name }}</h2>
              <p>{{ drink.description || '这是一份等待命名的灵感配方。' }}</p>
              <strong class="price">¥ {{ Number(drink.price).toFixed(2) }}</strong>
            </div>
          </li>
        </ul>
      </section>

      <section v-else-if="activeTab === 'order'" class="panel">
        <template v-if="!currentUser">
          <div class="empty-state">
            <h2>请先登录</h2>
            <p>登录后即可根据角色进入对应的工作台。</p>
          </div>
        </template>
        <template v-else-if="isAdmin">
          <div class="panel-header">
            <h1 class="heading">咖啡甜品管理</h1>
            <p class="subheading">新增、编辑或下架菜单项，保持咖啡吧台和甜品柜常新。</p>
          </div>
          <form class="form" @submit.prevent="submitDrink">
            <div class="form-row">
              <label>菜单名称</label>
              <input v-model="drinkForm.name" type="text" placeholder="请输入咖啡或甜品名称" />
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
              <input v-model="drinkForm.imageUrl" type="url" placeholder="可选：咖啡或甜品展示图" />
            </div>
            <div class="form-row">
              <label>菜单描述</label>
              <textarea v-model="drinkForm.description" rows="3" placeholder="一句话描述你的咖啡或甜品故事"></textarea>
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
              <button class="primary" type="submit">{{ drinkForm.id ? '更新菜单项' : '新增菜单项' }}</button>
              <button class="ghost" type="button" v-if="drinkForm.id" @click="resetDrinkForm">取消编辑</button>
            </div>
          </form>

          <ul class="drink-list">
            <li v-for="drink in adminDrinks" :key="drink.id" class="drink-item">
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
        </template>
        <template v-else-if="isMerchant">
          <div class="panel-header">
            <h1 class="heading">门店接单工作台</h1>
            <p class="subheading">实时查看并更新 {{ merchantSnapshot?.merchantName || '' }} 的订单进度。</p>
          </div>
          <div class="order-board" v-if="merchantBoard.orders.length">
            <article v-for="order in merchantBoard.orders" :key="order.id" class="order-card">
              <header>
                <h3>{{ order.drinkName }} × {{ order.quantity }}</h3>
                <span class="status" :class="order.status.toLowerCase()">{{ statusLabel(order.status) }}</span>
              </header>
              <ul>
                <li>顾客：{{ order.customerName }}</li>
                <li>联系电话：{{ order.contactPhone }}</li>
                <li>取餐时间：{{ order.pickupTime || '尽快' }}</li>
                <li>下单时间：{{ formatTime(order.createdAt) }}</li>
              </ul>
              <footer>
                <button
                  v-for="transition in nextStatuses(order.status)"
                  :key="transition.code"
                  class="primary"
                  @click="changeOrderStatus(order.id, transition.code)"
                >
                  {{ transition.label }}
                </button>
              </footer>
            </article>
          </div>
          <div class="empty-state" v-else>
            <h2>暂时没有新订单</h2>
            <p>喝杯咖啡休息一下，新的灵感随时会来。</p>
          </div>
        </template>
        <template v-else>
          <OrderForm :drinks="catalogDrinks" :merchants="merchants" :submit-order="submitCustomerOrder" />
        </template>
      </section>

      <section v-else-if="activeTab === 'explore'" class="panel explore">
        <h1 class="heading">灵感实验室</h1>
        <p class="subheading">以数据驱动下一杯咖啡与下一块甜品，看看今日运营脉搏。</p>
        <div class="overview-grid" v-if="orderOverview">
          <div class="overview-card">
            <h3>新接单</h3>
            <span>{{ orderOverview.received }}</span>
          </div>
          <div class="overview-card">
            <h3>制作中</h3>
            <span>{{ orderOverview.preparing }}</span>
          </div>
          <div class="overview-card">
            <h3>待交付</h3>
            <span>{{ orderOverview.ready }}</span>
          </div>
          <div class="overview-card">
            <h3>已完成</h3>
            <span>{{ orderOverview.completed }}</span>
          </div>
          <div class="overview-card highlight">
            <h3>热销推荐</h3>
            <span>{{ orderOverview.topDrink }}</span>
          </div>
        </div>
        <RoleSpotlight />
      </section>

      <section v-else class="panel profile">
        <h1 class="heading">帐号中心</h1>
        <p class="subheading">区分角色登录，体验完整的前后端联动。</p>
        <div class="auth-card">
          <div class="tabs">
            <button :class="{ active: authMode === 'login' }" @click="setAuthMode('login')">登录</button>
            <button :class="{ active: authMode === 'register' }" @click="setAuthMode('register')">注册</button>
          </div>
          <form class="form" @submit.prevent="submitAuth">
            <div class="role-switcher" v-if="authMode === 'login'">
              <button
                v-for="role in roles"
                :key="role.value"
                type="button"
                :class="{ active: loginRole === role.value }"
                @click="setLoginRole(role.value)"
              >
                {{ role.label }}登录
              </button>
            </div>
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
            <div class="form-row" v-if="authMode === 'register'">
              <label>注册角色</label>
              <select v-model="registerRole">
                <option v-for="role in roles" :key="role.value" :value="role.value">{{ role.label }}</option>
              </select>
            </div>
            <div class="form-row" v-if="authMode === 'register' && registerRole === 'MERCHANT'">
              <label>关联门店</label>
              <select v-model="authForm.merchantId">
                <option disabled value="">请选择门店</option>
                <option v-for="merchant in merchants" :key="merchant.id" :value="merchant.id">
                  {{ merchant.name }} · {{ merchant.location }}
                </option>
              </select>
              <span class="error" v-if="authErrors.merchantId">{{ authErrors.merchantId }}</span>
            </div>
            <div class="actions">
              <button class="primary" type="submit">{{ authMode === 'login' ? '立即登录' : '立即注册' }}</button>
              <button class="ghost" type="button" v-if="authMode === 'register'" @click="setAuthMode('login')">已有帐号？去登录</button>
            </div>
          </form>
          <p class="feedback" v-if="authFeedback">{{ authFeedback }}</p>
          <div class="current-user" v-if="currentUser">
            <p>
              当前登录：<strong>{{ currentUser.displayName }}</strong>（{{ currentUser.username }}） · 角色：{{ roleLabel(currentUser.role) }}
            </p>
            <p v-if="currentUser.merchantName">所属门店：{{ currentUser.merchantName }}</p>
            <button class="ghost" type="button" @click="logout">退出登录</button>
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
        <span>{{ isCustomer ? '下单' : '工作台' }}</span>
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
import { computed, onMounted, reactive, ref, watch } from 'vue'
import OrderForm from './components/OrderForm.vue'
import RoleSpotlight from './components/RoleSpotlight.vue'
import {
  createDrink,
  deleteDrink as removeDrink,
  listDrinks,
  login,
  register,
  updateDrink as patchDrink,
  fetchAdminOverview,
  fetchCatalogDrinks,
  fetchMerchants,
  createOrder,
  fetchOrderOverview,
  fetchMerchantOrders,
  updateMerchantOrderStatus
} from './services/api'

const roles = [
  { label: '管理员', value: 'ADMIN' },
  { label: '商家', value: 'MERCHANT' },
  { label: '顾客', value: 'CUSTOMER' }
]

const activeTab = ref('home')
const adminDrinks = ref([])
const catalogDrinks = ref([])
const merchants = ref([])
const homeCategories = [
  {
    label: '经典咖啡',
    description: '拿铁、美式等经典配方，稳定发挥。',
    icon: '☕',
    accent: 'linear-gradient(135deg, rgba(59, 130, 246, 0.35), rgba(14, 116, 144, 0.65))'
  },
  {
    label: '创意冷萃',
    description: '冷萃与风味糖浆交织，适合尝鲜。',
    icon: '🧊',
    accent: 'linear-gradient(135deg, rgba(165, 180, 252, 0.4), rgba(129, 140, 248, 0.65))'
  },
  {
    label: '巴斯克芝士',
    description: '每日现烤的流心芝士蛋糕。',
    icon: '🧀',
    accent: 'linear-gradient(135deg, rgba(45, 212, 191, 0.35), rgba(16, 185, 129, 0.55))'
  },
  {
    label: '咖啡搭配',
    description: '咖啡伴侣，甜度恰到好处。',
    icon: '🍰',
    accent: 'linear-gradient(135deg, rgba(250, 204, 21, 0.35), rgba(244, 114, 182, 0.45))'
  }
]
const merchantBoard = reactive({
  merchantName: '',
  received: 0,
  preparing: 0,
  ready: 0,
  completed: 0,
  orders: []
})
const adminOverview = ref(null)
const orderOverview = ref(null)
const featuredDrinks = computed(() => catalogDrinks.value.slice(0, 4))
const moreDrinks = computed(() => catalogDrinks.value.slice(4))

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
const loginRole = ref('CUSTOMER')
const registerRole = ref('CUSTOMER')
const authForm = reactive({
  username: '',
  displayName: '',
  password: '',
  merchantId: ''
})
const authErrors = reactive({})
const authFeedback = ref('')
const currentUser = ref(null)

const isAdmin = computed(() => currentUser.value?.role === 'ADMIN')
const isMerchant = computed(() => currentUser.value?.role === 'MERCHANT')
const isCustomer = computed(() => currentUser.value?.role === 'CUSTOMER')
const merchantSnapshot = computed(() =>
  isMerchant.value
    ? {
        merchantName: merchantBoard.merchantName,
        received: merchantBoard.received,
        preparing: merchantBoard.preparing,
        ready: merchantBoard.ready,
        completed: merchantBoard.completed
      }
    : null
)

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
  if (!drinkForm.name) errors.name = '请填写菜单名称'
  if (!drinkForm.price || Number(drinkForm.price) <= 0) errors.price = '菜单价格需大于0'
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
    await loadAdminResources()
    resetDrinkForm()
  } catch (error) {
    if (error.response?.data?.errors) {
      Object.assign(drinkErrors, error.response.data.errors)
    }
  }
}

const deleteDrink = async (id) => {
  if (!confirm('确定要删除这款菜单项吗？')) return
  try {
    await removeDrink(id)
    await loadAdminResources()
    if (drinkForm.id === id) {
      resetDrinkForm()
    }
  } catch (error) {
    alert(error.response?.data?.message || '删除失败，请稍后再试')
  }
}

const validateAuth = () => {
  const errors = {}
  if (!authForm.username) errors.username = '请填写用户名'
  if (!authForm.password) errors.password = '请填写密码'
  if (authMode.value === 'register') {
    if (!authForm.displayName) errors.displayName = '请填写昵称'
    if (registerRole.value === 'MERCHANT' && !authForm.merchantId) {
      errors.merchantId = '请选择门店'
    }
  }
  return errors
}

const setAuthMode = (mode) => {
  authMode.value = mode
  authFeedback.value = ''
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
}

const setLoginRole = (role) => {
  loginRole.value = role
  authFeedback.value = ''
}

const roleLabel = (role) => roles.find((item) => item.value === role)?.label || role

const submitAuth = async () => {
  const errors = validateAuth()
  Object.keys(authErrors).forEach((key) => delete authErrors[key])
  Object.assign(authErrors, errors)
  if (Object.keys(errors).length) return

  try {
    if (authMode.value === 'register') {
      const payload = {
        username: authForm.username,
        displayName: authForm.displayName,
        password: authForm.password,
        role: registerRole.value
      }
      if (registerRole.value === 'MERCHANT') {
        payload.merchantId = authForm.merchantId
      }
      const user = await register(payload)
      currentUser.value = user
      loginRole.value = user.role
      setAuthMode('login')
      authFeedback.value = '注册成功，已为你登录。'
      authForm.password = ''
      await afterAuth(user)
    } else {
      const payload = {
        username: authForm.username,
        password: authForm.password,
        role: loginRole.value
      }
      const user = await login(payload)
      currentUser.value = user
      authFeedback.value = `欢迎回来，${user.displayName}`
      authForm.password = ''
      await afterAuth(user)
    }
  } catch (error) {
    authFeedback.value = error.response?.data?.message || '操作失败，请稍后再试'
  }
}

const logout = () => {
  currentUser.value = null
  loginRole.value = 'CUSTOMER'
  registerRole.value = 'CUSTOMER'
  authFeedback.value = ''
  resetDrinkForm()
  adminDrinks.value = []
  adminOverview.value = null
  merchantBoard.merchantName = ''
  merchantBoard.received = 0
  merchantBoard.preparing = 0
  merchantBoard.ready = 0
  merchantBoard.completed = 0
  merchantBoard.orders = []
}

const loadAdminResources = async () => {
  if (!isAdmin.value) return
  adminDrinks.value = await listDrinks()
  adminOverview.value = await fetchAdminOverview()
}

const loadMerchantBoard = async () => {
  if (!isMerchant.value || !currentUser.value?.merchantId) {
    merchantBoard.merchantName = ''
    merchantBoard.received = 0
    merchantBoard.preparing = 0
    merchantBoard.ready = 0
    merchantBoard.completed = 0
    merchantBoard.orders = []
    return
  }
  const snapshot = await fetchMerchantOrders(currentUser.value.merchantId)
  merchantBoard.merchantName = snapshot.merchantName
  merchantBoard.received = snapshot.received
  merchantBoard.preparing = snapshot.preparing
  merchantBoard.ready = snapshot.ready
  merchantBoard.completed = snapshot.completed
  merchantBoard.orders = snapshot.orders
}

const loadSharedResources = async () => {
  catalogDrinks.value = await fetchCatalogDrinks()
  merchants.value = await fetchMerchants()
  orderOverview.value = await fetchOrderOverview()
  if (registerRole.value === 'MERCHANT' && merchants.value.length && !authForm.merchantId) {
    authForm.merchantId = merchants.value[0].id
  }
}

const afterAuth = async (user) => {
  if (user.role === 'ADMIN') {
    await loadAdminResources()
  }
  if (user.role === 'MERCHANT') {
    await loadMerchantBoard()
  }
}

const submitCustomerOrder = async (payload) => {
  await createOrder({
    ...payload,
    drinkId: Number(payload.drinkId),
    merchantId: Number(payload.merchantId)
  })
  await loadMerchantBoard()
  await loadSharedResources()
}

const changeOrderStatus = async (orderId, status) => {
  if (!currentUser.value?.merchantId) return
  await updateMerchantOrderStatus(currentUser.value.merchantId, orderId, status)
  await loadMerchantBoard()
}

const statusLabel = (status) => {
  switch (status) {
    case 'RECEIVED':
      return '已接单'
    case 'PREPARING':
      return '制作中'
    case 'READY':
      return '待交付'
    case 'COMPLETED':
      return '已完成'
    default:
      return status
  }
}

const nextStatuses = (status) => {
  const transitions = {
    RECEIVED: [{ code: 'PREPARING', label: '开始制作' }],
    PREPARING: [
      { code: 'READY', label: '制作完成' }
    ],
    READY: [{ code: 'COMPLETED', label: '完成交付' }],
    COMPLETED: []
  }
  return transitions[status] || []
}

const formatTime = (isoString) => {
  if (!isoString) return '--'
  const date = new Date(isoString)
  return `${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`
}

watch(
  () => registerRole.value,
  (role) => {
    if (role !== 'MERCHANT') {
      authForm.merchantId = ''
    } else if (!authForm.merchantId && merchants.value.length) {
      authForm.merchantId = merchants.value[0].id
    }
  }
)

watch(
  () => currentUser.value?.role,
  async (role) => {
    if (role === 'ADMIN') {
      await loadAdminResources()
    } else if (role === 'MERCHANT') {
      await loadMerchantBoard()
    }
  }
)

onMounted(async () => {
  try {
    await loadSharedResources()
  } catch (error) {
    console.error('初始化数据失败', error)
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

.hero-carousel {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 24px;
}

.hero-slide {
  position: relative;
  padding: 28px;
  border-radius: 22px;
  background: linear-gradient(145deg, rgba(59, 130, 246, 0.3), rgba(30, 64, 175, 0.45));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.12);
  overflow: hidden;
}

.hero-slide::after {
  content: '';
  position: absolute;
  inset: 10px;
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.18);
  pointer-events: none;
}

.hero-kicker {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.55);
  font-size: 0.8rem;
  letter-spacing: 0.08em;
}

.hero-slide h2 {
  margin: 16px 0 8px;
  font-size: 1.5rem;
}

.hero-slide p {
  margin: 0;
  color: rgba(226, 232, 240, 0.85);
  line-height: 1.5;
}

.hero-dots {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.dot {
  width: 8px;
  height: 8px;
  border-radius: 999px;
  background: rgba(148, 163, 184, 0.35);
  transition: transform 0.3s ease, background 0.3s ease;
}

.dot.active {
  background: rgba(56, 189, 248, 0.9);
  transform: scale(1.3);
}

.home-section {
  margin-bottom: 28px;
}

.section-header {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.section-header h2 {
  margin: 0;
  font-size: 1.2rem;
}

.section-header p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 16px;
}

.category-card {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 18px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.7);
  border: 1px solid rgba(148, 163, 184, 0.18);
  box-shadow: 0 16px 32px rgba(15, 23, 42, 0.25);
}

.category-icon {
  width: 44px;
  height: 44px;
  border-radius: 14px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-size: 1.4rem;
  color: #0f172a;
  box-shadow: 0 12px 24px rgba(15, 23, 42, 0.2);
}

.category-card h3 {
  margin: 0;
  font-size: 1rem;
}

.category-card p {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
  font-size: 0.9rem;
}

.featured-grid {
  display: grid;
  gap: 16px;
}

.featured-card {
  display: grid;
  grid-template-columns: 110px 1fr;
  gap: 16px;
  padding: 16px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.75);
  border: 1px solid rgba(148, 163, 184, 0.15);
  box-shadow: 0 20px 36px rgba(15, 23, 42, 0.35);
}

.featured-media {
  border-radius: 14px;
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-color: rgba(59, 130, 246, 0.35);
}

.featured-body {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.featured-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.85);
}

.featured-merchant {
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(15, 23, 42, 0.55);
}

.featured-badge {
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(56, 189, 248, 0.2);
  color: rgba(125, 211, 252, 0.95);
}

.featured-card h3 {
  margin: 0;
  font-size: 1.1rem;
}

.featured-card p {
  margin: 0;
  color: rgba(226, 232, 240, 0.8);
  line-height: 1.45;
}

.featured-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.95rem;
  color: rgba(148, 163, 184, 0.85);
}

.featured-footer strong {
  font-size: 1.1rem;
  color: #f8fafc;
}

.empty-hint {
  grid-column: 1 / -1;
  margin: 0;
  text-align: center;
  color: rgba(148, 163, 184, 0.75);
}

.panel-header {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 16px;
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

.dashboard-grid {
  display: grid;
  gap: 12px;
  margin-bottom: 24px;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
}

.dashboard-card {
  padding: 18px;
  border-radius: 16px;
  background: rgba(30, 41, 59, 0.8);
  border: 1px solid rgba(148, 163, 184, 0.18);
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.dashboard-card h3 {
  margin: 0;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.dashboard-card span {
  font-size: 1.4rem;
  font-weight: 700;
}

.dashboard-card.highlight {
  grid-column: span 2;
  background: linear-gradient(145deg, rgba(14, 165, 233, 0.2), rgba(99, 102, 241, 0.25));
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
  color: #0f172a;
  font-weight: 600;
}

.card-body {
  padding: 18px;
  display: grid;
  gap: 10px;
}

.card-body h2 {
  margin: 0;
  font-size: 1.3rem;
}

.card-body p {
  margin: 0;
  color: rgba(226, 232, 240, 0.8);
  line-height: 1.6;
}

.price {
  font-size: 1.1rem;
}

.form {
  display: grid;
  gap: 16px;
}

.form-row {
  display: grid;
  gap: 6px;
}

.inline {
  align-items: center;
  grid-template-columns: auto auto auto;
  gap: 12px;
}

label {
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.85);
}

input,
select,
textarea {
  width: 100%;
  padding: 14px 16px;
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
  color: #f8fafc;
}

textarea {
  resize: vertical;
}

input:focus,
select:focus,
textarea:focus {
  outline: none;
  border-color: rgba(96, 165, 250, 0.75);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
}

.switch {
  position: relative;
  display: inline-flex;
  align-items: center;
  width: 44px;
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
  inset: 0;
  background-color: rgba(148, 163, 184, 0.4);
  border-radius: 999px;
  transition: 0.3s;
}

.slider:before {
  position: absolute;
  content: '';
  height: 18px;
  width: 18px;
  left: 3px;
  bottom: 3px;
  background-color: #0f172a;
  border-radius: 50%;
  transition: 0.3s;
}

input:checked + .slider {
  background-color: rgba(14, 165, 233, 0.6);
}

input:checked + .slider:before {
  transform: translateX(20px);
}

.actions {
  display: flex;
  gap: 12px;
}

button {
  cursor: pointer;
}

button.primary {
  flex: none;
  padding: 14px 24px;
  border-radius: 999px;
  border: none;
  font-size: 1rem;
  font-weight: 600;
  color: #020617;
  background: linear-gradient(135deg, #38bdf8, #22d3ee 55%, #60a5fa);
  box-shadow: 0 18px 32px rgba(14, 165, 233, 0.35);
}

button.ghost {
  padding: 14px 24px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: transparent;
  color: #e2e8f0;
}

button.danger {
  padding: 14px 24px;
  border-radius: 999px;
  border: none;
  background: rgba(248, 113, 113, 0.2);
  color: #fecaca;
}

.error {
  color: #f87171;
  font-size: 0.85rem;
}

.drink-list {
  list-style: none;
  padding: 0;
  margin: 24px 0 0;
  display: grid;
  gap: 16px;
}

.drink-item {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  padding: 16px;
  border-radius: 16px;
  background: rgba(30, 41, 59, 0.65);
}

.meta {
  margin: 4px 0;
  color: rgba(148, 163, 184, 0.9);
}

.desc {
  margin: 0;
  color: rgba(226, 232, 240, 0.8);
}

.item-actions {
  display: flex;
  gap: 10px;
  align-items: center;
}

.order-board {
  display: grid;
  gap: 16px;
}

.order-card {
  padding: 18px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.7);
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 12px;
}

.order-card header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-card ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 6px;
  color: rgba(226, 232, 240, 0.85);
  font-size: 0.95rem;
}

.order-card footer {
  display: flex;
  gap: 10px;
}

.status {
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 0.8rem;
  color: #0f172a;
  background: rgba(96, 165, 250, 0.85);
}

.status.preparing {
  background: rgba(251, 191, 36, 0.75);
}

.status.ready {
  background: rgba(34, 211, 238, 0.75);
}

.status.completed {
  background: rgba(134, 239, 172, 0.75);
}

.empty-state {
  text-align: center;
  padding: 48px 0;
  color: rgba(226, 232, 240, 0.75);
}

.explore .overview-grid {
  margin-bottom: 32px;
}

.overview-grid {
  display: grid;
  gap: 16px;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
}

.overview-card {
  padding: 16px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.75);
  border: 1px solid rgba(148, 163, 184, 0.18);
}

.overview-card h3 {
  margin: 0;
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.overview-card span {
  display: block;
  margin-top: 8px;
  font-size: 1.4rem;
  font-weight: 700;
}

.overview-card.highlight {
  grid-column: span 2;
  background: linear-gradient(145deg, rgba(59, 130, 246, 0.2), rgba(129, 140, 248, 0.25));
}

.auth-card {
  background: rgba(15, 23, 42, 0.65);
  border-radius: 20px;
  padding: 20px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 18px;
}

.tabs {
  display: inline-flex;
  background: rgba(30, 41, 59, 0.8);
  border-radius: 999px;
  padding: 4px;
}

.tabs button {
  padding: 10px 22px;
  border-radius: 999px;
  border: none;
  background: transparent;
  color: rgba(226, 232, 240, 0.75);
}

.tabs button.active {
  background: linear-gradient(135deg, rgba(14, 165, 233, 0.35), rgba(79, 70, 229, 0.4));
  color: #f8fafc;
}

.role-switcher {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.role-switcher button {
  flex: 1 1 30%;
  padding: 10px 12px;
  border-radius: 12px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: transparent;
  color: rgba(226, 232, 240, 0.75);
  font-size: 0.9rem;
}

.role-switcher button.active {
  background: rgba(59, 130, 246, 0.25);
  border-color: rgba(59, 130, 246, 0.55);
  color: #f8fafc;
}

.feedback {
  margin: 0;
  color: rgba(125, 211, 252, 0.9);
}

.current-user {
  display: grid;
  gap: 10px;
  padding: 16px;
  border-radius: 14px;
  background: rgba(30, 41, 59, 0.6);
}

.tabbar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  background: rgba(15, 23, 42, 0.85);
  backdrop-filter: blur(16px);
  border-top: 1px solid rgba(148, 163, 184, 0.15);
}

.tabbar button {
  border: none;
  background: transparent;
  color: rgba(148, 163, 184, 0.9);
  padding: 10px 0;
  display: grid;
  place-items: center;
  gap: 4px;
  font-size: 0.8rem;
}

.tabbar button.active {
  color: #f8fafc;
}

.icon {
  font-size: 1.2rem;
}

@media (min-width: 768px) {
  .content {
    max-width: 960px;
    margin: 0 auto;
  }

  .dashboard-card.highlight,
  .overview-card.highlight {
    grid-column: span 1;
  }

  .tabbar {
    position: static;
    margin-top: 24px;
    border-radius: 20px;
    overflow: hidden;
  }
}
</style>
