#!/bin/bash
# LexConductor - Build and Push Docker Image to IBM Container Registry
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}LexConductor - Docker Build & Push${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Check if required environment variables are set
if [ -z "$ICR_NAMESPACE" ]; then
    echo -e "${RED}Error: ICR_NAMESPACE environment variable is not set${NC}"
    echo "Please set it with: export ICR_NAMESPACE=your-namespace"
    exit 1
fi

# Configuration
IMAGE_NAME="lexconductor-agents"
IMAGE_TAG="${IMAGE_TAG:-latest}"
ICR_REGION="${ICR_REGION:-us.icr.io}"
FULL_IMAGE_NAME="${ICR_REGION}/${ICR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"

echo -e "${YELLOW}Configuration:${NC}"
echo "  Registry: ${ICR_REGION}"
echo "  Namespace: ${ICR_NAMESPACE}"
echo "  Image: ${IMAGE_NAME}"
echo "  Tag: ${IMAGE_TAG}"
echo "  Full name: ${FULL_IMAGE_NAME}"
echo ""

# Step 1: Build Docker image
echo -e "${YELLOW}Step 1: Building Docker image...${NC}"
docker build -t "${FULL_IMAGE_NAME}" .

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image built successfully${NC}"
else
    echo -e "${RED}✗ Docker build failed${NC}"
    exit 1
fi
echo ""

# Step 2: Login to IBM Container Registry
echo -e "${YELLOW}Step 2: Logging in to IBM Container Registry...${NC}"
echo "Please ensure you have set IBM_CLOUD_API_KEY environment variable"

if [ -z "$IBM_CLOUD_API_KEY" ]; then
    echo -e "${YELLOW}IBM_CLOUD_API_KEY not set. Attempting interactive login...${NC}"
    ibmcloud login
else
    ibmcloud login --apikey "$IBM_CLOUD_API_KEY" -r us-south
fi

# Login to container registry
echo "$IBM_CLOUD_API_KEY" | docker login -u iamapikey --password-stdin "${ICR_REGION}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Logged in to IBM Container Registry${NC}"
else
    echo -e "${RED}✗ Login to IBM Container Registry failed${NC}"
    exit 1
fi
echo ""

# Step 3: Push Docker image
echo -e "${YELLOW}Step 3: Pushing Docker image to IBM Container Registry...${NC}"
docker push "${FULL_IMAGE_NAME}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Docker image pushed successfully${NC}"
else
    echo -e "${RED}✗ Docker push failed${NC}"
    exit 1
fi
echo ""

# Step 4: Verify image in registry
echo -e "${YELLOW}Step 4: Verifying image in registry...${NC}"
ibmcloud cr image-list --restrict "${ICR_NAMESPACE}/${IMAGE_NAME}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Image verified in registry${NC}"
else
    echo -e "${YELLOW}⚠ Could not verify image (may still be successful)${NC}"
fi
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Docker Build & Push Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Image: ${FULL_IMAGE_NAME}"
echo ""
echo "Next steps:"
echo "  1. Deploy to Code Engine with: ./scripts/deploy_to_code_engine.sh"
echo "  2. Or manually deploy using IBM Cloud Console"
echo ""
