# API Gateway

The central API Gateway for the microservices architecture. Built with NestJS.

## Overview

The API Gateway serves as the single entry point for all client requests, routing them to the appropriate microservices based on the request path.

## Features

- **Service Discovery**: Maintains a registry of all available services
- **Request Routing**: Routes requests to appropriate microservices
- **Service Composition**: Aggregates responses from multiple services
- **Validation**: Request/response validation using NestJS pipes
- **CORS**: Enabled for cross-origin requests

## Port

The gateway runs on **port 3000** (configurable via `PORT` environment variable).

## Installation

```bash
pnpm install
```

## Running the Gateway

### Development Mode
```bash
pnpm dev
```

### Production Mode
```bash
pnpm build
pnpm start:prod
```

## API Endpoints

### System Endpoints
- `GET /` - Welcome message
- `GET /health` - Health check
- `GET /services` - List all registered services

### Service Routes

#### Authentication (→ Auth Service :3001)
- `POST /auth/login` - User login
- `POST /auth/register` - User registration

#### Impact & Carbon (→ Impact Service :3003)
- `POST /impact/calculate` - Calculate environmental impact

#### Projects (→ Projects Service :3004)
- `GET /projects` - List all projects
- `POST /projects` - Create a new project

#### Equivalents (→ Equivalents Service :3005)
- `GET /equivalents/:type` - Get equivalents for a type

#### Transactions (→ Transactions Service :3100 - Go)
- `POST /transactions` - Create transaction
- `GET /transactions/:id` - Get transaction details

#### Funds (→ Funds Service :3101 - Go)
- `POST /funds/aggregate` - Aggregate funds

#### Payments (→ Payments Service :3102 - Go)
- `POST /payments` - Create payment
- `GET /payments/:id` - Get payment details

#### Portfolio (→ Portfolio Service :3200 - .NET)
- `GET /portfolios/:id` - Get portfolio
- `GET /portfolios/:id/report` - Get portfolio report

#### Analytics (→ Reporting Service :3201 - .NET)
- `GET /analytics/reports` - Get analytics reports

#### Messaging (→ Messaging Service :3009)
- `POST /messages` - Send a message

## Service Registry

The gateway maintains a registry of all services with their configuration:

```typescript
{
  name: string;
  baseUrl: string;
  language: string;
  purpose: string;
}
```

## Environment Variables

```bash
PORT=3000
NODE_ENV=development
```

## Architecture

The gateway uses NestJS's decorator-based routing system to define API endpoints. Each endpoint proxies requests to the appropriate backend service.

### Service Discovery

Services are registered in `app.service.ts` with their base URLs and metadata.

### Future Enhancements

- [ ] Implement actual HTTP proxy using axios or @nestjs/http
- [ ] Add authentication middleware
- [ ] Implement request/response caching
- [ ] Add rate limiting
- [ ] Implement circuit breaker pattern
- [ ] Add request logging and monitoring
- [ ] Implement GraphQL support
- [ ] Add WebSocket support for real-time features

## Testing

```bash
# Unit tests
pnpm test

# E2E tests
pnpm test:e2e

# Test coverage
pnpm test:cov
```

## Related Documentation

- [ARCHITECTURE.md](../../ARCHITECTURE.md) - Overall architecture
- [SERVICES.md](../../SERVICES.md) - Service overview
