# Monorepo Setup Guide

## Understanding the pnpm Workspace

This repository uses **pnpm workspaces** to manage multiple packages in a monorepo structure.

## Important: Installation Process

### ❌ WRONG: Installing in subdirectories
```bash
# This will NOT work correctly
cd services/ts/auth-service
pnpm install  # ❌ Won't create node_modules
```

### ✅ CORRECT: Installing from root
```bash
# Always install from the root directory
cd /path/to/bilo-repo
pnpm install  # ✅ Installs all workspace dependencies
```

## Why This Matters

In a pnpm workspace:
- **All dependencies** are managed at the root level
- **Shared dependencies** are hoisted to the root `node_modules`
- **Service-specific dependencies** are symlinked from root
- Running `pnpm install` in a subdirectory just checks the workspace and exits

## Workspace Configuration

The workspace is defined in `pnpm-workspace.yaml`:

```yaml
packages:
  - "apps/*"           # API Gateway
  - "services/ts/*"    # TypeScript services
  - "packages/*"       # Shared packages
```

## First-Time Setup

### 1. Install Dependencies

From the **root directory**:

```bash
pnpm install
```

This will:
- ✅ Install all dependencies for all packages
- ✅ Create `node_modules` in each service
- ✅ Link shared dependencies
- ✅ Set up workspace symlinks

### 2. Verify Installation

Check that node_modules exist:

```bash
ls -la services/ts/auth-service/node_modules
ls -la services/ts/sessions-service/node_modules
ls -la apps/api-gateway/node_modules
```

You should see directories, not empty output.

## Running Services

### Option 1: Using the Startup Script

```bash
./start-services.sh all
```

The script will:
- Check prerequisites
- Verify dependencies are installed
- Start all services

### Option 2: Manual Start

```bash
# From root, use workspace filters
pnpm --filter auth-service dev
pnpm --filter api-gateway dev

# Or navigate to service and run
cd services/ts/auth-service
pnpm dev
```

## Adding New Dependencies

### To a specific service:

```bash
# From root directory
pnpm --filter auth-service add passport

# Or from the service directory
cd services/ts/auth-service
pnpm add passport
```

### To all services:

```bash
# From root
pnpm -r add some-package
```

## Common Issues & Solutions

### Issue: "node_modules not found"

**Solution:**
```bash
cd /path/to/bilo-repo
pnpm install
```

### Issue: "Scope: all X workspace projects" but nothing happens

**Explanation:** This is normal! It means the workspace is already up to date.

**Verify by checking:**
```bash
ls services/ts/auth-service/node_modules
```

### Issue: Dependencies out of sync

**Solution:**
```bash
# Clean and reinstall
rm -rf node_modules
rm -rf services/ts/*/node_modules
rm -rf apps/*/node_modules
pnpm install
```

### Issue: "Cannot find module" errors when running services

**Solution:**
```bash
# Rebuild TypeScript services
cd services/ts/auth-service
pnpm build

# Or rebuild all from root
pnpm -r build
```

## Workspace Commands

### Install dependencies
```bash
pnpm install              # Install all workspace packages
```

### Run scripts
```bash
pnpm -r dev              # Run 'dev' in all packages
pnpm --filter "auth-*" dev  # Run in packages matching pattern
```

### Add dependencies
```bash
pnpm -r add lodash       # Add to all packages
pnpm --filter api-gateway add axios  # Add to specific package
```

### Update dependencies
```bash
pnpm -r update           # Update all packages
pnpm --filter auth-service update  # Update specific package
```

## Turborepo Integration

This workspace also uses Turborepo for:
- **Task orchestration**
- **Caching**
- **Parallel execution**

Run builds with Turbo:
```bash
turbo build              # Build all packages
turbo dev                # Run dev mode for all
```

## Directory Structure

```
bilo-repo/
├── pnpm-workspace.yaml     # Workspace configuration
├── package.json            # Root package.json
├── node_modules/           # Root dependencies
├── apps/
│   └── api-gateway/
│       ├── package.json    # Service dependencies
│       └── node_modules/   # Symlinks to root
└── services/
    └── ts/
        ├── auth-service/
        │   ├── package.json
        │   └── node_modules/  # Symlinks to root
        └── projects-service/
            ├── package.json
            └── node_modules/
```

## Best Practices

1. **Always run `pnpm install` from root** - Never from subdirectories
2. **Use workspace filters** - `pnpm --filter <package-name> <command>`
3. **Keep versions in sync** - Use same versions of shared deps
4. **Use workspace protocol** - `"dependency": "workspace:*"` for internal packages
5. **Clean installs** - When in doubt, remove all node_modules and reinstall

## Quick Reference

| Task | Command |
|------|---------|
| Install all | `pnpm install` |
| Install for service | `pnpm --filter auth-service install` |
| Add dependency | `pnpm --filter auth-service add <pkg>` |
| Run dev mode | `pnpm --filter auth-service dev` |
| Run all dev modes | `pnpm -r dev` |
| Build all | `turbo build` |
| Clean all | `rm -rf node_modules services/ts/*/node_modules apps/*/node_modules` |

## Summary

✅ **DO:**
- Run `pnpm install` from the root directory
- Use `pnpm --filter` for package-specific commands
- Keep the workspace configuration updated

❌ **DON'T:**
- Run `pnpm install` inside service directories
- Manually create node_modules folders
- Install dependencies outside the workspace

## More Information

- [pnpm Workspace Documentation](https://pnpm.io/workspaces)
- [Turborepo Documentation](https://turbo.build/repo/docs)

