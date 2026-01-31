#!/bin/bash
# LexConductor - Test External Agent Endpoints
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
echo -e "${GREEN}LexConductor - Endpoint Testing${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Configuration
APP_NAME="lexconductor-agents"
BASE_URL="${BASE_URL:-}"

# If BASE_URL not provided, try to get it from Code Engine
if [ -z "$BASE_URL" ]; then
    echo -e "${YELLOW}BASE_URL not provided, attempting to retrieve from Code Engine...${NC}"
    
    # Check if ibmcloud CLI is available
    if command -v ibmcloud &> /dev/null; then
        BASE_URL=$(ibmcloud ce app get --name "${APP_NAME}" --output json 2>/dev/null | jq -r '.status.url')
        
        if [ -z "$BASE_URL" ] || [ "$BASE_URL" == "null" ]; then
            echo -e "${RED}Error: Could not retrieve application URL from Code Engine${NC}"
            echo "Please provide BASE_URL environment variable:"
            echo "  export BASE_URL=https://your-app-url.com"
            echo "  ./scripts/test_endpoints.sh"
            exit 1
        fi
        
        echo -e "${GREEN}✓ Retrieved URL from Code Engine: ${BASE_URL}${NC}"
    else
        echo -e "${RED}Error: ibmcloud CLI not found and BASE_URL not provided${NC}"
        echo "Please provide BASE_URL environment variable:"
        echo "  export BASE_URL=https://your-app-url.com"
        echo "  ./scripts/test_endpoints.sh"
        exit 1
    fi
fi

echo ""
echo -e "${BLUE}Testing endpoints at: ${BASE_URL}${NC}"
echo ""

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0
TOTAL_TESTS=6

# Function to test endpoint
test_endpoint() {
    local test_name="$1"
    local method="$2"
    local endpoint="$3"
    local data="$4"
    local expected_status="${5:-200}"
    
    echo -e "${YELLOW}Testing: ${test_name}${NC}"
    echo "  Endpoint: ${method} ${endpoint}"
    
    # Start timer
    START_TIME=$(date +%s%3N)
    
    # Make request
    if [ "$method" == "GET" ]; then
        RESPONSE=$(curl -s -w "\n%{http_code}" "${BASE_URL}${endpoint}")
    else
        RESPONSE=$(curl -s -w "\n%{http_code}" -X "${method}" "${BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -d "${data}")
    fi
    
    # End timer
    END_TIME=$(date +%s%3N)
    DURATION=$((END_TIME - START_TIME))
    
    # Extract status code (last line)
    STATUS_CODE=$(echo "$RESPONSE" | tail -n 1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    # Check status code
    if [ "$STATUS_CODE" == "$expected_status" ]; then
        echo -e "  ${GREEN}✓ Status: ${STATUS_CODE} (Expected: ${expected_status})${NC}"
        echo -e "  ${GREEN}✓ Response time: ${DURATION}ms${NC}"
        
        # Check if response time is acceptable (<5 seconds = 5000ms)
        if [ "$DURATION" -lt 5000 ]; then
            echo -e "  ${GREEN}✓ Performance: OK (<5s)${NC}"
        else
            echo -e "  ${YELLOW}⚠ Performance: Slow (>5s)${NC}"
        fi
        
        # Pretty print JSON response (first 500 chars)
        if command -v jq &> /dev/null; then
            echo "  Response:"
            echo "$BODY" | jq -C '.' 2>/dev/null | head -n 20 || echo "$BODY" | head -c 500
        else
            echo "  Response: ${BODY:0:500}"
        fi
        
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓ Test passed${NC}"
    else
        echo -e "  ${RED}✗ Status: ${STATUS_CODE} (Expected: ${expected_status})${NC}"
        echo -e "  ${RED}✗ Response time: ${DURATION}ms${NC}"
        echo "  Response: ${BODY:0:500}"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗ Test failed${NC}"
    fi
    
    echo ""
}

# Test 1: Health endpoint
test_endpoint \
    "Health Check" \
    "GET" \
    "/health" \
    "" \
    "200"

# Test 2: Root endpoint
test_endpoint \
    "Root Endpoint" \
    "GET" \
    "/" \
    "" \
    "200"

# Test 3: Fusion Agent - Analyze endpoint
FUSION_DATA='{
  "contract_text": "Party A agrees to indemnify Party B for all claims arising from this agreement. Liability shall be capped at $1,000,000.",
  "contract_type": "NDA",
  "jurisdiction": "US",
  "clauses": [
    {
      "section": "4",
      "title": "Indemnification",
      "text": "Party A shall indemnify Party B for all claims arising from this agreement."
    },
    {
      "section": "5",
      "title": "Liability Cap",
      "text": "Liability shall be capped at $1,000,000."
    }
  ]
}'

test_endpoint \
    "Fusion Agent - Analyze Contract" \
    "POST" \
    "/fusion/analyze" \
    "$FUSION_DATA" \
    "200"

# Test 4: Routing Agent - Classify endpoint
ROUTING_DATA='{
  "fusion_analysis": {
    "internal_signals": [],
    "external_signals": [],
    "historical_signals": [],
    "gaps": [],
    "overall_confidence": 0.95
  },
  "contract_metadata": {
    "type": "NDA",
    "value": 50000,
    "jurisdiction": "US"
  }
}'

test_endpoint \
    "Routing Agent - Classify Contract" \
    "POST" \
    "/routing/classify" \
    "$ROUTING_DATA" \
    "200"

# Test 5: Memory Agent - Query endpoint
MEMORY_DATA='{
  "contract_type": "NDA",
  "jurisdiction": "US",
  "clause_type": "indemnification",
  "limit": 10
}'

test_endpoint \
    "Memory Agent - Query Precedents" \
    "POST" \
    "/memory/query" \
    "$MEMORY_DATA" \
    "200"

# Test 6: Traceability Agent - Generate endpoint
TRACEABILITY_DATA='{
  "contract_id": "NDA-2026-0130-001",
  "contract_type": "NDA",
  "fusion_analysis": {
    "internal_signals": [],
    "external_signals": [],
    "historical_signals": [],
    "gaps": [],
    "overall_confidence": 0.95
  },
  "routing_decision": {
    "complexity": "ROUTINE",
    "risk_level": "LOW",
    "risk_score": 0.15,
    "workflow_path": "AUTO_APPROVE",
    "human_review_required": false,
    "justification": "Low risk contract with high confidence",
    "escalation_level": "NONE"
  },
  "precedents": []
}'

test_endpoint \
    "Traceability Agent - Generate Trace" \
    "POST" \
    "/traceability/generate" \
    "$TRACEABILITY_DATA" \
    "200"

# Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Test Summary${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Total tests: ${TOTAL_TESTS}"
echo -e "${GREEN}Passed: ${TESTS_PASSED}${NC}"
echo -e "${RED}Failed: ${TESTS_FAILED}${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "Your LexConductor external agents are ready for integration with watsonx Orchestrate."
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo ""
    echo "Please check the logs and fix any issues:"
    echo "  ibmcloud ce app logs --name ${APP_NAME}"
    exit 1
fi
