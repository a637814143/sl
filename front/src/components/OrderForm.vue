<template>
  <section class="order">
    <header>
      <h2>立即预约你的晨间咖啡或巴斯克</h2>
      <p>从下单到取餐平均只需 8 分钟。</p>
    </header>
    <form @submit.prevent="handleSubmit">
      <div class="field">
        <label for="customer">称呼</label>
        <input id="customer" v-model="form.customerName" type="text" placeholder="如：晨光" required />
      </div>
      <div class="field">
        <label for="phone">联系电话</label>
        <input id="phone" v-model="form.contactPhone" type="tel" placeholder="请输入手机号" required />
      </div>
      <div class="field">
        <label for="drink">选择菜单</label>
        <select id="drink" v-model="form.drinkId" required>
          <option disabled value="">请选择菜单项</option>
          <option v-for="drink in drinks" :key="drink.id" :value="drink.id">
            {{ drink.name }} · ¥{{ Number(drink.price).toFixed(2) }}
          </option>
        </select>
      </div>
      <div class="field">
        <label for="merchant">取餐门店</label>
        <select id="merchant" v-model="form.merchantId" required>
          <option disabled value="">选择门店</option>
          <option v-for="merchant in merchants" :key="merchant.id" :value="merchant.id">
            {{ merchant.name }} · {{ merchant.location }}
          </option>
        </select>
      </div>
      <div class="field field--inline">
        <div>
          <label for="quantity">份数</label>
          <input id="quantity" v-model.number="form.quantity" type="number" min="1" max="9" />
        </div>
        <div>
          <label for="pickup">预计取餐</label>
          <input id="pickup" v-model="form.pickupTime" type="time" />
        </div>
      </div>
      <button :disabled="submitting">
        {{ submitting ? '预约中...' : '唤醒味觉' }}
      </button>
      <p v-if="message" class="message" :class="{ 'message--success': success }">{{ message }}</p>
    </form>
  </section>
</template>

<script setup>
import { reactive, ref, watch } from 'vue'

const props = defineProps({
  drinks: { type: Array, default: () => [] },
  merchants: { type: Array, default: () => [] },
  submitOrder: { type: Function, required: true }
})

const initialState = () => ({
  customerName: '',
  contactPhone: '',
  drinkId: '',
  merchantId: '',
  quantity: 1,
  pickupTime: ''
})

const form = reactive(initialState())
const submitting = ref(false)
const message = ref('')
const success = ref(false)

watch(
  () => props.drinks,
  (list) => {
    if (!form.drinkId && list.length) {
      form.drinkId = list[0].id
    }
  },
  { immediate: true }
)

watch(
  () => props.merchants,
  (list) => {
    if (!form.merchantId && list.length) {
      form.merchantId = list[0].id
    }
  },
  { immediate: true }
)

const handleSubmit = async () => {
  submitting.value = true
  message.value = ''
  success.value = false
  try {
    await props.submitOrder({ ...form })
    Object.assign(form, initialState())
    if (props.drinks.length) {
      form.drinkId = props.drinks[0].id
    }
    if (props.merchants.length) {
      form.merchantId = props.merchants[0].id
    }
    message.value = '预约成功，我们会在制作完成后短信提醒你。'
    success.value = true
  } catch (error) {
    message.value = error?.response?.data?.message || '下单失败，请稍后重试。'
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.order {
  margin: 72px 20px 0;
  padding: 32px 26px;
  border-radius: 28px;
  background: linear-gradient(160deg, rgba(6, 182, 212, 0.25), rgba(37, 99, 235, 0.18));
  border: 1px solid rgba(96, 165, 250, 0.4);
  box-shadow: 0 20px 40px rgba(37, 99, 235, 0.22);
}

header h2 {
  margin: 0 0 6px;
  font-size: 1.4rem;
}

header p {
  margin: 0 0 24px;
  color: rgba(226, 232, 240, 0.8);
}

form {
  display: grid;
  gap: 16px;
}

.field {
  display: grid;
  gap: 6px;
}

label {
  font-size: 0.9rem;
  color: rgba(226, 232, 240, 0.85);
}

input,
select {
  width: 100%;
  padding: 14px 16px;
  border-radius: 14px;
  border: 1px solid rgba(148, 163, 184, 0.25);
  background: rgba(15, 23, 42, 0.65);
  color: #f8fafc;
}

input:focus,
select:focus {
  outline: none;
  border-color: rgba(96, 165, 250, 0.75);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.25);
}

.field--inline {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

button {
  margin-top: 8px;
  padding: 16px;
  border-radius: 999px;
  border: none;
  font-size: 1rem;
  font-weight: 600;
  color: #020617;
  background: linear-gradient(135deg, #38bdf8, #22d3ee 55%, #60a5fa);
  box-shadow: 0 18px 32px rgba(14, 165, 233, 0.35);
  cursor: pointer;
  transition: transform 0.2s ease;
}

button:disabled {
  opacity: 0.65;
  cursor: wait;
  transform: none !important;
}

button:not(:disabled):active {
  transform: translateY(1px);
}

.message {
  margin: 0;
  font-size: 0.9rem;
  color: rgba(248, 250, 252, 0.85);
}

.message--success {
  color: #99f6e4;
}

@media (min-width: 768px) {
  .order {
    max-width: 640px;
    margin-left: auto;
    margin-right: auto;
  }
}
</style>
