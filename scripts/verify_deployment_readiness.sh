#!/bin/bash
# LexConductor - Verify Deployment Readiness
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}LexConductor - Deployment Readiness${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_WARNING=0

# Function to check command exists
check_command() {
    local cmd="$1"
    local name="$2"
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $name is installed"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $name is NOT installed"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
        return 1
    fi
}

# Function to check file exists
check_file() {
    local file="$1"
    local name="$2"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $name exists"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $name does NOT exist"
        CHECKS_FAILED=$((CHECKS_FAILED + 1))
        return 1
    fi
}

# Function to check environment variable
check_env_var() {
    local var="$1"
    local name="$2"
    
    if [ ! -z "${!var}" ] && [ "${!var}" != "your_"* ]; then
        echo -e "${GREEN}✓${NC} $name is set"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $name is NOT set or has placeholder value"
        CHECKS_WARNING=$((CHECKS_WARNING + 1))
        return 1
    fi
}

echo -e "${BLUE}Checking prerequisites...${NC}"
echo ""

# Check Docker
check_command "docker" "Docker"

# Check Docker daemon
if docker info &> /dev/null; then
    echo -e "${GREEN}✓${NC} Docker daemon is running"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}✗${NC} Docker daemon is NOT running"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi

# Check IBM Cloud CLI
check_command "ibmcloud" "IBM Cloud CLI"

# Check jq
if check_command "jq" "jq (JSON processor)"; then
    :
else
    echo -e "${YELLOW}  Note: jq is optional but recommended for better output${NC}"
fi

echo ""
echo -e "${BLUE}Checking project files...${NC}"
echo ""

# Check Dockerfile
check_file "Dockerfile" "Dockerfile"

# Check .dockerignore
check_file ".dockerignore" ".dockerignore"

# Check requirements.txt
check_file "requirements.txt" "requirements.txt"

# Check backend directory
if [ -d "backend" ]; then
    echo -e "${GREEN}✓${NC} backend/ directory exists"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${RED}✗${NC} backend/ directory does NOT exist"
    CHECKS_FAILED=$((CHECKS_FAILED + 1))
fi

# Check main.py
check_file "backend/main.py" "backend/main.py"

# Check deployment scripts
check_file "scripts/build_and_push_docker.sh" "build_and_push_docker.sh"
check_file "scripts/deploy_to_code_engine.sh" "deploy_to_code_engine.sh"
check_file "scripts/test_endpoints.sh" "test_endpoints.sh"

echo ""
echo -e "${BLUE}Checking environment variables...${NC}"
echo ""

# Load .env if exists
if [ -f ".env" ]; then
    echo -e "${GREEN}✓${NC} .env file exists"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    source .env
else
    echo -e "${YELLOW}⚠${NC} .env file does NOT exist"
    echo -e "${YELLOW}  Create it from .env.example: cp .env.example .env${NC}"
    CHECKS_WARNING=$((CHECKS_WARNING + 1))
fi

# Check critical environment variables
check_env_var "IBM_CLOUD_API_KEY" "IBM_CLOUD_API_KEY"
check_env_var "ICR_NAMESPACE" "ICR_NAMESPACE"
check_env_var "CLOUDANT_URL" "CLOUDANT_URL"
check_env_var "CLOUDANT_API_KEY" "CLOUDANT_API_KEY"
check_env_var "COS_ENDPOINT" "COS_ENDPOINT"
check_env_var "COS_API_KEY" "COS_API_KEY"
check_env_var "COS_INSTANCE_ID" "COS_INSTANCE_ID"
check_env_var "WATSONX_API_KEY" "WATSONX_API_KEY"
check_env_var "WATSONX_PROJECT_ID" "WATSONX_PROJECT_ID"

echo ""
echo -e "${BLUE}Checking IBM Cloud CLI plugins...${NC}"
echo ""

# Check Container Registry plugin
if ibmcloud plugin list | grep -q "container-registry"; then
    echo -e "${GREEN}✓${NC} Container Registry plugin is installed"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${YELLOW}⚠${NC} Container Registry plugin is NOT installed"
    echo -e "${YELLOW}  Install with: ibmcloud plugin install container-registry${NC}"
    CHECKS_WARNING=$((CHECKS_WARNING + 1))
fi

# Check Code Engine plugin
if ibmcloud plugin list | grep -q "code-engine"; then
    echo -e "${GREEN}✓${NC} Code Engine plugin is installed"
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
else
    echo -e "${YELLOW}⚠${NC} Code Engine plugin is NOT installed"
    echo -e "${YELLOW}  Install with: ibmcloud plugin install code-engine${NC}"
    CHECKS_WARNING=$((CHECKS_WARNING + 1))
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Readiness Summary${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${GREEN}Passed:  ${CHECKS_PASSED}${NC}"
echo -e "${YELLOW}Warnings: ${CHECKS_WARNING}${NC}"
echo -e "${RED}Failed:  ${CHECKS_FAILED}${NC}"
echo ""

if [ $CHECKS_FAILED -eq 0 ] && [ $CHECKS_WARNING -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! You are ready to deploy.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Build and push Docker image:"
    echo "     ./scripts/build_and_push_docker.sh"
    echo ""
    echo "  2. Deploy to Code Engine:"
    echo "     ./scripts/deploy_to_code_engine.sh"
    echo ""
    echo "  3. Test endpoints:"
    echo "     ./scripts/test_endpoints.sh"
    exit 0
elif [ $CHECKS_FAILED -eq 0 ]; then
    echo -e "${YELLOW}⚠ Some warnings detected. Review them before deploying.${NC}"
    echo ""
    echo "You can proceed with deployment, but address warnings for best results."
    exit 0
else
    echo -e "${RED}✗ Some critical checks failed. Fix them before deploying.${NC}"
    echo ""
    echo "Common fixes:"
    echo "  - Install Docker: https://docs.docker.com/get-docker/"
    echo "  - Install IBM Cloud CLI: https://cloud.ibm.com/docs/cli"
    echo "  - Create .env file: cp .env.example .env"
    echo "  - Fill in credentials in .env file"
    exit 1
fi
