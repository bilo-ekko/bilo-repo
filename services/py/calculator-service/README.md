# Calculation Service

Python FastAPI service for carbon emission calculations and environmental impact computations.

## Overview

This service provides APIs for calculating carbon emissions based on various activities such as:
- Electricity consumption
- Flight travel
- Car travel
- Train travel
- Gas usage

## Prerequisites

- Python 3.9 or higher
- pip (Python package installer)

## Installation

### Option 1: Quick Setup
```bash
pnpm run setup
```

### Option 2: Manual Setup
```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

## Development

### Using npm/pnpm scripts (recommended)
```bash
# Run in development mode with hot-reload and proper cleanup
pnpm dev

# Simple start without hot-reload
pnpm start

# Clean up virtual environment
pnpm clean
```

**Important:** The `dev` script includes proper Ctrl+C signal handling:
- Catches interrupt signals
- Kills the Python process cleanly
- Frees up port 3010
- Shows cleanup confirmation

### Using Python directly
```bash
# Activate virtual environment first
source venv/bin/activate

# Run the application
python main.py

# Or use uvicorn directly
uvicorn main:app --reload --host 0.0.0.0 --port 3010
```

## API Endpoints

### Health Check
```bash
# Standard health endpoint
GET http://localhost:3010/health

# Alternative health endpoint
GET http://localhost:3010/health-check
```

Response:
```json
{
  "ok": true,
  "service": "calculation-service",
  "python_version": "3.9.6"
}
```

### Calculate Emissions
```bash
POST http://localhost:3010/calculate
Content-Type: application/json

{
  "activity_type": "car",
  "value": 100,
  "unit": "km"
}
```

Response:
```json
{
  "success": true,
  "calculation_id": "calc_550e8400-e29b-41d4-a716-446655440000",
  "co2_kg": 17.1,
  "activity_type": "car",
  "service": "calculation-service"
}
```

Supported activity types:
- `electricity` - kWh consumed
- `flight` - kilometers flown
- `car` - kilometers driven
- `train` - kilometers traveled
- `gas` - cubic meters of natural gas

### Get Emission Factors
```bash
GET http://localhost:3010/emission-factors
```

Returns all available emission factors with their units and descriptions.

## Environment Variables

- `PORT` - Server port (default: 3010)

## Technology Stack

- **FastAPI** - Modern, fast web framework for building APIs
- **Uvicorn** - ASGI server for running FastAPI
- **Pydantic** - Data validation using Python type annotations

## Port

Default port: **3010**

## Interactive API Documentation

Once running, visit:
- Swagger UI: http://localhost:3010/docs
- ReDoc: http://localhost:3010/redoc

## Notes

- The service uses simplified emission factors for demonstration
- In production, emission factors should come from a real database
- CORS is configured to allow all origins in development
- The service automatically creates and manages a Python virtual environment

