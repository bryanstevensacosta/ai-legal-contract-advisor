# LexConductor - Deployment Guide

This guide covers deploying the LexConductor external agents to IBM Code Engine.

## Prerequisites

Before deploying, ensure you have:

1. **IBM Cloud Account** with access to:
   - IBM Container Registry (ICR)
   - IBM Code Engine
   - watsonx.ai
   - Cloudant
   - Cloud Object Storage

2. **IBM Cloud CLI** installed:
   ```bash
   curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
   ```

3. **Docker** installed and running

4. **Environment Variables** configured (see `.env.example`)

## Step 1: Setup IBM Cloud CLI

```bash
# Login to IBM Cloud
ibmcloud login --apikey $IBM_CLOUD_API_KEY -r us-south

# Install Container Registry plugin
ibmcloud plugin install container-registry

# Install Code Engine plugin
ibmcloud plugin install code-engine

# Target your resource group
ibmcloud target -g Default
```

## Step 2: Create Container Registry Namespace

```bash
# Create a namespace (one-time setup)
export ICR_NAMESPACE="lexconductor"
ibmcloud cr namespace-add $ICR_NAMESPACE

# Verify namespace
ibmcloud cr namespace-list
```

## Step 3: Build and Push Docker Image

### Option A: Using the provided script (Recommended)

```bash
# Set required environment variables
export ICR_NAMESPACE="lexconductor"
export IBM_CLOUD_API_KEY="your-api-key-here"

# Run the build and push script
./scripts/build_and_push_docker.sh
```

### Option B: Manual build and push

```bash
# Set variables
export ICR_NAMESPACE="lexconductor"
export ICR_REGION="us.icr.io"
export IMAGE_NAME="lexconductor-agents"
export IMAGE_TAG="latest"

# Build the Docker image
docker build -t ${ICR_REGION}/${ICR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG} .

# Login to IBM Container Registry
echo "$IBM_CLOUD_API_KEY" | docker login -u iamapikey --password-stdin ${ICR_REGION}

# Push the image
docker push ${ICR_REGION}/${ICR_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}

# Verify the image
ibmcloud cr image-list --restrict ${ICR_NAMESPACE}/${IMAGE_NAME}
```

## Step 4: Deploy to Code Engine

### Option A: Using the provided script (Recommended)

```bash
# Set required environment variables
export CODE_ENGINE_PROJECT="lexconductor-project"
export ICR_NAMESPACE="lexconductor"

# Set your service credentials
export CLOUDANT_URL="your-cloudant-url"
export CLOUDANT_API_KEY="your-cloudant-api-key"
export COS_ENDPOINT="your-cos-endpoint"
export COS_API_KEY="your-cos-api-key"
export COS_INSTANCE_ID="your-cos-instance-id"
export WATSONX_API_KEY="your-watsonx-api-key"
export WATSONX_PROJECT_ID="your-watsonx-project-id"

# Run the deployment script
./scripts/deploy_to_code_engine.sh
```

### Option B: Manual deployment

```bash
# Create Code Engine project (one-time setup)
ibmcloud ce project create --name lexconductor-project --region jp-osa

# Select the project
ibmcloud ce project select --name lexconductor-project

# Create the application
ibmcloud ce app create \
  --name lexconductor-agents \
  --image us.icr.io/${ICR_NAMESPACE}/lexconductor-agents:latest \
  --registry-secret icr-secret \
  --port 8080 \
  --min-scale 0 \
  --max-scale 5 \
  --cpu 1 \
  --memory 512M \
  --concurrency 10 \
  --env CLOUDANT_URL="${CLOUDANT_URL}" \
  --env CLOUDANT_API_KEY="${CLOUDANT_API_KEY}" \
  --env COS_ENDPOINT="${COS_ENDPOINT}" \
  --env COS_API_KEY="${COS_API_KEY}" \
  --env COS_INSTANCE_ID="${COS_INSTANCE_ID}" \
  --env WATSONX_API_KEY="${WATSONX_API_KEY}" \
  --env WATSONX_PROJECT_ID="${WATSONX_PROJECT_ID}"

# Get the application URL
ibmcloud ce app get --name lexconductor-agents
```

## Step 5: Test the Deployment

### Test health endpoint

```bash
# Get the application URL
export APP_URL=$(ibmcloud ce app get --name lexconductor-agents --output json | jq -r '.status.url')

# Test health endpoint
curl ${APP_URL}/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-30T12:00:00.000000",
  "service": "lexconductor-agents"
}
```

### Test Fusion Agent endpoint

```bash
curl -X POST ${APP_URL}/fusion/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "contract_text": "Party A agrees to indemnify Party B...",
    "contract_type": "NDA",
    "jurisdiction": "US",
    "clauses": [
      {
        "section": "4",
        "title": "Indemnification",
        "text": "Party A shall indemnify..."
      }
    ]
  }'
```

### Test Routing Agent endpoint

```bash
curl -X POST ${APP_URL}/routing/classify \
  -H "Content-Type: application/json" \
  -d '{
    "fusion_analysis": {
      "gaps": [],
      "overall_confidence": 0.95
    },
    "contract_metadata": {
      "type": "NDA",
      "value": 50000,
      "jurisdiction": "US"
    }
  }'
```

### Test Memory Agent endpoint

```bash
curl -X POST ${APP_URL}/memory/query \
  -H "Content-Type: application/json" \
  -d '{
    "contract_type": "NDA",
    "jurisdiction": "US",
    "clause_type": "indemnification",
    "limit": 10
  }'
```

### Test Traceability Agent endpoint

```bash
curl -X POST ${APP_URL}/traceability/generate \
  -H "Content-Type: application/json" \
  -d '{
    "contract_id": "NDA-2026-0130-001",
    "contract_type": "NDA",
    "fusion_analysis": {},
    "routing_decision": {},
    "precedents": []
  }'
```

## Step 6: Monitor the Application

### View logs

```bash
# View recent logs
ibmcloud ce app logs --name lexconductor-agents

# Follow logs in real-time
ibmcloud ce app logs --name lexconductor-agents --follow
```

### Check application status

```bash
# Get application details
ibmcloud ce app get --name lexconductor-agents

# List all applications
ibmcloud ce app list
```

### Monitor metrics

```bash
# View application events
ibmcloud ce app events --name lexconductor-agents
```

## Updating the Application

### Update with new image

```bash
# Build and push new image
./scripts/build_and_push_docker.sh

# Update the application
ibmcloud ce app update --name lexconductor-agents \
  --image us.icr.io/${ICR_NAMESPACE}/lexconductor-agents:latest
```

### Update environment variables

```bash
ibmcloud ce app update --name lexconductor-agents \
  --env CLOUDANT_URL="${NEW_CLOUDANT_URL}"
```

## Troubleshooting

### Application not starting

1. Check logs:
   ```bash
   ibmcloud ce app logs --name lexconductor-agents --tail 100
   ```

2. Verify environment variables:
   ```bash
   ibmcloud ce app get --name lexconductor-agents --output json | jq '.spec.template.spec.containers[0].env'
   ```

3. Check image exists:
   ```bash
   ibmcloud cr image-list --restrict ${ICR_NAMESPACE}/lexconductor-agents
   ```

### Health check failing

1. Test locally first:
   ```bash
   docker run -p 8080:8080 us.icr.io/${ICR_NAMESPACE}/lexconductor-agents:latest
   curl http://localhost:8080/health
   ```

2. Check application logs for errors

### Slow response times

1. Increase resources:
   ```bash
   ibmcloud ce app update --name lexconductor-agents \
     --cpu 2 \
     --memory 1G
   ```

2. Increase minimum scale:
   ```bash
   ibmcloud ce app update --name lexconductor-agents \
     --min-scale 1
   ```

## Cost Optimization

### Free tier limits

- Code Engine: 100,000 vCPU-seconds/month free
- Container Registry: 500MB storage free
- Bandwidth: 5GB/month free

### Recommendations

1. Use `--min-scale 0` to scale to zero when idle
2. Use smaller CPU/memory allocations (0.5 CPU, 512M memory)
3. Set appropriate concurrency (10-20 requests per instance)
4. Monitor usage with:
   ```bash
   ibmcloud billing account-usage
   ```

## Security Best Practices

1. **Never commit credentials**:
   - Use environment variables
   - Use `.env` files (excluded from git)
   - Rotate API keys regularly

2. **Use registry secrets**:
   ```bash
   ibmcloud ce registry create --name icr-secret \
     --server us.icr.io \
     --username iamapikey \
     --password $IBM_CLOUD_API_KEY
   ```

3. **Limit access**:
   - Use least privilege IAM policies
   - Restrict network access if possible
   - Enable audit logging

## Cleanup

### Delete the application

```bash
ibmcloud ce app delete --name lexconductor-agents --force
```

### Delete the project

```bash
ibmcloud ce project delete --name lexconductor-project --force
```

### Delete the image

```bash
ibmcloud cr image-rm us.icr.io/${ICR_NAMESPACE}/lexconductor-agents:latest
```

### Delete the namespace

```bash
ibmcloud cr namespace-rm ${ICR_NAMESPACE} --force
```

## Additional Resources

- [IBM Code Engine Documentation](https://cloud.ibm.com/docs/codeengine)
- [IBM Container Registry Documentation](https://cloud.ibm.com/docs/Registry)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Docker Documentation](https://docs.docker.com/)

## Support

For issues or questions:
1. Check the logs: `ibmcloud ce app logs --name lexconductor-agents`
2. Review the troubleshooting section above
3. Contact IBM Cloud Support
4. Check the hackathon Slack channels

---

**Last Updated**: January 30, 2026  
**Team**: AI Kings 👑  
**Hackathon**: IBM Dev Day AI Demystified 2026
