#!/bin/bash

# Microservices Startup Script
# This script helps start all services or individual services by category

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_service() {
    echo -e "${GREEN}✓${NC} Starting ${BLUE}$1${NC} on port ${MAGENTA}$2${NC}"
}

print_error() {
    echo -e "${RED}✗ Error:${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_header "Checking Prerequisites"
    
    local missing_deps=0
    
    if ! command_exists node; then
        print_error "Node.js is not installed"
        missing_deps=1
    else
        echo -e "${GREEN}✓${NC} Node.js: $(node --version)"
    fi
    
    if ! command_exists pnpm; then
        print_error "pnpm is not installed. Install with: npm install -g pnpm"
        missing_deps=1
    else
        echo -e "${GREEN}✓${NC} pnpm: $(pnpm --version)"
    fi
    
    if ! command_exists go; then
        print_info "Go is not installed (optional - needed for Go services)"
    else
        echo -e "${GREEN}✓${NC} Go: $(go version)"
    fi
    
    if ! command_exists dotnet; then
        print_info ".NET SDK is not installed (optional - needed for .NET services)"
    else
        echo -e "${GREEN}✓${NC} .NET: $(dotnet --version)"
    fi
    
    echo ""
    
    if [ $missing_deps -eq 1 ]; then
        print_error "Some dependencies are missing. Please install them first."
        exit 1
    fi
    
    # Check if workspace dependencies are installed
    if [ ! -d "node_modules" ]; then
        print_info "Installing workspace dependencies..."
        pnpm install
    fi
    
    # Check if TypeScript services have node_modules
    if [ ! -d "services/ts/auth-service/node_modules" ]; then
        print_error "Service dependencies not installed!"
        print_info "Run: pnpm install"
        exit 1
    else
        echo -e "${GREEN}✓${NC} Workspace dependencies installed"
    fi
}

# Start API Gateway
start_gateway() {
    print_header "Starting API Gateway"
    print_service "API Gateway" "3000"
    cd apps/api-gateway
    pnpm dev &
    cd ../..
}

# Start TypeScript Services
start_ts_services() {
    print_header "Starting TypeScript Services (NestJS)"
    
    services=(
        "auth-service:3001"
        "calculation-service:3002"
        "impact-calculation-service:3003"
        "projects-service:3004"
        "equivalents-service:3005"
        "messaging-service:3009"
    )
    
    for service in "${services[@]}"; do
        IFS=':' read -r name port <<< "$service"
        print_service "$name" "$port"
        cd "services/ts/$name"
        PORT=$port pnpm dev &
        cd ../../..
    done
}

# Start Go Services
start_go_services() {
    if ! command_exists go; then
        print_error "Go is not installed. Skipping Go services."
        print_info "Install Go from: https://golang.org/dl/"
        return
    fi
    
    print_header "Starting Go Services"
    
    services=(
        "transactions-service:3100"
        "funds-service:3101"
        "payments-service:3102"
    )
    
    # Download Go dependencies if needed
    print_info "Checking Go dependencies..."
    for service in "${services[@]}"; do
        IFS=':' read -r name port <<< "$service"
        cd "services/go/$name"
        if [ ! -d "vendor" ] && [ ! -f "go.sum" ]; then
            print_info "Downloading dependencies for $name..."
            go mod download 2>/dev/null || true
        fi
        cd ../../..
    done
    
    for service in "${services[@]}"; do
        IFS=':' read -r name port <<< "$service"
        print_service "$name" "$port"
        cd "services/go/$name"
        PORT=$port go run main.go &
        cd ../../..
    done
}

# Start .NET Services
start_dotnet_services() {
    if ! command_exists dotnet; then
        print_error ".NET SDK is not installed. Skipping .NET services."
        print_info "Install .NET from: https://dotnet.microsoft.com/download"
        return
    fi
    
    print_header "Starting .NET Core Services"
    
    services=(
        "portfolio-service:3200"
        "analytics-service:3201"
    )
    
    for service in "${services[@]}"; do
        IFS=':' read -r name port <<< "$service"
        print_service "$name" "$port"
        cd "services/cs/$name"
        PORT=$port dotnet run &
        cd ../../..
    done
}

# Show usage
show_usage() {
    echo -e "${CYAN}Microservices Startup Script${NC}"
    echo ""
    echo "Usage: ./start-services.sh [option]"
    echo ""
    echo "Options:"
    echo "  all          Start all services (gateway + all microservices)"
    echo "  gateway      Start only the API Gateway"
    echo "  typescript   Start only TypeScript/NestJS services"
    echo "  go           Start only Go services"
    echo "  dotnet       Start only .NET Core services"
    echo "  check        Check prerequisites only"
    echo "  help         Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./start-services.sh all         # Start everything"
    echo "  ./start-services.sh typescript  # Start only TypeScript services"
    echo ""
}

# Main script
main() {
    case "${1:-all}" in
        all)
            check_prerequisites
            start_gateway
            sleep 2
            start_ts_services
            sleep 2
            start_go_services
            sleep 2
            start_dotnet_services
            
            echo ""
            print_header "All Services Started!"
            print_info "API Gateway: http://localhost:3000"
            print_info "Service List: http://localhost:3000/services"
            print_info "Health Check: http://localhost:3000/health"
            echo ""
            print_info "Press Ctrl+C to stop all services"
            
            # Wait for user interrupt
            wait
            ;;
        gateway)
            check_prerequisites
            start_gateway
            wait
            ;;
        typescript|ts)
            check_prerequisites
            start_ts_services
            wait
            ;;
        go)
            check_prerequisites
            start_go_services
            wait
            ;;
        dotnet)
            check_prerequisites
            start_dotnet_services
            wait
            ;;
        check)
            check_prerequisites
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"

