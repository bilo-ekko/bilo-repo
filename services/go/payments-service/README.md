# Payments Service

PSP integration service built with Go for low-latency payment processing.

## Features

- Payment Service Provider (PSP) integrations (Stripe, Adyen)
- Low-latency parallel calls
- Batch payment processing
- Concurrent PSP operations with fan-out/fan-in pattern

## Tech Stack

- **Language**: Go 1.21+
- **Framework**: Fiber
- **Purpose**: PSP integrations, low-latency parallel calls

## Getting Started

### Prerequisites

- Go 1.21 or higher

### Installation

```bash
go mod download
```

### Environment Variables

```bash
STRIPE_API_KEY=your_stripe_key
ADYEN_API_KEY=your_adyen_key
PORT=3102
```

### Running the Service

```bash
go run main.go
```

The service will start on port 3102 (or PORT environment variable).

### API Endpoints

- `GET /health` - Health check
- `POST /payments` - Create a new payment
- `GET /payments/:id` - Get payment details
- `POST /payments/:id/refund` - Refund a payment
- `POST /payments/batch` - Process batch payments

## Why Go?

Go is ideal for network I/O fan-out/fan-in patterns, providing reliability, simple deployment, and excellent performance for parallel PSP integrations with low latency.


