# Portfolio Service

Portfolio aggregation and reporting service built with C# and .NET Core.

## Features

- Portfolio aggregation
- Advanced reporting with typed DTOs
- LINQ for data shaping
- Entity Framework Core for data access

## Tech Stack

- **Language**: C# (.NET 8.0)
- **Framework**: ASP.NET Core
- **ORM**: Entity Framework Core
- **Purpose**: Portfolio aggregation, reporting, typed DTOs

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

The service will start on port 3200 (or PORT environment variable).

### API Endpoints

- `GET /health` - Health check
- `GET /portfolios/{id}` - Get portfolio details
- `POST /portfolios` - Create a new portfolio
- `GET /portfolios/{id}/aggregate` - Get portfolio aggregation
- `GET /portfolios/{id}/report` - Generate portfolio report

## Why .NET Core?

.NET's LINQ and Entity Framework Core are excellent for data shaping and aggregation. The robust type system and strong tooling make it ideal for complex reporting and portfolio management.

