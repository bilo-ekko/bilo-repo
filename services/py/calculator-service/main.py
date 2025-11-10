"""
Calculator Service - FastAPI
Handles carbon calculations and emission computations
"""

import os
import uuid
from typing import Optional
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
from bilo_shared_utils import hello_from_shared_utils, create_success_response

app = FastAPI(
    title="Calculator Service",
    description="Carbon calculation and emission computation service",
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


# Models
class HealthResponse(BaseModel):
    ok: bool
    service: str
    python_version: str


class CalculationRequest(BaseModel):
    activity_type: str
    value: float
    unit: str


class CalculationResponse(BaseModel):
    success: bool
    calculation_id: str
    co2_kg: float
    activity_type: str
    service: str


# Routes
@app.get("/")
async def root():
    """Root endpoint"""
    return {"message": "Calculation Service - Python/FastAPI Edition"}


@app.get("/health")
async def health():
    """Health check endpoint"""
    import sys
    return HealthResponse(
        ok=True,
        service="calculation-service",
        python_version=f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    )


@app.get("/health-check")
async def health_check():
    """Health check endpoint (alternative path)"""
    import sys
    return HealthResponse(
        ok=True,
        service="calculation-service",
        python_version=f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    )


@app.get("/shared-utils-demo")
async def shared_utils_demo():
    """Shared utils demo endpoint"""
    message = hello_from_shared_utils("calculator-service")
    response = create_success_response({"message": message})
    return response


@app.post("/calculate")
async def calculate(request: CalculationRequest):
    """
    Calculate carbon emissions for a given activity
    
    This is a simplified calculation service.
    In production, this would use real emission factors from a database.
    """
    # Simple emission factors (kg CO2 per unit)
    emission_factors = {
        "electricity": 0.5,  # kg CO2 per kWh
        "flight": 0.255,     # kg CO2 per km
        "car": 0.171,        # kg CO2 per km
        "train": 0.041,      # kg CO2 per km
        "gas": 2.0,          # kg CO2 per m³
    }
    
    # Get emission factor
    factor = emission_factors.get(request.activity_type.lower())
    
    if factor is None:
        raise HTTPException(
            status_code=400,
            detail=f"Unknown activity type: {request.activity_type}. "
                   f"Supported types: {', '.join(emission_factors.keys())}"
        )
    
    # Calculate CO2 emissions
    co2_kg = request.value * factor
    
    return CalculationResponse(
        success=True,
        calculation_id=f"calc_{uuid.uuid4()}",
        co2_kg=round(co2_kg, 3),
        activity_type=request.activity_type,
        service="calculation-service"
    )


@app.get("/emission-factors")
async def get_emission_factors():
    """Get available emission factors"""
    return {
        "electricity": {"value": 0.5, "unit": "kg CO2/kWh", "description": "Grid electricity"},
        "flight": {"value": 0.255, "unit": "kg CO2/km", "description": "Commercial flight"},
        "car": {"value": 0.171, "unit": "kg CO2/km", "description": "Average car"},
        "train": {"value": 0.041, "unit": "kg CO2/km", "description": "Train travel"},
        "gas": {"value": 2.0, "unit": "kg CO2/m³", "description": "Natural gas"}
    }


if __name__ == "__main__":
    port = int(os.getenv("PORT", "4005"))
    print(f"🐍 Starting Calculation Service (Python/FastAPI) on port {port}")
    
    uvicorn.run(
        app,
        host="0.0.0.0",
        port=port,
        log_level="info"
    )

