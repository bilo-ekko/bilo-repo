#!/bin/bash

# Script to run FastAPI with proper signal handling
# This ensures that Ctrl+C kills the Python process cleanly

set -e

# Store the PID of the Python process
PYTHON_PID=""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down analytics service..."
    
    # Kill Python process if running
    if [ ! -z "$PYTHON_PID" ]; then
        kill -TERM "$PYTHON_PID" 2>/dev/null || true
        wait "$PYTHON_PID" 2>/dev/null || true
    fi
    
    # Kill any remaining Python processes for this service
    pkill -9 -f "analytics-service" 2>/dev/null || true
    
    # Free up port 3011
    lsof -ti :3011 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Service stopped"
    exit 0
}

# Set up trap to catch INT (Ctrl+C) and TERM signals
trap cleanup INT TERM

# Get the directory of this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "🐍 Starting Analytics Service (Python/FastAPI)..."
echo "Press Ctrl+C to stop"
echo ""

# Check if virtual environment exists, create if not
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Use virtual environment's Python and pip directly (no need to activate)
VENV_PYTHON="$DIR/venv/bin/python"
VENV_PIP="$DIR/venv/bin/pip"

# Install/update dependencies
echo "📦 Installing dependencies..."
$VENV_PIP install -q --upgrade pip
$VENV_PIP install -q -r requirements.txt

echo ""
echo "🚀 Starting server on port 3011..."
echo ""

# Run the application and store its PID
$VENV_PYTHON main.py &
PYTHON_PID=$!

# Wait for the process to finish
wait "$PYTHON_PID"

# Cleanup on normal exit
cleanup


