<script lang="ts">
	import { onMount } from 'svelte';

	let serviceStatus: Record<string, any> = {};
	let loading = true;

	const services = [
		{ name: 'Auth Service', port: 3001, stack: 'TypeScript' },
		{ name: 'Reporting Service', port: 3201, stack: 'C#' },
		{ name: 'Funds Service', port: 3101, stack: 'Go' },
		{ name: 'Calculator Service', port: 3010, stack: 'Python' },
		{ name: 'Messaging Service', port: 3009, stack: 'Rust' }
	];

	onMount(async () => {
		const status: Record<string, any> = {};
		
		for (const service of services) {
			try {
				const response = await fetch(`http://localhost:${service.port}/health`);
				if (response.ok) {
					status[service.name] = { healthy: true, ...(await response.json()) };
				} else {
					status[service.name] = { healthy: false };
				}
			} catch (error) {
				status[service.name] = { healthy: false, error: String(error) };
			}
		}
		
		serviceStatus = status;
		loading = false;
	});
</script>

<svelte:head>
	<title>Checkout - Bilo Monorepo</title>
</svelte:head>

<div class="container">
	<header>
		<h1>🛒 Web Checkout</h1>
		<p class="subtitle">Svelte • SvelteKit • TypeScript</p>
	</header>

	<main>
		<section class="hero">
			<h2>Welcome to the Checkout App</h2>
			<p>A modern checkout experience built with SvelteKit in the Bilo polyglot monorepo.</p>
		</section>

		<section class="services">
			<h3>📡 Service Status</h3>
			{#if loading}
				<p class="loading">Checking services...</p>
			{:else}
				<div class="service-grid">
					{#each services as service}
						{@const status = serviceStatus[service.name]}
						<div class="service-card" class:healthy={status?.healthy} class:unhealthy={!status?.healthy}>
							<div class="service-header">
								<h4>{service.name}</h4>
								<span class="badge">{service.stack}</span>
							</div>
							<div class="service-body">
								<div class="status-indicator">
									{status?.healthy ? '✅' : '❌'}
									<span>{status?.healthy ? 'Healthy' : 'Offline'}</span>
								</div>
								<p class="port">Port: {service.port}</p>
							</div>
						</div>
					{/each}
				</div>
			{/if}
		</section>

		<section class="features">
			<h3>✨ Features</h3>
			<div class="feature-grid">
				<div class="feature">
					<span class="icon">⚡</span>
					<h4>Lightning Fast</h4>
					<p>Built with Svelte for optimal performance</p>
				</div>
				<div class="feature">
					<span class="icon">🔧</span>
					<h4>Type Safe</h4>
					<p>Full TypeScript support throughout</p>
				</div>
				<div class="feature">
					<span class="icon">🎨</span>
					<h4>Modern UI</h4>
					<p>Clean, responsive design</p>
				</div>
				<div class="feature">
					<span class="icon">🚀</span>
					<h4>Monorepo Ready</h4>
					<p>Integrated with Turborepo</p>
				</div>
			</div>
		</section>
	</main>

	<footer>
		<p>Part of the Bilo polyglot monorepo • Running on port 3006</p>
	</footer>
</div>

<style>
	:global(body) {
		margin: 0;
		padding: 0;
		font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
		min-height: 100vh;
	}

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
		background: #667eea;
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

	.feature-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
		gap: 1.5rem;
	}

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

