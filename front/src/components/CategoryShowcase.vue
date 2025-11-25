<template>
  <div class="category-page">
    <header class="page-head">
      <p class="kicker">8am 灵感菜单</p>
      <h1>全部分类与购物车</h1>
    </header>

    <section class="layout">
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
          <div class="card-list">
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
            <p v-if="!section.items.length" class="empty-tip">该分类暂未上架，稍后再来看看。</p>
          </div>
        </section>
      </main>

      <aside class="cart-panel">
        <header>
          <div>
            <h3>已选商品</h3>
            <small v-if="cartItems.length">共 {{ cartItems.length }} 款 · ¥ {{ cartTotal.toFixed(2) }}</small>
            <small v-else>购物车为空</small>
          </div>
          <button class="ghost" type="button" :disabled="!cartItems.length" @click="clearCart">清空</button>
        </header>
        <div class="cart-list" v-if="cartItems.length">
          <article v-for="item in cartItems" :key="item.id">
            <div>
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
        <p v-else class="empty-tip">点击商品右侧“+”即可加入购物车。</p>
        <footer class="cart-actions">
          <button type="button" class="primary" :disabled="!cartItems.length" @click="emitCheckout">去下单</button>
        </footer>
      </aside>
    </section>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from 'vue'

const props = defineProps({
  drinks: { type: Array, default: () => [] },
  initialCategory: { type: String, default: 'CLASSIC' }
})
const emit = defineEmits(['checkout'])

const navItems = [
  { label: '经典咖啡', value: 'CLASSIC', icon: '☕', description: '顺口经典款，适合任何时刻', placeholder: '经典区等待你的故事。' },
  { label: '特调', value: 'SIGNATURE', icon: '🧪', description: '主理人灵感限定', placeholder: '特调灵感来自当季食材。' },
  { label: '特色手冲', value: 'POUR', icon: '🫘', description: '单品豆的香气旅程', placeholder: '手冲区展示不同产区。' },
  { label: '甜品', value: 'DESSERT', icon: '🍰', description: '巴斯克与烘焙小点', placeholder: '甜品限量烘焙，搭配咖啡更出色。' }
]

const activeCategory = ref(props.initialCategory || 'CLASSIC')
const contentRef = ref(null)
const cart = reactive({})

const resolveCategory = (drink, index) => {
  const explicit = String(drink.category || drink.type || '').toUpperCase()
  if (navItems.some((item) => item.value === explicit)) return explicit
  const text = `${drink.name} ${drink.description || ''}`.toLowerCase()
  if (text.includes('手冲')) return 'POUR'
  if (text.includes('特调')) return 'SIGNATURE'
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

const cartItems = computed(() => Object.values(cart))
const cartTotal = computed(() =>
  cartItems.value.reduce((sum, item) => sum + Number(item.price || 0) * item.quantity, 0)
)

const addToCart = (drink) => {
  if (!drink?.id) return
  const key = String(drink.id)
  if (!cart[key]) {
    cart[key] = { id: drink.id, name: drink.name, price: drink.price, imageUrl: drink.imageUrl, quantity: 0 }
  }
  cart[key].quantity += 1
}

const increment = (item) => addToCart(item)

const decrement = (item) => {
  const key = String(item.id)
  if (!cart[key]) return
  cart[key].quantity -= 1
  if (cart[key].quantity <= 0) {
    delete cart[key]
  }
}

const clearCart = () => {
  Object.keys(cart).forEach((key) => delete cart[key])
}

const emitCheckout = () => {
  if (!cartItems.value.length) return
  emit('checkout', cartItems.value)
}

const coverStyle = (image) => ({
  backgroundImage: image
    ? `linear-gradient(135deg, rgba(15,23,42,0.35), rgba(2,6,23,0.45)), url(${image})`
    : 'linear-gradient(135deg, rgba(30,64,175,0.3), rgba(2,6,23,0.6))'
})

const setCategory = (value) => {
  activeCategory.value = value
  const sectionEl = document.getElementById(`section-${value.toLowerCase()}`)
  if (sectionEl && contentRef.value) {
    contentRef.value.scrollTo({ top: sectionEl.offsetTop, behavior: 'smooth' })
  }
}
</script>

<style scoped>
.category-page {
  display: grid;
  gap: 16px;
  padding: 16px;
  color: #f8fafc;
}

.page-head h1 {
  margin: 6px 0 0;
}

.layout {
  display: grid;
  grid-template-columns: 90px minmax(0, 1fr) 260px;
  gap: 16px;
  min-height: 70vh;
}

.nav-panel {
  display: flex;
  flex-direction: column;
  gap: 10px;
  position: sticky;
  top: 16px;
}

.nav-panel button {
  border: none;
  border-radius: 16px;
  padding: 12px 8px;
  background: rgba(15, 23, 42, 0.75);
  color: rgba(226, 232, 240, 0.85);
  display: grid;
  justify-items: center;
  gap: 4px;
}

.nav-panel button.active {
  background: rgba(59, 130, 246, 0.35);
}

.icon {
  font-size: 1.2rem;
}

.content-panel {
  display: grid;
  gap: 16px;
  max-height: 70vh;
  overflow-y: auto;
  padding-right: 6px;
}

.category-block {
  border-radius: 18px;
  background: rgba(15, 23, 42, 0.75);
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 16px;
}

.card-list {
  display: grid;
  gap: 12px;
  margin-top: 12px;
}

.card {
  display: grid;
  grid-template-columns: 100px minmax(0, 1fr);
  gap: 12px;
  border-radius: 16px;
  background: rgba(15, 23, 42, 0.65);
  border: 1px solid rgba(148, 163, 184, 0.25);
  padding: 12px;
}

.cover {
  border-radius: 14px;
  background-size: cover;
  background-position: center;
  min-height: 100px;
}

.info h3 {
  margin: 0 0 6px;
}

.info footer {
  margin-top: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.info footer button {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  border: none;
  background: rgba(59, 130, 246, 0.3);
  color: #0f172a;
  font-size: 1.2rem;
}

.empty-tip {
  margin: 8px 0 0;
  color: rgba(148, 163, 184, 0.8);
}

.cart-panel {
  border-radius: 22px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(2, 6, 23, 0.9);
  padding: 18px;
  display: grid;
  gap: 12px;
  position: sticky;
  top: 16px;
  max-height: 70vh;
}

.cart-list {
  display: grid;
  gap: 10px;
  max-height: 280px;
  overflow-y: auto;
}

.cart-list article {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 8px;
  border-bottom: 1px dashed rgba(148, 163, 184, 0.3);
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
  border-radius: 12px;
  background: linear-gradient(135deg, #38bdf8, #22d3ee);
  color: #0f172a;
  font-weight: 600;
}

.ghost {
  border: 1px dashed rgba(148, 163, 184, 0.4);
  background: transparent;
  color: rgba(226, 232, 240, 0.9);
  padding: 8px 12px;
  border-radius: 12px;
}

@media (max-width: 960px) {
  .layout {
    grid-template-columns: 1fr;
    grid-template-areas:
      'nav'
      'content'
      'cart';
  }

  .nav-panel {
    flex-direction: row;
    overflow-x: auto;
  }

  .cart-panel {
    position: static;
    max-height: none;
  }

  .card {
    grid-template-columns: 1fr;
  }
}
</style>
