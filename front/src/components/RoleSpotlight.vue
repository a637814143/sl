<template>
  <section class="spotlight">
    <div class="spotlight__header">
      <h2>角色灵感空间</h2>
      <p>不同角色在8am实验室的专属工作台。</p>
    </div>
    <div class="spotlight__cards">
      <article v-for="role in roles" :key="role.title" class="card">
        <div class="card__header">
          <span class="card__tag">{{ role.tag }}</span>
          <h3>{{ role.title }}</h3>
        </div>
        <p class="card__description">{{ role.description }}</p>
        <ul>
          <li v-for="item in role.highlights" :key="item">
            <span class="dot"></span>{{ item }}
          </li>
        </ul>
      </article>
    </div>
  </section>
</template>

<script setup>
const roles = [
  {
    tag: 'ADMIN',
    title: '管理员控制塔',
    description: '沉浸式监控运营指标，掌控实验室每一个节奏点。',
    highlights: ['实时订单热力', '品类动销预测', '人群画像巡航']
  },
  {
    tag: 'MERCHANT',
    title: '商家灵感工作台',
    description: '快速上新爆款饮品，协同供应链完成实验。',
    highlights: ['门店口碑雷达', '风味库存监测', '晨间巡店提醒']
  },
  {
    tag: 'CUSTOMER',
    title: '用户感官旅程',
    description: '轻松预约心仪口味，随时查看饮品制作进度。',
    highlights: ['一键预约取杯', '风味口碑分享', '专属会员灵感']
  }
]
</script>

<style scoped>
.spotlight {
  margin-top: 72px;
  padding: 0 20px 32px;
}

.spotlight__header h2 {
  font-size: 1.4rem;
  margin-bottom: 6px;
}

.spotlight__header p {
  color: rgba(226, 232, 240, 0.75);
  font-size: 0.95rem;
}

.spotlight__cards {
  display: grid;
  gap: 16px;
  margin-top: 28px;
}

.card {
  background: linear-gradient(145deg, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0.4));
  border: 1px solid rgba(148, 163, 184, 0.12);
  border-radius: 20px;
  padding: 22px;
  backdrop-filter: blur(18px);
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.45);
}

.card__tag {
  display: inline-block;
  font-size: 0.7rem;
  letter-spacing: 0.12rem;
  color: rgba(165, 243, 252, 0.8);
  border: 1px solid rgba(103, 232, 249, 0.35);
  border-radius: 999px;
  padding: 6px 10px;
}

.card__header h3 {
  font-size: 1.2rem;
  margin: 12px 0 0;
}

.card__description {
  color: rgba(226, 232, 240, 0.8);
  line-height: 1.6;
  margin: 12px 0 20px;
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
  display: grid;
  gap: 8px;
}

li {
  display: flex;
  align-items: center;
  color: rgba(226, 232, 240, 0.9);
  font-size: 0.92rem;
}

.dot {
  display: inline-flex;
  width: 6px;
  height: 6px;
  border-radius: 999px;
  background: linear-gradient(135deg, #38bdf8, #6366f1);
  margin-right: 10px;
}

@media (min-width: 768px) {
  .spotlight__cards {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}
</style>
