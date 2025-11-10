#!/bin/bash

# Simple wrapper for cargo run with proper cleanup
# This ensures that Ctrl+C kills the rust process

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down messaging service..."
    
    # Kill any messaging-service processes
    pkill -9 -f "target/debug/messaging-service" 2>/dev/null || true
    
    # Free up port 4004
    lsof -ti :4004 | xargs kill -9 2>/dev/null || true
    
    echo "✅ Service stopped"
    exit 0
}

# Set up trap to catch INT (Ctrl+C) and TERM signals
trap cleanup INT TERM

echo "🦀 Starting Messaging Service (Rust)..."
echo "Press Ctrl+C to stop"
echo ""

# Run cargo run
cd "$(dirname "$0")"
cargo run

# Cleanup on normal exit
cleanup

