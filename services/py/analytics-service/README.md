# Analytics Service

Python FastAPI service for tracking metrics, events, and generating analytics reports.

## Overview

This service provides APIs for:
- **Metrics Tracking**: Record numeric metrics like page views, API calls, response times
- **Event Tracking**: Track user events like signups, purchases, clicks
- **Data Aggregation**: Calculate statistics (count, sum, average, min, max) over time periods
- **Dashboard Stats**: Get overview of all tracked metrics and events

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
- Frees up port 3011
- Shows cleanup confirmation

### Using Python directly
```bash
# Activate virtual environment first
source venv/bin/activate

# Run the application
python main.py

# Or use uvicorn directly
uvicorn main:app --reload --host 0.0.0.0 --port 3011
```

## API Endpoints

### Health Check
```bash
# Standard health endpoint
GET http://localhost:3011/health

# Alternative health endpoint
GET http://localhost:3011/health-check
```

Response:
```json
{
  "ok": true,
  "service": "analytics-service",
  "python_version": "3.9.6"
}
```

### Track Metric
```bash
POST http://localhost:3011/metrics
Content-Type: application/json

{
  "metric_name": "page_views",
  "value": 150,
  "tags": {
    "page": "/dashboard",
    "user_type": "premium"
  }
}
```

Response:
```json
{
  "success": true,
  "metric_id": "metric_550e8400-e29b-41d4-a716-446655440000",
  "metric_name": "page_views",
  "value": 150,
  "timestamp": "2025-10-30T12:34:56.789Z",
  "service": "analytics-service"
}
```

### Track Event
```bash
POST http://localhost:3011/events
Content-Type: application/json

{
  "event_name": "user_signup",
  "user_id": "user_123",
  "properties": {
    "plan": "premium",
    "referral_source": "google"
  }
}
```

Response:
```json
{
  "success": true,
  "event_id": "event_550e8400-e29b-41d4-a716-446655440000",
  "event_name": "user_signup",
  "timestamp": "2025-10-30T12:34:56.789Z",
  "service": "analytics-service"
}
```

### Get Metric Aggregation
```bash
# Get stats for the last 24 hours
GET http://localhost:3011/metrics/page_views?hours=24

# Get stats for the last 7 days
GET http://localhost:3011/metrics/api_calls?hours=168
```

Response:
```json
{
  "metric_name": "page_views",
  "count": 1500,
  "sum": 225000,
  "average": 150,
  "min": 50,
  "max": 500,
  "period_start": "2025-10-29T12:00:00Z",
  "period_end": "2025-10-30T12:00:00Z"
}
```

### List All Metrics
```bash
GET http://localhost:3011/metrics
```

Response:
```json
{
  "metrics": ["page_views", "api_calls", "response_time"],
  "count": 3
}
```

### List Events
```bash
# Get latest 100 events
GET http://localhost:3011/events?limit=100

# Filter by event name
GET http://localhost:3011/events?event_name=user_signup&limit=50
```

Response:
```json
{
  "events": [
    {
      "id": "event_123",
      "event_name": "user_signup",
      "user_id": "user_123",
      "properties": {"plan": "premium"},
      "timestamp": "2025-10-30T12:34:56.789Z"
    }
  ],
  "count": 1,
  "total": 1500
}
```

### Dashboard Statistics
```bash
GET http://localhost:3011/dashboard
```

Response:
```json
{
  "total_metrics_tracked": 5000,
  "unique_metric_types": 3,
  "total_events_tracked": 1500,
  "metric_names": ["page_views", "api_calls", "response_time"],
  "timestamp": "2025-10-30T12:34:56.789Z"
}
```

### Clear Data (Development Only)
```bash
# Clear a specific metric
DELETE http://localhost:3011/metrics/page_views

# Clear all events
DELETE http://localhost:3011/events
```

## Common Use Cases

### Tracking Page Views
```bash
curl -X POST http://localhost:3011/metrics \
  -H "Content-Type: application/json" \
  -d '{
    "metric_name": "page_views",
    "value": 1,
    "tags": {"page": "/dashboard"}
  }'
```

### Tracking API Response Time
```bash
curl -X POST http://localhost:3011/metrics \
  -H "Content-Type: application/json" \
  -d '{
    "metric_name": "api_response_time",
    "value": 125.5,
    "tags": {"endpoint": "/api/users", "method": "GET"}
  }'
```

### Tracking User Events
```bash
curl -X POST http://localhost:3011/events \
  -H "Content-Type: application/json" \
  -d '{
    "event_name": "purchase_completed",
    "user_id": "user_456",
    "properties": {
      "amount": 99.99,
      "currency": "USD",
      "items": 3
    }
  }'
```

## Environment Variables

- `PORT` - Server port (default: 3011)

## Technology Stack

- **FastAPI** - Modern, fast web framework for building APIs
- **Uvicorn** - ASGI server for running FastAPI
- **Pydantic** - Data validation using Python type annotations

## Port

Default port: **3011**

## Interactive API Documentation

Once running, visit:
- Swagger UI: http://localhost:3011/docs
- ReDoc: http://localhost:3011/redoc

## Data Storage

⚠️ **Note**: This service currently uses in-memory storage for demonstration purposes.

In production, you should:
- Use a time-series database (e.g., InfluxDB, TimescaleDB)
- Implement persistent storage
- Add data retention policies
- Set up proper indexing for queries

## CORS Configuration

CORS is configured to allow all origins in development. In production, you should restrict this to your specific domains.

## Integration with Other Services

This analytics service can be integrated with:
- **web-dashboard** - Display metrics and charts
- **auth-service** - Track user authentication events
- **transactions-service** - Monitor transaction metrics
- Any service that needs to track metrics or events




