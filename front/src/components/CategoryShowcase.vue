<template>
  <div class="category-page">
    <header class="page-head">
      <p class="kicker">8am 灵感菜单</p>
      <h1>灵感单专场</h1>
    </header>

    <section
      class="category-layout"
      :class="{
        'no-cart': !cartItems.length,
        'cart-open': isMobile && cartOpen
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
                  <span>¥ {{ Number(item.price || 0).toFixed(2) }}</span>
                  <button type="button" @click="addToCart(item)">+</button>
                </footer>
              </div>
            </article>
          </div>
          <p v-else class="empty-tip">{{ section.placeholder }}</p>
        </section>
      </main>

      <aside
        v-if="cartItems.length && (cartOpen || !isMobile)"
        :class="['cart-panel', { 'is-floating': isMobile }]"
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
            <div class="thumb" :style="thumbStyle(item)"></div>
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

        <footer class="cart-actions">
          <button type="button" class="primary" @click="emitCheckout">去下单</button>
        </footer>
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
    </section>
  </div>
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
  clearCart: { type: Function, default: null }
})
const emit = defineEmits(['checkout'])

const navItems = [
  {
    label: '经典咖啡',
    value: 'CLASSIC',
    icon: '☕',
    description: '顺口经典款，日常最稳妥的选择。',
    placeholder: '经典区暂未上架，稍后看看。'
  },
  {
    label: '特调',
    value: 'SIGNATURE',
    icon: '🧪',
    description: '主理人灵感限定，甜感与香气更有记忆点。',
    placeholder: '特调会随季节更新，敬请期待。'
  },
  {
    label: '特色手冲',
    value: 'POUR',
    icon: '🫘',
    description: '产区风味的旅程，慢慢品出层次。',
    placeholder: '手冲豆正在新鲜烘焙，马上上线。'
  },
  {
    label: '甜品',
    value: 'DESSERT',
    icon: '🍰',
    description: '巴斯克与烘焙小点，配咖啡才完整。',
    placeholder: '甜品烘焙中，稍后刷新就能看到。'
  }
]

const activeCategory = ref(props.initialCategory || 'CLASSIC')
const contentRef = ref(null)
const internalCart = reactive({})
const cartOpen = ref(false)
const isMobile = ref(false)

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
    items: props.drinks.filter((drink, index) => resolveCategory(drink, index) === item.value)
  }))
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

const setCategory = (value) => {
  activeCategory.value = value
  const panel = contentRef.value
  if (!panel) return
  const target = panel.querySelector(`#section-${value.toLowerCase()}`)
  if (target) {
    panel.scrollTo({ top: target.offsetTop, behavior: 'smooth' })
  }
}

const buildPayload = (source) => ({
  id: source.id || source.name,
  name: source.name,
  price: Number(source.price || 0),
  imageUrl: source.imageUrl || source.image
})

const mutateLocalCart = (source, delta) => {
  const id = source.id || source.name
  if (!internalCart[id]) {
    internalCart[id] = {
      id,
      name: source.name,
      price: Number(source.price || 0),
      image: source.image || source.imageUrl,
      quantity: 0
    }
  }
  internalCart[id].quantity += delta
  if (internalCart[id].quantity <= 0) {
    delete internalCart[id]
  }
}

const addToCart = (drink) => {
  if (!drink) return
  if (typeof props.addToCart === 'function') {
    props.addToCart({ ...buildPayload(drink), quantity: 1 })
  } else {
    mutateLocalCart(drink, 1)
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
  display: grid;
  gap: 10px;
}

.cover {
  border-radius: 18px;
  padding-bottom: 60%;
  background-size: cover;
  background-position: center;
}

.info {
  display: grid;
  gap: 6px;
}

.info footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
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
  min-height: 56px;
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
}
</style>
