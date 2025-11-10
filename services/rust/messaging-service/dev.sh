#!/bin/bash

# Script to run bacon with proper signal handling
# This ensures that Ctrl+C kills both bacon and the spawned cargo/rust process

set -e

# Store the PID of the bacon process
BACON_PID=""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down messaging service..."
    
    # Kill bacon and its child processes if running
    if [ ! -z "$BACON_PID" ]; then
        # Kill the entire process group
        pkill -P "$BACON_PID" 2>/dev/null || true
        kill -TERM "$BACON_PID" 2>/dev/null || true
    fi
    
    # Kill any remaining messaging-service processes
    pkill -9 -f "target/debug/messaging-service" 2>/dev/null || true
    pkill -9 -f "messaging-service" 2>/dev/null || true
    
    # Free up port 4004
    lsof -ti :4004 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Cleanup complete"
    exit 0
}

# Set up trap to catch INT (Ctrl+C), TERM, and EXIT signals
trap cleanup INT TERM EXIT

echo "🦀 Starting Messaging Service (Rust) with bacon..."
echo "Press Ctrl+C to stop"
echo ""

# Run bacon with exec to replace the shell process
# This ensures signals are properly forwarded
exec $HOME/.cargo/bin/bacon run

