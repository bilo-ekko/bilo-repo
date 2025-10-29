# Microservices Architecture

This document outlines the microservices architecture for the platform, organized by language/technology stack.

## Architecture Overview

The platform consists of a polyglot microservices architecture with:
- **1 API Gateway** (NestJS)
- **5 TypeScript Services** (NestJS)
- **1 Rust Service** (Actix-web)
- **3 Go Services** (Fiber)
- **2 .NET Services** (.NET Core)

## Service Directory Structure

```
services/
├── ts/                          # TypeScript/NestJS Services
│   ├── auth-service/           # Port 3001
│   ├── calculation-service/    # Port 3002
│   ├── sessions-service/       # Port 3003
│   ├── projects-service/       # Port 3004
│   └── equivalents-service/    # Port 3005
├── rust/                        # Rust Services
│   └── messaging-service/      # Port 3009
├── go/                          # Go Services
│   ├── transactions-service/   # Port 3100
│   ├── funds-service/          # Port 3101
│   └── payments-service/       # Port 3102
└── cs/                          # .NET Core Services
    ├── portfolio-service/      # Port 3200
    └── analytics-service/      # Port 3201
```

## Service Details

### Gateway API (Port 3000)
- **Language**: TypeScript (NestJS)
- **Purpose**: Single entry point for REST/GraphQL, routing, validation, composition
- **Why NestJS**: Shines at API composition, decorators, validation pipes, modular structure, and fast developer velocity

### TypeScript Services (NestJS)

#### Auth Service (Port 3001)
- **Purpose**: AuthN/Z, JWT/OAuth2, API keys, user/org models
- **Why NestJS**: Rich ecosystem for auth, guards/interceptors fit perfectly, easy integration with Passport/Keycloak/IdP

#### Calculation Service (Port 3002)
- **Purpose**: Carbon tracking and calculations
- **Why NestJS**: Existing service for carbon-related operations

#### Impact Calculation Service (Port 3003)
- **Purpose**: Data transforms, environmental factors, scientific constants
- **Why NestJS**: Strong type sharing with Gateway, rapid iteration on models, great DX for numeric/business logic

#### Projects Service (Port 3004)
- **Purpose**: Project metadata provider / CMS-like CRUD
- **Why NestJS**: Quick for CRUD + validation + DTOs; easy to share TS models across services

#### Equivalents Service (Port 3005)
- **Purpose**: Numeric conversions and logic-heavy lookups
- **Why NestJS**: Shared TS utilities, strong typing for formulas, fast to extend and test

#### Messaging Service (Port 3009)
- **Purpose**: Async processing, Kafka/Rabbit/SNS workers, pub/sub
- **Why NestJS**: Nest's microservices modules support brokers out of the box; easy message schema sharing in TS

### Go Services

#### Transactions Service (Port 3100)
- **Framework**: Fiber
- **Purpose**: High-volume financial events, idempotency, reversals
- **Why Go**: Go's concurrency + low latency + small footprint; simple, predictable performance under load

#### Funds Service (Port 3101)
- **Framework**: Fiber
- **Purpose**: Internal aggregations, reconciliation flows
- **Why Go**: Go's goroutines/channels handle concurrent ledger ops efficiently and safely

#### Payments Service (Port 3102)
- **Framework**: Fiber
- **Purpose**: PSP integrations (Stripe/Adyen), low-latency parallel calls
- **Why Go**: Ideal for network I/O fan-out/fan-in, reliability, and simple deployment

### .NET Core Services

#### Portfolio Service (Port 3200)
- **Purpose**: Portfolio aggregation, reporting, typed DTOs
- **Why .NET**: LINQ/EF Core are excellent for data shaping; robust type system for reporting

#### Analytics Service (Port 3201) - Optional
- **Purpose**: Heavy reporting, aggregates, data pipelines
- **Why .NET**: Performs well for compute + strong typing; good tooling for BI/export pipelines

## API Gateway Routes

The API Gateway (Port 3000) provides a unified interface to all microservices:

### Authentication Routes
- `POST /auth/login` → Auth Service
- `POST /auth/register` → Auth Service

### Impact & Carbon Routes
- `POST /impact/calculate` → Impact Calculation Service

### Projects Routes
- `GET /projects` → Projects Service
- `POST /projects` → Projects Service

### Equivalents Routes
- `GET /equivalents/:type` → Equivalents Service

### Financial Routes
- `POST /transactions` → Transactions Service (Go)
- `GET /transactions/:id` → Transactions Service (Go)
- `POST /funds/aggregate` → Funds Service (Go)
- `POST /payments` → Payments Service (Go)
- `GET /payments/:id` → Payments Service (Go)

### Portfolio Routes
- `GET /portfolios/:id` → Portfolio Service (.NET)
- `GET /portfolios/:id/report` → Portfolio Service (.NET)

### Analytics Routes
- `GET /analytics/reports` → Analytics Service (.NET)

### Messaging Routes
- `POST /messages` → Messaging Service

### System Routes
- `GET /health` → Health check
- `GET /services` → List all services and their configuration

## Technology Rationale

### Why Polyglot?
Each service uses the language best suited for its specific requirements:

1. **TypeScript/NestJS** - Business logic, rapid development, type sharing
2. **Go** - High-performance, concurrent operations, low latency
3. **C#/.NET** - Data aggregation, reporting, strong typing

### Benefits
- **Performance Optimization**: Each service uses the best tool for the job
- **Developer Experience**: Teams can use languages matching their domain
- **Scalability**: Services can be scaled independently based on needs
- **Resilience**: Failure in one language runtime doesn't affect others

## Running the Services

### Prerequisites
- Node.js 18+ (for TypeScript services)
- Go 1.21+ (for Go services)
- .NET 8.0 SDK (for .NET services)
- Docker & Docker Compose (optional, for containerized deployment)

### Development Mode

#### Start All TypeScript Services
```bash
# Gateway
cd apps/api-gateway && pnpm install && pnpm dev

# Services
cd services/ts/auth-service && pnpm install && pnpm dev
cd services/ts/sessions-service && pnpm install && pnpm dev
cd services/ts/projects-service && pnpm install && pnpm dev
cd services/ts/equivalents-service && pnpm install && pnpm dev

# Rust Services
cd services/rust/messaging-service && cargo run
```

#### Start All Go Services
```bash
cd services/go/transactions-service && go run main.go
cd services/go/funds-service && go run main.go
cd services/go/payments-service && go run main.go
```

#### Start All .NET Services
```bash
cd services/cs/portfolio-service && dotnet run
cd services/cs/analytics-service && dotnet run
```

### Using Docker Compose
```bash
docker-compose up
```

## Next Steps

1. Implement actual HTTP proxy logic in API Gateway
2. Add authentication middleware
3. Implement service discovery
4. Add monitoring and observability (Prometheus, Grafana)
5. Set up CI/CD pipelines for each service
6. Configure Kubernetes deployments
7. Add API documentation (Swagger/OpenAPI)

