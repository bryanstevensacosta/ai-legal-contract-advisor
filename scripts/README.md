# LexConductor - Setup Scripts

**IBM Dev Day AI Demystified Hackathon 2026**  
**Team: AI Kings 👑**

This directory contains utility scripts for setting up and verifying the LexConductor development environment.

## 🚀 Quick Start

### Option 1: Interactive Setup (Recommended)
```bash
./scripts/interactive_setup.sh
```
Guides you step-by-step through the entire IBM Cloud setup process.

### Option 2: Automated Setup (Requires IBM Cloud CLI)
```bash
./scripts/setup_ibm_cloud.sh
```
Automatically creates resources using IBM Cloud CLI.

### Option 3: Manual Setup
Follow the guides:
- English: `docs/IBM_CLOUD_SETUP.md`
- Español: `docs/GUIA_CREDENCIALES_ES.md`

---

## Scripts

### 1. verify_setup.py

**Purpose**: Comprehensive verification of local development environment setup.

**Usage**:
```bash
source .venv/bin/activate
python scripts/verify_setup.py
```

**Checks**:
- ✅ Python version (3.11+ required)
- ✅ All Python packages installed
- ✅ watsonx Orchestrate ADK installed
- ✅ Environment variables configured
- ✅ .gitignore properly configured
- ✅ Project directory structure

**Output**:
- Green ✓ for passed checks
- Red ✗ for failed checks
- Yellow ⚠ for warnings
- Blue ℹ for information

**Exit Codes**:
- `0` - All checks passed
- `1` - Some checks failed

---

### 3. setup_ibm_cloud.sh (NEW)

**Purpose**: Automated IBM Cloud resource creation using IBM Cloud CLI.

**Usage**:
```bash
./scripts/setup_ibm_cloud.sh
```

**Prerequisites**:
- IBM Cloud CLI installed
- Logged in to IBM Cloud (`ibmcloud login --sso`)
- `jq` command-line JSON processor

**What it does**:
- ✅ Creates IBM Cloud API key
- ✅ Creates Cloudant instance with credentials
- ✅ Creates Cloud Object Storage instance with HMAC credentials
- ✅ Creates Code Engine project in Osaka region
- ✅ Saves all credentials to `.env.temp`

**Output**:
- Creates `.env.temp` file with all credentials
- Displays summary of created resources

**Important**:
- Review `.env.temp` before copying to `.env`
- Delete `.env.temp` after copying for security
- watsonx Orchestrate and watsonx.ai credentials must be added manually

---

### 4. interactive_setup.sh (NEW)

**Purpose**: Interactive step-by-step guide for IBM Cloud setup.

**Usage**:
```bash
./scripts/interactive_setup.sh
```

**Prerequisites**:
- Web browser access to IBM Cloud Console
- IBM Cloud account

**What it does**:
- 📋 Guides you through each service setup
- 🔗 Provides direct links to IBM Cloud Console
- ✍️ Collects credentials interactively
- 💾 Saves all credentials to `.env.setup`
- ✅ Validates each step

**Steps**:
1. Create IBM Cloud API Key
2. Create watsonx.ai Project
3. Create Cloudant Instance
4. Create Cloud Object Storage Instance
5. Create Code Engine Project
6. Get watsonx Orchestrate Credentials

**Output**:
- Creates `.env.setup` file with all credentials
- Provides next steps instructions

**Advantages**:
- No CLI installation required
- Visual confirmation at each step
- Beginner-friendly
- Detailed instructions

---

### 2. test_connections.py

**Purpose**: Test connectivity to all IBM Cloud services.

**Usage**:
```bash
source .venv/bin/activate
python scripts/test_connections.py
```

**Tests**:
- 🔗 watsonx.ai connection and Granite model availability
- 🔗 Cloudant database connection and database existence
- 🔗 Cloud Object Storage connection and bucket existence
- 🔗 watsonx Orchestrate credentials configuration

**Prerequisites**:
- IBM Cloud services must be created
- Credentials must be in `.env` file
- Services must be accessible from your network

**Output**:
- Connection status for each service
- Detailed error messages if connection fails
- Summary of all connection tests

**Exit Codes**:
- `0` - All connections successful
- `1` - Some connections failed

---

## Data Population Scripts

### 5. setup_cloudant_databases.py (NEW)

**Purpose**: Create Cloudant databases and indexes for LexConductor.

**Usage**:
```bash
python scripts/setup_cloudant_databases.py
```

**What it does**:
- ✅ Creates `golden_clauses` database with contract_type index
- ✅ Creates `historical_decisions` database with decision_id index
- ✅ Creates `regulatory_mappings` database with jurisdiction index
- ✅ Creates additional indexes for efficient querying

**Prerequisites**:
- Cloudant instance created
- `CLOUDANT_URL` and `CLOUDANT_API_KEY` in `.env`

**Output**:
- Database creation status
- Index creation status
- Verification summary

---

### 6. populate_golden_clauses.py (NEW)

**Purpose**: Populate Golden Clauses collection with sample data.

**Usage**:
```bash
python scripts/populate_golden_clauses.py
```

**What it does**:
- ✅ Adds 15 sample Golden Clauses
- ✅ Covers NDA, MSA, and Service Agreement types
- ✅ Includes liability caps, indemnification, confidentiality, termination clauses
- ✅ Each clause has proper metadata (type, jurisdiction, risk_level, tags)

**Prerequisites**:
- Cloudant databases created (run `setup_cloudant_databases.py` first)

**Output**:
- Clause addition status
- Verification by contract type
- Total clause count

---

### 7. populate_historical_decisions.py (NEW)

**Purpose**: Seed historical precedents for common scenarios.

**Usage**:
```bash
python scripts/populate_historical_decisions.py
```

**What it does**:
- ✅ Adds 10 sample historical decisions
- ✅ Covers NDA, MSA, and Service Agreement types
- ✅ Includes rationale, confidence scores, and regulatory basis
- ✅ Each decision has original and modified clause text

**Prerequisites**:
- Cloudant databases created

**Output**:
- Decision addition status
- Verification by contract type and jurisdiction
- High confidence decision count

---

### 8. setup_cos_buckets.py (NEW)

**Purpose**: Setup Cloud Object Storage bucket and regulatory mappings.

**Usage**:
```bash
python scripts/setup_cos_buckets.py
```

**What it does**:
- ✅ Creates COS bucket: `watsonx-hackathon-regulations`
- ✅ Creates folder structure: EU/, UK/, US/, templates/
- ✅ Populates 13 regulatory mappings in Cloudant
- ✅ Provides instructions for uploading regulatory PDFs

**Prerequisites**:
- COS instance created
- `COS_API_KEY`, `COS_INSTANCE_ID`, `COS_ENDPOINT` in `.env`
- Cloudant databases created

**Output**:
- Bucket creation status
- Folder creation status
- Regulatory mapping addition status
- PDF upload instructions

---

### 9. verify_data_layer.py (NEW)

**Purpose**: Verify complete data layer setup.

**Usage**:
```bash
python scripts/verify_data_layer.py
```

**What it does**:
- ✅ Verifies all Cloudant databases exist with expected document counts
- ✅ Verifies COS bucket exists with folder structure
- ✅ Checks for uploaded PDFs
- ✅ Provides comprehensive verification summary

**Prerequisites**:
- All data population scripts run
- PDFs uploaded to COS (optional, will warn if missing)

**Output**:
- Database verification status
- Document counts by type
- COS bucket verification
- Overall pass/fail summary

---

## Data Population Workflow

Complete data layer setup in order:

```bash
# 1. Create databases and indexes
python scripts/setup_cloudant_databases.py

# 2. Populate Golden Clauses (15 clauses)
python scripts/populate_golden_clauses.py

# 3. Populate Historical Decisions (10 precedents)
python scripts/populate_historical_decisions.py

# 4. Setup COS bucket and regulatory mappings (13 regulations)
python scripts/setup_cos_buckets.py

# 5. Upload regulatory PDFs (manual step - see instructions from step 4)

# 6. Verify everything
python scripts/verify_data_layer.py
```

**See**: `scripts/DATA_POPULATION_README.md` for detailed guide.

---

## Typical Workflow

### Initial Setup

1. **Run setup script**:
   ```bash
   ./setup.sh
   ```

2. **Verify installation**:
   ```bash
   source .venv/bin/activate
   python scripts/verify_setup.py
   ```

3. **Create IBM Cloud services** (see `docs/IBM_CLOUD_SETUP.md`)

4. **Update .env with credentials**

5. **Test connections**:
   ```bash
   python scripts/test_connections.py
   ```

### Daily Development

Before starting work:
```bash
source .venv/bin/activate
python scripts/verify_setup.py
```

After updating dependencies:
```bash
pip install -r requirements.txt
python scripts/verify_setup.py
```

After changing credentials:
```bash
python scripts/test_connections.py
```

---

## Troubleshooting

### verify_setup.py Issues

**Error**: "Python version too old"
- Install Python 3.11 or higher
- Update PATH to use correct Python version

**Error**: "Missing packages"
- Run: `pip install -r requirements.txt`
- Ensure virtual environment is activated

**Error**: "watsonx Orchestrate ADK not found"
- Run: `pip install ibm-watsonx-orchestrate`
- Verify installation: `orchestrate --version`

**Warning**: "Placeholder values detected"
- Update `.env` with actual IBM Cloud credentials
- See `docs/IBM_CLOUD_SETUP.md` for instructions

### test_connections.py Issues

**Error**: "watsonx.ai connection failed"
- Verify `WATSONX_API_KEY` is correct IBM Cloud API key
- Verify `WATSONX_PROJECT_ID` is correct
- Check project access permissions

**Error**: "Cloudant connection failed"
- Verify `CLOUDANT_URL` includes `https://`
- Verify `CLOUDANT_API_KEY` has Manager role
- Check databases exist: `golden_clauses`, `historical_decisions`, `regulatory_mappings`

**Error**: "Cloud Object Storage connection failed"
- Verify HMAC credentials were generated
- Verify `COS_INSTANCE_ID` is correct
- Check bucket exists: `watsonx-hackathon-regulations`

**Error**: "watsonx Orchestrate connection failed"
- Verify `WO_INSTANCE` URL is correct
- Verify `WO_API_KEY` is valid
- Try regenerating API key in Orchestrate settings

---

## Script Details

### verify_setup.py

**Language**: Python 3.11+  
**Dependencies**: Standard library only  
**Runtime**: ~5 seconds  
**Network**: No network calls

**Functions**:
- `check_python_version()` - Verify Python 3.11+
- `check_env_file()` - Check .env exists and has required variables
- `check_dependencies()` - Verify all packages installed
- `check_orchestrate_adk()` - Verify ADK installation
- `check_directory_structure()` - Check project folders
- `check_gitignore()` - Verify security patterns

### test_connections.py

**Language**: Python 3.11+  
**Dependencies**: IBM Cloud SDKs  
**Runtime**: ~10-30 seconds  
**Network**: Makes API calls to IBM Cloud

**Functions**:
- `test_watsonx_ai()` - Test watsonx.ai and list models
- `test_cloudant()` - Test Cloudant and list databases
- `test_cos()` - Test COS and list buckets
- `test_orchestrate()` - Verify Orchestrate credentials

---

## Environment Variables

Both scripts read from `.env` file. Required variables:

```bash
# watsonx Orchestrate
WO_INSTANCE=https://your-instance.watson-orchestrate.ibm.com
WO_API_KEY=your_api_key

# watsonx.ai
WATSONX_API_KEY=your_ibm_cloud_api_key
WATSONX_PROJECT_ID=your_project_id
WATSONX_URL=https://us-south.ml.cloud.ibm.com

# Cloudant
CLOUDANT_URL=https://your-instance.cloudantnosqldb.appdomain.cloud
CLOUDANT_API_KEY=your_api_key

# Cloud Object Storage
COS_ENDPOINT=s3.us-south.cloud-object-storage.appdomain.cloud
COS_API_KEY=your_api_key
COS_INSTANCE_ID=your_instance_id
```

See `.env.example` for complete list.

---

## Security Notes

- ⚠️ Never commit `.env` file to git
- ⚠️ Scripts check for placeholder values
- ⚠️ Credentials are never logged or displayed
- ⚠️ Use separate credentials for dev/test/prod

---

## Contributing

When adding new scripts:

1. Add executable permissions: `chmod +x scripts/your_script.py`
2. Add shebang: `#!/usr/bin/env python3`
3. Add docstring with purpose and usage
4. Use color codes for output (GREEN, RED, YELLOW, BLUE)
5. Return appropriate exit codes (0 = success, 1 = failure)
6. Update this README

---

## Quick Reference

```bash
# Verify setup
python scripts/verify_setup.py

# Test connections
python scripts/test_connections.py

# Both in sequence
python scripts/verify_setup.py && python scripts/test_connections.py

# With verbose output
python scripts/test_connections.py -v  # (if implemented)
```

---

**Last Updated**: January 30, 2026  
**Hackathon Deadline**: February 1, 2026 - 10:00 AM ET

---

*Team: AI Kings 👑*


---

## Deployment Scripts

### 10. build_and_push_docker.sh (NEW)

**Purpose**: Build Docker image and push to IBM Container Registry.

**Usage**:
```bash
export ICR_NAMESPACE="lexconductor"
export IBM_CLOUD_API_KEY="your-api-key"
./scripts/build_and_push_docker.sh
```

**What it does**:
- ✅ Builds Docker image from Dockerfile
- ✅ Logs in to IBM Container Registry
- ✅ Pushes image to ICR
- ✅ Verifies image in registry

**Prerequisites**:
- Docker installed and running
- IBM Cloud CLI installed
- `ICR_NAMESPACE` environment variable set
- `IBM_CLOUD_API_KEY` environment variable set

**Configuration**:
- Registry: `us.icr.io` (default)
- Image name: `lexconductor-agents`
- Tag: `latest` (default, can override with `IMAGE_TAG`)

**Output**:
- Build progress
- Push progress
- Image verification
- Full image name for deployment

---

### 11. deploy_to_code_engine.sh (NEW)

**Purpose**: Deploy the application to IBM Code Engine.

**Usage**:
```bash
# Set required environment variables
export CODE_ENGINE_PROJECT="lexconductor-project"
export ICR_NAMESPACE="lexconductor"
export CLOUDANT_URL="your-cloudant-url"
export CLOUDANT_API_KEY="your-cloudant-api-key"
export COS_ENDPOINT="your-cos-endpoint"
export COS_API_KEY="your-cos-api-key"
export COS_INSTANCE_ID="your-cos-instance-id"
export WATSONX_API_KEY="your-watsonx-api-key"
export WATSONX_PROJECT_ID="your-watsonx-project-id"
export IBM_CLOUD_API_KEY="your-ibm-cloud-api-key"

./scripts/deploy_to_code_engine.sh
```

**What it does**:
- ✅ Logs in to IBM Cloud
- ✅ Creates or selects Code Engine project
- ✅ Creates registry secret for ICR
- ✅ Creates or updates application
- ✅ Configures environment variables
- ✅ Sets auto-scaling and resources
- ✅ Returns application URL

**Configuration**:
- Region: `jp-osa` (Osaka, default)
- Min scale: 0 instances (scales to zero when idle)
- Max scale: 5 instances
- CPU: 1 vCPU
- Memory: 512Mi
- Concurrency: 10 requests/instance
- Port: 8080

**Prerequisites**:
- Docker image pushed to ICR
- All required environment variables set
- IBM Cloud CLI with Code Engine plugin

**Output**:
- Deployment progress
- Application URL
- Application status
- Next steps instructions

---

### 12. test_endpoints.sh (NEW)

**Purpose**: Test all external agent endpoints.

**Usage**:
```bash
# Option 1: Auto-detect URL from Code Engine
./scripts/test_endpoints.sh

# Option 2: Provide URL manually
export BASE_URL="https://your-app-url.com"
./scripts/test_endpoints.sh
```

**What it tests**:
1. ✅ Health check endpoint (GET /health)
2. ✅ Root endpoint (GET /)
3. ✅ Fusion Agent (POST /fusion/analyze)
4. ✅ Routing Agent (POST /routing/classify)
5. ✅ Memory Agent (POST /memory/query)
6. ✅ Traceability Agent (POST /traceability/generate)

**Success criteria**:
- All endpoints return 200 status
- Response times < 5 seconds
- Valid JSON responses

**Prerequisites**:
- Application deployed to Code Engine
- Application is running and accessible
- `jq` command-line JSON processor (optional, for pretty output)

**Output**:
- Test results for each endpoint
- Response times
- Response samples
- Pass/fail summary

**Exit Codes**:
- `0` - All tests passed
- `1` - Some tests failed

---

## Complete Deployment Workflow

### Step-by-Step Deployment

1. **Ensure data layer is setup**:
   ```bash
   python scripts/verify_data_layer.py
   ```

2. **Build and push Docker image**:
   ```bash
   export ICR_NAMESPACE="lexconductor"
   export IBM_CLOUD_API_KEY="your-api-key"
   ./scripts/build_and_push_docker.sh
   ```

3. **Deploy to Code Engine**:
   ```bash
   # Ensure all environment variables are set
   source .env
   ./scripts/deploy_to_code_engine.sh
   ```

4. **Test endpoints**:
   ```bash
   ./scripts/test_endpoints.sh
   ```

5. **Monitor application**:
   ```bash
   ibmcloud ce app logs --name lexconductor-agents --follow
   ```

### Quick Deployment (All Steps)

```bash
# 1. Verify data layer
python scripts/verify_data_layer.py

# 2. Build and push
export ICR_NAMESPACE="lexconductor"
./scripts/build_and_push_docker.sh

# 3. Deploy
./scripts/deploy_to_code_engine.sh

# 4. Test
./scripts/test_endpoints.sh
```

---

## Deployment Troubleshooting

### Docker Build Issues

**Error**: "Docker build failed"
- Check Dockerfile syntax
- Verify `requirements.txt` exists
- Ensure Docker daemon is running
- Check for sufficient disk space

**Error**: "Docker push failed"
- Verify `IBM_CLOUD_API_KEY` is correct
- Check `ICR_NAMESPACE` exists: `ibmcloud cr namespace-list`
- Ensure logged in to ICR
- Check network connectivity

### Code Engine Deployment Issues

**Error**: "Code Engine deployment failed"
- Check all environment variables are set
- Verify image exists in ICR: `ibmcloud cr image-list`
- Check Code Engine project exists: `ibmcloud ce project list`
- Review logs: `ibmcloud ce app logs --name lexconductor-agents`

**Error**: "Application not starting"
- Check application logs for errors
- Verify environment variables are correct
- Check image can run locally: `docker run -p 8080:8080 <image>`
- Verify port 8080 is exposed

**Error**: "Health check failing"
- Test locally first: `curl http://localhost:8080/health`
- Check application logs
- Verify `/health` endpoint exists
- Check startup time (may need to increase timeout)

### Endpoint Test Issues

**Error**: "Endpoint tests failing"
- Verify application is running: `ibmcloud ce app get --name lexconductor-agents`
- Check application URL is correct
- Test health endpoint manually: `curl $APP_URL/health`
- Check application logs for errors
- Verify environment variables are set correctly

**Error**: "Slow response times (>5s)"
- Increase CPU/memory: `ibmcloud ce app update --name lexconductor-agents --cpu 2 --memory 1G`
- Increase minimum scale: `ibmcloud ce app update --name lexconductor-agents --min-scale 1`
- Check watsonx.ai response times
- Review application logs for bottlenecks

---

## Monitoring and Maintenance

### View Application Logs

```bash
# View recent logs
ibmcloud ce app logs --name lexconductor-agents

# Follow logs in real-time
ibmcloud ce app logs --name lexconductor-agents --follow

# View last 100 lines
ibmcloud ce app logs --name lexconductor-agents --tail 100
```

### Check Application Status

```bash
# Get application details
ibmcloud ce app get --name lexconductor-agents

# List all applications
ibmcloud ce app list

# View application events
ibmcloud ce app events --name lexconductor-agents
```

### Update Application

```bash
# Update with new image
./scripts/build_and_push_docker.sh
ibmcloud ce app update --name lexconductor-agents \
  --image us.icr.io/${ICR_NAMESPACE}/lexconductor-agents:latest

# Update environment variables
ibmcloud ce app update --name lexconductor-agents \
  --env CLOUDANT_URL="${NEW_CLOUDANT_URL}"

# Update resources
ibmcloud ce app update --name lexconductor-agents \
  --cpu 2 --memory 1G
```

### Cost Monitoring

```bash
# Check IBM Cloud usage
ibmcloud billing account-usage

# Monitor Code Engine usage
ibmcloud ce project get --name lexconductor-project
```

---

## Additional Resources

- **Deployment Guide**: See `DEPLOYMENT.md` for detailed deployment instructions
- **IBM Cloud Setup**: See `docs/IBM_CLOUD_SETUP.md` for service setup
- **Data Population**: See `scripts/DATA_POPULATION_README.md` for data setup
- **Code Engine Docs**: https://cloud.ibm.com/docs/codeengine
- **Container Registry Docs**: https://cloud.ibm.com/docs/Registry

---

**Deployment Scripts Added**: January 30, 2026  
**Ready for Code Engine Deployment**: ✅
