#!/bin/bash

# LexConductor - Import Agents to watsonx Orchestrate
# IBM Dev Day AI Demystified Hackathon 2026
# Team: AI Kings 👑

set -e  # Exit on error

echo "=========================================="
echo "Importing Agents to watsonx Orchestrate"
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
echo "Step 1: Importing Conductor Agent (Native)"
echo "-------------------------------------------"

if [ -f "agents/conductor_agent.yaml" ]; then
    echo "Importing conductor agent..."
    orchestrate agents import -f agents/conductor_agent.yaml
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Conductor agent imported successfully"
    else
        echo -e "${RED}✗${NC} Failed to import conductor agent"
        exit 1
    fi
else
    echo -e "${RED}✗${NC} conductor_agent.yaml not found!"
    exit 1
fi

echo ""
echo "Step 2: Importing External Agents"
echo "----------------------------------"

# Array of external agents
external_agents=(
    "fusion_agent_external"
    "routing_agent_external"
    "memory_agent_external"
    "traceability_agent_external"
)

for agent in "${external_agents[@]}"; do
    echo ""
    echo "Importing ${agent}..."
    
    if [ -f "agents/${agent}.yaml" ]; then
        orchestrate agents import -f "agents/${agent}.yaml"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓${NC} ${agent} imported successfully"
        else
            echo -e "${YELLOW}⚠${NC} Warning: Failed to import ${agent}"
            echo "  This may be expected if the agent already exists."
        fi
    else
        echo -e "${RED}✗${NC} ${agent}.yaml not found!"
    fi
done

echo ""
echo "Step 3: Verifying Imported Agents"
echo "----------------------------------"

echo "Listing all agents..."
orchestrate agents list

echo ""
echo -e "${GREEN}=========================================="
echo "✓ Agent Import Complete!"
echo "==========================================${NC}"
echo ""
echo "Imported agents:"
echo "  1. LexConductor Orchestrator (Native)"
echo "  2. Fusion Agent (External)"
echo "  3. Routing Agent (External)"
echo "  4. Memory Agent (External)"
echo "  5. Traceability Agent (External)"
echo ""
echo "Next steps:"
echo "  1. Deploy agents: ./scripts/deploy_agents.sh"
echo "  2. Test integration: ./scripts/test_orchestrate.sh"
echo ""
