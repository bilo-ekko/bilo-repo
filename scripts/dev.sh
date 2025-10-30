#!/bin/bash

# Wrapper script for pnpm dev that ensures all processes are killed on Ctrl+C
# This ensures both services and web apps are properly terminated

set -e

# Store the PID of the turbo process
TURBO_PID=""

# Cleanup function
cleanup() {
    echo ""
    echo "🛑 Shutting down all services and web apps..."
    
    # Kill Turbo process and its children if running
    if [ ! -z "$TURBO_PID" ]; then
        # Send SIGTERM to Turbo (graceful shutdown)
        kill -TERM "$TURBO_PID" 2>/dev/null || true
        # Wait a moment for graceful shutdown
        sleep 1
        # Kill process group if still running
        pkill -P "$TURBO_PID" 2>/dev/null || true
        kill -9 "$TURBO_PID" 2>/dev/null || true
    fi
    
    # Kill all Turbo processes
    pkill -f "turbo run dev" 2>/dev/null || true
    
    # Kill Next.js processes (web apps) - these sometimes don't respond to SIGTERM
    pkill -f "next dev" 2>/dev/null || true
    pkill -f "next-server" 2>/dev/null || true
    
    # Kill Vite processes (web apps)
    pkill -f "vite.*--port" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true
    
    # Kill any remaining processes on web app ports (force kill)
    lsof -ti :9001 2>/dev/null | xargs kill -9 2>/dev/null || true
    lsof -ti :9002 2>/dev/null | xargs kill -9 2>/dev/null || true
    lsof -ti :9003 2>/dev/null | xargs kill -9 2>/dev/null || true
    lsof -ti :3006 2>/dev/null | xargs kill -9 2>/dev/null || true
    lsof -ti :3007 2>/dev/null | xargs kill -9 2>/dev/null || true
    
    echo "✅ All processes stopped"
    exit 0
}

# Set up trap to catch INT (Ctrl+C), TERM, and EXIT signals
trap cleanup INT TERM EXIT

# Run turbo dev in background and store PID
echo "🚀 Starting all services and web apps..."
echo "Press Ctrl+C to stop all processes"
echo ""

pnpm turbo run dev --concurrency 25 &
TURBO_PID=$!

# Wait for the turbo process to finish
wait "$TURBO_PID"
