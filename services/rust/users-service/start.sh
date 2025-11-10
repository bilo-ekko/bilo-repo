#!/bin/bash

# Simple wrapper for cargo run with proper cleanup
# This ensures that Ctrl+C kills the rust process

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down users service..."
    
    # Kill any users-service processes
    pkill -9 -f "target/debug/users-service" 2>/dev/null || true
    
    # Free up port 4007
    lsof -ti :4007 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Service stopped"
    exit 0
}

# Set up trap to catch INT (Ctrl+C) and TERM signals
trap cleanup INT TERM

echo "🦀 Starting Users Service (Rust)..."
echo "Press Ctrl+C to stop"
echo ""

# Run cargo run
cd "$(dirname "$0")"
cargo run

# Cleanup on normal exit
cleanup


