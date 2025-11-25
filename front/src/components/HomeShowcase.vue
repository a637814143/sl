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
            <small>{{ cartCount }} 杯 · ¥ {{ cartTotal.toFixed(2) }}</small>
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
    image:
      'https://images.unsplash.com/photo-1504753793650-d4a2b783c15f?auto=format&fit=crop&w=600&q=80',
    tag: '限量'
  },
  {
    id: 'choco-basque',
    name: '迪拜巧克力巴斯克',
    description: '70% 黑巧融合椰枣糖浆，入口柔软又醇厚。',
    price: 52,
    image:
      'https://images.unsplash.com/photo-1505253399886-34b28f31c15f?auto=format&fit=crop&w=600&q=80',
    tag: '人气'
  }
]

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

const buildPayload = (source) => ({
  id: source.id || source.name,
  name: source.name,
  price: Number(source.price || 0),
  imageUrl: source.imageUrl || source.image,
  tag: source.tag
})

const mutateLocalCart = (source, delta) => {
  const id = source.id || source.name
  if (!internalCart[id]) {
    internalCart[id] = {
      id,
      name: source.name,
      price: Number(source.price || 0),
      image: source.image || source.imageUrl,
      tag: source.tag,
      quantity: 0
    }
  }
  internalCart[id].quantity += delta
  if (internalCart[id].quantity <= 0) {
    delete internalCart[id]
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

const addProduct = (product) => {
  if (typeof props.addToCart === 'function') {
    props.addToCart({ ...buildPayload(product), quantity: 1 })
  } else {
    mutateLocalCart(product, 1)
  }
}

const increment = (item) => {
  if (typeof props.incrementItem === 'function') {
    props.incrementItem(item)
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
  border-radius: 24px;
  padding: 24px;
  background: linear-gradient(135deg, rgba(58, 123, 213, 0.35), rgba(0, 210, 255, 0.3));
  position: relative;
  overflow: hidden;
}

.hero h2 {
  margin: 4px 0;
  font-size: clamp(1.8rem, 4vw, 2.4rem);
}

.hero-sub {
  margin: 0;
  color: rgba(226, 232, 240, 0.8);
}

.hero-tag {
  margin: 0;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  font-size: 0.85rem;
  color: rgba(15, 23, 42, 0.8);
}

.hero-dots {
  display: flex;
  gap: 8px;
  position: absolute;
  bottom: 16px;
}

.hero-dots button {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.35);
}

.hero-dots button.active {
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

@media (max-width: 1200px) {
  .home-layout {
    grid-template-columns: 96px minmax(0, 1fr) 260px;
  }

  .home-layout.no-cart {
    grid-template-columns: 96px minmax(0, 1fr);
  }
}

@media (max-width: 960px) {
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
}
</style>
