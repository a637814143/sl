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
          @click="setSlide(idx)"
        />
      </div>
    </div>

    <div class="home-layout">
      <nav class="category-tabs">
        <button
          v-for="item in navItems"
          :key="item.value"
          :class="{ active: activeCategory === item.value }"
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
            <li>甜品每天两次新鲜出炉，售完即止。</li>
            <li>如需与咖啡一起取餐，请在备注中说明。</li>
            <li>需要切片或祝福语，可在备注里留言。</li>
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

      <aside class="mini-cart">
        <header>
          <div>
            <h3>已选商品</h3>
            <small v-if="cartItems.length">共 {{ cartCount }} 件 · ¥ {{ cartTotal.toFixed(2) }}</small>
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
        <p class="empty" v-else>点击“+”即可加入购物车。</p>
        <button class="primary" type="button" :disabled="!cartItems.length" @click="emitCheckout">去下单</button>
      </aside>
    </div>
  </section>
</template>

<script setup>
import { computed, onMounted, onUnmounted, reactive, ref } from 'vue'

const props = defineProps({ drinks: { type: Array, default: () => [] } })
const emit = defineEmits(['checkout'])

const heroSlides = [
  { tag: '经典推荐', title: '焦糖燕麦拿铁', subtitle: '丝滑燕麦奶搭配淡淡焦糖' },
  { tag: '季节限定', title: '芝芝龙井气泡', subtitle: '茶香气泡让清爽加倍' },
  { tag: '手作甜品', title: '红茶无花果巴斯克', subtitle: '蜜渍无花果与锡兰红茶的碰撞' }
]

const navItems = [
  { label: '甜品', value: 'DESSERT', icon: '🍰' },
  { label: '经典咖啡', value: 'CLASSIC', icon: '☕' },
  { label: '特色手冲', value: 'POUR', icon: '🫘' },
  { label: '特调', value: 'SIGNATURE', icon: '🧪' }
]

const dessertList = [
  { id: 'fig-basque', name: '红茶无花果巴斯克', description: '蜜渍无花果搭配锡兰红茶，冷藏更好吃。', price: 48, image: 'https://images.unsplash.com/photo-1504753793650-d4a2b783c15f?auto=format&fit=crop&w=600&q=80', tag: '限量' },
  { id: 'choco-basque', name: '迪拜巧克力巴斯克', description: '70% 黑巧与椰枣糖浆打造丝滑口感。', price: 52, image: 'https://images.unsplash.com/photo-1505253399886-34b28f31c15f?auto=format&fit=crop&w=600&q=80', tag: '人气' }
]

const activeSlide = ref(0)
const slideTimer = ref(null)
const activeCategory = ref('DESSERT')
const cart = reactive({})

const preparedDrinks = computed(() =>
  props.drinks.map((drink, index) => ({
    id: drink.id ?? `drink-${index}`,
    name: drink.name ?? '灵感饮品',
    description: drink.description ?? '这杯饮品正在等待你来定义故事。',
    price: Number(drink.price || 0),
    image: drink.imageUrl || dessertList[index % dessertList.length].image,
    category: String(drink.category || '').toUpperCase()
  }))
)

const catalog = computed(() => {
  const result = { CLASSIC: [], SIGNATURE: [], POUR: [] }
  preparedDrinks.value.forEach((item) => {
    const key = result[item.category] ? item.category : 'CLASSIC'
    result[key].push(item)
  })
  return result
})

const currentProducts = computed(() => (activeCategory.value === 'DESSERT' ? dessertList : catalog.value[activeCategory.value] || []))
const cartItems = computed(() => Object.values(cart))
const cartCount = computed(() => cartItems.value.reduce((sum, item) => sum + item.quantity, 0))
const cartTotal = computed(() => cartItems.value.reduce((sum, item) => sum + Number(item.price || 0) * item.quantity, 0))

const coverStyle = (image) => ({
  backgroundImage: `linear-gradient(135deg, rgba(15,23,42,0.4), rgba(2,6,23,0.55)), url(${image})`
})

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
  const id = product.id || product.name
  if (!cart[id]) {
    cart[id] = { id, name: product.name, price: Number(product.price || 0), quantity: 0 }
  }
  cart[id].quantity += 1
}

const increment = (item) => addProduct(item)
const decrement = (item) => {
  const entry = cart[item.id]
  if (!entry) return
  entry.quantity -= 1
  if (entry.quantity <= 0) delete cart[item.id]
}

const clearCart = () => Object.keys(cart).forEach((key) => delete cart[key])

const emitCheckout = () => {
  if (!cartItems.value.length) return
  emit('checkout', cartItems.value)
}

onMounted(() => startSlide())
onUnmounted(() => stopSlide())
</script>

<style scoped>
.home-showcase {
  display: grid;
  gap: 16px;
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

.hero-tag {
  margin: 0 0 6px;
  letter-spacing: 0.08em;
  font-size: 0.85rem;
}

.hero h2 {
  margin: 0 0 6px;
}

.hero-dots {
  display: flex;
  gap: 6px;
  position: absolute;
  right: 20px;
  bottom: 16px;
}

.hero-dots button {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.5);
}

.hero-dots button.active {
  background: #fff;
}

.home-layout {
  display: grid;
  grid-template-columns: 90px minmax(0, 1fr) 260px;
  gap: 16px;
}

.category-tabs {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.category-tabs button {
  border: none;
  border-radius: 16px;
  padding: 10px 8px;
  background: rgba(15, 23, 42, 0.75);
  color: rgba(226, 232, 240, 0.85);
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

.content {
  display: grid;
  gap: 12px;
}

.notice {
  border-radius: 16px;
  padding: 16px;
  background: rgba(15, 23, 42, 0.7);
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.notice ul {
  margin: 8px 0 0;
  padding-left: 18px;
  color: rgba(226, 232, 240, 0.85);
}

.product-grid {
  display: grid;
  gap: 12px;
}

.product-card {
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

.cover-tag {
  position: absolute;
  left: 8px;
  bottom: 8px;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(59, 130, 246, 0.8);
  color: #0f172a;
  font-size: 0.75rem;
}

.info h3 {
  margin: 0 0 6px;
}

.desc {
  margin: 0 0 10px;
  color: rgba(226, 232, 240, 0.8);
}

.meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meta button {
  width: 34px;
  height: 34px;
  border-radius: 50%;
  border: none;
  background: rgba(59, 130, 246, 0.3);
  color: #0f172a;
  font-size: 1.2rem;
}

.empty {
  margin: 0;
  color: rgba(148, 163, 184, 0.8);
}

.mini-cart {
  border-radius: 20px;
  padding: 16px;
  background: rgba(2, 6, 23, 0.9);
  border: 1px solid rgba(148, 163, 184, 0.25);
  display: grid;
  gap: 12px;
}

.cart-list {
  display: grid;
  gap: 10px;
  max-height: 240px;
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

.primary {
  width: 100%;
  border: none;
  padding: 12px;
  border-radius: 12px;
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

@media (max-width: 960px) {
  .home-layout {
    grid-template-columns: 1fr;
  }

  .category-tabs {
    flex-direction: row;
    overflow-x: auto;
  }

  .product-card {
    grid-template-columns: 1fr;
  }

  .mini-cart {
    position: static;
  }
}
</style>
