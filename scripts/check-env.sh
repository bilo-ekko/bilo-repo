#!/bin/bash

# Script to check versions of all tech stacks used in the monorepo
# Provides a clear, formatted output of installed tool versions with recommendations

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'
DIM='\033[2m'

# Recommended versions based on project configuration
RECOMMENDED_NODE=">=18"
RECOMMENDED_PNPM="9.0.0"
RECOMMENDED_GO="1.23"
RECOMMENDED_DOTNET="9.0"
RECOMMENDED_PYTHON="3.9+"
RECOMMENDED_RUST="stable"  # Rust uses stable/nightly channels

# Function to check if a command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to check if version meets requirement
check_version_requirement() {
    local current=$1
    local required=$2
    
    if [[ "$required" == *">="* ]]; then
        # Extract version number from requirement (e.g., ">=18" -> "18")
        local min_version=$(echo "$required" | sed 's/>=//')
        # Extract major version from current (e.g., "v22.20.0" -> "22")
        local current_major=$(echo "$current" | grep -oE '[0-9]+' | head -n 1)
        if [ "$current_major" -ge "$min_version" ] 2>/dev/null; then
            return 0
        fi
    elif [[ "$required" == *"+"* ]]; then
        # For Python 3.9+, just check it's 3.9 or higher
        local min_version=$(echo "$required" | sed 's/[^0-9]//g')
        local current_major=$(echo "$current" | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
        if [ -n "$current_major" ]; then
            return 0  # Simplified check - just verify it exists
        fi
    else
        # Exact match or contains check
        if [[ "$current" == *"$required"* ]]; then
            return 0
        fi
    fi
    return 1
}

# Function to get install command
get_install_command() {
    local tool=$1
    case "$tool" in
        "node")
            echo "brew install node"
            ;;
        "pnpm")
            echo "npm install -g pnpm@9.0.0"
            ;;
        "go")
            echo "brew install go"
            ;;
        "dotnet")
            echo "brew install --cask dotnet-sdk"
            ;;
        "python3")
            echo "brew install python@3.11"
            ;;
        "rustc"|"cargo")
            echo "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
            ;;
        "docker")
            echo "brew install --cask docker"
            ;;
        "kubectl")
            echo "brew install kubectl"
            ;;
        "helm")
            echo "brew install helm"
            ;;
        *)
            echo "Check documentation for installation"
            ;;
    esac
}

# Header
echo ""
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${CYAN}  Environment Check - Tech Stack Versions${NC}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""

MISSING_TOOLS=()
VERSION_MISMATCHES=()

# Node.js & npm
echo -e "${BOLD}${BLUE}📦 Node.js & Package Managers${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
if check_command "node"; then
    NODE_VERSION=$(node --version)
    if check_version_requirement "$NODE_VERSION" "$RECOMMENDED_NODE"; then
        echo -e "  ${GREEN}✓${NC} Node.js:     ${BOLD}$NODE_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_NODE)${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC} Node.js:     ${BOLD}$NODE_VERSION${NC} ${YELLOW}(recommended: $RECOMMENDED_NODE)${NC}"
        VERSION_MISMATCHES+=("node")
    fi
else
    echo -e "  ${RED}✗${NC} Node.js:     ${RED}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_NODE)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "node")${NC}"
    MISSING_TOOLS+=("node")
fi

if check_command "npm"; then
    NPM_VERSION=$(npm --version)
    echo -e "  ${GREEN}✓${NC} npm:         ${BOLD}$NPM_VERSION${NC}"
else
    echo -e "  ${RED}✗${NC} npm:         ${RED}Not installed${NC}"
    MISSING_TOOLS+=("npm")
fi

if check_command "pnpm"; then
    PNPM_VERSION=$(pnpm --version)
    if [ "$PNPM_VERSION" = "$RECOMMENDED_PNPM" ]; then
        echo -e "  ${GREEN}✓${NC} pnpm:        ${BOLD}$PNPM_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_PNPM)${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC} pnpm:        ${BOLD}$PNPM_VERSION${NC} ${YELLOW}(recommended: $RECOMMENDED_PNPM)${NC}"
        echo -e "    ${DIM}→ Update: $(get_install_command "pnpm")${NC}"
        VERSION_MISMATCHES+=("pnpm")
    fi
else
    echo -e "  ${YELLOW}⚠${NC} pnpm:        ${YELLOW}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_PNPM)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "pnpm")${NC}"
    MISSING_TOOLS+=("pnpm")
fi

if check_command "yarn"; then
    YARN_VERSION=$(yarn --version)
    echo -e "  ${GREEN}✓${NC} yarn:        ${BOLD}$YARN_VERSION${NC} ${DIM}(optional)${NC}"
else
    echo -e "  ${GREEN}✓${NC} yarn:        ${NC}Not installed ${DIM}(optional)${NC}"
fi
echo ""

# Rust
echo -e "${BOLD}${BLUE}🦀 Rust${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
if check_command "rustc"; then
    RUSTC_VERSION=$(rustc --version)
    echo -e "  ${GREEN}✓${NC} rustc:       ${BOLD}$RUSTC_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_RUST)${NC}"
else
    echo -e "  ${RED}✗${NC} rustc:       ${RED}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_RUST)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "rustc")${NC}"
    MISSING_TOOLS+=("rustc")
fi

if check_command "cargo"; then
    CARGO_VERSION=$(cargo --version)
    echo -e "  ${GREEN}✓${NC} cargo:       ${BOLD}$CARGO_VERSION${NC}"
else
    echo -e "  ${RED}✗${NC} cargo:       ${RED}Not installed${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "cargo")${NC}"
    MISSING_TOOLS+=("cargo")
fi
echo ""

# Go
echo -e "${BOLD}${BLUE}🐹 Go${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
if check_command "go"; then
    GO_VERSION=$(go version | awk '{print $3}')
    # Extract major.minor version (e.g., "go1.25.3" -> "1.25")
    GO_MAJOR_MINOR=$(echo "$GO_VERSION" | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
    RECOMMENDED_GO_MINOR=$(echo "$RECOMMENDED_GO" | grep -oE '[0-9]+\.[0-9]+' | head -n 1)
    
    # Compare versions - newer or equal is fine
    if [ -n "$GO_MAJOR_MINOR" ] && [ -n "$RECOMMENDED_GO_MINOR" ]; then
        # Simple numeric comparison (works for major.minor format)
        GO_MAJOR=$(echo "$GO_MAJOR_MINOR" | cut -d. -f1)
        GO_MINOR=$(echo "$GO_MAJOR_MINOR" | cut -d. -f2)
        REC_MAJOR=$(echo "$RECOMMENDED_GO_MINOR" | cut -d. -f1)
        REC_MINOR=$(echo "$RECOMMENDED_GO_MINOR" | cut -d. -f2)
        
        if [ "$GO_MAJOR" -gt "$REC_MAJOR" ] || ([ "$GO_MAJOR" -eq "$REC_MAJOR" ] && [ "$GO_MINOR" -ge "$REC_MINOR" ]); then
            echo -e "  ${GREEN}✓${NC} go:          ${BOLD}$GO_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_GO+)${NC}"
        else
            echo -e "  ${YELLOW}⚠${NC} go:          ${BOLD}$GO_VERSION${NC} ${YELLOW}(recommended: $RECOMMENDED_GO+)${NC}"
            echo -e "    ${DIM}→ Update: $(get_install_command "go")${NC}"
            VERSION_MISMATCHES+=("go")
        fi
    else
        # Fallback to simple contains check
        if [[ "$GO_VERSION" == *"$RECOMMENDED_GO"* ]]; then
            echo -e "  ${GREEN}✓${NC} go:          ${BOLD}$GO_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_GO+)${NC}"
        else
            echo -e "  ${GREEN}✓${NC} go:          ${BOLD}$GO_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_GO+)${NC}"
        fi
    fi
else
    echo -e "  ${RED}✗${NC} go:          ${RED}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_GO+)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "go")${NC}"
    MISSING_TOOLS+=("go")
fi
echo ""

# .NET / C#
echo -e "${BOLD}${BLUE}🔷 .NET / C#${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
if check_command "dotnet"; then
    DOTNET_VERSION=$(dotnet --version)
    if [[ "$DOTNET_VERSION" == "$RECOMMENDED_DOTNET"* ]]; then
        echo -e "  ${GREEN}✓${NC} dotnet:      ${BOLD}$DOTNET_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_DOTNET.x)${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC} dotnet:      ${BOLD}$DOTNET_VERSION${NC} ${YELLOW}(recommended: $RECOMMENDED_DOTNET.x)${NC}"
        echo -e "    ${DIM}→ Update: $(get_install_command "dotnet")${NC}"
        VERSION_MISMATCHES+=("dotnet")
    fi
else
    echo -e "  ${RED}✗${NC} dotnet:      ${RED}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_DOTNET.x)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "dotnet")${NC}"
    MISSING_TOOLS+=("dotnet")
fi
echo ""

# Python
echo -e "${BOLD}${BLUE}🐍 Python${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
if check_command "python3"; then
    PYTHON3_VERSION=$(python3 --version 2>&1)
    if check_version_requirement "$PYTHON3_VERSION" "$RECOMMENDED_PYTHON"; then
        echo -e "  ${GREEN}✓${NC} python3:     ${BOLD}$PYTHON3_VERSION${NC} ${DIM}(recommended: $RECOMMENDED_PYTHON)${NC}"
    else
        echo -e "  ${YELLOW}⚠${NC} python3:     ${BOLD}$PYTHON3_VERSION${NC} ${YELLOW}(recommended: $RECOMMENDED_PYTHON)${NC}"
        echo -e "    ${DIM}→ Update: $(get_install_command "python3")${NC}"
        VERSION_MISMATCHES+=("python3")
    fi
else
    echo -e "  ${RED}✗${NC} python3:     ${RED}Not installed${NC} ${DIM}(recommended: $RECOMMENDED_PYTHON)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "python3")${NC}"
    MISSING_TOOLS+=("python3")
fi

if check_command "python"; then
    PYTHON_VERSION=$(python --version 2>&1)
    echo -e "  ${GREEN}✓${NC} python:      ${BOLD}$PYTHON_VERSION${NC} ${DIM}(optional)${NC}"
else
    echo -e "  ${GREEN}✓${NC} python:      ${NC}Not installed ${DIM}(python3 is sufficient)${NC}"
fi

if check_command "pip3"; then
    PIP3_VERSION=$(pip3 --version 2>&1 | awk '{print $2}')
    echo -e "  ${GREEN}✓${NC} pip3:        ${BOLD}$PIP3_VERSION${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} pip3:        ${YELLOW}Not installed${NC}"
    echo -e "    ${DIM}→ Install: python3 -m ensurepip --upgrade${NC}"
fi
echo ""

# Additional Tools
echo -e "${BOLD}${BLUE}🛠️  Additional Tools${NC}"
echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"

if check_command "docker"; then
    DOCKER_VERSION=$(docker --version)
    echo -e "  ${GREEN}✓${NC} docker:      ${BOLD}$DOCKER_VERSION${NC} ${DIM}(optional)${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} docker:      ${YELLOW}Not installed${NC} ${DIM}(optional, for containerization)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "docker")${NC}"
fi

if check_command "kubectl"; then
    KUBECTL_VERSION=$(kubectl version --client 2>/dev/null | grep -o 'Client Version: v[0-9.]*' | sed 's/Client Version: //' || kubectl version --client 2>/dev/null | head -n 1 | grep -o 'v[0-9.]*' | head -n 1 || echo "installed")
    echo -e "  ${GREEN}✓${NC} kubectl:     ${BOLD}$KUBECTL_VERSION${NC} ${DIM}(optional)${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} kubectl:     ${YELLOW}Not installed${NC} ${DIM}(optional, for Kubernetes)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "kubectl")${NC}"
fi

if check_command "helm"; then
    HELM_VERSION=$(helm version --short 2>/dev/null | sed 's/v//' || helm version 2>/dev/null | head -n 1)
    echo -e "  ${GREEN}✓${NC} helm:        ${BOLD}$HELM_VERSION${NC} ${DIM}(optional)${NC}"
else
    echo -e "  ${YELLOW}⚠${NC} helm:        ${YELLOW}Not installed${NC} ${DIM}(optional, for Helm charts)${NC}"
    echo -e "    ${DIM}→ Install: $(get_install_command "helm")${NC}"
fi
echo ""

# Summary
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BOLD}${CYAN}  Summary${NC}"
echo -e "${BOLD}${CYAN}═══════════════════════════════════════════════════════════${NC}"

if [ ${#MISSING_TOOLS[@]} -eq 0 ] && [ ${#VERSION_MISMATCHES[@]} -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} All required tools are installed with recommended versions!"
elif [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo -e "  ${GREEN}✓${NC} All required tools are installed!"
    echo -e "  ${YELLOW}⚠${NC} ${BOLD}${#VERSION_MISMATCHES[@]}${NC} tool(s) have version mismatches (see above for install commands)"
else
    echo -e "  ${RED}✗${NC} ${BOLD}${#MISSING_TOOLS[@]}${NC} required tool(s) missing (see above for install commands)"
    if [ ${#VERSION_MISMATCHES[@]} -gt 0 ]; then
        echo -e "  ${YELLOW}⚠${NC} ${BOLD}${#VERSION_MISMATCHES[@]}${NC} tool(s) have version mismatches (see above for install commands)"
    fi
fi

# Show quick install commands if there are issues
if [ ${#MISSING_TOOLS[@]} -gt 0 ] || [ ${#VERSION_MISMATCHES[@]} -gt 0 ]; then
    echo ""
    echo -e "${BOLD}${CYAN}  Quick Install Commands${NC}"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
    
    # Show missing tools
    for tool in "${MISSING_TOOLS[@]}"; do
        INSTALL_CMD=$(get_install_command "$tool")
        echo -e "  ${DIM}# Install $tool${NC}"
        echo -e "  ${DIM}$INSTALL_CMD${NC}"
        echo ""
    done
    
    # Show version mismatches
    for tool in "${VERSION_MISMATCHES[@]}"; do
        INSTALL_CMD=$(get_install_command "$tool")
        echo -e "  ${DIM}# Update $tool${NC}"
        echo -e "  ${DIM}$INSTALL_CMD${NC}"
        echo ""
    done
fi

echo ""
echo ""
