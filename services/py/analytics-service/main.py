"""
Analytics Service - FastAPI
Handles metrics tracking, data aggregation, and analytics reporting
"""

import os
import uuid
from datetime import datetime, timedelta
from typing import Optional, List, Dict, Any
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn
from bilo_shared_utils import hello_from_shared_utils, create_success_response

app = FastAPI(
    title="Analytics Service",
    description="Metrics tracking and analytics reporting service",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins in development
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# In-memory storage for demo purposes
# In production, this would be a database
metrics_store: Dict[str, List[Dict[str, Any]]] = {}
events_store: List[Dict[str, Any]] = []


# Models
class HealthResponse(BaseModel):
    ok: bool
    service: str
    python_version: str


class MetricRequest(BaseModel):
    metric_name: str = Field(..., description="Name of the metric (e.g., 'page_views', 'api_calls')")
    value: float = Field(..., description="Metric value")
    tags: Optional[Dict[str, str]] = Field(default=None, description="Optional tags for filtering")
    timestamp: Optional[str] = Field(default=None, description="Optional timestamp (ISO format)")


class MetricResponse(BaseModel):
    success: bool
    metric_id: str
    metric_name: str
    value: float
    timestamp: str
    service: str


class EventRequest(BaseModel):
    event_name: str = Field(..., description="Event name (e.g., 'user_signup', 'purchase')")
    user_id: Optional[str] = Field(default=None, description="User identifier")
    properties: Optional[Dict[str, Any]] = Field(default=None, description="Event properties")
    timestamp: Optional[str] = Field(default=None, description="Optional timestamp (ISO format)")


class EventResponse(BaseModel):
    success: bool
    event_id: str
    event_name: str
    timestamp: str
    service: str


class AggregationResponse(BaseModel):
    metric_name: str
    count: int
    sum: float
    average: float
    min: float
    max: float
    period_start: str
    period_end: str


# Routes
@app.get("/")
async def root():
    """Root endpoint"""
    return {"message": "Analytics Service - Python/FastAPI Edition"}


@app.get("/health")
async def health():
    """Health check endpoint"""
    import sys
    return HealthResponse(
        ok=True,
        service="analytics-service",
        python_version=f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    )


@app.get("/health-check")
async def health_check():
    """Health check endpoint (alternative path)"""
    import sys
    return HealthResponse(
        ok=True,
        service="analytics-service",
        python_version=f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    )


@app.get("/shared-utils-demo")
async def shared_utils_demo():
    """Shared utils demo endpoint"""
    message = hello_from_shared_utils("analytics-service")
    response = create_success_response({"message": message})
    return response


@app.post("/metrics", response_model=MetricResponse)
async def track_metric(request: MetricRequest):
    """
    Track a metric value
    
    This endpoint allows you to record metrics like page views, API calls,
    response times, error counts, etc.
    """
    timestamp = request.timestamp or datetime.utcnow().isoformat()
    metric_id = f"metric_{uuid.uuid4()}"
    
    # Store metric
    if request.metric_name not in metrics_store:
        metrics_store[request.metric_name] = []
    
    metric_data = {
        "id": metric_id,
        "value": request.value,
        "tags": request.tags or {},
        "timestamp": timestamp
    }
    
    metrics_store[request.metric_name].append(metric_data)
    
    return MetricResponse(
        success=True,
        metric_id=metric_id,
        metric_name=request.metric_name,
        value=request.value,
        timestamp=timestamp,
        service="analytics-service"
    )


@app.post("/events", response_model=EventResponse)
async def track_event(request: EventRequest):
    """
    Track an event
    
    This endpoint allows you to record user events like signups, purchases,
    button clicks, etc.
    """
    timestamp = request.timestamp or datetime.utcnow().isoformat()
    event_id = f"event_{uuid.uuid4()}"
    
    # Store event
    event_data = {
        "id": event_id,
        "event_name": request.event_name,
        "user_id": request.user_id,
        "properties": request.properties or {},
        "timestamp": timestamp
    }
    
    events_store.append(event_data)
    
    return EventResponse(
        success=True,
        event_id=event_id,
        event_name=request.event_name,
        timestamp=timestamp,
        service="analytics-service"
    )


@app.get("/metrics/{metric_name}", response_model=AggregationResponse)
async def get_metric_aggregation(
    metric_name: str,
    hours: int = Query(default=24, description="Number of hours to aggregate")
):
    """
    Get aggregated metric data
    
    Returns statistics (count, sum, average, min, max) for a specific metric
    over the specified time period.
    """
    if metric_name not in metrics_store:
        raise HTTPException(
            status_code=404,
            detail=f"Metric '{metric_name}' not found"
        )
    
    # Calculate time window
    now = datetime.utcnow()
    period_start = now - timedelta(hours=hours)
    
    # Filter metrics by time window
    metrics = metrics_store[metric_name]
    filtered_metrics = [
        m for m in metrics
        if datetime.fromisoformat(m["timestamp"].replace('Z', '+00:00')) >= period_start
    ]
    
    if not filtered_metrics:
        raise HTTPException(
            status_code=404,
            detail=f"No data found for metric '{metric_name}' in the last {hours} hours"
        )
    
    # Calculate aggregations
    values = [m["value"] for m in filtered_metrics]
    
    return AggregationResponse(
        metric_name=metric_name,
        count=len(values),
        sum=sum(values),
        average=sum(values) / len(values),
        min=min(values),
        max=max(values),
        period_start=period_start.isoformat(),
        period_end=now.isoformat()
    )


@app.get("/metrics")
async def list_metrics():
    """
    List all available metrics
    
    Returns a list of all metric names that have been tracked.
    """
    return {
        "metrics": list(metrics_store.keys()),
        "count": len(metrics_store)
    }


@app.get("/events")
async def list_events(
    limit: int = Query(default=100, description="Maximum number of events to return"),
    event_name: Optional[str] = Query(default=None, description="Filter by event name")
):
    """
    List tracked events
    
    Returns a list of events, optionally filtered by event name.
    """
    filtered_events = events_store
    
    if event_name:
        filtered_events = [e for e in events_store if e["event_name"] == event_name]
    
    # Return most recent events first
    sorted_events = sorted(
        filtered_events,
        key=lambda x: x["timestamp"],
        reverse=True
    )
    
    return {
        "events": sorted_events[:limit],
        "count": len(sorted_events),
        "total": len(events_store)
    }


@app.get("/dashboard")
async def get_dashboard_stats():
    """
    Get dashboard statistics
    
    Returns overview statistics for all metrics and events.
    """
    total_metrics = sum(len(metrics) for metrics in metrics_store.values())
    
    return {
        "total_metrics_tracked": total_metrics,
        "unique_metric_types": len(metrics_store),
        "total_events_tracked": len(events_store),
        "metric_names": list(metrics_store.keys()),
        "timestamp": datetime.utcnow().isoformat()
    }


@app.delete("/metrics/{metric_name}")
async def clear_metric(metric_name: str):
    """
    Clear all data for a specific metric
    
    This is useful for testing or resetting data.
    """
    if metric_name not in metrics_store:
        raise HTTPException(
            status_code=404,
            detail=f"Metric '{metric_name}' not found"
        )
    
    count = len(metrics_store[metric_name])
    del metrics_store[metric_name]
    
    return {
        "success": True,
        "message": f"Cleared {count} data points for metric '{metric_name}'"
    }


@app.delete("/events")
async def clear_events():
    """
    Clear all tracked events
    
    This is useful for testing or resetting data.
    """
    count = len(events_store)
    events_store.clear()
    
    return {
        "success": True,
        "message": f"Cleared {count} events"
    }


if __name__ == "__main__":
    port = int(os.getenv("PORT", "3011"))
    print(f"🐍 Starting Analytics Service (Python/FastAPI) on port {port}")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=port,
        log_level="info"
    )






