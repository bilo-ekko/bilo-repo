<script setup lang="ts">
interface Props {
  icon: string
  title: string
  description: string
}

defineProps<Props>()
</script>

<template>
  <div class="feature">
    <span class="icon">{{ icon }}</span>
    <h4>{{ title }}</h4>
    <p>{{ description }}</p>
  </div>
</template>

<style scoped>
.feature {
  text-align: center;
  padding: 1.5rem;
  border-radius: 0.5rem;
  background: #f8f9fa;
  transition: all 0.3s ease;
}

.feature:hover {
  background: #e9ecef;
  transform: translateY(-2px);
}

.icon {
  font-size: 2.5rem;
  display: block;
  margin-bottom: 1rem;
}

.feature h4 {
  color: #333;
  margin: 0.5rem 0;
}

.feature p {
  color: #666;
  font-size: 0.95rem;
  margin: 0;
}
</style>

