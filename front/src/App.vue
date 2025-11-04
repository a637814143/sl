<template>
  <div class="page">
    <header class="topbar">
      <div class="brand">
        <span class="logo">8</span>
        <div>
          <strong>8am实验室</strong>
          <p>感官饮品研究所</p>
        </div>
      </div>
      <button class="ghost">预约取杯</button>
    </header>

    <main>
      <section class="hero">
        <div class="hero__copy">
          <span class="badge">Mobile First · 纯前后端分离</span>
          <h1>唤醒清晨的第一口灵感</h1>
          <p>
            8am实验室以实验精神打造下一杯风味灵感。我们连接管理者、商家与用户，让每一次下单都充满仪式感。
          </p>
          <div class="hero__actions">
            <a class="primary" href="#order">开启预约</a>
            <a class="secondary" href="#drinks">浏览灵感单</a>
          </div>
          <div class="hero__avatars">
            <img v-for="profile in customerProfiles" :key="profile.id" :src="profile.avatar" :alt="profile.displayName" />
            <span>与 {{ customerProfiles.length }} 位晨间合伙人共同品味</span>
          </div>
        </div>
        <div class="hero__panel">
          <div class="glass">
            <h3>今日订单节奏</h3>
            <ul>
              <li>
                <span>接收中</span>
                <strong>{{ overview?.received ?? '—' }}</strong>
              </li>
              <li>
                <span>萃取中</span>
                <strong>{{ overview?.preparing ?? '—' }}</strong>
              </li>
              <li>
                <span>待取杯</span>
                <strong>{{ overview?.ready ?? '—' }}</strong>
              </li>
              <li>
                <span>今日人气</span>
                <strong>{{ overview?.topDrink ?? '—' }}</strong>
              </li>
            </ul>
          </div>
        </div>
      </section>

      <DrinkGrid id="drinks" :drinks="drinks" />
      <RoleSpotlight />
      <OrderForm id="order" :drinks="drinks" :merchants="merchants" :submit-order="handleOrder" />
    </main>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import DrinkGrid from './components/DrinkGrid.vue'
import RoleSpotlight from './components/RoleSpotlight.vue'
import OrderForm from './components/OrderForm.vue'
import {
  fetchDrinks,
  fetchMerchants,
  fetchOverview,
  fetchProfilesByRole,
  createOrder
} from './services/api'

const drinks = ref([])
const merchants = ref([])
const overview = ref()
const customerProfiles = ref([])

const loadBaseData = async () => {
  const [drinkList, merchantList, overviewData, customers] = await Promise.all([
    fetchDrinks(),
    fetchMerchants(),
    fetchOverview(),
    fetchProfilesByRole('customer')
  ])
  drinks.value = drinkList
  merchants.value = merchantList
  overview.value = overviewData
  customerProfiles.value = customers
}

const refreshOverview = async () => {
  overview.value = await fetchOverview()
}

const handleOrder = async (payload) => {
  await createOrder({
    ...payload,
    drinkId: Number(payload.drinkId),
    merchantId: Number(payload.merchantId)
  })
  await refreshOverview()
}

onMounted(async () => {
  try {
    await loadBaseData()
  } catch (error) {
    console.error('加载基础数据失败', error)
  }
})
</script>

<style scoped>
.page {
  padding-bottom: 120px;
}

.topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 24px 20px 12px;
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(20px);
  background: rgba(8, 11, 15, 0.75);
}

.brand {
  display: flex;
  align-items: center;
  gap: 14px;
}

.logo {
  width: 48px;
  height: 48px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 16px;
  background: linear-gradient(140deg, #2563eb, #38bdf8 60%, #a855f7);
  font-size: 1.4rem;
  font-weight: 700;
  color: #0f172a;
}

.brand strong {
  display: block;
  font-size: 1.1rem;
}

.brand p {
  margin: 0;
  color: rgba(148, 163, 184, 0.8);
  font-size: 0.78rem;
}

.ghost {
  border: 1px solid rgba(148, 163, 184, 0.35);
  background: transparent;
  color: #e2e8f0;
  padding: 10px 18px;
  border-radius: 999px;
  font-weight: 600;
  letter-spacing: 0.02em;
}

.hero {
  display: grid;
  gap: 26px;
  padding: 32px 20px 16px;
}

.hero__copy h1 {
  font-size: clamp(2rem, 9vw, 2.8rem);
  margin: 14px 0 12px;
}

.hero__copy p {
  color: rgba(226, 232, 240, 0.76);
  line-height: 1.7;
  margin: 0 0 22px;
}

.badge {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  border-radius: 999px;
  border: 1px solid rgba(148, 163, 184, 0.35);
  padding: 6px 12px;
  font-size: 0.78rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.hero__actions {
  display: flex;
  gap: 14px;
}

.primary,
.secondary {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 14px 22px;
  border-radius: 999px;
  font-weight: 600;
}

.primary {
  background: linear-gradient(120deg, #38bdf8, #6366f1);
  color: #020617;
  box-shadow: 0 18px 36px rgba(59, 130, 246, 0.35);
}

.secondary {
  border: 1px solid rgba(148, 163, 184, 0.35);
  color: rgba(226, 232, 240, 0.9);
}

.hero__avatars {
  margin-top: 24px;
  display: flex;
  align-items: center;
  gap: 10px;
  color: rgba(226, 232, 240, 0.75);
}

.hero__avatars img {
  width: 40px;
  height: 40px;
  border-radius: 999px;
  object-fit: cover;
  border: 2px solid rgba(14, 165, 233, 0.65);
  box-shadow: 0 10px 20px rgba(14, 165, 233, 0.25);
}

.hero__panel {
  display: flex;
  justify-content: center;
}

.glass {
  min-width: 280px;
  border-radius: 24px;
  padding: 22px 24px;
  background: linear-gradient(160deg, rgba(2, 6, 23, 0.92), rgba(14, 116, 144, 0.35));
  border: 1px solid rgba(125, 211, 252, 0.35);
  box-shadow: 0 16px 40px rgba(14, 116, 144, 0.35);
}

.glass h3 {
  margin: 0 0 18px;
  font-size: 1.1rem;
}

.glass ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 14px;
}

.glass li {
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: rgba(226, 232, 240, 0.8);
}

.glass strong {
  font-size: 1.1rem;
  color: #f8fafc;
}

@media (min-width: 960px) {
  .hero {
    grid-template-columns: 1.1fr 0.9fr;
    align-items: center;
    padding: 60px 8vw 40px;
  }

  .topbar {
    padding: 30px 8vw 12px;
  }
}
</style>
