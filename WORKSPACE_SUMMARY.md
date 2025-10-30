# Workspace Summary

## pnpm Workspace Configuration

The monorepo includes **13 TypeScript/Node.js packages** managed by pnpm workspaces:

### Apps (3)
- ✅ `api-gateway` - API Gateway (Port 3000)
- ✅ `docs` - Documentation site (Next.js)
- ✅ `web` - Web application (Next.js)

### TypeScript Services (6)
- ✅ `auth-service` - Port 3001
- ✅ `webhook-service` - Port 3002
- ✅ `equivalents-service` - Port 3005
- ✅ `sessions-service` - Port 3003
- ✅ `messaging-service` - Port 3009
- ✅ `projects-service` - Port 3004

### Shared Packages (4)
- ✅ `eslint-config` - Shared ESLint configuration
- ✅ `typescript-config` - Shared TypeScript configuration
- ✅ `ui` - Shared UI components
- ✅ `web-components` - Web components library

## Go Services (Not in pnpm workspace)

These are standalone Go services with their own `go.mod`:

- 🔵 `transactions-service` - Port 3100
- 🔵 `funds-service` - Port 3101
- 🔵 `payments-service` - Port 3102

**Install:** `go mod download` in each service directory

## .NET Services (Not in pnpm workspace)

These are standalone .NET services with their own `.csproj`:

- 🟣 `portfolio-service` - Port 3200
- 🟣 `reporting-service` - Port 3201

**Install:** `dotnet restore` in each service directory

## Turborepo Configuration

The `turbo.json` file orchestrates tasks across all **13 pnpm workspace packages**.

### Supported Tasks

```json
{
  "build": "Build all packages (outputs to dist/)",
  "test": "Run tests with coverage",
  "test:e2e": "Run end-to-end tests",
  "lint": "Lint all packages",
  "check-types": "TypeScript type checking",
  "dev": "Development mode (persistent)",
  "start": "Production start",
  "start:prod": "Production mode",
  "docker:build": "Build Docker images"
}
```

### Running Turbo Commands

```bash
# Build all packages
turbo build

# Run dev mode for all packages
turbo dev

# Run specific task for specific package
turbo build --filter=api-gateway

# Run task for all services
turbo build --filter="services/ts/*"

# Parallel execution
turbo test --parallel
```

## Workspace Commands Reference

### Installation
```bash
pnpm install              # Install all workspace packages
```

### Development
```bash
pnpm -r dev              # Dev mode in all packages
pnpm --filter api-gateway dev  # Dev mode in specific package
turbo dev                # Turbo orchestrated dev mode
```

### Building
```bash
turbo build              # Build all packages
turbo build --filter="services/ts/*"  # Build all services
pnpm -r build            # Alternative: build all
```

### Testing
```bash
turbo test               # Test all packages
turbo test:e2e           # E2E tests
pnpm --filter auth-service test  # Test specific package
```

### Linting
```bash
turbo lint               # Lint all packages
pnpm -r lint             # Alternative
```

## Package Dependencies

### Workspace Dependencies
When a package depends on another workspace package, use the `workspace:` protocol:

```json
{
  "dependencies": {
    "@repo/ui": "workspace:*",
    "@repo/typescript-config": "workspace:*"
  }
}
```

### External Dependencies
Add to specific packages:

```bash
pnpm --filter api-gateway add axios
pnpm --filter auth-service add passport
```

Add to all packages:

```bash
pnpm -r add lodash
```

## File Structure

```
bilo-repo/
├── pnpm-workspace.yaml    # Workspace configuration
├── turbo.json             # Turborepo configuration
├── package.json           # Root package.json
├── node_modules/          # Shared dependencies
│
├── apps/                  # Applications (3)
│   ├── api-gateway/       ✅ Port 3000
│   ├── docs/              ✅ Next.js docs
│   └── web/               ✅ Next.js web app
│
├── services/
│   ├── ts/               # TypeScript services (6)
│   │   ├── auth-service/           ✅ Port 3001
│   │   ├── webhook-service/        ✅ Port 3002
│   │   ├── equivalents-service/    ✅ Port 3005
│   │   ├── sessions-service/  ✅ Port 3003
│   │   ├── messaging-service/      ✅ Port 3009
│   │   └── projects-service/       ✅ Port 3004
│   │
│   ├── go/               # Go services (3)
│   │   ├── transactions-service/   🔵 Port 3100
│   │   ├── funds-service/          🔵 Port 3101
│   │   └── payments-service/       🔵 Port 3102
│   │
│   └── dotnet/           # .NET services (2)
│       ├── portfolio-service/      🟣 Port 3200
│       └── reporting-service/      🟣 Port 3201
│
└── packages/             # Shared packages (4)
    ├── eslint-config/    ✅ Shared ESLint
    ├── typescript-config/ ✅ Shared TS config
    ├── ui/               ✅ UI components
    └── web-components/   ✅ Web components
```

## Summary

- **Total Workspace Packages:** 13 (managed by pnpm + Turborepo)
  - 3 Apps
  - 6 TypeScript Services
  - 4 Shared Packages

- **External Services:** 5 (managed independently)
  - 3 Go Services
  - 2 .NET Services

- **Total Services:** 12 (1 Gateway + 11 Microservices)

## Quick Commands

```bash
# Install everything
pnpm install

# Start all TypeScript services
turbo dev

# Build everything
turbo build

# Test everything
turbo test

# Start all services (including Go & .NET)
./start-services.sh all
```

