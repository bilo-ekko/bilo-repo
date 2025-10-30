# Microservices Overview

## Quick Start

### Start the API Gateway and All Services

The API Gateway runs on **Port 3000** and provides a unified interface to all microservices.

```bash
# View all available services
curl http://localhost:3000/services
```

### Port Allocation

| Service                        | Port | Language       |
|--------------------------------|------|----------------|
| **API Gateway**                | 3000 | TypeScript     |
| Auth Service                   | 3001 | TypeScript     |
| Webhook Service                | 3002 | TypeScript     |
| Impact Calculation Service     | 3003 | TypeScript     |
| Projects Service               | 3004 | TypeScript     |
| Equivalents Service            | 3005 | TypeScript     |
| Messaging Service              | 3009 | TypeScript     |
| Transactions Service           | 3100 | Go             |
| Funds Service                  | 3101 | Go             |
| Payments Service               | 3102 | Go             |
| Portfolio Service              | 3200 | C# (.NET Core) |
| Reporting Service              | 3201 | C# (.NET Core) |

## Service Categories

### TypeScript/NestJS Services (Ports 3001-3009)

Perfect for business logic, rapid development, and type sharing across the application.

#### Auth Service (3001)
- Authentication & Authorization
- JWT/OAuth2 tokens
- API keys management
- User and organization models

#### Webhook Service (3002)
- Webhook handling
- Event processing
- External integrations

#### Impact Calculation Service (3003)
- Environmental factor transformations
- Scientific constants and conversions
- Impact modeling and calculations

#### Projects Service (3004)
- Project metadata management
- CMS-like CRUD operations
- Project lifecycle tracking

#### Equivalents Service (3005)
- Numeric conversions
- Unit transformations
- Logic-heavy lookups

#### Messaging Service (3009)
- Async message processing
- Kafka/RabbitMQ/SNS integration
- Pub/Sub patterns

### Go Services (Ports 3100-3102)

High-performance services for concurrent operations and low latency requirements.

#### Transactions Service (3100)
- High-volume financial transactions
- Idempotency support
- Transaction reversals
- Optimized for throughput

#### Funds Service (3101)
- Internal fund aggregations
- Reconciliation flows
- Concurrent ledger operations

#### Payments Service (3102)
- PSP integrations (Stripe, Adyen)
- Low-latency parallel calls
- Batch payment processing
- Fan-out/fan-in patterns

### .NET Core Services (Ports 3200-3201)

Data-intensive services requiring strong typing and LINQ capabilities.

#### Portfolio Service (3200)
- Portfolio aggregation
- Reporting with typed DTOs
- LINQ-based data shaping
- Entity Framework Core integration

#### Reporting Service (3201)
- Heavy reporting and aggregates
- Data pipeline processing
- BI/export functionality
- Compute-intensive operations

## API Gateway Routes

All requests go through the API Gateway at `http://localhost:3000`:

### Authentication
```bash
POST /auth/login
POST /auth/register
```

### Impact & Carbon
```bash
POST /impact/calculate
```

### Projects
```bash
GET /projects
POST /projects
```

### Equivalents
```bash
GET /equivalents/:type
```

### Transactions
```bash
POST /transactions
GET /transactions/:id
```

### Funds
```bash
POST /funds/aggregate
```

### Payments
```bash
POST /payments
GET /payments/:id
```

### Portfolio
```bash
GET /portfolios/:id
GET /portfolios/:id/report
```

### Analytics
```bash
GET /analytics/reports
```

### Messaging
```bash
POST /messages
```

### System
```bash
GET /health          # Gateway health check
GET /services        # List all services
```

## Development

### Running Individual Services

#### TypeScript Services
```bash
cd services/ts/<service-name>
pnpm install
pnpm dev
```

#### Go Services
```bash
cd services/go/<service-name>
go run main.go
```

#### .NET Services
```bash
cd services/cs/<service-name>
dotnet run
```

### Running All Services with Docker

```bash
docker-compose up
```

## Architecture Benefits

1. **Language-Specific Optimization**: Each service uses the best language for its domain
2. **Independent Scaling**: Scale services based on their specific load patterns
3. **Team Autonomy**: Different teams can work in their preferred languages
4. **Fault Isolation**: Failures are contained to individual services
5. **Technology Evolution**: Easy to upgrade or replace individual services

## Next Steps

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architecture documentation.

