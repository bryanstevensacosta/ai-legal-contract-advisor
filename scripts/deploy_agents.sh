#!/bin/bash

# LexConductor - Deploy Agents to watsonx Orchestrate
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

echo "=========================================="
echo "Deploying Agents to watsonx Orchestrate"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if ADK is installed
if ! command -v orchestrate &> /dev/null; then
    echo -e "${RED}✗${NC} watsonx Orchestrate ADK not found!"
    echo "Please run: ./scripts/setup_orchestrate_adk.sh"
    exit 1
fi

# Check if environment is activated
echo "Checking environment status..."
orchestrate env list | grep -q "prod.*active"
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠${NC} Production environment not active. Activating..."
    orchestrate env activate prod
fi

echo ""
echo "Step 1: Deploying Conductor Agent"
echo "----------------------------------"

echo "Deploying LexConductor_Orchestrator_9985W8..."
orchestrate agents deploy LexConductor_Orchestrator_9985W8

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Conductor agent deployed successfully"
else
    echo -e "${YELLOW}⚠${NC} Warning: Deployment may have failed or agent already deployed"
fi

echo ""
echo "Step 2: Deploying External Agents"
echo "----------------------------------"

# Array of external agent names
external_agents=(
    "fusion-agent"
    "routing-agent"
    "memory-agent"
    "traceability-agent"
)

for agent in "${external_agents[@]}"; do
    echo ""
    echo "Deploying ${agent}..."
    
    orchestrate agents deploy "${agent}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} ${agent} deployed successfully"
    else
        echo -e "${YELLOW}⚠${NC} Warning: ${agent} deployment may have failed"
        echo "  This may be expected if the agent is already deployed."
    fi
    
    # Small delay between deployments
    sleep 2
done

echo ""
echo "Step 3: Verifying Deployments"
echo "------------------------------"

echo ""
echo "Checking Conductor Agent status..."
orchestrate agents get LexConductor_Orchestrator_9985W8

echo ""
echo "Listing all deployed agents..."
orchestrate agents list

echo ""
echo -e "${GREEN}=========================================="
echo "✓ Agent Deployment Complete!"
echo "==========================================${NC}"
echo ""
echo "Deployed agents:"
echo "  1. ✓ LexConductor Orchestrator (Native)"
echo "  2. ✓ Fusion Agent (External)"
echo "  3. ✓ Routing Agent (External)"
echo "  4. ✓ Memory Agent (External)"
echo "  5. ✓ Traceability Agent (External)"
echo ""
echo "Next steps:"
echo "  1. Test integration: ./scripts/test_orchestrate.sh"
echo "  2. View logs: orchestrate agents logs LexConductor_Orchestrator_9985W8"
echo "  3. Open Chat UI: Access watsonx Orchestrate web interface"
echo ""
