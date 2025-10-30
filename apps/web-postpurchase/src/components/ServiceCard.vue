<script setup lang="ts">
interface Props {
  name: string
  port: number
  stack: string
  status: {
    healthy: boolean
    [key: string]: any
  }
}

defineProps<Props>()
</script>

<template>
  <div class="service-card" :class="{ healthy: status.healthy, unhealthy: !status.healthy }">
    <div class="service-header">
      <h4>{{ name }}</h4>
      <span class="badge">{{ stack }}</span>
    </div>
    <div class="service-body">
      <div class="status-indicator">
        {{ status.healthy ? '✅' : '❌' }}
        <span>{{ status.healthy ? 'Healthy' : 'Offline' }}</span>
      </div>
      <p class="port">Port: {{ port }}</p>
    </div>
  </div>
</template>

<style scoped>
.service-card {
  border: 2px solid #e0e0e0;
  border-radius: 0.5rem;
  padding: 1.5rem;
  transition: all 0.3s ease;
}

.service-card.healthy {
  border-color: #4caf50;
  background: #f1f8f4;
}

.service-card.unhealthy {
  border-color: #f44336;
  background: #fff5f5;
}

.service-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.service-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.service-header h4 {
  margin: 0;
  color: #333;
  font-size: 1.1rem;
}

.badge {
  background: #42d392;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 1rem;
  font-size: 0.85rem;
  font-weight: 500;
}

.service-body {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 500;
}

.port {
  color: #666;
  font-size: 0.9rem;
  margin: 0;
}
</style>

