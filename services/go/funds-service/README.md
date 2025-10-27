# Funds Service

Internal aggregations and reconciliation flows service built with Go.

## Features

- Internal fund aggregations
- Reconciliation flows
- Concurrent ledger operations
- Safe concurrent processing with goroutines and channels

## Tech Stack

- **Language**: Go 1.21+
- **Framework**: Fiber
- **Purpose**: Internal aggregations, reconciliation flows

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

The service will start on port 3101 (or PORT environment variable).

### API Endpoints

- `GET /health` - Health check
- `POST /funds/aggregate` - Aggregate funds
- `POST /funds/reconcile` - Reconcile funds
- `GET /funds/:id` - Get fund details

## Why Go?

Go's goroutines and channels handle concurrent ledger operations efficiently and safely, making it perfect for internal fund aggregations and reconciliation flows.

