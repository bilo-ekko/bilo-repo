<script setup lang="ts">
import { ref, onMounted } from 'vue'
import ServiceCard from './components/ServiceCard.vue'
import FeatureCard from './components/FeatureCard.vue'

interface Service {
  name: string
  port: number
  stack: string
}

interface ServiceStatus {
  healthy: boolean
  [key: string]: any
}

const services: Service[] = [
  { name: 'Auth Service', port: 3001, stack: 'TypeScript' },
  { name: 'Reporting Service', port: 3201, stack: 'C#' },
  { name: 'Funds Service', port: 3101, stack: 'Go' },
  { name: 'Calculator Service', port: 3010, stack: 'Python' },
  { name: 'Messaging Service', port: 3009, stack: 'Rust' }
]

const serviceStatus = ref<Record<string, ServiceStatus>>({})
const loading = ref(true)

const features = [
  { icon: '📦', title: 'Order Tracking', description: 'Track your orders in real-time' },
  { icon: '💳', title: 'Invoice Management', description: 'Access and manage invoices' },
  { icon: '🔔', title: 'Smart Notifications', description: 'Stay updated on your purchases' },
  { icon: '🎁', title: 'Rewards Program', description: 'Earn points with every purchase' }
]

onMounted(async () => {
  const status: Record<string, ServiceStatus> = {}

  for (const service of services) {
    try {
      const response = await fetch(`http://localhost:${service.port}/health`)
      if (response.ok) {
        status[service.name] = { healthy: true, ...(await response.json()) }
      } else {
        status[service.name] = { healthy: false }
      }
    } catch (error) {
      status[service.name] = { healthy: false, error: String(error) }
    }
  }

  serviceStatus.value = status
  loading.value = false
})
</script>

<template>
  <div class="container">
    <header>
      <h1>🎉 Post-Purchase Experience</h1>
      <p class="subtitle">Vue 3 • Vite • TypeScript</p>
    </header>

    <main>
      <section class="hero">
        <h2>Welcome to Your Post-Purchase Portal</h2>
        <p>
          Manage your orders, track deliveries, and access your purchase history all in one place.
        </p>
      </section>

      <section class="services">
        <h3>📡 Service Health Monitor</h3>
        <p v-if="loading" class="loading">Checking services...</p>
        <div v-else class="service-grid">
          <ServiceCard
            v-for="service in services"
            :key="service.name"
            :name="service.name"
            :port="service.port"
            :stack="service.stack"
            :status="serviceStatus[service.name]"
          />
        </div>
      </section>

      <section class="features">
        <h3>✨ Features</h3>
        <div class="feature-grid">
          <FeatureCard
            v-for="feature in features"
            :key="feature.title"
            :icon="feature.icon"
            :title="feature.title"
            :description="feature.description"
          />
        </div>
      </section>

      <section class="cta">
        <div class="cta-content">
          <h3>Ready to explore?</h3>
          <p>Dive into your post-purchase experience with our comprehensive tools and features.</p>
          <button class="cta-button">Get Started</button>
        </div>
      </section>
    </main>

    <footer>
      <p>Part of the Bilo polyglot monorepo • Running on port 3007</p>
    </footer>
  </div>
</template>

<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

header {
  text-align: center;
  color: white;
  margin-bottom: 3rem;
}

h1 {
  font-size: 3rem;
  margin: 0;
  font-weight: 700;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.subtitle {
  font-size: 1.2rem;
  opacity: 0.9;
  margin-top: 0.5rem;
}

main {
  background: white;
  border-radius: 1rem;
  padding: 2rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}

section {
  margin-bottom: 3rem;
}

section:last-child {
  margin-bottom: 0;
}

.hero {
  text-align: center;
  padding: 2rem 0;
  border-bottom: 2px solid #f0f0f0;
}

.hero h2 {
  color: #333;
  font-size: 2rem;
  margin-bottom: 1rem;
}

.hero p {
  color: #666;
  font-size: 1.1rem;
  max-width: 600px;
  margin: 0 auto;
}

h3 {
  color: #333;
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
}

.loading {
  text-align: center;
  color: #666;
  padding: 2rem;
}

.service-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1rem;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1.5rem;
}

.cta {
  background: linear-gradient(135deg, #42d392 0%, #647eff 100%);
  border-radius: 1rem;
  padding: 3rem 2rem;
  text-align: center;
  color: white;
}

.cta-content h3 {
  color: white;
  margin-bottom: 1rem;
}

.cta-content p {
  font-size: 1.1rem;
  margin-bottom: 2rem;
  opacity: 0.95;
}

.cta-button {
  background: white;
  color: #647eff;
  border: none;
  padding: 1rem 2.5rem;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
}

.cta-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

footer {
  text-align: center;
  color: white;
  margin-top: 2rem;
  opacity: 0.9;
}

footer p {
  margin: 0;
}
</style>

