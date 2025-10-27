# Service Map & Port Allocation

## Visual Architecture

```
                                ┌─────────────────────────┐
                                │                         │
                                │    API GATEWAY :3000    │
                                │   (TypeScript/NestJS)   │
                                │                         │
                                └────────────┬────────────┘
                                             │
                     ┌───────────────────────┼───────────────────────┐
                     │                       │                       │
         ┌───────────▼──────────┐ ┌─────────▼─────────┐  ┌─────────▼─────────┐
         │  TypeScript Services │ │    Go Services    │  │  .NET Services    │
         │      (NestJS)        │ │     (Fiber)       │  │   (ASP.NET Core)  │
         └───────────┬──────────┘ └─────────┬─────────┘  └─────────┬─────────┘
                     │                       │                       │
         ┌───────────┴──────────┐            │                       │
         │                      │            │                       │
    ┌────▼────┐           ┌────▼────┐  ┌────▼────┐            ┌────▼────┐
    │  Auth   │           │ Impact  │  │ Trans.  │            │Portfolio│
    │  :3001  │           │  :3003  │  │ :3100   │            │  :3200  │
    └─────────┘           └─────────┘  └─────────┘            └─────────┘
    
    ┌─────────┐           ┌─────────┐  ┌─────────┐            ┌─────────┐
    │ Carbon  │           │Projects │  │  Funds  │            │Analytics│
    │  :3002  │           │  :3004  │  │  :3101  │            │  :3201  │
    └─────────┘           └─────────┘  └─────────┘            └─────────┘
    
    ┌─────────┐           ┌─────────┐  ┌─────────┐
    │Messaging│           │Equiv.   │  │Payments │
    │  :3009  │           │  :3005  │  │  :3102  │
    └─────────┘           └─────────┘  └─────────┘
```

## Port Allocation by Range

### Gateway Layer (3000)
| Port | Service | Language |
|------|---------|----------|
| 3000 | API Gateway | TypeScript (NestJS) |

### TypeScript Services (3001-3009)
| Port | Service | Purpose |
|------|---------|---------|
| 3001 | Auth Service | Authentication & Authorization |
| 3002 | Calculation Service | Carbon tracking & calculations |
| 3003 | Impact Calculation Service | Environmental impact calculations |
| 3004 | Projects Service | Project metadata & CRUD |
| 3005 | Equivalents Service | Numeric conversions & lookups |
| 3009 | Messaging Service | Async processing & pub/sub |

### Go Services (3100-3102)
| Port | Service | Purpose |
|------|---------|---------|
| 3100 | Transactions Service | High-volume financial transactions |
| 3101 | Funds Service | Fund aggregations & reconciliation |
| 3102 | Payments Service | PSP integrations (Stripe/Adyen) |

### .NET Services (3200-3201)
| Port | Service | Purpose |
|------|---------|---------|
| 3200 | Portfolio Service | Portfolio aggregation & reporting |
| 3201 | Analytics Service | Heavy reporting & data pipelines |

## Service Communication Flow

```
Client Request
    │
    ▼
API Gateway :3000
    │
    ├─→ /auth/*          → Auth Service :3001
    ├─→ /impact/*        → Impact Service :3003
    ├─→ /projects/*      → Projects Service :3004
    ├─→ /equivalents/*   → Equivalents Service :3005
    ├─→ /transactions/*  → Transactions Service :3100 (Go)
    ├─→ /funds/*         → Funds Service :3101 (Go)
    ├─→ /payments/*      → Payments Service :3102 (Go)
    ├─→ /portfolios/*    → Portfolio Service :3200 (.NET)
    ├─→ /analytics/*     → Analytics Service :3201 (.NET)
    └─→ /messages/*      → Messaging Service :3009
```

## Technology Distribution

```
┌─────────────────────────────────────────────┐
│  TypeScript/NestJS (7 total)                │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 58.3%   │
│  • API Gateway                              │
│  • Auth, Carbon, Impact, Projects           │
│  • Equivalents, Messaging                   │
└─────────────────────────────────────────────┘

┌────────────────────────────┐
│  Go/Fiber (3 total)        │
│  ━━━━━━━━━━━━━━━━ 25%     │
│  • Transactions            │
│  • Funds, Payments         │
└────────────────────────────┘

┌────────────────────────────┐
│  C#/.NET Core (2 total)    │
│  ━━━━━━━━━━ 16.7%         │
│  • Portfolio               │
│  • Analytics               │
└────────────────────────────┘
```

## Service Characteristics

### High-Performance Services (Go)
- **Transactions :3100** - Handles high-volume concurrent operations
- **Funds :3101** - Concurrent ledger operations with goroutines
- **Payments :3102** - Low-latency PSP integrations

### Business Logic Services (TypeScript)
- **Auth :3001** - Rich auth ecosystem with guards/interceptors
- **Impact :3003** - Rapid iteration on calculation models
- **Projects :3004** - Quick CRUD with validation
- **Equivalents :3005** - Type-safe formula calculations
- **Messaging :3009** - Native broker support

### Data-Intensive Services (.NET)
- **Portfolio :3200** - LINQ-based data shaping
- **Analytics :3201** - Compute-intensive aggregations

## Health Check Endpoints

Every service provides a health check:

```bash
# Gateway
curl http://localhost:3000/health

# TypeScript Services
curl http://localhost:3001/health  # Auth
curl http://localhost:3002/health  # Carbon
curl http://localhost:3003/health  # Impact
curl http://localhost:3004/health  # Projects
curl http://localhost:3005/health  # Equivalents
curl http://localhost:3009/health  # Messaging

# Go Services
curl http://localhost:3100/health  # Transactions
curl http://localhost:3101/health  # Funds
curl http://localhost:3102/health  # Payments

# .NET Services
curl http://localhost:3200/health  # Portfolio
curl http://localhost:3201/health  # Analytics
```

## Development Ports Summary

| Range | Technology | Count | Services |
|-------|-----------|-------|----------|
| 3000 | Gateway | 1 | API Gateway |
| 3001-3009 | TypeScript | 6 | Auth, Carbon, Impact, Projects, Equivalents, Messaging |
| 3100-3102 | Go | 3 | Transactions, Funds, Payments |
| 3200-3201 | .NET Core | 2 | Portfolio, Analytics |

**Total Services: 12** (1 Gateway + 11 Microservices)

## Starting Services

### All at once:
```bash
./start-services.sh all
```

### By technology:
```bash
./start-services.sh typescript  # Ports 3001-3009
./start-services.sh go         # Ports 3100-3102
./start-services.sh dotnet     # Ports 3200-3201
```

### Using Docker:
```bash
docker-compose up
```

## Monitoring Dashboard URLs

Once all services are running:

- **Gateway Dashboard**: http://localhost:3000
- **Service List**: http://localhost:3000/services
- **Health Check**: http://localhost:3000/health

## Next Steps

1. ✅ Services created
2. ⏭️ Install dependencies
3. ⏭️ Configure environment variables
4. ⏭️ Start services
5. ⏭️ Test endpoints
6. ⏭️ Deploy to production

