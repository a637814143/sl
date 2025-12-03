<template>
  <div class="category-page">
    <header class="page-head">
      <p class="kicker">8am 灵感菜单</p>
      <h1>灵感单专场</h1>
    </header>

    <section
      class="category-layout"
      :class="{
        'no-cart': isMerchantMode || !cartItems.length,
        'cart-open': !isMerchantMode && isMobile && cartOpen,
        'merchant-mode': isMerchantMode
      }"
    >
      <nav class="nav-panel">
        <button
          v-for="item in navItems"
          :key="item.value"
          :class="{ active: activeCategory === item.value }"
          type="button"
          @click="setCategory(item.value)"
        >
          <span class="icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </button>
      </nav>

      <main class="content-panel" ref="contentRef">
        <section
          v-for="section in sections"
          :key="section.value"
          :id="section.anchor"
          class="category-block"
        >
          <header>
            <h2>{{ section.label }}</h2>
            <p>{{ section.description }}</p>
          </header>

          <div class="card-list" v-if="section.items.length">
            <article v-for="item in section.items" :key="item.id" class="card">
              <div class="cover" :style="coverStyle(item.imageUrl)"></div>
              <div class="info">
                <h3>{{ item.name }}</h3>
                <p>{{ item.description || section.placeholder }}</p>
                <footer>
                  <div class="price-block">
                    <span>¥ {{ Number(item.price || 0).toFixed(2) }}</span>
                    <span
                      v-if="isMerchantMode"
                      :class="['availability-chip', { offline: item.available === false }]"
                    >
                      {{ item.available === false ? '已下架' : '在售' }}
                    </span>
                  </div>
                  <div v-if="isMerchantMode" class="card-actions">
                    <button type="button" class="card-btn" @click="handleEdit(item)">编辑</button>
                    <button type="button" class="card-btn danger" @click="handleDelete(item)">删除</button>
                  </div>
                  <button
                    v-else
                    type="button"
                    @click="addToCart({ ...item, category: section.value })"
                    aria-label="加入灵感单"
                  >
                    +
                  </button>
                </footer>
              </div>
            </article>
          </div>
          <p v-else class="empty-tip">{{ section.placeholder }}</p>
        </section>
      </main>

      <aside
        v-if="!isMerchantMode && cartItems.length && (cartOpen || !isMobile)"
        :class="['cart-panel', { 'is-floating': isMobile }]"
      >
        <header>
          <div>
            <h3>已选商品</h3>
            <small>¥ {{ cartTotal.toFixed(2) }}</small>
          </div>
          <button class="ghost" type="button" @click="clearCart">清空</button>
        </header>

        <div class="cart-list">
          <article v-for="item in cartItems" :key="item.id">
            <div class="thumb" :style="thumbStyle(item)"></div>
            <div class="cart-info">
              <h4>{{ item.name }}</h4>
              <p>¥ {{ Number(item.price || 0).toFixed(2) }}</p>
              <p class="custom-note" v-if="item.customSummary">{{ item.customSummary }}</p>
            </div>
            <div class="qty">
              <button type="button" @click="decrement(item)">-</button>
              <span>{{ item.quantity }}</span>
              <button type="button" @click="increment(item)">+</button>
            </div>
          </article>
        </div>

        <footer class="cart-actions">
          <button type="button" class="primary" @click="emitCheckout">去下单</button>
        </footer>
      </aside>

      <button
        v-if="!isMerchantMode && isMobile && cartItems.length"
        :class="['cart-fab', { active: cartOpen }]"
        type="button"
        :aria-label="cartOpen ? '收起购物车' : '打开购物车'"
        @click="toggleCart"
      >
        <span class="cart-icon">🛒</span>
        <span class="cart-count">{{ cartCount }}</span>
      </button>
    </section>
  </div>

  <transition name="modal-fade">
    <div v-if="!isMerchantMode && customization.open" class="guide-overlay" role="dialog" aria-modal="true">
      <div class="guide-mask"></div>
      <div class="guide-panel">
        <header class="guide-header">
          <p class="guide-tag">{{ customization.product?.category || '灵感饮品' }}</p>
          <h3>{{ customization.product?.name || '选择商品' }}</h3>
          <p class="guide-desc">
            {{
              customization.product?.description ||
              '根据顾客喜好补充必要信息，完成后即可加入购物车。'
            }}
          </p>
        </header>

        <section class="guide-groups">
          <article class="guide-group" v-for="group in customization.groups" :key="group.key">
            <div class="group-head">
              <h4>{{ group.label }}</h4>
              <small v-if="group.hint">{{ group.hint }}</small>
            </div>
            <div class="guide-options">
              <button
                v-for="option in group.options"
                :key="option.value"
                type="button"
                :class="{ active: customization.selections[group.key] === option.value }"
                @click="selectGuideOption(group.key, option.value)"
              >
                <strong>{{ option.label }}</strong>
                <span>{{ option.desc }}</span>
              </button>
            </div>
          </article>
        </section>

        <footer class="guide-actions">
          <p class="guide-summary" v-if="customizationSummary">{{ customizationSummary }}</p>
          <div class="guide-buttons">
            <button type="button" class="ghost" @click="closeCustomization">返回主界面</button>
            <button type="button" class="primary" @click="confirmCustomization">确认加入购物车</button>
          </div>
        </footer>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue'

const props = defineProps({
  drinks: { type: Array, default: () => [] },
  initialCategory: { type: String, default: 'CLASSIC' },
  cartItems: { type: Array, default: null },
  cartTotal: { type: Number, default: null },
  addToCart: { type: Function, default: null },
  incrementItem: { type: Function, default: null },
  decrementItem: { type: Function, default: null },
  clearCart: { type: Function, default: null },
  isMerchant: { type: Boolean, default: false },
  onEditProduct: { type: Function, default: null },
  onDeleteProduct: { type: Function, default: null }
})
const emit = defineEmits(['checkout'])
const isMerchantMode = computed(() => !!props.isMerchant)

const navItems = [
  {
    label: '经典咖啡',
    value: 'CLASSIC',
    icon: '☕️',
    description: '顺口经典款，日常稳妥选择。',
    placeholder: '经典区暂未上架，稍后看看。'
  },
  {
    label: '灵感特调',
    value: 'SIGNATURE',
    icon: '✨',
    description: '主理人灵感限定，甜感与香气更有记忆点。',
    placeholder: '特调会随季节更新，敬请期待。'
  },
  {
    label: '手冲风味',
    value: 'POUR',
    icon: '🫖',
    description: '产区风味的旅程，慢慢品出层次。',
    placeholder: '手冲豆正在新鲜烘焙，马上上线。'
  },
  {
    label: '甜品点心',
    value: 'DESSERT',
    icon: '🍰',
    description: '巴斯克与烘焙小点，搭配咖啡才完整。',
    placeholder: '甜品烘焙中，稍后刷新就能看到。'
  }
]

const guideLibrary = {
  CLASSIC: [
    {
      key: 'size',
      label: '选择杯型',
      hint: '不同容量会影响浓度',
      options: [
        { value: 'medium', label: '中杯 360ml', desc: '日常提神，口味最均衡' },
        { value: 'large', label: '大杯 480ml', desc: '适合分享或长时间外带' }
      ],
      default: 'medium'
    },
    {
      key: 'temperature',
      label: '温度偏好',
      hint: '温度会影响香气释放',
      options: [
        { value: 'hot', label: '热饮 65°C', desc: '现萃热饮，建议搭配全脂奶' },
        { value: 'iced', label: '冰饮 8°C', desc: '冰块 40%，更清爽' }
      ],
      default: 'hot'
    },
    {
      key: 'sweetness',
      label: '甜度',
      options: [
        { value: 'regular', label: '标准甜', desc: '保留原配方风味' },
        { value: 'less', label: '少糖', desc: '降低 30% 糖浆' }
      ],
      default: 'regular'
    }
  ],
  SIGNATURE: [
    {
      key: 'craft',
      label: '制作方式',
      options: [
        { value: 'coldbrew', label: '冷萃', desc: '12 小时慢萃，口感柔顺' },
        { value: 'nitro', label: '氮气注入', desc: '营造更绵密泡沫层' }
      ],
      default: 'coldbrew'
    },
    {
      key: 'finish',
      label: '收尾装饰',
      options: [
        { value: 'citrus', label: '柑橘皮', desc: '突出果酸与清香' },
        { value: 'cacao', label: '可可碎', desc: '口感更厚重' }
      ],
      default: 'citrus'
    }
  ],
  POUR: [
    {
      key: 'roast',
      label: '豆子烘焙',
      options: [
        { value: 'light', label: '浅焙', desc: '花香、果香更明显' },
        { value: 'medium', label: '中焙', desc: '坚果与巧克力风味' }
      ],
      default: 'light'
    },
    {
      key: 'milk',
      label: '是否加奶',
      options: [
        { value: 'pure', label: '不加奶', desc: '保留原豆风味' },
        { value: 'oat', label: '燕麦奶', desc: '顺滑口感，植物基' }
      ],
      default: 'pure'
    }
  ],
  DESSERT: [
    {
      key: 'portion',
      label: '份量',
      options: [
        { value: 'whole', label: '整块', desc: '适合 2-3 人分享' },
        { value: 'slice', label: '切片', desc: '单人享用更方便' }
      ],
      default: 'slice'
    },
    {
      key: 'pack',
      label: '打包方式',
      options: [
        { value: 'plate', label: '堂食餐盘', desc: '立即享用口感最佳' },
        { value: 'chill', label: '冷藏盒装', desc: '随单附赠保冷袋' }
      ],
      default: 'plate'
    }
  ],
  DEFAULT: [
    {
      key: 'preference',
      label: '体验侧重',
      options: [
        { value: 'balanced', label: '标准风味', desc: '遵循门店配比' },
        { value: 'bold', label: '强调风味', desc: '加强主体风味表现' }
      ],
      default: 'balanced'
    }
  ]
}

const customization = reactive({
  open: false,
  product: null,
  groups: [],
  selections: {}
})

const activeCategory = ref(props.initialCategory || 'CLASSIC')
const contentRef = ref(null)
const internalCart = reactive({})
const cartOpen = ref(false)
const isMobile = ref(false)
const decoratedDrinks = computed(() =>
  (Array.isArray(props.drinks) ? props.drinks : []).map((drink, index) => ({ drink, index }))
)
const filteredDrinks = computed(() =>
  decoratedDrinks.value.filter(({ drink }) => isMerchantMode.value || drink.available !== false)
)

const resolveCategory = (drink, index) => {
  const explicit = String(drink.category || drink.type || '').toUpperCase()
  if (navItems.some((item) => item.value === explicit)) return explicit
  const text = `${drink.name || ''} ${drink.description || ''}`.toLowerCase()
  if (text.includes('手冲')) return 'POUR'
  if (text.includes('特调') || text.includes('灵感')) return 'SIGNATURE'
  if (text.includes('甜品')) return 'DESSERT'
  return navItems[index % navItems.length].value
}

const sections = computed(() =>
  navItems.map((item) => ({
    ...item,
    anchor: `section-${item.value.toLowerCase()}`,
    items: filteredDrinks.value
      .filter(({ drink, index }) => resolveCategory(drink, index) === item.value)
      .map(({ drink }) => drink)
  }))
)

const cartItems = computed(() => {
  if (isMerchantMode.value) return []
  return Array.isArray(props.cartItems) ? props.cartItems : Object.values(internalCart)
})
const cartCount = computed(() => {
  if (isMerchantMode.value) return 0
  return cartItems.value.reduce((sum, item) => sum + Number(item.quantity || 0), 0)
})
const cartTotal = computed(() => {
  if (isMerchantMode.value) return 0
  if (Array.isArray(props.cartItems) && typeof props.cartTotal === 'number') {
    return props.cartTotal
  }
  return cartItems.value.reduce(
    (sum, item) => sum + Number(item.price || 0) * Number(item.quantity || 0),
    0
  )
})

const coverStyle = (image) => ({
  backgroundImage: image
    ? `linear-gradient(135deg, rgba(15,23,42,0.35), rgba(2,6,23,0.45)), url(${image})`
    : 'linear-gradient(135deg, rgba(15,23,42,0.35), rgba(2,6,23,0.45))'
})

const thumbStyle = (item) => {
  const image = item?.image || item?.imageUrl
  return {
    backgroundImage: image
      ? `linear-gradient(135deg, rgba(15,23,42,0.25), rgba(2,6,23,0.55)), url(${image})`
      : 'linear-gradient(135deg, rgba(15,23,42,0.25), rgba(2,6,23,0.55))'
  }
}

const setCategory = (value) => {
  activeCategory.value = value
  const panel = contentRef.value
  if (!panel) return
  const target = panel.querySelector(`#section-${value.toLowerCase()}`)
  if (target) {
    panel.scrollTo({ top: target.offsetTop, behavior: 'smooth' })
  }
}

const resolveGuide = (product = {}) => {
  const category = product.category || activeCategory.value
  return product.guide || guideLibrary[category] || guideLibrary.DEFAULT
}

const initSelections = (groups = []) => {
  const selections = {}
  groups.forEach((group) => {
    selections[group.key] = group.default ?? group.options?.[0]?.value ?? ''
  })
  return selections
}

const summarizeSelections = (groups, selections) =>
  groups
    .map((group) => {
      const value = selections[group.key]
      const choice = group.options?.find((option) => option.value === value)
      return `${group.label}：${choice?.label || value || '默认'}`
    })
    .join(' · ')

const buildSignature = (product, summary) => {
  const base = String(product.id || product.name || 'item')
  const normalized = summary
    ? summary
        .replace(/：/g, '-')
        .replace(/[^a-zA-Z0-9]+/g, '-')
        .replace(/-+/g, '-')
        .toLowerCase()
    : 'standard'
  return `${base}-${normalized}`.replace(/-+/g, '-')
}

const customizationSummary = computed(() =>
  customization.open ? summarizeSelections(customization.groups, customization.selections) : ''
)

const dispatchCartPayload = (payload) => {
  if (typeof props.addToCart === 'function') {
    props.addToCart(payload)
    return
  }
  mutateLocalCart(payload, payload.quantity || 1, {
    signature: payload.id,
    customSummary: payload.customSummary,
    customizations: payload.customizations
  })
}

const handleEdit = (item) => {
  if (!item || typeof props.onEditProduct !== 'function') return
  props.onEditProduct(item)
}

const handleDelete = (item) => {
  if (!item || typeof props.onDeleteProduct !== 'function') return
  props.onDeleteProduct(item)
}

const openCustomization = (product) => {
  if (!product) return
  const guide = resolveGuide(product)
  customization.product = product
  customization.groups = guide
  customization.selections = initSelections(guide)
  customization.open = true
}

const closeCustomization = () => {
  customization.open = false
  customization.product = null
  customization.groups = []
  customization.selections = {}
}

const selectGuideOption = (groupKey, value) => {
  customization.selections[groupKey] = value
}

const confirmCustomization = () => {
  if (!customization.product) return
  const summary = summarizeSelections(customization.groups, customization.selections)
  const signature = buildSignature(customization.product, summary)
  const payload = buildPayload(customization.product, {
    id: signature,
    cartSignature: signature,
    drinkId: customization.product.id || customization.product.name,
    quantity: 1,
    customizations: { ...customization.selections },
    customSummary: summary
  })
  dispatchCartPayload(payload)
  closeCustomization()
}

const buildPayload = (source, overrides = {}) => ({
  id: source.id || source.name,
  cartSignature: source.cartSignature || source.id || source.name,
  drinkId: source.drinkId || source.id || source.name,
  name: source.name,
  category: source.category,
  price: Number(source.price || 0),
  imageUrl: source.imageUrl || source.image,
  tag: source.tag,
  ...overrides
})

const mutateLocalCart = (source, delta, meta = {}) => {
  const signature = meta.signature || source.cartSignature || source.id || source.name
  if (!signature) return
  if (!internalCart[signature]) {
    internalCart[signature] = {
      id: signature,
      drinkId: source.drinkId || source.id || source.name,
      name: source.name,
      price: Number(source.price || 0),
      image: source.image || source.imageUrl,
      tag: source.tag,
      customSummary: meta.customSummary || source.customSummary || '',
      customizations: meta.customizations || source.customizations || null,
      quantity: 0
    }
  }
  if (meta.customSummary || source.customSummary) {
    internalCart[signature].customSummary = meta.customSummary || source.customSummary
  }
  if (meta.customizations || source.customizations) {
    internalCart[signature].customizations = meta.customizations || source.customizations
  }
  internalCart[signature].price = Number(source.price || internalCart[signature].price || 0)
  internalCart[signature].quantity += delta
  if (internalCart[signature].quantity <= 0) {
    delete internalCart[signature]
  }
}

const addToCart = (drink) => {
  if (!drink) return
  openCustomization(drink)
}

const increment = (item) => {
  if (typeof props.incrementItem === 'function') {
    props.incrementItem({ ...item, quantity: 1 })
    return
  }
  if (typeof props.addToCart === 'function') {
    props.addToCart({ ...buildPayload(item), quantity: 1 })
    return
  }
  mutateLocalCart(item, 1)
}

const decrement = (item) => {
  if (typeof props.decrementItem === 'function') {
    props.decrementItem(item)
  } else {
    mutateLocalCart(item, -1)
  }
}

const clearCart = () => {
  if (typeof props.clearCart === 'function') {
    props.clearCart()
  } else {
    Object.keys(internalCart).forEach((key) => delete internalCart[key])
  }
}

const emitCheckout = () => {
  if (!cartItems.value.length) return
  emit('checkout', cartItems.value)
}

const toggleCart = () => {
  cartOpen.value = !cartOpen.value
}

const updateDevice = () => {
  if (typeof window === 'undefined') return
  isMobile.value = window.innerWidth <= 960
  if (isMerchantMode.value) {
    cartOpen.value = false
    return
  }
  if (!isMobile.value && cartItems.value.length) {
    cartOpen.value = true
  }
  if (isMobile.value && !cartItems.value.length) {
    cartOpen.value = false
  }
}

watch(cartItems, (items) => {
  if (isMerchantMode.value) {
    cartOpen.value = false
    return
  }
  if (!items.length) {
    cartOpen.value = false
    return
  }
  if (!isMobile.value) {
    cartOpen.value = true
  }
})

onMounted(() => {
  updateDevice()
  window.addEventListener('resize', updateDevice)
})

onUnmounted(() => {
  window.removeEventListener('resize', updateDevice)
})
</script>

<style scoped>
.category-page {
  display: grid;
  gap: 16px;
  padding: 16px;
  color: #f8fafc;
}

.kicker {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.page-head h1 {
  margin: 6px 0 0;
}

.category-layout {
  display: grid;
  grid-template-columns: 110px minmax(0, 1fr) 300px;
  grid-template-areas: 'nav content cart';
  gap: 16px;
  align-items: flex-start;
  min-height: calc(100vh - 160px);
}

.category-layout.no-cart {
  grid-template-columns: 110px minmax(0, 1fr);
  grid-template-areas: 'nav content';
}

.nav-panel {
  grid-area: nav;
  display: flex;
  flex-direction: column;
  gap: 12px;
  position: sticky;
  top: 12px;
}

.nav-panel button {
  border: none;
  border-radius: 18px;
  padding: 12px 8px;
  background: rgba(15, 23, 42, 0.85);
  color: rgba(226, 232, 240, 0.9);
  display: grid;
  justify-items: center;
  gap: 4px;
}

.nav-panel button.active {
  background: rgba(59, 130, 246, 0.35);
}

.content-panel {
  grid-area: content;
  display: grid;
  gap: 18px;
  height: calc(100vh - 200px);
  overflow-y: auto;
  padding-right: 6px;
}

.category-block {
  border-radius: 22px;
  padding: 18px;
  background: rgba(15, 23, 42, 0.7);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 14px;
}

.card-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 14px;
}

.card {
  border-radius: 20px;
  padding: 12px;
  background: rgba(2, 6, 23, 0.6);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: flex;
  flex-direction: column;
  gap: 10px;
  min-height: 260px;
}

.cover {
  position: relative;
  border-radius: 18px;
  width: 100%;
  aspect-ratio: 4 / 3;
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.info footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price-block {
  display: flex;
  align-items: center;
  gap: 8px;
}

.availability-chip {
  padding: 2px 10px;
  border-radius: 999px;
  border: 1px solid rgba(74, 222, 128, 0.7);
  font-size: 0.75rem;
  color: #4ade80;
}

.availability-chip.offline {
  border-color: rgba(248, 113, 113, 0.8);
  color: #fecdd3;
}

.info footer button {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(59, 130, 246, 0.35);
  color: #0f172a;
  font-size: 1.2rem;
}

.card-actions {
  display: inline-flex;
  gap: 8px;
  flex-wrap: wrap;
  justify-content: flex-end;
}

.card-btn {
  border: 1px solid rgba(148, 163, 184, 0.5);
  border-radius: 18px;
  padding: 6px 12px;
  background: transparent;
  color: #e2e8f0;
  font-size: 0.85rem;
}

.card-btn.danger {
  border-color: rgba(248, 113, 113, 0.8);
  color: #fecdd3;
}

.empty-tip {
  margin: 0;
  color: rgba(148, 163, 184, 0.85);
}

.cart-panel {
  grid-area: cart;
  border-radius: 22px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(2, 6, 23, 0.92);
  padding: 18px;
  display: grid;
  gap: 12px;
  position: sticky;
  top: 12px;
  max-height: calc(100vh - 200px);
}

.cart-list {
  display: grid;
  gap: 10px;
  max-height: 280px;
  overflow-y: auto;
}

.cart-list article {
  display: grid;
  grid-template-columns: 56px 1fr auto;
  gap: 10px;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.35);
}

.thumb {
  border-radius: 16px;
  background-size: cover;
  background-position: center;
  width: 56px;
  aspect-ratio: 1 / 1;
  min-height: 0;
}

.cart-info {
  display: grid;
  gap: 4px;
}

.cart-info h4 {
  margin: 0;
  font-size: 0.95rem;
}

.cart-info p {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.cart-info .custom-note {
  font-size: 0.8rem;
  color: rgba(203, 213, 225, 0.85);
}

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.25s ease;
}

.modal-fade-enter-from,
.modal-fade-leave-to {
  opacity: 0;
}

.guide-overlay {
  position: fixed;
  inset: 0;
  z-index: 200;
  display: flex;
  align-items: center;
  justify-content: center;
}

.guide-mask {
  position: absolute;
  inset: 0;
  background: rgba(2, 6, 23, 0.78);
  backdrop-filter: blur(12px);
}

.guide-panel {
  position: relative;
  width: min(760px, 94vw);
  max-height: calc(100vh - 32px);
  overflow-y: auto;
  padding: 32px;
  padding-bottom: clamp(48px, 10vh, 96px);
  margin: 16px;
  border-radius: 28px;
  border: 1px solid rgba(226, 232, 240, 0.08);
  background: rgba(8, 15, 40, 0.95);
  box-shadow: 0 40px 100px rgba(2, 6, 23, 0.65);
  color: #f8fafc;
}

.guide-header {
  display: grid;
  gap: 8px;
  margin-bottom: 18px;
}

.guide-tag {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 999px;
  font-size: 0.85rem;
  background: rgba(148, 163, 184, 0.18);
  color: rgba(248, 250, 252, 0.9);
  width: fit-content;
}

.guide-desc {
  margin: 0;
  color: rgba(226, 232, 240, 0.75);
}

.guide-groups {
  display: grid;
  gap: 18px;
}

.guide-group {
  border-radius: 20px;
  padding: 18px;
  background: rgba(15, 23, 42, 0.8);
  border: 1px solid rgba(59, 130, 246, 0.08);
  display: grid;
  gap: 12px;
}

.group-head {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 12px;
}

.group-head h4 {
  margin: 0;
  font-size: 1rem;
}

.group-head small {
  color: rgba(148, 163, 184, 0.8);
}

.guide-options {
  display: grid;
  gap: 10px;
}

.guide-options button {
  border: 1px solid rgba(148, 163, 184, 0.35);
  border-radius: 16px;
  padding: 12px 16px;
  text-align: left;
  background: rgba(15, 23, 42, 0.35);
  color: #f8fafc;
  display: grid;
  gap: 2px;
  transition: border-color 0.2s ease, background 0.2s ease;
}

.guide-options button strong {
  font-size: 0.95rem;
}

.guide-options button span {
  font-size: 0.85rem;
  color: rgba(148, 163, 184, 0.9);
}

.guide-options button.active {
  border-color: rgba(56, 189, 248, 0.8);
  background: rgba(56, 189, 248, 0.18);
}

.guide-actions {
  display: grid;
  gap: 12px;
  margin-top: 24px;
}

.guide-summary {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.guide-buttons {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

.guide-buttons .primary {
  border: none;
  padding: 12px 24px;
  border-radius: 14px;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  color: #0f172a;
  font-weight: 600;
  min-width: 180px;
}

.qty {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.qty button {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  border: 1px solid rgba(148, 163, 184, 0.5);
  background: transparent;
  color: #f8fafc;
}

.cart-actions .primary {
  width: 100%;
  border: none;
  padding: 12px;
  border-radius: 14px;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  color: #0f172a;
  font-weight: 600;
}

.ghost {
  border: 1px dashed rgba(148, 163, 184, 0.5);
  background: transparent;
  color: rgba(226, 232, 240, 0.9);
  padding: 6px 12px;
  border-radius: 12px;
}

.cart-fab {
  display: none;
  position: fixed;
  right: 12px;
  bottom: 64px;
  transform: translateY(-50%);
  width: 52px;
  height: 52px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  color: #0f172a;
  font-weight: 600;
  align-items: center;
  justify-content: center;
  gap: 0;
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.45);
  z-index: 50;
  padding: 0;
}

.cart-fab.active {
  background: linear-gradient(135deg, #f472b6, #fb7185);
}

.cart-icon {
  font-size: 1.2rem;
}

.cart-count {
  position: absolute;
  top: 6px;
  right: 6px;
  min-width: 18px;
  height: 18px;
  border-radius: 999px;
  background: #0f172a;
  color: #f8fafc;
  font-size: 0.75rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0 4px;
}

@media (max-width: 1200px) {
  .category-layout {
    grid-template-columns: 96px minmax(0, 1fr) 260px;
  }

  .category-layout.no-cart {
    grid-template-columns: 96px minmax(0, 1fr);
  }
}

@media (max-width: 960px) {
  .category-layout {
    row-gap: 8px;
    column-gap: 0;
    grid-template-columns: 84px minmax(0, 1fr);
    grid-template-areas: 'nav content';
    padding-bottom: 0;
  }

  .card-list {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  }

  .cart-panel {
    grid-area: content;
    position: fixed;
    left: 16px;
    right: 16px;
    bottom: 64px;
    top: auto;
    max-height: 65vh;
    z-index: 30;
    box-shadow: 0 25px 60px rgba(2, 6, 23, 0.6);
    border-radius: 24px 24px 0 0;
  }

  .cart-fab {
    display: inline-flex;
  }
}

@media (max-width: 640px) {
  .category-layout {
    row-gap: 6px;
    column-gap: 0;
    grid-template-columns: 72px minmax(0, 1fr);
    padding-bottom: 0;
  }

  .cart-panel {
    left: 12px;
    right: 12px;
  }

  .guide-panel {
    padding: 24px;
    padding-bottom: clamp(48px, 14vh, 110px);
    width: min(480px, 92vw);
    margin: 12px;
    max-height: calc(100vh - 24px);
  }

  .guide-buttons {
    flex-direction: column;
  }

  .guide-buttons .primary,
  .guide-buttons .ghost {
    width: 100%;
  }
}
</style>
