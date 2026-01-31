#!/bin/bash

# LexConductor - watsonx Orchestrate ADK Setup Script
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

echo "=========================================="
echo "watsonx Orchestrate ADK Setup"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    echo -e "${GREEN}✓${NC} Loading environment variables from .env"
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}✗${NC} .env file not found!"
    exit 1
fi

# Check required environment variables
if [ -z "$WO_INSTANCE" ] || [ -z "$WO_API_KEY" ]; then
    echo -e "${RED}✗${NC} Missing required environment variables:"
    echo "  - WO_INSTANCE"
    echo "  - WO_API_KEY"
    exit 1
fi

echo ""
echo "Step 1: Installing watsonx Orchestrate ADK"
echo "-------------------------------------------"

# Check if pip is available
if ! command -v pip &> /dev/null; then
    echo -e "${RED}✗${NC} pip not found. Please install Python 3.11+ first."
    exit 1
fi

# Install ADK
echo "Installing ibm-watsonx-orchestrate..."
pip install --upgrade ibm-watsonx-orchestrate

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} ADK installed successfully"
else
    echo -e "${RED}✗${NC} Failed to install ADK"
    exit 1
fi

echo ""
echo "Step 2: Configuring ADK Environment"
echo "------------------------------------"

# Add environment
echo "Adding production environment..."
orchestrate env add prod \
    --instance "$WO_INSTANCE" \
    --api-key "$WO_API_KEY"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Environment added successfully"
else
    echo -e "${YELLOW}⚠${NC} Environment may already exist, continuing..."
fi

# Activate environment
echo "Activating production environment..."
orchestrate env activate prod

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Environment activated"
else
    echo -e "${RED}✗${NC} Failed to activate environment"
    exit 1
fi

# Login
echo "Logging in to watsonx Orchestrate..."
orchestrate auth login

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Login successful"
else
    echo -e "${RED}✗${NC} Login failed"
    exit 1
fi

echo ""
echo "Step 3: Verifying Setup"
echo "-----------------------"

# List environments
echo "Available environments:"
orchestrate env list

# Check authentication
echo ""
echo "Authentication status:"
orchestrate auth status

echo ""
echo -e "${GREEN}=========================================="
echo "✓ ADK Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Import agents: ./scripts/import_agents.sh"
echo "  2. Deploy agents: ./scripts/deploy_agents.sh"
echo "  3. Test integration: ./scripts/test_orchestrate.sh"
echo ""
