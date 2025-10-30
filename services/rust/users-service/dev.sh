#!/bin/bash

# Script to run bacon with proper signal handling
# This ensures that Ctrl+C kills both bacon and the spawned cargo/rust process

set -e

# Store the PID of the bacon process
BACON_PID=""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down users service..."
    
    # Kill bacon and its child processes if running
    if [ ! -z "$BACON_PID" ]; then
        # Kill the entire process group
        pkill -P "$BACON_PID" 2>/dev/null || true
        kill -TERM "$BACON_PID" 2>/dev/null || true
    fi
    
    # Kill any remaining users-service processes
    pkill -9 -f "target/debug/users-service" 2>/dev/null || true
    pkill -9 -f "users-service" 2>/dev/null || true
    
    # Free up port 3012
    lsof -ti :3012 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Cleanup complete"
    exit 0
}

# Set up trap to catch INT (Ctrl+C), TERM, and EXIT signals
trap cleanup INT TERM EXIT

echo "🦀 Starting Users Service (Rust) with bacon..."
echo "Press Ctrl+C to stop"
echo ""

# Run bacon with exec to replace the shell process
# This ensures signals are properly forwarded
exec $HOME/.cargo/bin/bacon run

