# Bilo Repo - Polyglot Monorepo

A production-ready polyglot monorepo managed by Turborepo, featuring services across **TypeScript**, **C#**, **Go**, **Python**, and **Rust**.

<div style="display: flex; flex-direction: row; gap: 12px;">
    <a href="https://www.typescriptlang.org/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/typescript/typescript-original.svg"
            alt="typescript"
            width="40"
            height="40"
        />
    </a>
    <a href="https://www.w3schools.com/cs/" target="_blank">
    <img
        src="https://raw.githubusercontent.com/devicons/devicon/master/icons/csharp/csharp-original.svg"
        alt="csharp"
        width="40"
        height="40"
    />
    </a>
    <a href="https://www.python.org" target="_blank">
    <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/python/python-original.svg"
            alt="python"
            width="40"
            height="40"
    />
  </a>
    <a href="https://www.rust-lang.org/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/rust/rust-original.svg"
            alt="rust"
            width="40"
            height="40"
        />
    
</div>

Libraries and frameworks:

<div style="display: flex; flex-direction: row; gap: 12px">
    <a href="https://nestjs.com/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nestjs/nestjs-original.svg"
            alt="nestjs"
            width="40"
            height="40"
        />
    </a>
    <a href="https://dotnet.microsoft.com/" target="_blank">
        <img
        src="https://raw.githubusercontent.com/devicons/devicon/master/icons/dot-net/dot-net-original-wordmark.svg"
        alt="dotnet"
        width="40"
        height="40"
        />
    </a>
    <a href="https://go.dev/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/go/go-original.svg"
            alt="go"
            width="40"
            height="40"
        />
    </a>
    <a href="https://gofiber.io/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/fiber/fiber-original.svg"
            alt="fiber"
            width="40"
            height="40"
        />
    </a>
    <a href="https://fastapi.tiangolo.com/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/fastapi/fastapi-original.svg"
            alt="fastapi"
            width="40"
            height="40"
        />
    </a>
    <a href="https://actix.rs/" target="_blank">
        <img
            src="https://actix.rs/img/logo.png"
            alt="actix-web"
            width="40"
            height="40"
        />
    </a>
    
</div>

Frontend:

<div style="display: flex; flex-direction: row; gap: 12px">
    <a href="https://reactjs.org/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/react/react-original-wordmark.svg"
            alt="react"
            width="40"
            height="40"
        />
    </a>
    <a href="https://nextjs.org/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/nextjs/nextjs-original-wordmark.svg"
            alt="nextjs"
            width="40"
            height="40"
            style="background:white; border-radius:6px"
        />
    </a>
    <a href="https://svelte.dev/" target="_blank">
        <img
            src="https://raw.githubusercontent.com/devicons/devicon/master/icons/svelte/svelte-original.svg"
            alt="svelte"
            width="40"
            height="40"
        />
    </a>
</div>
## Overview

This repository demonstrates a modern monorepo pattern where multiple technology stacks coexist, each using their native tooling while benefiting from unified orchestration via Turborepo. The monorepo includes web applications, shared packages, and microservices across five different programming languages.

### Turborepo Benefits

Turborepo provides:
- **Unified build orchestration** across all stacks
- **Intelligent caching** of build outputs
- **Parallel execution** of tasks
- **Dependency-aware task scheduling**

## Repository Structure

```
bilo-repo/
├── apps/           # Frontend applications
├── packages/       # Shared code organized by stack
└── services/       # Backend services organized by stack
```

### Apps (`/apps`)

Frontend applications built with modern frameworks:
- **Next.js applications** for documentation and web interfaces
- Shared UI components and configurations

### Packages (`/packages`)

Reusable code organized by technology stack:

```
packages/
├── ts/             # TypeScript packages
│   ├── eslint-config
│   ├── typescript-config
│   └── shared-utils
├── cs/             # C# packages
│   └── SharedUtils
├── go/             # Go packages
│   └── shared-utils
├── py/             # Python packages
│   └── shared-utils
└── rust/           # Rust packages
    └── shared-utils
```

Each stack's shared packages use native dependency management (pnpm workspaces, go modules, cargo, etc.) while Turborepo handles cross-stack orchestration.

### Services (`/services`)

Backend microservices organized by technology stack:

```
services/
├── ts/             # TypeScript/Node.js services (NestJS)
├── cs/             # C# services (.NET)
├── go/             # Go services (Fiber)
├── py/             # Python services (FastAPI)
└── rust/           # Rust services (Actix)
```

## Technology Stacks

### 🔷 TypeScript Stack
- **Framework**: NestJS, Next.js
- **Runtime**: Node.js
- **Package Manager**: pnpm
- **Build Tool**: tsc, Next.js compiler

### 🟦 C# Stack
- **Framework**: ASP.NET Core
- **Runtime**: .NET 9.0
- **Package Manager**: NuGet
- **Build Tool**: dotnet CLI

### 🔵 Go Stack
- **Framework**: Fiber
- **Runtime**: Go 1.21+
- **Package Manager**: Go modules
- **Build Tool**: go build

### 🟡 Python Stack
- **Framework**: FastAPI
- **Runtime**: Python 3.9+
- **Package Manager**: pip
- **Build Tool**: pip/setuptools

### 🟠 Rust Stack
- **Framework**: Actix-web
- **Runtime**: Rust 2021 edition
- **Package Manager**: Cargo
- **Build Tool**: cargo

## Getting Started

### Prerequisites

Install the required tools for the stacks you want to work with:

- **Node.js** (v20+) and **pnpm** - for TypeScript services and apps
- **.NET SDK** (9.0+) - for C# services
- **Go** (1.21+) - for Go services
- **Python** (3.9+) - for Python services
- **Rust** (latest stable) - for Rust services

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd bilo-repo

# Install Node.js dependencies (TypeScript stack + Turborepo)
pnpm install
```

## Running Services

### Start Everything

Run all services and apps from the repository root:

```bash
pnpm dev
```

This starts:
- All Next.js applications
- All TypeScript services
- All services in other stacks (via their `package.json` scripts)

### Start Individual Services

Each service/app has a `package.json` that wraps the native tooling. Navigate to any service and run:

```bash
cd apps/web           # or any app/service
pnpm dev
```

This works uniformly across all stacks, even though each stack uses different underlying commands.

## Stack-Specific Commands

<details>
<summary><strong>TypeScript Services</strong></summary>

### Development
```bash
cd services/ts/<service-name>
pnpm dev                    # Start with watch mode
```

### Build
```bash
pnpm build                  # Compile TypeScript
```

### Production
```bash
pnpm start                  # Run compiled code
```

### Testing
```bash
pnpm test                   # Run tests
pnpm test:e2e              # Run e2e tests
```

</details>

<details>
<summary><strong>C# Services</strong></summary>

### Development
```bash
cd services/cs/<service-name>
pnpm dev                    # Uses dotnet watch
# OR
dotnet run                  # Direct .NET command
```

### Build
```bash
pnpm build                  # Build project
# OR
dotnet build
```

### Production
```bash
dotnet run --configuration Release
```

### Testing
```bash
dotnet test
```

</details>

<details>
<summary><strong>Go Services</strong></summary>

### Development
```bash
cd services/go/<service-name>
pnpm dev                    # Uses go run with hot reload
# OR
go run main.go              # Direct Go command
```

### Build
```bash
pnpm build                  # Build binary
# OR
go build -o bin/<service-name>
```

### Production
```bash
./bin/<service-name>        # Run compiled binary
```

### Testing
```bash
go test ./...
```

### Dependencies
```bash
go mod tidy                 # Clean up dependencies
go mod download             # Download dependencies
```

</details>

<details>
<summary><strong>Python Services</strong></summary>

### Development
```bash
cd services/py/<service-name>
pnpm dev                    # Uses uvicorn with reload
# OR
python main.py              # Direct Python command
```

### Build (Install Dependencies)
```bash
pip install -r requirements.txt
```

### Production
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Testing
```bash
pytest
```

### Virtual Environment
```bash
python -m venv venv
source venv/bin/activate    # Linux/Mac
# or
venv\Scripts\activate       # Windows
```

</details>

<details>
<summary><strong>Rust Services</strong></summary>

### Development
```bash
cd services/rust/<service-name>
pnpm dev                    # Uses cargo watch
# OR
cargo run                   # Direct Rust command
```

### Build
```bash
pnpm build                  # Build release binary
# OR
cargo build --release
```

### Production
```bash
./target/release/<service-name>
```

### Testing
```bash
cargo test
```

### Dependencies
```bash
cargo update                # Update dependencies
```

</details>

## Building

### Build Everything
```bash
pnpm build
```

### Build Specific Stack
```bash
turbo build --filter="./services/ts/*"    # All TypeScript services
turbo build --filter="./services/go/*"    # All Go services
```

### Build Single Service
```bash
cd services/ts/auth-service
pnpm build
```

## Service Ports

By default, services run on the following ports:

| Port Range | Stack      | Example                 |
|------------|------------|-------------------------|
| 3000-3005  | TypeScript | auth-service (3001)     |
| 3009       | Rust       | messaging-service       |
| 3010       | Python     | calculator-service      |
| 3101-3103  | Go         | funds-service (3101)    |
| 3201-3202  | C#         | analytics-service (3201)|

Ports can be customized via environment variables (`PORT=3099`).

## Shared Packages

This monorepo uses stack-specific shared packages. Each technology stack has its own shared utilities that services can import using native dependency management.

For detailed information on using shared packages, see [SHARED_PACKAGES.md](./SHARED_PACKAGES.md).

## Documentation

- **[SHARED_PACKAGES.md](./SHARED_PACKAGES.md)** - Complete guide to shared packages pattern
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Architecture overview and design decisions
- **[packages/README.md](./packages/README.md)** - Packages directory structure

## Turborepo Features

### Caching

Turborepo automatically caches build outputs. Subsequent builds are near-instant when nothing has changed:

```bash
pnpm build    # First run: builds everything
pnpm build    # Second run: instant (uses cache)
```

### Filtering

Run tasks for specific packages or patterns:

```bash
# Run dev for a specific service
turbo dev --filter=auth-service

# Run build for all Go services
turbo build --filter="./services/go/*"

# Run test for all TypeScript packages
turbo test --filter="./packages/ts/*"
```

### Parallel Execution

Turborepo runs tasks in parallel while respecting dependencies:

```bash
turbo build    # Builds shared packages first, then services
```

## Environment Variables

Create `.env` files in service directories:

```bash
# services/ts/auth-service/.env
PORT=3001
DATABASE_URL=postgresql://localhost:5432/auth
```

## Contributing

1. Choose the stack you want to work with
2. Create a new service in `services/<stack>/` or package in `packages/<stack>/`
3. Add `package.json` with appropriate scripts for Turborepo integration
4. Follow stack-specific conventions and best practices

## Troubleshooting

### TypeScript: Module not found
```bash
pnpm install
```

### C#: Project reference not found
```bash
dotnet restore
```

### Go: Package not found
```bash
go mod tidy
```

### Python: Import error
```bash
pip install -r requirements.txt
```

### Rust: Dependency error
```bash
cargo update
```

## Learn More

- [Turborepo Documentation](https://turbo.build/repo/docs)
- [Shared Packages Guide](./SHARED_PACKAGES.md)
- [Architecture Overview](./ARCHITECTURE.md)

---

**Stack Coverage**: TypeScript • C# • Go • Python • Rust  
**Orchestration**: Turborepo  
**Package Management**: pnpm, NuGet, Go modules, pip, Cargo
