# watsonx Orchestrate Integration Guide

## LexConductor - IBM Dev Day AI Demystified Hackathon 2026

This guide covers the complete integration of LexConductor with IBM watsonx Orchestrate.

---

## 🎯 Overview

LexConductor uses a **hybrid architecture** combining:
- **Native Orchestrate Agent**: Conductor Agent (orchestrator)
- **External Agents**: Fusion, Routing, Memory, Traceability (via Agent Connect Framework)

This architecture provides:
- ✅ Full watsonx Orchestrate governance and observability
- ✅ Custom business logic in external agents
- ✅ Scalable deployment on IBM Code Engine
- ✅ Transparent multi-agent collaboration

---

## 📋 Prerequisites

Before starting, ensure you have:

1. **IBM Cloud Account** with watsonx Orchestrate access
2. **Environment Variables** configured in `.env`:
   - `WO_INSTANCE` - Your watsonx Orchestrate instance URL
   - `WO_API_KEY` - Your watsonx Orchestrate API key
3. **External Agents Deployed** to Code Engine:
   - URL: `https://lexconductor-agents.25rf0qd39xzz.jp-osa.codeengine.appdomain.cloud`
4. **Python 3.11+** installed
5. **pip** package manager

---

## 🚀 Quick Start (5 Steps)

### Step 1: Install watsonx Orchestrate ADK

```bash
./scripts/setup_orchestrate_adk.sh
```

This script will:
- Install `ibm-watsonx-orchestrate` package
- Configure production environment
- Authenticate with your credentials
- Verify setup

**Expected output:**
```
✓ ADK installed successfully
✓ Environment added successfully
✓ Environment activated
✓ Login successful
```

---

### Step 2: Import Agent Definitions

```bash
./scripts/import_agents.sh
```

This script will:
- Import Conductor Agent (native)
- Import 4 external agent definitions
- Verify all imports

**Expected output:**
```
✓ Conductor agent imported successfully
✓ fusion_agent_external imported successfully
✓ routing_agent_external imported successfully
✓ memory_agent_external imported successfully
✓ traceability_agent_external imported successfully
```

---

### Step 3: Deploy Agents

```bash
./scripts/deploy_agents.sh
```

This script will:
- Deploy Conductor Agent to Orchestrate
- Deploy external agent connectors
- Verify deployment status

**Expected output:**
```
✓ Conductor agent deployed successfully
✓ fusion-agent deployed successfully
✓ routing-agent deployed successfully
✓ memory-agent deployed successfully
✓ traceability-agent deployed successfully
```

---

### Step 4: Test Integration

```bash
./scripts/test_orchestrate.sh
```

This script will:
- Verify agent availability
- Test external agent endpoints
- Check agent logs
- Provide interactive testing instructions

**Expected output:**
```
✓ Conductor agent is available
✓ Health check passed
✓ Fusion agent endpoint responding
✓ Routing agent endpoint responding
✓ Memory agent endpoint responding
✓ Traceability agent endpoint responding
```

---

### Step 5: Test in Chat UI

1. Open watsonx Orchestrate web interface:
   ```
   https://api.eu-de.watson-orchestrate.cloud.ibm.com/instances/7ac2e805-0f88-4084-87d7-07449140ab7d
   ```

2. Navigate to **Chat** interface

3. Select **LexConductor Orchestrator** agent

4. Test with sample query:
   ```
   Analyze this NDA contract:
   
   "The parties agree to maintain confidentiality of all proprietary 
   information for a period of 2 years from the date of disclosure. 
   The receiving party shall not disclose such information to any 
   third party without prior written consent."
   ```

5. Verify the workflow:
   - ✅ Conductor receives request
   - ✅ Delegates to Fusion Agent (signal correlation)
   - ✅ Delegates to Memory Agent (precedent search)
   - ✅ Delegates to Routing Agent (risk classification)
   - ✅ Delegates to Traceability Agent (audit trail)
   - ✅ Returns complete Legal Logic Trace

---

## 🏗️ Architecture

### Agent Collaboration Flow

```
User Query (Chat UI)
    ↓
LexConductor Orchestrator (Native Agent)
    ↓
    ├─→ Fusion Agent (External) ──────┐
    ├─→ Memory Agent (External) ──────┤
    │                                  ├─→ Aggregation
    ├─→ Routing Agent (External) ─────┤
    └─→ Traceability Agent (External) ┘
    ↓
Legal Logic Trace (Response)
```

### Agent Definitions

#### 1. Conductor Agent (Native)
- **Type**: Native watsonx Orchestrate agent
- **Model**: IBM Granite 3 8B Instruct
- **Role**: Primary orchestrator
- **Collaborators**: fusion-agent, routing-agent, memory-agent, traceability-agent
- **File**: `agents/conductor_agent.yaml`

#### 2. Fusion Agent (External)
- **Type**: External agent via Agent Connect
- **Endpoint**: `/fusion/analyze`
- **Role**: Signal correlation and compliance gap detection
- **File**: `agents/fusion_agent_external.yaml`

#### 3. Routing Agent (External)
- **Type**: External agent via Agent Connect
- **Endpoint**: `/routing/classify`
- **Role**: Risk assessment and workflow routing
- **File**: `agents/routing_agent_external.yaml`

#### 4. Memory Agent (External)
- **Type**: External agent via Agent Connect
- **Endpoint**: `/memory/query`
- **Role**: Historical precedent retrieval
- **File**: `agents/memory_agent_external.yaml`

#### 5. Traceability Agent (External)
- **Type**: External agent via Agent Connect
- **Endpoint**: `/traceability/generate`
- **Role**: Legal Logic Trace generation
- **File**: `agents/traceability_agent_external.yaml`

---

## 🔧 Manual Commands

### ADK Environment Management

```bash
# List environments
orchestrate env list

# Activate environment
orchestrate env activate prod

# Check authentication
orchestrate auth status

# Login
orchestrate auth login
```

### Agent Management

```bash
# List all agents
orchestrate agents list

# Get agent details
orchestrate agents get LexConductor_Orchestrator_9985W8

# View agent logs
orchestrate agents logs LexConductor_Orchestrator_9985W8

# Follow logs in real-time
orchestrate agents logs LexConductor_Orchestrator_9985W8 --follow

# Delete agent (if needed)
orchestrate agents delete LexConductor_Orchestrator_9985W8
```

### Interactive Testing

```bash
# Start chat session with agent
orchestrate chat --agent LexConductor_Orchestrator_9985W8

# Test with specific query
echo "Analyze this NDA contract..." | orchestrate chat --agent LexConductor_Orchestrator_9985W8
```

---

## 🐛 Troubleshooting

### Issue: ADK Installation Fails

**Solution:**
```bash
# Upgrade pip first
pip install --upgrade pip

# Install with verbose output
pip install -v ibm-watsonx-orchestrate

# Check Python version (must be 3.11+)
python --version
```

### Issue: Authentication Fails

**Solution:**
```bash
# Verify environment variables
echo $WO_INSTANCE
echo $WO_API_KEY

# Re-add environment
orchestrate env remove prod
orchestrate env add prod --instance $WO_INSTANCE --api-key $WO_API_KEY

# Login again
orchestrate auth login
```

### Issue: Agent Import Fails

**Solution:**
```bash
# Check YAML syntax
cat agents/conductor_agent.yaml | python -m yaml

# Try importing with verbose output
orchestrate agents import -f agents/conductor_agent.yaml --verbose

# Check if agent already exists
orchestrate agents list | grep LexConductor
```

### Issue: External Agent Not Responding

**Solution:**
```bash
# Test Code Engine endpoint directly
curl https://lexconductor-agents.25rf0qd39xzz.jp-osa.codeengine.appdomain.cloud/health

# Check Code Engine logs
ibmcloud ce app logs --name lexconductor-agents --follow

# Verify agent YAML has correct endpoint
cat agents/fusion_agent_external.yaml | grep endpoint
```

### Issue: Conductor Agent Can't Find Collaborators

**Solution:**
```bash
# Verify all external agents are imported
orchestrate agents list

# Check conductor agent collaborators
orchestrate agents get LexConductor_Orchestrator_9985W8 | grep collaborators

# Re-import conductor agent
orchestrate agents import -f agents/conductor_agent.yaml --force
```

---

## 📊 Monitoring & Observability

### View Agent Execution Logs

```bash
# View recent logs
orchestrate agents logs LexConductor_Orchestrator_9985W8 --tail 50

# Follow logs in real-time
orchestrate agents logs LexConductor_Orchestrator_9985W8 --follow

# Filter logs by level
orchestrate agents logs LexConductor_Orchestrator_9985W8 --level ERROR
```

### Check Agent Performance

```bash
# Get agent metrics
orchestrate agents metrics LexConductor_Orchestrator_9985W8

# View execution history
orchestrate agents history LexConductor_Orchestrator_9985W8
```

### Monitor External Agents

```bash
# Check Code Engine application status
ibmcloud ce app get --name lexconductor-agents

# View Code Engine logs
ibmcloud ce app logs --name lexconductor-agents --tail 100

# Check resource usage
ibmcloud ce app events --name lexconductor-agents
```

---

## 🎬 Demo Preparation

### Test Scenarios

#### Scenario 1: Routine NDA (Auto-Approve)
```
Query: "Analyze this standard NDA: Both parties agree to maintain 
confidentiality for 3 years. Standard indemnification applies."

Expected Result:
- Complexity: LOW
- Routing: ROUTINE
- Decision: AUTO_APPROVE
- Confidence: >0.90
```

#### Scenario 2: Service Agreement with Gaps (Paralegal Review)
```
Query: "Review this service agreement: Provider will deliver services 
for $50,000. Payment terms net 30. No liability cap specified."

Expected Result:
- Complexity: MEDIUM
- Routing: STANDARD
- Decision: PARALEGAL_REVIEW
- Gaps: Missing liability cap
- Confidence: 0.70-0.90
```

#### Scenario 3: Complex M&A (GC Escalation)
```
Query: "Analyze this acquisition agreement: Company A acquires Company B 
for $10M. Multiple jurisdictions involved. Complex IP transfer."

Expected Result:
- Complexity: HIGH
- Routing: COMPLEX
- Decision: GC_ESCALATION
- Confidence: <0.70
```

### Recording Demo Video

1. **Open watsonx Orchestrate Chat UI** (≥90 seconds required)
2. **Show agent selection**: Select LexConductor Orchestrator
3. **Submit test query**: Use one of the scenarios above
4. **Show agent collaboration**: Highlight delegation to external agents
5. **Display Legal Logic Trace**: Show complete analysis
6. **Explain results**: Narrate the decision and recommendations

**Video Requirements:**
- ≤3 minutes total
- ≥90 seconds showing Orchestrate UI
- Clear audio narration
- Professional presentation
- Upload to YouTube/Vimeo (PUBLIC)

---

## 📝 Submission Checklist

### watsonx Orchestrate Integration (CRITICAL)

- [x] ADK installed and configured
- [x] Conductor Agent (native) created
- [x] 4 External agents defined
- [x] All agents imported to Orchestrate
- [x] All agents deployed
- [x] Integration tested end-to-end
- [ ] Video demo recorded showing Orchestrate UI
- [ ] Agentic AI statement written explaining integration

### Agentic AI Statement Requirements

Your submission statement must include:

1. **watsonx Orchestrate Usage** (CRITICAL):
   - "LexConductor uses IBM watsonx Orchestrate as the primary orchestration platform"
   - Explain hybrid architecture (native + external agents)

2. **Agent Inventory**:
   - List all 5 agents
   - Specify which are native vs external

3. **Agent Descriptions**:
   - What each agent does
   - Domain expertise
   - Analysis provided

4. **Collaboration Mechanism**:
   - How agents communicate (Agent Connect Framework)
   - Workflow pattern (Conductor delegates to specialists)
   - Result aggregation

5. **Technology Integration**:
   - watsonx.ai Granite 3 8B Instruct
   - IBM Code Engine for external agents
   - IBM Cloudant for data
   - IBM Cloud Object Storage for regulations

---

## 🎯 Success Criteria

### Functional Requirements
- ✅ All 5 agents operational
- ✅ End-to-end workflow completes successfully
- ✅ Response time <10 seconds
- ✅ Legal Logic Trace generated correctly
- ✅ No errors during demo

### Hackathon Requirements
- ✅ watsonx Orchestrate clearly demonstrated
- ✅ Multi-agent collaboration visible
- ✅ Hybrid architecture explained
- ✅ Video shows Orchestrate UI (≥90s)
- ✅ All deliverables submitted before deadline

---

## 📚 Additional Resources

### Official Documentation
- [watsonx Orchestrate Docs](https://www.ibm.com/docs/en/watson-orchestrate)
- [Agent Development Kit](https://developer.watson-orchestrate.ibm.com/)
- [Agent Connect Framework](https://www.ibm.com/docs/en/watson-orchestrate?topic=agents-agent-connect-framework)

### Project Documentation
- `DEPLOYMENT.md` - Code Engine deployment guide
- `README.md` - Project overview
- `.kiro/steering/` - Hackathon guidelines

### Support
- IBM Dev Day Slack: #watsonx-orchestrate
- BeMyApp Support: support@bemyapp.com

---

**Team**: AI Kings 👑  
**Hackathon**: IBM Dev Day AI Demystified 2026  
**Deadline**: February 1, 2026 - 10:00 AM ET

---

## 🚀 Next Steps

1. ✅ Complete Task 6 (watsonx Orchestrate Integration)
2. ⏭️ Task 16-17: Prepare demo environment
3. ⏭️ Task 19: Record video demo
4. ⏭️ Task 20: Write submission statements
5. ⏭️ Task 22: Submit before deadline

**Time Remaining**: ~20 hours until deadline

Good luck! 🎉
