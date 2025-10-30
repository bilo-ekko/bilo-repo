# Web Post-Purchase

A modern post-purchase experience portal built with Vue.js in the Bilo polyglot monorepo.

## Stack

- **Framework**: Vue 3 (Composition API)
- **Language**: TypeScript
- **Build Tool**: Vite
- **Port**: 3007

## Features

- 🎉 Modern post-purchase experience
- 📦 Order tracking and management
- 💳 Invoice access
- 🔔 Smart notifications
- 🎁 Rewards program
- 📡 Real-time service health monitoring
- ⚡ Lightning-fast with Vue 3 + Vite
- 🔧 Full TypeScript support
- 🎨 Responsive design
- 🚀 Integrated with Turborepo

## Development

```bash
# From app directory
pnpm dev

# From repo root
pnpm dev --filter=web-postpurchase
```

The app will be available at `http://localhost:3007`

## Building

```bash
pnpm build
```

## Preview Production Build

```bash
pnpm preview
```

## Type Checking

```bash
pnpm build  # Includes type checking via vue-tsc
```

## Structure

```
src/
├── components/
│   ├── ServiceCard.vue    # Service health card
│   └── FeatureCard.vue    # Feature display card
├── App.vue                # Main app component
├── main.ts                # App entry point
├── style.css              # Global styles
└── vite-env.d.ts          # Vite type definitions
```

## Integration with Monorepo

This app is part of the Bilo monorepo and:
- Uses shared ESLint and TypeScript configs from `packages/ts/`
- Managed by Turborepo for builds and caching
- Runs alongside other apps and services
- Port 3007 (configurable)

## Component Architecture

Built with Vue 3's **Composition API** using `<script setup>`:
- Reactive state management with `ref`
- Lifecycle hooks with `onMounted`
- TypeScript interfaces for type safety
- Reusable components with props

## Learn More

- [Vue 3 Documentation](https://vuejs.org/guide/introduction.html)
- [Vite Documentation](https://vite.dev/)
- [TypeScript with Vue](https://vuejs.org/guide/typescript/overview.html)

