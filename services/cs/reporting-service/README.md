# Reporting Service (Optional)

Heavy reporting, aggregates, and data pipelines service built with C# and .NET Core.

## Features

- Heavy reporting and aggregations
- Data pipeline processing
- BI/export functionality
- Compute-intensive operations with strong typing

## Tech Stack

- **Language**: C# (.NET 8.0)
- **Framework**: ASP.NET Core
- **ORM**: Entity Framework Core
- **Purpose**: Heavy reporting, aggregates, data pipelines

## Getting Started

### Prerequisites

- .NET 8.0 SDK or higher

### Installation

```bash
dotnet restore
```

### Running the Service

```bash
dotnet run
```

The service will start on port 3201 (or PORT environment variable).

### API Endpoints

- `GET /health` - Health check
- `GET /analytics/reports` - Get analytics reports
- `POST /analytics/aggregate` - Perform data aggregation
- `POST /analytics/pipeline` - Execute data pipeline
- `GET /analytics/export` - Export data for BI

## Why .NET Core?

.NET performs well for compute-intensive operations with strong typing. The excellent tooling and LINQ capabilities make it ideal for BI, data pipelines, and complex reporting scenarios.

