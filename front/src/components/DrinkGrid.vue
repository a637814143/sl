<template>
  <section class="drinks">
    <header class="drinks__header">
      <h2>本周晨间灵感单</h2>
      <p>跟随实验室味觉探针，探索限量风味。</p>
    </header>
    <div class="drinks__grid">
      <article v-for="drink in drinks" :key="drink.id" class="card">
        <div class="card__media">
          <img :src="drink.imageUrl" :alt="drink.name" loading="lazy" />
        </div>
        <div class="card__body">
          <div class="card__title">
            <h3>{{ drink.name }}</h3>
            <span class="price">¥{{ Number(drink.price).toFixed(2) }}</span>
          </div>
          <p>{{ drink.description }}</p>
          <footer>
            <span class="tag">{{ drink.flavorProfile }}</span>
            <span class="tag tag--merchant">{{ drink.merchantName }}</span>
          </footer>
        </div>
      </article>
    </div>
  </section>
</template>

<script setup>
defineProps({
  drinks: {
    type: Array,
    default: () => []
  }
})
</script>

<style scoped>
.drinks {
  margin-top: 56px;
  padding: 0 20px;
}

.drinks__header h2 {
  font-size: 1.45rem;
  margin-bottom: 6px;
}

.drinks__header p {
  color: rgba(226, 232, 240, 0.75);
  margin: 0;
}

.drinks__grid {
  display: grid;
  gap: 20px;
  margin-top: 26px;
}

.card {
  background: linear-gradient(150deg, rgba(15, 23, 42, 0.95), rgba(15, 23, 42, 0.35));
  border-radius: 24px;
  border: 1px solid rgba(148, 163, 184, 0.18);
  overflow: hidden;
  box-shadow: 0 16px 32px rgba(8, 47, 73, 0.35);
}

.card__media {
  padding-top: 62%;
  position: relative;
  overflow: hidden;
  background: rgba(15, 118, 110, 0.12);
}

.card__media img {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  object-fit: cover;
}

.card__body {
  padding: 22px 22px 24px;
}

.card__title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.card__title h3 {
  font-size: 1.2rem;
  margin: 0;
}

.price {
  background: rgba(59, 130, 246, 0.2);
  border-radius: 12px;
  padding: 6px 12px;
  font-weight: 600;
}

.card__body p {
  color: rgba(226, 232, 240, 0.78);
  line-height: 1.6;
  margin: 12px 0 20px;
}

footer {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.tag {
  display: inline-flex;
  align-items: center;
  padding: 4px 12px;
  border-radius: 999px;
  font-size: 0.75rem;
  letter-spacing: 0.08rem;
  background: rgba(148, 163, 184, 0.12);
  border: 1px solid rgba(148, 163, 184, 0.25);
}

.tag--merchant {
  background: rgba(56, 189, 248, 0.18);
  border-color: rgba(96, 165, 250, 0.35);
}

@media (min-width: 768px) {
  .drinks__grid {
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }
}
</style>
