<template>
  <section class="home-showcase">
    <div class="hero" @mouseenter="stopSlide" @mouseleave="startSlide">
      <div v-for="(slide, idx) in heroSlides" :key="slide.title" v-show="idx === activeSlide">
        <p class="hero-tag">{{ slide.tag }}</p>
        <h2>{{ slide.title }}</h2>
        <p class="hero-sub">{{ slide.subtitle }}</p>
      </div>
      <div class="hero-dots">
        <button
          v-for="(slide, idx) in heroSlides"
          :key="`dot-${idx}`"
          :class="{ active: idx === activeSlide }"
          type="button"
          @click="setSlide(idx)"
        />
      </div>
    </div>

    <div
      class="home-layout"
      :class="{ 'no-cart': !cartItems.length, 'cart-open': isMobile && cartOpen }"
    >
      <nav class="category-tabs">
        <button
          v-for="item in navItems"
          :key="item.value"
          :class="{ active: activeCategory === item.value }"
          type="button"
          @click="selectCategory(item.value)"
        >
          <span class="icon">{{ item.icon }}</span>
          <span>{{ item.label }}</span>
        </button>
      </nav>

      <div class="product-area">
        <section v-if="activeCategory === 'DESSERT'" class="notice">
          <h3>下单必看</h3>
          <ul>
            <li>甜品每天两次新鲜出炉，售完即止，请尽早下单。</li>
            <li>如需与咖啡一起取餐，请在备注说明，我们会统一打包。</li>
            <li>需要写祝福语或切片服务，也可以直接在备注里告诉我们。</li>
          </ul>
        </section>

        <div class="product-grid" v-if="currentProducts.length">
          <article v-for="item in currentProducts" :key="item.id" class="product-card">
            <div class="cover" :style="coverStyle(item.image)">
              <span v-if="item.tag" class="cover-tag">{{ item.tag }}</span>
            </div>
            <div class="info">
              <h3>{{ item.name }}</h3>
              <p class="desc">{{ item.description }}</p>
              <div class="meta">
                <span>¥ {{ Number(item.price || 0).toFixed(2) }}</span>
                <button type="button" @click="addProduct(item)">+</button>
              </div>
            </div>
          </article>
        </div>
        <p v-else class="empty">该分类暂未上架，敬请期待。</p>
      </div>

      <aside
        v-if="cartItems.length && (cartOpen || !isMobile)"
        :class="['mini-cart', { 'is-floating': isMobile }]"
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
            <div class="thumb" :style="thumbStyle(item)">
              <span v-if="item.tag" class="mini-tag">{{ item.tag }}</span>
            </div>
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

        <button class="primary" type="button" @click="emitCheckout">去下单</button>
      </aside>

      <button
        v-if="isMobile && cartItems.length"
        :class="['cart-fab', { active: cartOpen }]"
        type="button"
        :aria-label="cartOpen ? '收起购物车' : '打开购物车'"
        @click="toggleCart"
      >
        <span class="cart-icon">🛒</span>
        <span class="cart-count">{{ cartCount }}</span>
      </button>
    </div>

    <transition name="modal-fade">
      <div v-if="customization.open" class="guide-overlay" role="dialog" aria-modal="true">
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
              <button type="button" class="primary" @click="confirmCustomization">
                确认加入购物车
              </button>
            </div>
          </footer>
        </div>
      </div>
    </transition>
  </section>
</template>

<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue'

const props = defineProps({
  drinks: { type: Array, default: () => [] },
  cartItems: { type: Array, default: null },
  cartTotal: { type: Number, default: null },
  addToCart: { type: Function, default: null },
  incrementItem: { type: Function, default: null },
  decrementItem: { type: Function, default: null },
  clearCart: { type: Function, default: null }
})
const emit = defineEmits(['checkout'])

const heroSlides = [
  { tag: '经典推荐', title: '焦糖燕麦拿铁', subtitle: '丝滑燕麦奶搭配焦糖香气，顺口醇厚。' },
  { tag: '季节限定', title: '芝芝龙井气泡', subtitle: '龙井茶与清爽气泡叠加，入口非常轻盈。' },
  { tag: '手作甜品', title: '红茶无花果巴斯克', subtitle: '锡兰红茶与蜜渍无花果的双重香气。' }
]

const navItems = [
  { label: '甜品', value: 'DESSERT', icon: '🍰' },
  { label: '经典咖啡', value: 'CLASSIC', icon: '☕' },
  { label: '特色手冲', value: 'POUR', icon: '🫘' },
  { label: '特调', value: 'SIGNATURE', icon: '🧪' }
]

const dessertList = [
  {
    id: 'fig-basque',
    name: '红茶无花果巴斯克',
    description: '蜜渍无花果搭配锡兰红茶，冷藏后口感更丝滑。',
    price: 48,
    category: 'DESSERT',
    image:
      'https://images.unsplash.com/photo-1504753793650-d4a2b783c15f?auto=format&fit=crop&w=600&q=80',
    tag: '限量'
  },
  {
    id: 'choco-basque',
    name: '迪拜巧克力巴斯克',
    description: '70% 黑巧融合椰枣糖浆，入口柔软又醇厚。',
    price: 52,
    category: 'DESSERT',
    image:
      'https://images.unsplash.com/photo-1505253399886-34b28f31c15f?auto=format&fit=crop&w=600&q=80',
    tag: '人气'
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

const activeSlide = ref(0)
const slideTimer = ref(null)
const activeCategory = ref('DESSERT')
const internalCart = reactive({})
const cartOpen = ref(false)
const isMobile = ref(false)

const preparedDrinks = computed(() =>
  props.drinks.map((drink, index) => ({
    id: drink.id ?? `drink-${index}`,
    name: drink.name ?? `灵感饮品 ${index + 1}`,
    description: drink.description ?? '这杯饮品正在等待你来定义故事。',
    price: Number(drink.price || 0),
    image: drink.imageUrl || dessertList[index % dessertList.length].image,
    category: String(drink.category || '').toUpperCase(),
    tag: drink.tag
  }))
)

const catalog = computed(() => {
  const collections = { CLASSIC: [], SIGNATURE: [], POUR: [] }
  preparedDrinks.value.forEach((item) => {
    const key = collections[item.category] ? item.category : 'CLASSIC'
    collections[key].push(item)
  })
  return collections
})

const currentProducts = computed(() =>
  activeCategory.value === 'DESSERT' ? dessertList : catalog.value[activeCategory.value] || []
)

const cartItems = computed(() =>
  Array.isArray(props.cartItems) ? props.cartItems : Object.values(internalCart)
)
const cartCount = computed(() =>
  cartItems.value.reduce((sum, item) => sum + Number(item.quantity || 0), 0)
)
const cartTotal = computed(() => {
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

const buildPayload = (source, overrides = {}) => ({
  id: source.id || source.name,
  cartSignature: source.cartSignature || source.id || source.name,
  drinkId: source.drinkId || source.id || source.name,
  name: source.name,
  category: source.category || activeCategory.value,
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

const setSlide = (idx) => {
  activeSlide.value = idx
}

const startSlide = () => {
  stopSlide()
  slideTimer.value = setInterval(() => {
    activeSlide.value = (activeSlide.value + 1) % heroSlides.length
  }, 4000)
}

const stopSlide = () => {
  if (slideTimer.value) {
    clearInterval(slideTimer.value)
    slideTimer.value = null
  }
}

const selectCategory = (value) => {
  activeCategory.value = value
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

const addProduct = (product) => {
  openCustomization(product)
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
  if (!isMobile.value && cartItems.value.length) {
    cartOpen.value = true
  }
  if (isMobile.value && !cartItems.value.length) {
    cartOpen.value = false
  }
}

watch(cartItems, (items) => {
  if (!items.length) {
    cartOpen.value = false
    return
  }
  if (!isMobile.value) {
    cartOpen.value = true
  }
})

onMounted(() => {
  startSlide()
  updateDevice()
  window.addEventListener('resize', updateDevice)
})

onUnmounted(() => {
  stopSlide()
  window.removeEventListener('resize', updateDevice)
})
</script>

<style scoped>
.home-showcase {
  display: grid;
  gap: 20px;
  padding: 16px;
  color: #f8fafc;
}

.hero {
  border-radius: 32px;
  padding: clamp(28px, 5vw, 64px);
  background: radial-gradient(circle at 20% 20%, rgba(15, 23, 42, 0.45), transparent 55%),
    linear-gradient(135deg, rgba(59, 130, 246, 0.65), rgba(14, 165, 233, 0.5));
  position: relative;
  overflow: hidden;
  min-height: clamp(280px, 46vw, 460px);
  display: grid;
  align-content: center;
  gap: 12px;
  box-shadow: 0 40px 80px rgba(15, 23, 42, 0.45);
  isolation: isolate;
}

.hero::before,
.hero::after {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(circle at 75% 20%, rgba(248, 250, 252, 0.35), transparent 45%);
  mix-blend-mode: screen;
  opacity: 0.85;
  z-index: -1;
}

.hero::after {
  background: radial-gradient(circle at 85% 80%, rgba(236, 72, 153, 0.6), transparent 50%);
}

.hero h2 {
  margin: 6px 0;
  font-size: clamp(2.2rem, 5vw, 3.4rem);
  line-height: 1.1;
  max-width: min(580px, 90%);
}

.hero-sub {
  margin: 0;
  color: rgba(226, 232, 240, 0.9);
  font-size: clamp(1rem, 2vw, 1.2rem);
  max-width: min(520px, 88%);
}

.hero-tag {
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  font-size: 0.95rem;
  color: rgba(15, 23, 42, 0.9);
  background: rgba(248, 250, 252, 0.95);
  display: inline-flex;
  padding: 8px 16px;
  border-radius: 999px;
  box-shadow: 0 12px 26px rgba(15, 23, 42, 0.25);
}

.hero-dots {
  display: inline-flex;
  gap: 12px;
  position: absolute;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
}

.hero-dots button {
  width: 14px;
  height: 14px;
  border-radius: 12px;
  border: none;
  background: rgba(255, 255, 255, 0.35);
  transition: all 0.2s ease;
}

.hero-dots button.active {
  width: 32px;
  background: #fff;
}

.home-layout {
  display: grid;
  grid-template-columns: 110px minmax(0, 1fr) 300px;
  grid-template-areas: 'nav content cart';
  gap: 16px;
  align-items: flex-start;
  min-height: calc(100vh - 180px);
}

.home-layout.no-cart {
  grid-template-columns: 110px minmax(0, 1fr);
  grid-template-areas: 'nav content';
}

.category-tabs {
  grid-area: nav;
  display: flex;
  flex-direction: column;
  gap: 12px;
  position: sticky;
  top: 12px;
  align-self: flex-start;
}

.category-tabs button {
  border: none;
  border-radius: 18px;
  padding: 12px 8px;
  background: rgba(15, 23, 42, 0.85);
  color: rgba(226, 232, 240, 0.9);
  display: grid;
  justify-items: center;
  gap: 4px;
}

.category-tabs button.active {
  background: rgba(59, 130, 246, 0.35);
}

.icon {
  font-size: 1.2rem;
}

.product-area {
  grid-area: content;
  display: grid;
  gap: 14px;
  height: calc(100vh - 200px);
  overflow-y: auto;
  padding-right: 4px;
}

.notice {
  border-radius: 18px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px dashed rgba(148, 163, 184, 0.4);
}

.notice ul {
  margin: 8px 0 0;
  padding-left: 18px;
  color: rgba(226, 232, 240, 0.75);
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 14px;
}

.product-card {
  border-radius: 20px;
  padding: 12px;
  background: rgba(15, 23, 42, 0.7);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 12px;
}

.cover {
  position: relative;
  border-radius: 18px;
  padding-bottom: 60%;
  background-size: cover;
  background-position: center;
  overflow: hidden;
}

.cover-tag {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(250, 204, 21, 0.95);
  color: #0f172a;
  font-size: 0.85rem;
}

.info {
  display: grid;
  gap: 6px;
}

.desc {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meta button {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: none;
  background: rgba(59, 130, 246, 0.35);
  color: #0f172a;
  font-size: 1.2rem;
}

.empty {
  margin: 0;
  color: rgba(148, 163, 184, 0.9);
}

.mini-cart {
  grid-area: cart;
  border-radius: 22px;
  padding: 18px;
  background: rgba(2, 6, 23, 0.92);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 12px;
  position: sticky;
  top: 12px;
  max-height: calc(100vh - 200px);
}

.mini-cart header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.cart-list {
  display: grid;
  gap: 10px;
  max-height: 260px;
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
  position: relative;
  min-height: 56px;
}

.mini-tag {
  position: absolute;
  top: 6px;
  left: 6px;
  padding: 2px 8px;
  border-radius: 999px;
  background: rgba(250, 204, 21, 0.95);
  color: #0f172a;
  font-size: 0.75rem;
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
  margin: 4px 0 0;
  color: rgba(148, 163, 184, 0.9);
}

.cart-info .custom-note {
  font-size: 0.8rem;
  color: rgba(203, 213, 225, 0.85);
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

.primary {
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
  max-height: 90vh;
  overflow-y: auto;
  padding: 32px;
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

@media (max-width: 1200px) {
  .home-layout {
    grid-template-columns: 96px minmax(0, 1fr) 260px;
  }

  .home-layout.no-cart {
    grid-template-columns: 96px minmax(0, 1fr);
  }
}

@media (max-width: 960px) {
  .hero {
    min-height: clamp(240px, 52vw, 360px);
    padding: clamp(24px, 6vw, 48px);
  }

  .home-layout {
    row-gap: 8px;
    column-gap: 0;
    grid-template-columns: 84px minmax(0, 1fr);
    grid-template-areas: 'nav content';
    padding-bottom: 0;
  }

  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  }

  .mini-cart {
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

  .mini-cart.is-floating {
    display: grid;
  }

  .category-tabs {
    position: sticky;
    top: 12px;
  }

  .cart-fab {
    display: inline-flex;
  }
}

@media (max-width: 640px) {
  .hero {
    min-height: 220px;
    padding: 24px;
  }

  .hero h2 {
    font-size: clamp(1.9rem, 8vw, 2.4rem);
    max-width: 100%;
  }

  .hero-sub {
    max-width: 100%;
  }

  .hero-dots {
    bottom: 18px;
  }

  .home-layout {
    row-gap: 6px;
    column-gap: 0;
    grid-template-columns: 72px minmax(0, 1fr);
    padding-bottom: 0;
  }

  .mini-cart {
    left: 12px;
    right: 12px;
  }

  .guide-panel {
    padding: 24px;
    width: min(480px, 92vw);
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
