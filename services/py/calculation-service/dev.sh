#!/bin/bash

# Script to run FastAPI with proper signal handling
# This ensures that Ctrl+C kills the Python process cleanly

set -e

# Store the PID of the Python process
PYTHON_PID=""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down calculation service..."
    
    # Kill Python process if running
    if [ ! -z "$PYTHON_PID" ]; then
        kill -TERM "$PYTHON_PID" 2>/dev/null || true
        wait "$PYTHON_PID" 2>/dev/null || true
    fi
    
    # Kill any remaining Python processes for this service
    pkill -9 -f "calculation-service" 2>/dev/null || true
    
    # Free up port 3010
    lsof -ti :3010 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Service stopped"
    exit 0
}

# Set up trap to catch INT (Ctrl+C) and TERM signals
trap cleanup INT TERM

# Get the directory of this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DIR"

echo "🐍 Starting Calculation Service (Python/FastAPI)..."
echo "Press Ctrl+C to stop"
echo ""

# Check if virtual environment exists, create if not
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install/update dependencies
echo "📦 Installing dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt

echo ""
echo "🚀 Starting server on port 3010..."
echo ""

# Run the application and store its PID
python main.py &
PYTHON_PID=$!

# Wait for the process to finish
wait "$PYTHON_PID"

# Cleanup on normal exit
cleanup

