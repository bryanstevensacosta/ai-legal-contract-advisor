#!/bin/bash
# LexConductor - Install IBM Cloud CLI
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Installing IBM Cloud CLI${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "${BLUE}Detected OS: ${MACHINE}${NC}"
echo ""

if [ "$MACHINE" == "Mac" ]; then
    echo -e "${YELLOW}Installing IBM Cloud CLI for macOS...${NC}"
    curl -fsSL https://clis.cloud.ibm.com/install/osx | sh
elif [ "$MACHINE" == "Linux" ]; then
    echo -e "${YELLOW}Installing IBM Cloud CLI for Linux...${NC}"
    curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
else
    echo -e "${RED}Unsupported OS: ${MACHINE}${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Installing IBM Cloud CLI plugins...${NC}"

# Install Container Registry plugin
ibmcloud plugin install container-registry -f

# Install Code Engine plugin
ibmcloud plugin install code-engine -f

echo ""
echo -e "${GREEN}✓ IBM Cloud CLI installed successfully${NC}"
echo ""
echo "Verify installation:"
echo "  ibmcloud --version"
echo "  ibmcloud plugin list"
echo ""
echo "Next steps:"
echo "  1. Login: ibmcloud login --apikey \$IBM_CLOUD_API_KEY -r us-south"
echo "  2. Run deployment: ./scripts/deploy_to_code_engine.sh"
