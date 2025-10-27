# Transactions Service

High-volume financial events service built with Go and Fiber.

## Features

- High-volume transaction processing
- Idempotency support
- Transaction reversals
- Low latency and small footprint
- Predictable performance under load

## Tech Stack

- **Language**: Go 1.21+
- **Framework**: Fiber
- **Purpose**: Financial transactions, idempotency, reversals

## Getting Started

### Prerequisites

- Go 1.21 or higher

### Installation

```bash
go mod download
```

### Running the Service

```bash
go run main.go
```

The service will start on port 3100 (or PORT environment variable).

### API Endpoints

- `GET /health` - Health check
- `POST /transactions` - Create a new transaction
- `GET /transactions/:id` - Get transaction details
- `POST /transactions/:id/reverse` - Reverse a transaction

## Why Go?

Go's concurrency model with goroutines, low latency, and small footprint make it ideal for high-volume financial transaction processing with predictable performance under load.

