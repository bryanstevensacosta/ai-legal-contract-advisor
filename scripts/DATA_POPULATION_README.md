# Data Layer Population Guide

## Overview

This guide explains how to populate the LexConductor data layer with Golden Clauses, Historical Decisions, and Regulatory Documents for the IBM Dev Day AI Demystified Hackathon 2026.

## Prerequisites

1. **IBM Cloud Account** with access to:
   - IBM Cloudant (NoSQL Database)
   - IBM Cloud Object Storage (COS)

2. **Environment Setup**:
   ```bash
   # Copy environment template
   cp .env.example .env
   
   # Edit .env and add your credentials:
   # - CLOUDANT_URL
   # - CLOUDANT_API_KEY
   # - COS_API_KEY
   # - COS_INSTANCE_ID
   # - COS_ENDPOINT
   ```

3. **Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

## Quick Start

Run all setup scripts in order:

```bash
# 1. Create Cloudant databases and indexes
python scripts/setup_cloudant_databases.py

# 2. Populate Golden Clauses (15 clauses)
python scripts/populate_golden_clauses.py

# 3. Populate Historical Decisions (10 precedents)
python scripts/populate_historical_decisions.py

# 4. Setup COS bucket and regulatory mappings
python scripts/setup_cos_buckets.py

# 5. Verify everything is set up correctly
python scripts/verify_data_layer.py
```

## Detailed Steps

### Step 1: Create Cloudant Databases

**Script**: `setup_cloudant_databases.py`

**What it does**:
- Creates 3 Cloudant databases:
  - `golden_clauses` - Internal policy templates
  - `historical_decisions` - Past contract decisions
  - `regulatory_mappings` - Links to regulatory documents
- Creates indexes for efficient querying

**Run**:
```bash
python scripts/setup_cloudant_databases.py
```

**Expected Output**:
```
✓ Connected to Cloudant: https://your-instance.cloudantnosqldb.appdomain.cloud
✓ Created database: golden_clauses
✓ Created index 'idx_contract_type' on ['contract_types']
...
✅ All databases verified successfully!
```

### Step 2: Populate Golden Clauses

**Script**: `populate_golden_clauses.py`

**What it does**:
- Adds 15 sample Golden Clauses covering:
  - **NDA**: Confidentiality, term duration, return/destruction (3 clauses)
  - **MSA**: Liability cap, indemnification, termination, data protection (4 clauses)
  - **Service Agreement**: SLA, payment terms, IP rights (3 clauses)
  - **Common**: Governing law, force majeure, assignment, entire agreement, data breach (5 clauses)

**Run**:
```bash
python scripts/populate_golden_clauses.py
```

**Expected Output**:
```
✓ Added clause: golden_nda_001 (confidentiality)
✓ Added clause: golden_msa_001 (liability_cap)
...
✅ Successfully added 15 Golden Clauses
```

**Sample Golden Clause**:
```json
{
  "clause_id": "golden_msa_001",
  "type": "liability_cap",
  "contract_types": ["MSA", "Service Agreement"],
  "text": "Liability shall be capped at the lesser of $1,000,000 or fees paid in 12 months...",
  "jurisdiction": "US",
  "mandatory": true,
  "risk_level": "High",
  "tags": ["liability", "cap", "limitation", "damages"]
}
```

### Step 3: Populate Historical Decisions

**Script**: `populate_historical_decisions.py`

**What it does**:
- Adds 10 sample historical decisions covering:
  - **NDA**: Data breach carve-outs, confidentiality exclusions, remedies (3 decisions)
  - **MSA**: Liability caps, data processing, dispute resolution, insurance (4 decisions)
  - **Service Agreement**: SLA, termination, IP rights (3 decisions)
- Each decision includes:
  - Original and modified clause text
  - Rationale for the change
  - Regulatory basis (if applicable)
  - Confidence score (0.88-0.98)

**Run**:
```bash
python scripts/populate_historical_decisions.py
```

**Expected Output**:
```
✓ Added decision: dec_2025_Q4_001 (NDA)
✓ Added decision: dec_2025_Q3_003 (MSA)
...
✅ Successfully added 10 historical decisions
```

**Sample Historical Decision**:
```json
{
  "decision_id": "dec_2025_Q4_001",
  "contract_type": "NDA",
  "clause_modified": "Section 4 - Indemnification",
  "original_text": "Party A shall indemnify Party B for all claims...",
  "modified_text": "...except those arising from data breaches...",
  "rationale": "CCPA 2026 Amendment requires separate treatment of data breach liability",
  "confidence": 0.95,
  "regulatory_basis": ["CCPA_2026", "CPRA_2023"]
}
```

### Step 4: Setup Cloud Object Storage

**Script**: `setup_cos_buckets.py`

**What it does**:
- Creates COS bucket: `watsonx-hackathon-regulations`
- Creates folder structure: `EU/`, `UK/`, `US/`, `templates/`
- Populates 13 regulatory mappings in Cloudant:
  - **EU**: GDPR, AI Act, Digital Markets Act (3 regulations)
  - **UK**: Data Protection Act, Online Safety Act (2 regulations)
  - **US**: CCPA, CPRA, HIPAA, SOX, FTC Act (5 regulations)
  - **Multi-Jurisdiction**: ISO 27001, ISO 27701 (2 standards)

**Run**:
```bash
python scripts/setup_cos_buckets.py
```

**Expected Output**:
```
✓ Created bucket: watsonx-hackathon-regulations
✓ Created folder: EU/
✓ Added mapping: General Data Protection Regulation (GDPR) (EU)
...
📄 REGULATORY PDF UPLOAD INSTRUCTIONS
[Instructions for uploading PDFs]
```

**Regulatory Mappings**:
Each mapping includes:
- Regulation name and type
- Jurisdiction
- COS URL for the PDF document
- Key requirements summary
- Tags for searching

### Step 5: Upload Regulatory PDFs

**Manual Step** - Upload PDF documents to COS bucket

**Option 1: IBM Cloud Console**
1. Go to: https://cloud.ibm.com/objectstorage
2. Select bucket: `watsonx-hackathon-regulations`
3. Upload PDFs to appropriate folders

**Option 2: AWS CLI (S3-compatible)**
```bash
# Configure AWS CLI with COS credentials
aws configure set aws_access_key_id YOUR_COS_API_KEY
aws configure set aws_secret_access_key YOUR_COS_API_KEY

# Upload files
aws s3 cp GDPR_Regulation_2016_679.pdf \
  s3://watsonx-hackathon-regulations/EU/ \
  --endpoint-url https://s3.us-south.cloud-object-storage.appdomain.cloud
```

**Required PDFs** (13 total):
- **EU/** (3): GDPR, AI Act, Digital Markets Act
- **UK/** (2): Data Protection Act, Online Safety Act
- **US/** (5): CCPA, CPRA, HIPAA, SOX, FTC Act
- **templates/** (2): ISO 27001, ISO 27701

**Where to find public regulatory documents**:
- EUR-Lex: https://eur-lex.europa.eu/
- UK Legislation: https://www.legislation.gov.uk/
- US GPO: https://www.govinfo.gov/
- California Legislative Information: https://leginfo.legislature.ca.gov/

### Step 6: Verify Data Layer

**Script**: `verify_data_layer.py`

**What it does**:
- Verifies all Cloudant databases exist and have expected document counts
- Verifies COS bucket exists with folder structure
- Checks for uploaded PDFs
- Provides summary of verification results

**Run**:
```bash
python scripts/verify_data_layer.py
```

**Expected Output**:
```
📚 Verifying Golden Clauses...
  ✓ golden_clauses: 15 documents
    NDA: 5 clauses
    MSA: 7 clauses
    Service Agreement: 8 clauses

📜 Verifying Historical Decisions...
  ✓ historical_decisions: 10 documents
    NDA: 3 decisions
    MSA: 4 decisions
    Service Agreement: 3 decisions

⚖️  Verifying Regulatory Mappings...
  ✓ regulatory_mappings: 13 documents
    US: 5 regulations
    EU: 3 regulations
    UK: 2 regulations
    Multi-Jurisdiction: 2 regulations

🪣 Verifying Cloud Object Storage...
  ✓ Bucket 'watsonx-hackathon-regulations' exists
    EU/: 3 PDFs
    UK/: 2 PDFs
    US/: 5 PDFs
    templates/: 2 PDFs

✅ PASS: Golden Clauses
✅ PASS: Historical Decisions
✅ PASS: Regulatory Mappings
✅ PASS: Cos Bucket

✅ All verifications passed! Data layer is ready.
```

## Data Schema Reference

### Golden Clause Schema

```python
{
  "_id": str,                    # Unique ID (e.g., "golden_nda_001")
  "clause_id": str,              # Clause identifier
  "type": str,                   # Clause type (e.g., "liability_cap")
  "contract_types": List[str],   # Applicable contract types
  "text": str,                   # Full clause text
  "jurisdiction": str,           # US, EU, UK, Multi-Jurisdiction
  "mandatory": bool,             # Is this clause mandatory?
  "risk_level": str,             # Low, Medium, High
  "last_reviewed": str,          # ISO datetime
  "approved_by": str,            # Approver name
  "tags": List[str]              # Search tags
}
```

### Historical Decision Schema

```python
{
  "_id": str,                    # Unique ID (e.g., "dec_2025_Q4_001")
  "decision_id": str,            # Decision identifier
  "contract_type": str,          # NDA, MSA, Service Agreement
  "contract_id": str,            # Original contract ID
  "clause_modified": str,        # Which clause was changed
  "original_text": str,          # Original clause text
  "modified_text": str,          # Modified clause text
  "rationale": str,              # Why the change was made
  "approved_by": str,            # Approver name
  "date": str,                   # ISO datetime
  "jurisdiction": str,           # US, EU, UK, Multi-Jurisdiction
  "confidence": float,           # 0.0-1.0
  "tags": List[str],             # Search tags
  "regulatory_basis": List[str]  # Related regulations
}
```

### Regulatory Mapping Schema

```python
{
  "_id": str,                    # Unique ID (e.g., "reg_eu_gdpr")
  "regulation_id": str,          # Regulation identifier
  "regulation_name": str,        # Full regulation name
  "regulation_type": str,        # Type (e.g., "Data Protection")
  "jurisdiction": str,           # US, EU, UK, Multi-Jurisdiction
  "effective_date": str,         # YYYY-MM-DD
  "cos_url": str,                # Full COS URL to PDF
  "cos_key": str,                # COS object key
  "description": str,            # Brief description
  "key_requirements": List[str], # Main requirements
  "last_updated": str,           # ISO datetime
  "tags": List[str]              # Search tags
}
```

## Troubleshooting

### Issue: "Missing Cloudant credentials"

**Solution**:
1. Check `.env` file exists: `ls -la .env`
2. Verify credentials are set:
   ```bash
   grep CLOUDANT .env
   ```
3. Get credentials from IBM Cloud:
   - Go to: https://cloud.ibm.com/resources
   - Find your Cloudant instance
   - Click "Service credentials"
   - Copy URL and API key

### Issue: "Database already exists"

**Solution**: This is normal if you've run the script before. The script will skip existing databases.

### Issue: "Failed to create bucket"

**Solution**:
1. Check COS credentials in `.env`
2. Verify bucket name is unique (must be globally unique)
3. Check you have permissions to create buckets

### Issue: "No PDFs uploaded yet"

**Solution**: This is expected after initial setup. Follow the PDF upload instructions in Step 5.

### Issue: "Connection timeout"

**Solution**:
1. Check internet connection
2. Verify IBM Cloud services are running
3. Check firewall/proxy settings
4. Try again (temporary network issue)

## Data Statistics

After successful population:

| Database | Documents | Purpose |
|----------|-----------|---------|
| golden_clauses | 15 | Internal policy templates |
| historical_decisions | 10 | Past contract decisions |
| regulatory_mappings | 13 | Links to regulations |
| **Total** | **38** | **Complete data layer** |

**Coverage**:
- Contract Types: NDA, MSA, Service Agreement
- Jurisdictions: US, EU, UK, Multi-Jurisdiction
- Clause Types: 15 different types
- Regulations: 13 major regulations/standards

## Next Steps

After completing data population:

1. **Test Connectivity**:
   ```bash
   python scripts/test_connections.py
   ```

2. **Start Agent Implementation**:
   - Proceed to Task 3 in `.kiro/specs/lex-conductor-implementation/tasks.md`
   - Implement core data models and utilities

3. **Verify Integration**:
   - Test Cloudant queries
   - Test COS document retrieval
   - Test watsonx.ai integration

## Cost Tracking

**Cloudant** (Lite Plan):
- Storage: ~1MB used / 1GB available
- Reads: ~100 / 20 per second limit
- **Cost**: $0 (within free tier)

**Cloud Object Storage** (Lite Plan):
- Storage: ~50MB used / 25GB available
- **Cost**: $0 (within free tier)

**Total Data Layer Cost**: **$0** ✅

## Support

If you encounter issues:

1. Check this README for troubleshooting
2. Review script output for error messages
3. Verify `.env` file has correct credentials
4. Check IBM Cloud service status
5. Contact team members for assistance

---

**Last Updated**: January 30, 2026  
**Team**: AI Kings 👑  
**Hackathon**: IBM Dev Day AI Demystified 2026
