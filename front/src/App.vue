<template>
  <div class="mini-app">
    <header class="status-bar">8am 实验室 · 清晨饮品站</header>
    <main class="content">
      <section v-if="activeTab === 'home'" class="panel home-panel">
        <HomeShowcase
          :drinks="catalogDrinks"
          :merchants="merchants"
          :cart-items="sharedCartItems"
          :cart-summary="sharedCartSummary"
          :cart-total="sharedCartTotal"
          :add-to-cart="addCartItem"
          :increment-item="addCartItem"
          :decrement-item="decrementCartItem"
          :clear-cart="clearSharedCart"
          @checkout="openStorePicker"
        />
      </section>

      <section v-else-if="activeTab === 'order' && showWorkbench" class="panel">
        <template v-if="!currentUser">
          <div class="empty-state">
            <h2>请先登录</h2>
            <p>登录后即可根据角色进入对应的工作台。</p>
          </div>
        </template>
        <template v-else-if="isAdmin">
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
                <li>取杯时间：{{ order.pickupTime || '尽快' }}</li>
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
          <OrderForm
            :drinks="catalogDrinks"
            :merchants="merchants"
            :preferred-merchant-id="selectedMerchantId"
            :submit-order="submitCustomerOrder"
          />
        </template>
      </section>

      <section v-else-if="activeTab === 'explore'" class="panel explore-panel">
        <CategoryShowcase
          :drinks="catalogDrinks"
          initial-category="DESSERT"
          :cart-items="sharedCartItems"
          :cart-summary="sharedCartSummary"
          :cart-total="sharedCartTotal"
          :add-to-cart="addCartItem"
          :increment-item="addCartItem"
          :decrement-item="decrementCartItem"
          :clear-cart="clearSharedCart"
          @checkout="openStorePicker"
        />
      </section>

      <section v-else-if="activeTab === 'storePicker'" class="panel store-picker-page">
        <header class="store-page-header">
          <button class="ghost back-link" type="button" @click="closeStorePicker">‹ 返回</button>
          <div>
            <p class="store-title">选择取杯门店</p>
            <small class="store-note">{{ locationStatusText }}</small>
          </div>
          <button
            class="ghost"
            type="button"
            :disabled="locationStatus === 'pending' || !geolocationSupported"
            @click="requestLocation"
          >
            {{ locationButtonLabel }}
          </button>
        </header>
        <p class="store-intro">下单前先锁定离你最近的门店，便于安排取杯与通知。</p>
        <ul class="store-list">
          <li v-for="store in sortedMerchants" :key="store.id">
            <button
              type="button"
              :class="{ active: storePicker.selectedId === store.id }"
              @click="storePicker.selectedId = store.id"
            >
              <div>
                <strong>{{ store.name }}</strong>
                <span>{{ store.location || '地址待完善' }}</span>
              </div>
              <div class="distance" v-if="store.distance !== null">{{ store.distance.toFixed(1) }} km</div>
              <div class="distance" v-else>--</div>
            </button>
          </li>
          <li v-if="!sortedMerchants.length" class="store-empty">暂无可选门店</li>
        </ul>
        <div class="store-actions">
          <button class="ghost" type="button" @click="closeStorePicker">取消</button>
          <button class="primary" type="button" :disabled="!storePicker.selectedId" @click="confirmStoreSelection">
            确认门店
          </button>
        </div>
        <small v-if="locationStatus === 'denied'" class="store-denied">定位被拒，可在浏览器设置中允许权限</small>
      </section>

      <section v-else-if="activeTab === 'checkout'" class="panel checkout-panel">
        <header class="checkout-store">
          <div>
            <p class="section-label">取杯门店</p>
            <h2>{{ selectedMerchant?.name || '请选择门店' }}</h2>
            <small>{{ selectedMerchant?.location || '请选择门店以继续下单' }}</small>
          </div>
          <button class="ghost" type="button" @click="openStorePicker">切换门店</button>
        </header>

        <div class="checkout-contact" v-if="currentUser">
          <div>
            <p>取餐联系人</p>
            <strong>{{ orderContactName || '请完善称呼' }}</strong>
          </div>
          <div>
            <p>联系电话</p>
            <strong>{{ orderContactPhone || '请完善手机号' }}</strong>
          </div>
          <button class="ghost" type="button" @click="handleProfileAction('info')">完善资料</button>
        </div>
        <div class="checkout-contact warning" v-else>
          <div>
            <p>尚未登录</p>
            <small>登录后才能提交订单</small>
          </div>
          <button class="primary" type="button" @click="activeTab = 'profileLogin'">立即登录</button>
        </div>

        <section class="checkout-pickup">
          <header>
            <p>取餐方式</p>
            <small>{{ pickupMethodText }}</small>
          </header>
          <div class="pickup-options">
            <button
              v-for="option in pickupOptions"
              :key="option.value"
              type="button"
              :class="{ active: pickupMethod === option.value }"
              @click="pickupMethod = option.value"
            >
              <strong>{{ option.label }}</strong>
              <span>{{ option.desc }}</span>
            </button>
          </div>
        </section>

        <section class="checkout-products">
          <header>
            <div>
              <p>已选商品</p>
              <small>{{ sharedCartSummary }}</small>
            </div>
            <button class="ghost" type="button" @click="activeTab = 'home'">继续加购</button>
          </header>
          <ul v-if="sharedCartItems.length" class="checkout-list">
            <li v-for="item in sharedCartItems" :key="item.id">
              <div class="thumb" :style="checkoutThumbStyle(item)">
                <span v-if="item.tag" class="mini-tag">{{ item.tag }}</span>
              </div>
              <div class="item-info">
                <h3>{{ item.name }}</h3>
                <p>{{ item.customSummary || '标准出品' }}</p>
                <span>¥ {{ Number(item.price || 0).toFixed(2) }}</span>
              </div>
              <div class="item-qty">× {{ item.quantity }}</div>
            </li>
          </ul>
          <p v-else class="cart-empty">购物车为空，去首页挑选喜欢的商品吧</p>
        </section>

        <div class="checkout-summary">
          <span>共 {{ sharedCartCount }} 件</span>
          <strong>¥ {{ sharedCartTotal.toFixed(2) }}</strong>
        </div>

        <div class="checkout-remark">
          <div>
            <p>订单备注</p>
            <small>{{ orderRemark || '口味、包装等特殊要求' }}</small>
          </div>
          <button class="ghost" type="button" @click="remarkEditorOpen = !remarkEditorOpen">
            {{ remarkEditorOpen ? '完成' : '编辑' }}
          </button>
        </div>
        <textarea
          v-if="remarkEditorOpen"
          class="remark-editor"
          v-model="orderRemark"
          placeholder="示例：少糖、另外附赠纸袋"
        ></textarea>

        <p class="feedback" v-if="checkoutFeedback">{{ checkoutFeedback }}</p>

        <button
          class="primary checkout-submit"
          type="button"
          :disabled="checkoutDisabled"
          @click="handleCheckoutSubmit"
        >
          {{ checkoutSubmitting ? '下单中…' : `确认下单 · ¥ ${sharedCartTotal.toFixed(2)}` }}
        </button>
      </section>

      <section v-else-if="activeTab === 'profile'" class="panel profile">
        <div class="profile-hero banner-card">
          <img class="banner-bg" :src="profileBanner" alt="个人背景" />
          <div class="banner-overlay"></div>
          <button class="ghost icon-only banner-action" type="button" @click="handleProfileAction('info')">⚙</button>
          <div class="banner-content">
            <p class="banner-greeting">{{ heroGreeting }}</p>
            <small class="banner-role">{{ currentUser ? heroSubtitle : '未登录 · 游客模式' }}</small>
          </div>
          <div class="hero-avatar">
            <img v-if="profileAvatar" :src="profileAvatar" alt="当前头像" />
            <span v-else>{{ currentUser ? (currentUser.displayName || currentUser.username).slice(0, 1) : '访' }}</span>
          </div>
        </div>

        <div class="profile-highlights">
          <article v-for="card in profileHighlights" :key="card.label">
            <p class="card-label">{{ card.label }}</p>
            <strong>{{ card.value }}</strong>
            <span>{{ card.desc }}</span>
          </article>
        </div>

        <div class="profile-actions">
          <button
            v-for="item in profileActions"
            :key="item.key"
            type="button"
            @click="handleProfileAction(item.key)"
          >
            <div class="action-icon">{{ item.icon }}</div>
            <div class="action-info">
              <p>{{ item.label }}</p>
              <small>{{ item.desc }}</small>
            </div>
            <span class="action-arrow">›</span>
          </button>
        </div>

        <div v-if="currentUser" class="current-user detail-card">
          <p>
            当前登录：<strong>{{ currentUser.displayName }}</strong>（{{ currentUser.username }}） · 角色：{{ roleLabel(currentUser.role) }}
          </p>
          <p v-if="currentUser.merchantName">所属门店：{{ currentUser.merchantName }}</p>
          <button class="ghost" type="button" @click="logout">退出登录</button>
        </div>
        <div v-else class="auth-card profile-auth compact">
          <p class="cta-hint">登录后可同步订单、领取优惠券</p>
          <button class="primary gate-cta" type="button" @click="activeTab = 'profileLogin'">立即登录</button>
        </div>
      </section>

      <section v-else-if="activeTab === 'profileLogin'" class="panel profile auth-full">
        <button class="ghost back-link" type="button" @click="activeTab = 'profile'">‹ 返回我的</button>
        <div class="auth-card profile-auth">
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
              <button class="primary gate-cta" type="submit">{{ authMode === 'login' ? '立即登录' : '立即注册' }}</button>
              <button class="ghost" type="button" v-if="authMode === 'register'" @click="setAuthMode('login')">已有帐号？去登录</button>
            </div>
          </form>
          <p class="feedback" v-if="authFeedback">{{ authFeedback }}</p>
        </div>
      </section>

      <section v-else-if="activeTab === 'profileLanguage'" class="panel profile language-panel">
        <button class="ghost back-link" type="button" @click="activeTab = 'profile'">‹ 返回我的</button>
        <div class="language-card">
          <header>
            <p class="language-kicker">界面语言</p>
            <h2>请选择常用语言</h2>
            <small>系统会尽量保持中文显示，也支持英文界面方便境外顾客</small>
          </header>
          <ul class="language-list">
            <li v-for="option in languageOptions" :key="option.value">
              <button
                type="button"
                :class="{ active: currentLanguage === option.value }"
                @click="changeLanguage(option.value)"
              >
                <div>
                  <strong>{{ option.label }}</strong>
                  <span>{{ option.desc }}</span>
                </div>
                <span class="status" v-if="currentLanguage === option.value">使用中</span>
              </button>
            </li>
          </ul>
          <p class="language-tip">切换后部分文案可能需要刷新或重新进入页面才会更新。</p>
          <p class="feedback" v-if="languageFeedback">{{ languageFeedback }}</p>
        </div>
      </section>

      <section v-else-if="activeTab === 'profileSettings'" class="panel profile settings-panel">
        <header class="settings-header">
          <button class="ghost back-link" type="button" @click="activeTab = 'profile'">‹ 返回</button>
          <h2>个人资料</h2>
          <button class="ghost icon-only" type="button" @click="showProfileHints">···</button>
        </header>

        <div v-if="profileLoading" class="empty-state">
          <h2>加载资料中...</h2>
          <p>请稍候，正在同步账户信息。</p>
        </div>

        <div v-else-if="currentUser" class="settings-body">
          <div class="settings-card">
            <div class="avatar-preview">
              <div class="avatar-shell large">
                <img v-if="avatarDisplay" :src="avatarDisplay" alt="当前头像" />
                <span v-else>{{ profileInitial }}</span>
                <button class="avatar-edit" type="button" :disabled="avatarUploading" @click="triggerAvatarPicker">
                  {{ avatarUploading ? '上传中...' : '更换' }}
                </button>
                <input
                  ref="avatarInputRef"
                  type="file"
                  accept="image/*"
                  capture="environment"
                  class="visually-hidden"
                  :disabled="avatarUploading"
                  @change="handleAvatarFile"
                />
              </div>
              <small class="upload-hint" v-if="avatarUploading">正在上传，请稍候...</small>
              <p class="membership-date">{{ membershipCopy }}</p>
              <small class="membership-code">会员 NO.{{ membershipCode }}</small>
            </div>
          </div>

          <form class="profile-form" @submit.prevent="submitProfile">
            <div class="form-row required">
              <label>昵称</label>
              <input v-model.trim="profileForm.displayName" type="text" placeholder="请输入昵称" />
              <span class="error" v-if="profileErrors.displayName">{{ profileErrors.displayName }}</span>
            </div>
            <div class="form-row">
              <label>姓氏</label>
              <input v-model.trim="profileForm.familyName" type="text" placeholder="请输入姓氏" />
            </div>
            <div class="form-row">
              <label>名字</label>
              <input v-model.trim="profileForm.givenName" type="text" placeholder="请输入名字" />
            </div>
            <div class="form-row">
              <label>性别</label>
              <select v-model="profileForm.gender">
                <option value="">请选择</option>
                <option v-for="option in genderOptions" :key="option" :value="option">{{ option }}</option>
              </select>
            </div>
            <div class="form-row">
              <label>手机</label>
              <input v-model.trim="profileForm.phone" type="tel" placeholder="点击填写手机号" />
            </div>
            <div class="form-row">
              <label>生日</label>
              <input v-model="profileForm.birthday" type="date" placeholder="请选择你的生日" />
            </div>
            <div class="actions sticky-actions">
              <button class="primary" type="submit" :disabled="profileSaving">
                {{ profileSaving ? '保存中...' : '保存' }}
              </button>
            </div>
            <p class="feedback" v-if="profileFeedback">{{ profileFeedback }}</p>
          </form>
        </div>

        <div v-else class="empty-state">
          <h2>请先登录</h2>
          <p>登录后即可编辑个人资料并同步到数据库。</p>
          <button class="primary" type="button" @click="activeTab = 'profileLogin'">去登录</button>
        </div>
      </section>
    </main>

    <nav class="tabbar" :class="{ compact: !showWorkbench }">
      <button :class="{ active: activeTab === 'home' || activeTab === 'checkout' }" @click="activeTab = 'home'">
        <span class="icon">🏠</span>
        <span>首页</span>
      </button>
      <button v-if="showWorkbench" :class="{ active: activeTab === 'order' }" @click="activeTab = 'order'">
        <span class="icon">🧾</span>
        <span>工作台</span>
      </button>
      <button :class="{ active: activeTab === 'explore' }" @click="activeTab = 'explore'">
        <span class="icon">✨</span>
        <span>灵感</span>
      </button>
      <button
        :class="{
          active:
            activeTab === 'profile' ||
            activeTab === 'profileLogin' ||
            activeTab === 'profileSettings' ||
            activeTab === 'profileLanguage'
        }"
        @click="activeTab = 'profile'"
      >
        <span class="icon">👤</span>
        <span>我的</span>
      </button>
    </nav>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue'
const brandLogo = new URL('./assets/logo.png', import.meta.url).href
const profileBg = brandLogo
import OrderForm from './components/OrderForm.vue'
import HomeShowcase from './components/HomeShowcase.vue'
import CategoryShowcase from './components/CategoryShowcase.vue'
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
  updateMerchantOrderStatus,
  fetchUserProfile,
  updateUserProfile,
  uploadAvatar,
  createAlipayPayment
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
const merchantBoard = reactive({
  merchantName: '',
  received: 0,
  preparing: 0,
  ready: 0,
  completed: 0,
  orders: []
})
const sharedCart = reactive({})
const sharedCartItems = computed(() => Object.values(sharedCart))
const sharedCartCount = computed(() => sharedCartItems.value.reduce((sum, item) => sum + (item.quantity || 0), 0))
const sharedCartTotal = computed(() =>
  sharedCartItems.value.reduce((sum, item) => sum + Number(item.price || 0) * (item.quantity || 0), 0)
)
const sharedCartSummary = computed(() =>
  sharedCartCount.value ? `共 ${sharedCartCount.value} 件 · ¥ ${sharedCartTotal.value.toFixed(2)}` : '购物车为空'
)

const normalizeCartEntry = (item = {}) => {
  const signature = item.cartSignature || item.id || item.drinkId
  return {
    id: signature,
    cartSignature: signature,
    drinkId: item.drinkId ?? item.id ?? signature,
    name: item.name,
    price: Number(item.price) || 0,
    imageUrl: item.imageUrl || item.image,
    merchantName: item.merchantName || '',
    tag: item.tag,
    customSummary: item.customSummary || '',
    customizations: item.customizations || null,
    quantity: Number(item.quantity) || 0
  }
}

const addCartItem = (item) => {
  if (!item) return
  const payload = normalizeCartEntry(item)
  if (!payload.id) return
  const key = String(payload.id)
  if (!sharedCart[key]) {
    sharedCart[key] = { ...payload, quantity: 0 }
  }
  if (payload.customSummary) {
    sharedCart[key].customSummary = payload.customSummary
  }
  if (payload.customizations) {
    sharedCart[key].customizations = payload.customizations
  }
  sharedCart[key].quantity += payload.quantity || 1
}

const decrementCartItem = (item) => {
  if (!item?.id) return
  const key = String(item.id)
  if (!sharedCart[key]) return
  sharedCart[key].quantity -= 1
  if (sharedCart[key].quantity <= 0) {
    delete sharedCart[key]
  }
}

const clearSharedCart = () => {
  Object.keys(sharedCart).forEach((key) => delete sharedCart[key])
}
const adminOverview = ref(null)
const orderOverview = ref(null)

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

const genderOptions = ['女', '男', '保密']
const profileForm = reactive({
  displayName: '',
  familyName: '',
  givenName: '',
  gender: '',
  phone: '',
  birthday: '',
  avatar: ''
})
const profileErrors = reactive({})
const profileFeedback = ref('')
const profileSaving = ref(false)
const profileLoading = ref(false)
const avatarInputRef = ref(null)
const avatarUploading = ref(false)
const avatarPreviewUrl = ref('')
const selectedMerchantId = ref(null)
const storePicker = reactive({
  selectedId: null,
  returnTab: 'home'
})
const pickupOptions = [
  { value: 'DINE_IN', label: '店内享用', desc: '堂食慢慢品味' },
  { value: 'TAKEAWAY', label: '打包带走', desc: '到店自取更灵活' }
]
const pickupMethod = ref('TAKEAWAY')
const orderRemark = ref('')
const remarkEditorOpen = ref(false)
const checkoutFeedback = ref('')
const checkoutSubmitting = ref(false)
const geolocationSupported = typeof navigator !== 'undefined' && !!navigator.geolocation
const locationStatus = ref(geolocationSupported ? 'idle' : 'unsupported')
const userLocation = reactive({
  lat: null,
  lng: null
})

const isAdmin = computed(() => currentUser.value?.role === 'ADMIN')
const isMerchant = computed(() => currentUser.value?.role === 'MERCHANT')
const isCustomer = computed(() => currentUser.value?.role === 'CUSTOMER')
const showWorkbench = computed(() => isAdmin.value || isMerchant.value)
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

const heroGreeting = computed(() =>
  currentUser.value ? `您好，${currentUser.value.displayName}` : '欢迎来到 8AM 灵感室'
)

const heroSubtitle = computed(() =>
  currentUser.value ? `角色 · ${roleLabel(currentUser.value.role)}` : '游客模式 · 浏览精选内容'
)

const membershipCode = computed(() =>
  currentUser.value?.id ? String(currentUser.value.id).padStart(6, '0') : '------'
)

const membershipCopy = computed(() => {
  if (!currentUser.value) {
    return '欢迎加入 8AM 灵感室'
  }
  const base = new Date(2024, 0, 1)
  const offset = currentUser.value.id ? currentUser.value.id % 160 : 0
  base.setDate(base.getDate() + offset)
  const month = String(base.getMonth() + 1).padStart(2, '0')
  const day = String(base.getDate()).padStart(2, '0')
  const venue = currentUser.value.merchantName || '8AM 灵感室'
  return `${base.getFullYear()}-${month}-${day} 成为 ${venue} 会员`
})

const profileInitial = computed(() =>
  profileForm.displayName
    ? profileForm.displayName.slice(0, 1)
    : currentUser.value?.displayName?.slice(0, 1) || '访'
)
const avatarDisplay = computed(() => avatarPreviewUrl.value || profileForm.avatar || '')
const profileAvatar = computed(() => {
  if (avatarPreviewUrl.value) return avatarPreviewUrl.value
  if (profileForm.avatar) return profileForm.avatar
  return currentUser.value?.avatar || ''
})
const profileBanner = computed(
  () =>
    currentUser.value?.banner || profileBg
)
const locationStatusText = computed(() => {
  switch (locationStatus.value) {
    case 'pending':
      return '定位中，请稍候'
    case 'ready':
      return '已根据当前位置推荐'
    case 'denied':
      return '未授权定位，可手动选择'
    case 'error':
      return '定位失败，可手动选择'
    case 'unsupported':
      return '设备不支持定位'
    default:
      return '可开启定位以按距离排序'
  }
})
const locationButtonLabel = computed(() => {
  if (!geolocationSupported) return '设备不支持定位'
  if (locationStatus.value === 'pending') return '定位中...'
  if (locationStatus.value === 'ready') return '重新定位'
  if (locationStatus.value === 'denied') return '重新授权定位'
  if (locationStatus.value === 'error') return '重新定位'
  return '开启定位'
})
const sortedMerchants = computed(() => {
  const lat = userLocation.lat
  const lng = userLocation.lng
  const list = merchants.value.map((store) => {
    let distance = null
    if (
      lat !== null &&
      lng !== null &&
      store.latitude !== undefined &&
      store.latitude !== null &&
      store.longitude !== undefined &&
      store.longitude !== null
    ) {
      distance = distanceBetween(lat, lng, store.latitude, store.longitude)
    }
    return {
      ...store,
      distance
    }
  })
  return list.sort((a, b) => {
    if (a.distance !== null && b.distance !== null) {
      return a.distance - b.distance
    }
    if (a.distance !== null) return -1
    if (b.distance !== null) return 1
    return a.name.localeCompare(b.name)
  })
})

const selectedMerchant = computed(() =>
  merchants.value.find((store) => String(store.id) === String(selectedMerchantId.value)) || null
)
const pickupMethodText = computed(
  () => pickupOptions.find((option) => option.value === pickupMethod.value)?.desc || '选择你偏好的取餐方式'
)
const pickupMethodLabel = computed(
  () => pickupOptions.find((option) => option.value === pickupMethod.value)?.label || '自取带走'
)
const orderContactName = computed(
  () => profileForm.displayName || currentUser.value?.displayName || currentUser.value?.username || ''
)
const orderContactPhone = computed(() => profileForm.phone || currentUser.value?.phone || '')
const checkoutDisabled = computed(
  () =>
    checkoutSubmitting.value ||
    !currentUser.value ||
    !sharedCartItems.value.length ||
    !selectedMerchantId.value ||
    !orderContactPhone.value
)

const profileHighlights = computed(() => {
  const wallet = Number(currentUser.value?.wallet ?? 0)
  const coupons = currentUser.value?.couponCount ?? 3
  const points = currentUser.value?.points ?? 280
  return [
    {
      label: '余额',
      value: `¥ ${wallet.toFixed(2)}`,
      desc: '储值卡金额'
    },
    {
      label: '优惠券',
      value: `${coupons} 张`,
      desc: '门店/线上通用'
    },
    {
      label: '积分',
      value: points,
      desc: '可兑换灵感好物'
    }
  ]
})

const profileActions = [
  { key: 'orders', icon: '🧾', label: '订单中心', desc: '查看制作进度与历史' },
  { key: 'info', icon: '👤', label: '个人资料', desc: '昵称、手机号与生日' },
  { key: 'language', icon: '🌐', label: '语言设置', desc: '切换中文或英文界面' },
  { key: 'about', icon: '✨', label: '关于我们', desc: '品牌故事与灵感' }
]

const languageOptions = [
  { value: 'zh-CN', label: '简体中文', desc: '推荐 · 贴合微信小程序体验' },
  { value: 'en-US', label: 'English', desc: '如需英文界面可选择' }
]
const languageStorageKey = '8am-lab-language'
const currentLanguage = ref('zh-CN')
const languageFeedback = ref('')

const handleProfileAction = (key) => {
  if (key === 'orders') {
    activeTab.value = 'order'
    return
  }
  if (!currentUser.value) {
    authFeedback.value = '登录后即可使用该功能'
    setAuthMode('login')
    return
  }
  switch (key) {
    case 'info':
      profileFeedback.value = ''
      activeTab.value = 'profileSettings'
      ensureProfileHydrated()
      break
    case 'language':
      languageFeedback.value = ''
      hydrateLanguagePreference()
      activeTab.value = 'profileLanguage'
      break
    case 'about':
      authFeedback.value = '8AM 实验室 · 咖啡巴斯克'
      break
    default:
      break
  }
}

const applyLanguagePreference = (value) => {
  if (typeof document !== 'undefined') {
    document.documentElement.lang = value === 'en-US' ? 'en' : 'zh-Hans'
  }
}

const hydrateLanguagePreference = () => {
  if (typeof window === 'undefined' || typeof localStorage === 'undefined') return
  try {
    const saved = localStorage.getItem(languageStorageKey)
    if (saved && languageOptions.some((option) => option.value === saved)) {
      currentLanguage.value = saved
      applyLanguagePreference(saved)
    }
  } catch (error) {
    console.warn('语言设置读取失败', error)
  }
}

const changeLanguage = (value) => {
  if (!languageOptions.some((option) => option.value === value)) return
  currentLanguage.value = value
  applyLanguagePreference(value)
  languageFeedback.value = value === 'zh-CN' ? '已切换为简体中文界面' : '已切换为英文界面'
  if (typeof window === 'undefined' || typeof localStorage === 'undefined') return
  try {
    localStorage.setItem(languageStorageKey, value)
  } catch (error) {
    console.warn('语言设置保存失败', error)
  }
}

const resetProfileForm = () => {
  profileForm.displayName = ''
  profileForm.familyName = ''
  profileForm.givenName = ''
  profileForm.gender = ''
  profileForm.phone = ''
  profileForm.birthday = ''
  profileForm.avatar = ''
  Object.keys(profileErrors).forEach((key) => delete profileErrors[key])
  profileFeedback.value = ''
}

const populateProfileForm = (user) => {
  if (!user) {
    resetProfileForm()
    return
  }
  profileForm.displayName = user.displayName || ''
  profileForm.familyName = user.familyName || ''
  profileForm.givenName = user.givenName || ''
  profileForm.gender = user.gender || ''
  profileForm.phone = user.phone || ''
  profileForm.avatar = user.avatar || ''
  profileForm.birthday = user.birthday || ''
}

const ensureProfileHydrated = async () => {
  if (!currentUser.value?.id) return
  profileLoading.value = true
  try {
    const fresh = await fetchUserProfile(currentUser.value.id)
    currentUser.value = fresh
    populateProfileForm(fresh)
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '加载资料失败，请稍后重试'
  } finally {
    profileLoading.value = false
  }
}

const revokePreviewUrl = (url) => {
  if (!url) return
  if (typeof URL !== 'undefined' && typeof URL.revokeObjectURL === 'function') {
    URL.revokeObjectURL(url)
  }
}

const clearAvatarPreview = () => {
  if (avatarPreviewUrl.value) {
    revokePreviewUrl(avatarPreviewUrl.value)
    avatarPreviewUrl.value = ''
  }
}

const clearAvatarInput = () => {
  const input = avatarInputRef.value
  if (input) {
    input.value = ''
  }
}

const triggerAvatarPicker = () => {
  if (!currentUser.value) {
    activeTab.value = 'profileLogin'
    return
  }
  if (avatarUploading.value) return
  profileFeedback.value = ''
  avatarInputRef.value?.click()
}

const handleAvatarFile = async (event) => {
  const input = event.target
  const files = input?.files
  if (!files?.length) return
  const file = files[0]
  if (!file.type?.startsWith('image/')) {
    profileFeedback.value = '请选择图片文件'
    clearAvatarInput()
    return
  }
  clearAvatarPreview()
  avatarPreviewUrl.value = URL.createObjectURL(file)
  avatarUploading.value = true
  profileFeedback.value = ''
  try {
    const response = await uploadAvatar(file)
    if (!response?.url) {
      throw new Error('missing url')
    }
    profileForm.avatar = response.url
    profileFeedback.value = '头像已上传，记得点击保存'
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '上传失败，请稍后再试'
  } finally {
    avatarUploading.value = false
    clearAvatarPreview()
    clearAvatarInput()
  }
}

const showProfileHints = () => {
  profileFeedback.value = '支持相册与拍摄上传，成功后记得保存资料'
}

const distanceBetween = (lat1, lon1, lat2, lon2) => {
  const toRad = (value) => (value * Math.PI) / 180
  const R = 6371
  const dLat = toRad(lat2 - lat1)
  const dLon = toRad(lon2 - lon1)
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) * Math.sin(dLon / 2)
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}

const requestLocation = () => {
  if (!geolocationSupported) {
    locationStatus.value = 'unsupported'
    return
  }
  locationStatus.value = 'pending'
  navigator.geolocation.getCurrentPosition(
    (position) => {
      userLocation.lat = position.coords.latitude
      userLocation.lng = position.coords.longitude
      locationStatus.value = 'ready'
    },
    (error) => {
      if (error.code === error.PERMISSION_DENIED) {
        locationStatus.value = 'denied'
      } else {
        locationStatus.value = 'error'
      }
    },
    { enableHighAccuracy: true, timeout: 8000 }
  )
}

const checkoutThumbStyle = (item = {}) => {
  const image = item.imageUrl || item.image
  return {
    backgroundImage: image
      ? `linear-gradient(135deg, rgba(15,23,42,0.35), rgba(15,23,42,0.65)), url(${image})`
      : 'linear-gradient(135deg, rgba(15,23,42,0.35), rgba(15,23,42,0.65))',
    backgroundSize: 'cover',
    backgroundPosition: 'center'
  }
}

const openStorePicker = () => {
  storePicker.selectedId = selectedMerchantId.value || merchants.value[0]?.id || null
  storePicker.returnTab = activeTab.value || 'home'
  activeTab.value = 'storePicker'
  if (locationStatus.value === 'idle' && geolocationSupported) {
    requestLocation()
  }
}

const closeStorePicker = () => {
  activeTab.value = storePicker.returnTab || 'home'
}

const confirmStoreSelection = () => {
  if (!storePicker.selectedId) return
  selectedMerchantId.value = storePicker.selectedId
  const nextTab = showWorkbench.value ? 'order' : 'checkout'
  activeTab.value = nextTab
}

const handleCheckoutSubmit = async () => {
  if (checkoutDisabled.value) return
  if (!currentUser.value) {
    checkoutFeedback.value = '请先登录后再下单'
    activeTab.value = 'profileLogin'
    return
  }
  if (!sharedCartItems.value.length) {
    checkoutFeedback.value = '购物车为空，去挑选喜欢的灵感饮品吧'
    activeTab.value = 'home'
    return
  }
  if (!selectedMerchantId.value) {
    checkoutFeedback.value = '请选择门店后再下单'
    openStorePicker()
    return
  }
  if (!orderContactPhone.value) {
    checkoutFeedback.value = '请先在“我的-个人资料”中完善手机号'
    handleProfileAction('info')
    return
  }
  checkoutSubmitting.value = true
  checkoutFeedback.value = ''
  try {
    const merchantId = Number(selectedMerchantId.value)
    const pickupNote = [pickupMethodLabel.value, orderRemark.value.trim()].filter(Boolean).join(' · ')
    const createdOrderIds = []
    for (const item of sharedCartItems.value) {
      const order = await createOrder({
        customerName: orderContactName.value || '灵感顾客',
        contactPhone: orderContactPhone.value,
        drinkId: Number(item.drinkId),
        merchantId,
        quantity: Number(item.quantity) || 1,
        pickupTime: pickupNote || pickupMethodLabel.value
      })
      if (order?.id) {
        createdOrderIds.push(order.id)
      }
    }
    if (!createdOrderIds.length) {
      checkoutFeedback.value = '未能创建订单，请稍后再试'
      return
    }
    checkoutFeedback.value = '订单已创建，正在拉起支付宝'
    const paymentReturnUrl =
      typeof window !== 'undefined' ? `${window.location.origin}/` : undefined
    const payment = await createAlipayPayment({
      orderIds: createdOrderIds,
      returnUrl: paymentReturnUrl
    })
    if (payment?.payUrl && typeof window !== 'undefined') {
      const opened = window.open(payment.payUrl, '_blank', 'noopener')
      if (!opened) {
        window.location.href = payment.payUrl
      }
    }
    await loadSharedResources()
    orderRemark.value = ''
    remarkEditorOpen.value = false
    clearSharedCart()
    checkoutFeedback.value = '请在支付宝完成支付，稍后可在“我的-订单中心”查看进度'
    activeTab.value = 'home'
  } catch (error) {
    checkoutFeedback.value = error?.response?.data?.message || '下单或拉起支付失败，请稍后再试'
  } finally {
    checkoutSubmitting.value = false
  }
}

const validateProfileForm = () => {
  const errors = {}
  if (!profileForm.displayName) {
    errors.displayName = '请输入昵称'
  }
  return errors
}

const submitProfile = async () => {
  if (!currentUser.value?.id) {
    profileFeedback.value = '请先登录后再保存'
    return
  }
  const errors = validateProfileForm()
  Object.keys(profileErrors).forEach((key) => delete profileErrors[key])
  Object.assign(profileErrors, errors)
  if (Object.keys(errors).length) {
    return
  }
  profileSaving.value = true
  profileFeedback.value = ''
  try {
    const payload = {
      displayName: profileForm.displayName,
      familyName: profileForm.familyName || null,
      givenName: profileForm.givenName || null,
      gender: profileForm.gender || null,
      phone: profileForm.phone || null,
      birthday: profileForm.birthday || null,
      avatar: profileForm.avatar || null
    }
    const updated = await updateUserProfile(currentUser.value.id, payload)
    currentUser.value = updated
    populateProfileForm(updated)
    profileFeedback.value = '已保存'
  } catch (error) {
    profileFeedback.value = error.response?.data?.message || '保存失败，请稍后重试'
  } finally {
    profileSaving.value = false
  }
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
    await loadAdminResources()
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
      if (activeTab.value === 'profileLogin') {
        activeTab.value = 'profile'
      }
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
      if (activeTab.value === 'profileLogin') {
        activeTab.value = 'profile'
      }
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
  if (activeTab.value === 'profileLogin') {
    activeTab.value = 'profile'
  }
  resetDrinkForm()
  resetProfileForm()
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
      return '待取杯'
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
    READY: [{ code: 'COMPLETED', label: '完成取杯' }],
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
  () => currentUser.value,
  (user) => {
    populateProfileForm(user)
    if (!user) {
      profileLoading.value = false
    }
  },
  { immediate: true }
)

watch(
  () => activeTab.value,
  (tab) => {
    if (tab === 'profileSettings' && currentUser.value?.id) {
      ensureProfileHydrated()
    }
    if (tab !== 'profileSettings') {
      profileSaving.value = false
    }
    if (tab === 'profileLanguage') {
      hydrateLanguagePreference()
    }
    if (tab !== 'profileLanguage') {
      languageFeedback.value = ''
    }
  }
)

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

watch(
  () => merchants.value,
  (list) => {
    if (!selectedMerchantId.value && list.length) {
      selectedMerchantId.value = list[0].id
    }
  },
  { immediate: true }
)

watch(
  () => showWorkbench.value,
  (canAccess) => {
    if (!canAccess && activeTab.value === 'order') {
      activeTab.value = 'home'
    }
  }
)

onMounted(async () => {
  hydrateLanguagePreference()
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
  padding: 12px 16px 80px;
}

.panel {
  background: rgba(15, 23, 42, 0.75);
  border-radius: 20px;
  padding: 20px;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.45);
  backdrop-filter: blur(18px);
}

.panel.home-panel {
  padding: 0;
  background: transparent;
  box-shadow: none;
}

.panel.explore-panel {
  padding: 0;
  background: transparent;
  box-shadow: none;
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

.store-picker-page {
  display: grid;
  gap: 16px;
}

.store-page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.store-page-header > div {
  flex: 1;
}

.store-page-header .back-link {
  flex: none;
}

.store-title {
  margin: 0;
  font-size: 1.4rem;
  font-weight: 700;
  color: #f8fafc;
}

.store-note {
  color: rgba(148, 163, 184, 0.85);
}

.store-intro {
  margin: 0;
  color: rgba(226, 232, 240, 0.75);
}

.store-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 12px;
}

.store-list li button {
  width: 100%;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.2);
  background: rgba(15, 23, 42, 0.65);
  padding: 14px 16px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #e2e8f0;
  gap: 12px;
}

.store-list li button.active {
  border-color: rgba(59, 130, 246, 0.7);
  background: rgba(59, 130, 246, 0.15);
}

.store-list strong {
  font-size: 1rem;
}

.store-list span {
  display: block;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.distance {
  font-weight: 600;
  color: rgba(129, 140, 248, 0.95);
}

.store-empty {
  text-align: center;
  padding: 24px 12px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.45);
  color: rgba(148, 163, 184, 0.9);
}

.store-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.store-actions .ghost,
.store-actions .primary {
  flex: 1;
}

.store-denied {
  color: rgba(248, 113, 113, 0.85);
  font-size: 0.85rem;
}

.checkout-panel {
  display: grid;
  gap: 16px;
}

.section-label {
  margin: 0;
  font-size: 0.8rem;
  letter-spacing: 0.08em;
  color: rgba(148, 163, 184, 0.85);
}

.checkout-store {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.checkout-store h2 {
  margin: 4px 0 2px;
}

.checkout-store small {
  color: rgba(148, 163, 184, 0.85);
}

.checkout-contact {
  display: flex;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  padding: 14px 16px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.2);
}

.checkout-contact.warning {
  flex-wrap: wrap;
  border-color: rgba(248, 113, 113, 0.35);
  background: rgba(248, 113, 113, 0.08);
}

.checkout-contact p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.checkout-contact strong {
  display: block;
  font-size: 1.05rem;
}

.checkout-contact button {
  flex: none;
}

.checkout-pickup {
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
  display: grid;
  gap: 12px;
  background: rgba(15, 23, 42, 0.55);
}

.checkout-pickup header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.checkout-pickup header p {
  margin: 0;
}

.checkout-pickup header small {
  color: rgba(148, 163, 184, 0.85);
}

.pickup-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
  gap: 12px;
}

.pickup-options button {
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
  text-align: left;
  background: rgba(15, 23, 42, 0.45);
  color: #e2e8f0;
  display: grid;
  gap: 4px;
}

.pickup-options button.active {
  border-color: rgba(56, 189, 248, 0.65);
  background: rgba(56, 189, 248, 0.18);
  color: #f8fafc;
}

.pickup-options button strong {
  font-size: 1rem;
}

.pickup-options button span {
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.85);
}

.checkout-products {
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.5);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 12px;
}

.checkout-products header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.checkout-products header p {
  margin: 0;
  font-weight: 600;
}

.checkout-products header small {
  color: rgba(148, 163, 184, 0.85);
}

.checkout-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
  max-height: 360px;
  overflow-y: auto;
  padding-right: 4px;
}

.checkout-list li {
  display: grid;
  grid-template-columns: 72px 1fr auto;
  gap: 12px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.25);
}

.checkout-list li:last-child {
  border-bottom: none;
}

.checkout-list .thumb {
  border-radius: 16px;
  min-height: 72px;
  background-size: cover;
  background-position: center;
  position: relative;
}

.checkout-list .mini-tag {
  top: 8px;
  left: 8px;
}

.checkout-list .item-info {
  display: grid;
  gap: 4px;
}

.checkout-list .item-info h3 {
  margin: 0;
  font-size: 1rem;
}

.checkout-list .item-info p {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.checkout-list .item-info span {
  font-weight: 600;
}

.checkout-list .item-qty {
  font-weight: 700;
  align-self: center;
  color: rgba(226, 232, 240, 0.95);
}

.checkout-summary {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
}

.checkout-summary strong {
  font-size: 1.2rem;
}

.checkout-remark {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-radius: 16px;
  border: 1px dashed rgba(148, 163, 184, 0.4);
  background: rgba(15, 23, 42, 0.35);
}

.checkout-remark p {
  margin: 0;
  font-weight: 600;
}

.checkout-remark small {
  color: rgba(148, 163, 184, 0.85);
}

.remark-editor {
  width: 100%;
  min-height: 90px;
  border-radius: 16px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: rgba(15, 23, 42, 0.55);
  color: #f8fafc;
  padding: 14px;
  resize: vertical;
}

.checkout-submit {
  width: 100%;
  font-size: 1.05rem;
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

.detail-card {
  margin-top: 16px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
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
  height: 64px;
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

.tabbar.compact {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.tabbar.compact {
  grid-template-columns: repeat(3, minmax(0, 1fr));
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

.profile-hero {
  position: relative;
  border-radius: 22px;
  background: #0f172a;
  border: 1px solid rgba(59, 130, 246, 0.3);
  overflow: hidden;
  min-height: 170px;
  padding: 24px;
  box-shadow: 0 20px 40px rgba(15, 23, 42, 0.5);
}

.banner-bg {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.banner-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0.2));
}

.banner-action {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 2;
  color: #f8fafc;
}

.banner-content {
  position: relative;
  z-index: 2;
  color: #f8fafc;
  max-width: 65%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.banner-greeting {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
}

.banner-role {
  color: rgba(248, 250, 252, 0.85);
  font-size: 0.95rem;
}

.hero-avatar {
  position: absolute;
  right: 24px;
  bottom: 24px;
  width: 88px;
  height: 88px;
  border-radius: 28px;
  background: rgba(15, 23, 42, 0.85);
  border: 4px solid rgba(248, 250, 252, 0.8);
  display: grid;
  place-items: center;
  color: #f8fafc;
  font-weight: 700;
  font-size: 1.8rem;
  z-index: 3;
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.4);
}

.hero-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 24px;
}

.profile-highlights {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 12px;
  margin-top: 48px;
}

.profile-highlights article {
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.2);
  box-shadow: inset 0 0 0 1px rgba(15, 23, 42, 0.2);
  display: grid;
  gap: 6px;
}

.profile-highlights strong {
  font-size: 1.4rem;
  font-weight: 700;
  margin: 0;
}

.profile-highlights span {
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.card-label {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
  font-size: 0.85rem;
}

.profile-actions {
  margin-top: 20px;
  border-radius: 18px;
  padding: 4px;
  background: rgba(15, 23, 42, 0.55);
  border: 1px solid rgba(148, 163, 184, 0.2);
  display: grid;
  gap: 6px;
}

.profile-actions button {
  width: 100%;
  border: none;
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 14px;
  border-radius: 14px;
  color: #f8fafc;
  transition: background 0.2s ease, transform 0.1s ease;
}

.profile-actions button:hover,
.profile-actions button:focus-visible {
  background: rgba(59, 130, 246, 0.15);
}

.profile-actions button:active {
  transform: scale(0.98);
}

.action-icon {
  font-size: 1.2rem;
  width: 36px;
}

.action-info {
  flex: 1;
}

.action-info p {
  margin: 0;
  font-weight: 600;
}

.action-info small {
  color: rgba(148, 163, 184, 0.85);
}

.action-arrow {
  color: rgba(148, 163, 184, 0.85);
  font-size: 1.2rem;
}

.language-panel {
  display: grid;
  gap: 16px;
}

.language-card {
  border-radius: 20px;
  padding: 20px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
  display: grid;
  gap: 16px;
}

.language-card header {
  display: grid;
  gap: 6px;
}

.language-kicker {
  margin: 0;
  letter-spacing: 0.08em;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.85rem;
}

.language-card header h2 {
  margin: 0;
}

.language-card header small {
  color: rgba(148, 163, 184, 0.85);
}

.language-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 12px;
}

.language-list button {
  width: 100%;
  border-radius: 18px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.35);
  padding: 14px 16px;
  color: #f8fafc;
  display: flex;
  justify-content: space-between;
  align-items: center;
  text-align: left;
  gap: 12px;
}

.language-list button div {
  display: grid;
  gap: 4px;
}

.language-list button strong {
  font-size: 1rem;
}

.language-list button span {
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.language-list button .status {
  font-size: 0.85rem;
  color: #0f172a;
  background: rgba(56, 189, 248, 0.85);
  border-radius: 999px;
  padding: 6px 12px;
  font-weight: 600;
}

.language-list button.active {
  border-color: rgba(56, 189, 248, 0.65);
  background: rgba(56, 189, 248, 0.18);
}

.language-tip {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.profile-auth .primary,
.gate-cta {
  border-radius: 999px;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  transition: transform 0.1s ease, box-shadow 0.2s ease;
}

.profile-auth .primary:active,
.gate-cta:active {
  transform: scale(0.98);
  box-shadow: 0 6px 20px rgba(34, 211, 238, 0.35);
}

.profile-auth.compact {
  text-align: center;
  gap: 8px;
}

.cta-hint {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
  font-size: 0.9rem;
}

.auth-full .back-link {
  align-self: flex-start;
  margin-bottom: 12px;
}

.settings-panel {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.settings-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.settings-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.icon-only {
  min-width: 48px;
}

.settings-card {
  padding: 18px;
  border-radius: 18px;
  background: rgba(30, 41, 59, 0.85);
  border: 1px solid rgba(148, 163, 184, 0.25);
  text-align: center;
}

.avatar-shell.large {
  width: 96px;
  height: 96px;
  font-size: 2.3rem;
  margin: 0 auto;
  position: relative;
}

.avatar-shell.large img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
}

.avatar-edit {
  position: absolute;
  bottom: -6px;
  right: -6px;
  border-radius: 18px;
  background: #38bdf8;
  color: #0f172a;
  padding: 4px 12px;
  font-size: 0.8rem;
}

.avatar-edit:disabled {
  opacity: 0.7;
}

.avatar-preview p {
  margin: 16px 0 4px;
  font-weight: 600;
}

.membership-code {
  color: rgba(148, 163, 184, 0.8);
  letter-spacing: 0.2em;
}

.profile-form {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.form-row.required label::after {
  content: '*';
  color: #f87171;
  margin-left: 4px;
}

.sticky-actions {
  margin-top: 8px;
}

.upload-hint {
  display: block;
  margin-top: 8px;
  color: rgba(148, 163, 184, 0.85);
}

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

</style>
