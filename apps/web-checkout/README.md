# Web Checkout

A modern checkout application built with SvelteKit in the Bilo polyglot monorepo.

## Stack

- **Framework**: SvelteKit
- **Language**: TypeScript
- **Build Tool**: Vite
- **Port**: 3006

## Features

- 🎯 Modern checkout experience
- ⚡ Lightning-fast with Svelte
- 🔧 Full TypeScript support
- 🎨 Responsive design
- 📡 Service health monitoring
- 🚀 Integrated with Turborepo

## Development

```bash
# From app directory
pnpm dev

# From repo root
pnpm dev --filter=@repo/web-checkout
```

The app will be available at `http://localhost:3006`

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
pnpm check
```

## Structure

```
src/
├── routes/
│   ├── +page.svelte       # Home page
│   └── +layout.svelte     # Root layout
├── app.d.ts               # Type definitions
└── app.html               # HTML template
```

## Integration with Monorepo

This app is part of the Bilo monorepo and:
- Uses shared ESLint and TypeScript configs from `packages/ts/`
- Managed by Turborepo for builds and caching
- Runs alongside other apps and services

## Learn More

- [SvelteKit Documentation](https://svelte.dev/docs/kit)
- [Svelte Documentation](https://svelte.dev/docs/svelte/overview)
- [Vite Documentation](https://vite.dev/)

