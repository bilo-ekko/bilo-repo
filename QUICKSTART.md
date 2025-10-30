# Quick Start Guide

Get up and running with the microservices architecture in minutes.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** 18+ ([Download](https://nodejs.org/))
- **pnpm** (`npm install -g pnpm`)
- **Go** 1.21+ ([Download](https://golang.org/dl/))
- **.NET SDK** 8.0+ ([Download](https://dotnet.microsoft.com/download))
- **Docker** (optional, for containerized deployment)

## Installation (REQUIRED FIRST STEP)

### Install All Dependencies

**⚠️ IMPORTANT:** This is a pnpm workspace/monorepo. You **MUST** install from the root directory:

```bash
# From the root of bilo-repo
pnpm install
```

This will install dependencies for **all services** at once. 

**❌ DO NOT** run `pnpm install` inside individual service directories - it won't work!

See [MONOREPO_SETUP.md](./MONOREPO_SETUP.md) for detailed explanation.

## Quick Start Options

### Option 1: Use the Startup Script (Recommended)

Start all services at once:

```bash
./start-services.sh all
```

Or start specific categories:

```bash
./start-services.sh typescript  # Only TypeScript services
./start-services.sh go         # Only Go services
./start-services.sh dotnet     # Only .NET services
./start-services.sh gateway    # Only the API Gateway
```

Check prerequisites:

```bash
./start-services.sh check
```

### Option 2: Docker Compose

```bash
docker-compose up
```

This will build and start all services in containers.

### Option 3: Manual Start

**Prerequisites:** Make sure you've run `pnpm install` from the root first!

#### 1. Start the API Gateway

```bash
cd apps/api-gateway
pnpm dev
```

The gateway will be available at `http://localhost:3000`

#### 2. Start TypeScript Services

Open new terminal tabs for each:

```bash
# Auth Service (Port 3001)
cd services/ts/auth-service
pnpm dev

# Webhook Service (Port 3002)
cd services/ts/webhook-service
pnpm dev

# Sessions Service (Port 3003)
cd services/ts/sessions-service
pnpm dev

# Projects Service (Port 3004)
cd services/ts/projects-service
pnpm dev

# Equivalents Service (Port 3005)
cd services/ts/equivalents-service
pnpm dev

# Messaging Service (Port 3009)
cd services/ts/messaging-service
pnpm dev
```

#### 3. Start Go Services

```bash
# Transactions Service (Port 3100)
cd services/go/transactions-service
go run main.go

# Funds Service (Port 3101)
cd services/go/funds-service
go run main.go

# Payments Service (Port 3102)
cd services/go/payments-service
go run main.go
```

#### 4. Start .NET Services

```bash
# Portfolio Service (Port 3200)
cd services/cs/portfolio-service
dotnet run

# Reporting Service (Port 3201)
cd services/cs/reporting-service
dotnet run
```

## Verify Installation

Once all services are running, verify they're working:

### Check the Gateway

```bash
curl http://localhost:3000/health
```

### View All Services

```bash
curl http://localhost:3000/services
```

Or open in your browser: [http://localhost:3000/services](http://localhost:3000/services)

### Test Individual Services

```bash
# Auth Service
curl http://localhost:3001/health

# Transactions Service (Go)
curl http://localhost:3100/health

# Portfolio Service (.NET)
curl http://localhost:3200/health
```

## Testing the API

### Through the Gateway

All requests should go through the API Gateway at port 3000:

```bash
# Health check
curl http://localhost:3000/health

# Create a project
curl -X POST http://localhost:3000/projects \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Project"}'

# Get equivalents
curl http://localhost:3000/equivalents/carbon

# Create a transaction
curl -X POST http://localhost:3000/transactions \
  -H "Content-Type: application/json" \
  -d '{"amount": 100, "type": "credit"}'
```

## Development Workflow

### File Structure

```
bilo-repo/
├── apps/
│   └── api-gateway/          # API Gateway (Port 3000)
├── services/
│   ├── ts/                   # TypeScript/NestJS Services
│   │   ├── auth-service/     # Port 3001
│   │   ├── webhook-service/        # Port 3002
│   │   ├── sessions-service/  # Port 3003
│   │   ├── projects-service/ # Port 3004
│   │   ├── equivalents-service/  # Port 3005
│   │   └── messaging-service/    # Port 3009
│   ├── go/                   # Go Services
│   │   ├── transactions-service/  # Port 3100
│   │   ├── funds-service/    # Port 3101
│   │   └── payments-service/ # Port 3102
│   └── dotnet/              # .NET Core Services
│       ├── portfolio-service/    # Port 3200
│       └── reporting-service/    # Port 3201
├── ARCHITECTURE.md          # Detailed architecture docs
├── SERVICES.md             # Service overview
├── docker-compose.yml      # Docker orchestration
└── start-services.sh       # Startup script
```

### Making Changes

1. **TypeScript Services**: Edit files in `services/ts/[service-name]/src/`
2. **Go Services**: Edit `services/go/[service-name]/main.go`
3. **.NET Services**: Edit `services/cs/[service-name]/Program.cs`
4. **API Gateway**: Edit `apps/api-gateway/src/`

Changes are automatically picked up in development mode.

### Adding New Endpoints

#### In API Gateway (`apps/api-gateway/src/app.controller.ts`):

```typescript
@Get('/new-endpoint')
getNewEndpoint() {
  return this.appService.proxyToService('service-name', 'endpoint-path');
}
```

## Troubleshooting

### Port Already in Use

If you get "port already in use" errors:

```bash
# Find the process using the port (e.g., 3000)
lsof -ti:3000

# Kill the process
kill -9 $(lsof -ti:3000)
```

### Module Not Found Errors

```bash
# TypeScript services
cd services/ts/[service-name]
rm -rf node_modules
pnpm install

# Go services
cd services/go/[service-name]
go mod download

# .NET services
cd services/cs/[service-name]
dotnet restore
```

### Services Not Responding

Check if services are running:

```bash
# List all running node processes
ps aux | grep node

# List all running go processes
ps aux | grep go

# List all running dotnet processes
ps aux | grep dotnet
```

## Next Steps

- Read [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architecture information
- Read [SERVICES.md](./SERVICES.md) for service-specific documentation
- Check individual service READMEs in their directories
- Set up environment variables (copy `.env.example` to `.env`)
- Configure database connections
- Set up authentication keys
- Deploy to production

## Support

For issues or questions:
1. Check the service-specific README files
2. Review the architecture documentation
3. Check Docker logs: `docker-compose logs [service-name]`

