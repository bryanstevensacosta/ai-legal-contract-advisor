#!/bin/bash
# LexConductor - Deploy to IBM Code Engine
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}LexConductor - Code Engine Deployment${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Configuration
PROJECT_NAME="${CODE_ENGINE_PROJECT:-lexconductor-project}"
APP_NAME="lexconductor-agents"
REGION="${CODE_ENGINE_REGION:-jp-osa}"
ICR_NAMESPACE="${ICR_NAMESPACE:-lexconductor}"
ICR_REGION="${ICR_REGION:-us.icr.io}"
IMAGE_NAME="lexconductor-agents"
IMAGE_TAG="${IMAGE_TAG:-latest}"
FULL_IMAGE_NAME="${ICR_REGION}/${ICR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"

# Resource configuration
MIN_SCALE="${MIN_SCALE:-0}"
MAX_SCALE="${MAX_SCALE:-5}"
CPU="${CPU:-1}"
MEMORY="${MEMORY:-512M}"
CONCURRENCY="${CONCURRENCY:-10}"
PORT="${PORT:-8080}"

echo -e "${YELLOW}Configuration:${NC}"
echo "  Project: ${PROJECT_NAME}"
echo "  Application: ${APP_NAME}"
echo "  Region: ${REGION}"
echo "  Image: ${FULL_IMAGE_NAME}"
echo "  Resources: ${CPU} CPU, ${MEMORY} memory"
echo "  Scaling: ${MIN_SCALE}-${MAX_SCALE} instances"
echo "  Concurrency: ${CONCURRENCY} requests/instance"
echo ""

# Check required environment variables
echo -e "${YELLOW}Checking required environment variables...${NC}"
REQUIRED_VARS=(
    "CLOUDANT_URL"
    "CLOUDANT_API_KEY"
    "COS_ENDPOINT"
    "COS_API_KEY"
    "COS_INSTANCE_ID"
    "WATSONX_API_KEY"
    "WATSONX_PROJECT_ID"
    "IBM_CLOUD_API_KEY"
)

MISSING_VARS=()
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo -e "${RED}Error: Missing required environment variables:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo "  - $var"
    done
    echo ""
    echo "Please set them before running this script."
    echo "You can source them from .env file: source .env"
    exit 1
fi

echo -e "${GREEN}✓ All required environment variables are set${NC}"
echo ""

# Step 1: Login to IBM Cloud
echo -e "${YELLOW}Step 1: Logging in to IBM Cloud...${NC}"
ibmcloud login --apikey "$IBM_CLOUD_API_KEY" -r us-south

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Logged in to IBM Cloud${NC}"
else
    echo -e "${RED}✗ Login failed${NC}"
    exit 1
fi
echo ""

# Step 2: Target resource group
echo -e "${YELLOW}Step 2: Targeting resource group...${NC}"
ibmcloud target -g Default

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Resource group targeted${NC}"
else
    echo -e "${YELLOW}⚠ Could not target Default resource group, continuing...${NC}"
fi
echo ""

# Step 3: Check if Code Engine project exists, create if not
echo -e "${YELLOW}Step 3: Setting up Code Engine project...${NC}"
PROJECT_EXISTS=$(ibmcloud ce project list --output json | jq -r ".[] | select(.name==\"${PROJECT_NAME}\") | .name")

if [ -z "$PROJECT_EXISTS" ]; then
    echo "Creating new Code Engine project: ${PROJECT_NAME}"
    ibmcloud ce project create --name "${PROJECT_NAME}" --region "${REGION}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Code Engine project created${NC}"
    else
        echo -e "${RED}✗ Failed to create Code Engine project${NC}"
        exit 1
    fi
else
    echo "Code Engine project already exists: ${PROJECT_NAME}"
fi

# Select the project
ibmcloud ce project select --name "${PROJECT_NAME}"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Code Engine project selected${NC}"
else
    echo -e "${RED}✗ Failed to select Code Engine project${NC}"
    exit 1
fi
echo ""

# Step 4: Create or update registry secret
echo -e "${YELLOW}Step 4: Setting up registry secret...${NC}"
SECRET_EXISTS=$(ibmcloud ce registry list --output json | jq -r ".[] | select(.name==\"icr-secret\") | .name")

if [ -z "$SECRET_EXISTS" ]; then
    echo "Creating registry secret..."
    ibmcloud ce registry create \
        --name icr-secret \
        --server "${ICR_REGION}" \
        --username iamapikey \
        --password "$IBM_CLOUD_API_KEY"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Registry secret created${NC}"
    else
        echo -e "${RED}✗ Failed to create registry secret${NC}"
        exit 1
    fi
else
    echo "Registry secret already exists"
    echo -e "${GREEN}✓ Registry secret ready${NC}"
fi
echo ""

# Step 5: Check if application exists
echo -e "${YELLOW}Step 5: Deploying application...${NC}"
APP_EXISTS=$(ibmcloud ce app list --output json | jq -r ".[] | select(.name==\"${APP_NAME}\") | .name")

if [ -z "$APP_EXISTS" ]; then
    echo "Creating new application: ${APP_NAME}"
    
    ibmcloud ce app create \
        --name "${APP_NAME}" \
        --image "${FULL_IMAGE_NAME}" \
        --registry-secret icr-secret \
        --port "${PORT}" \
        --min-scale "${MIN_SCALE}" \
        --max-scale "${MAX_SCALE}" \
        --cpu "${CPU}" \
        --memory "${MEMORY}" \
        --concurrency "${CONCURRENCY}" \
        --env CLOUDANT_URL="${CLOUDANT_URL}" \
        --env CLOUDANT_API_KEY="${CLOUDANT_API_KEY}" \
        --env COS_ENDPOINT="${COS_ENDPOINT}" \
        --env COS_API_KEY="${COS_API_KEY}" \
        --env COS_INSTANCE_ID="${COS_INSTANCE_ID}" \
        --env WATSONX_API_KEY="${WATSONX_API_KEY}" \
        --env WATSONX_PROJECT_ID="${WATSONX_PROJECT_ID}" \
        --env WATSONX_URL="https://us-south.ml.cloud.ibm.com"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Application created successfully${NC}"
    else
        echo -e "${RED}✗ Failed to create application${NC}"
        exit 1
    fi
else
    echo "Application already exists, updating: ${APP_NAME}"
    
    ibmcloud ce app update \
        --name "${APP_NAME}" \
        --image "${FULL_IMAGE_NAME}" \
        --min-scale "${MIN_SCALE}" \
        --max-scale "${MAX_SCALE}" \
        --cpu "${CPU}" \
        --memory "${MEMORY}" \
        --concurrency "${CONCURRENCY}" \
        --env CLOUDANT_URL="${CLOUDANT_URL}" \
        --env CLOUDANT_API_KEY="${CLOUDANT_API_KEY}" \
        --env COS_ENDPOINT="${COS_ENDPOINT}" \
        --env COS_API_KEY="${COS_API_KEY}" \
        --env COS_INSTANCE_ID="${COS_INSTANCE_ID}" \
        --env WATSONX_API_KEY="${WATSONX_API_KEY}" \
        --env WATSONX_PROJECT_ID="${WATSONX_PROJECT_ID}" \
        --env WATSONX_URL="https://us-south.ml.cloud.ibm.com"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Application updated successfully${NC}"
    else
        echo -e "${RED}✗ Failed to update application${NC}"
        exit 1
    fi
fi
echo ""

# Step 6: Get application details and URL
echo -e "${YELLOW}Step 6: Getting application details...${NC}"
sleep 5  # Wait for application to be ready

APP_URL=$(ibmcloud ce app get --name "${APP_NAME}" --output json | jq -r '.status.url')

if [ -z "$APP_URL" ] || [ "$APP_URL" == "null" ]; then
    echo -e "${YELLOW}⚠ Could not retrieve application URL yet${NC}"
    echo "Run: ibmcloud ce app get --name ${APP_NAME}"
else
    echo -e "${GREEN}✓ Application deployed successfully${NC}"
    echo ""
    echo -e "${BLUE}Application URL: ${APP_URL}${NC}"
fi
echo ""

# Step 7: Display application status
echo -e "${YELLOW}Step 7: Application status:${NC}"
ibmcloud ce app get --name "${APP_NAME}"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Application: ${APP_NAME}"
echo "Project: ${PROJECT_NAME}"
echo "Region: ${REGION}"
if [ ! -z "$APP_URL" ] && [ "$APP_URL" != "null" ]; then
    echo "URL: ${APP_URL}"
fi
echo ""
echo "Next steps:"
echo "  1. Test the health endpoint:"
echo "     curl ${APP_URL}/health"
echo ""
echo "  2. View logs:"
echo "     ibmcloud ce app logs --name ${APP_NAME}"
echo ""
echo "  3. Monitor the application:"
echo "     ibmcloud ce app get --name ${APP_NAME}"
echo ""
echo "  4. Run the test script:"
echo "     ./scripts/test_endpoints.sh"
echo ""
