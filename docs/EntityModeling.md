Entity Modeling in the NDH
================================

## Background: The Payer-Network Data Problem

In the U.S. healthcare system, understanding which doctors are in which insurance networks is a longstanding and unresolved challenge. The issue has grown more complex over time due to the proliferation of health plans and contracting structures.

### Why It Matters:
- Patients want to choose insurance plans that allow them to continue seeing their preferred doctors.
- Patients in rural or underserved areas must ensure that at least one provider of a needed specialty is available within a reasonable distance.
- Marketplace users (e.g., on healthcare.gov) have consistently complained that they cannot determine:
  1. Whether their doctors are in-network.
  2. Whether their prescriptions are covered.

### Policy Response:
- CMS requires Medicare Advantage and healthcare.gov Qualified Health Plans (QHP) to publish provider networks in machine-readable formats.
- Two primary formats exist:
  - **QHP (Qualified Health Plan) JSON** files for ACA marketplace plans.
  - **FHIR Payer Network Endpoints** (public, per the Da Vinci project) for Medicare Advantage and other plans.

---

## Current Data Infrastructure

### 1. QHP JSON Files:
- Hosted on payer websites.
- Linked via a metadata file published by CMS.
- Format has improved over time but remains fragile and difficult to parse.

### 2. Public FHIR Endpoints:
- Should expose which **NPIs** are associated with which plans.
- More reliable due to do pagination and richer schema.
- Quality varies widely:
  - Some endpoints are unreachable.
  - Many do not include NPIs or fail to follow FHIR spec.

### Known Mechanical Challenges:
- Some JSON files are too large for conventional software libraries.
- CMS does not maintain a canonical index of all payer FHIR endpoints.
- Some endpoints fail basic validation or do not include required fields.

**Proposed Mechanical Fix:**
- Create a GitHub dashboard (CI-style) to show ETL success/failure across all known endpoints.
- Provide real-time transparency and peer-pressure incentives.

---

## Data Quality Problems

### 1. Misalignment of Network Membership
- Payers contract with **TINs** (Tax Identification Numbers), not individual NPIs.
- Providers know their NPIs and TINs but may not know their payer contracts.
- Payers know their contracted TINs but not every NPI within them.

### 2. Network Adequacy Misreporting
- Bad addresses and ghost providers inflate network adequacy.
- There is no incentive to maintain accurate provider-level data.
- CMS rules offer some safe harbor to payers who make good faith inquiries, but this has not resolved the problem.

**Industry workaround:** Mystery shopping to verify addresses and insurance participation.

Error rates for in-network status can be 30%–60%.

---

## Missing Identifiers

### 1. TIN (Tax Identification Number)
**Problem:** There is no way to reliably model payer-provider contracts without TINs.

**Fix:** Split responsibility:
- Payers report which TINs are in-network.
- Providers report which NPIs work under which TINs.

### 2. Enumerated Hashed TIN
**Problem:** Payers may contract with the same TIN but with variations (e.g., excluding Dr. Jones).

**Fix:**
- Use a hash of the TIN (for privacy).
- Add an enumerator: `TIN_HASH-001`, `TIN_HASH-002` to distinguish variants of the same organization.

### 3. Network Identifier
**Problem:** There is no way to track shared networks across plans or changes over time.

**Fix:** Create a reusable, persistent identifier for each network configuration.
- Example: A network with 8 TINs used in 6 different plans.
- Allows plans to be updated over time and ensures data deduplication.

### 4. Address Identifier
**Problem:** No consistent, stable identifier for practice locations.
- ZIP codes are tied to postal delivery routes and frequently change.
- Google Maps or OpenStreetMap lookups often return incorrect results.

**Fix:**
- Use one of:
  - Smarty Streets "Smarty Key"
  - OpenStreetMap address shapefile identifiers
  - USPS barcode system (with caveats)
- Ensure address variations (e.g., "St." vs. "Street") collapse to same identity.

---

## TIN Variation Edge Case: Excluded Providers

### The Problem:
- Same TIN used by multiple payers, but one payer excludes a provider.
- e.g., 1,000 NPIs under TIN `12-3456789`, but Molina (for example) excludes one doctor from the contract. Or BCBS chooses to exclude all of the Radiologists from one system in favor of a seperate Radiology contract, etc. 

### Fix:
- `TIN_HASH-001`, `TIN_HASH-002` system lets payers and providers track distinct contractual contexts without disclosing raw TINs.

---

## Use of the GLEIF Standard

### What is GLEIF?
- The **Global Legal Entity Identifier Foundation** issues **LEIs** (Legal Entity Identifiers).
- Used globally in financial services to identify corporate entities.

### Benefits:
- Public, global, hierarchical, and open.
- Could replace or supplement hashed-TIN identifiers in healthcare.
- Allows robust linkage across datasets and compliance contexts.

### Recommendation:
- Adopt a dual system:
  - **Short term:** Hashed TIN + enumerator
  - **Long term:** Transition to **GLEIF LEIs** for all contracting entities

---

## Summary: A Roadmap for Accurate Payer Network Data

### Goals:
- Enable patients to reliably choose insurance plans with needed providers.
- Improve data transparency for marketplace and Medicare Advantage plans.

### Requires:
- Reliable, machine-readable files
- Correctly scoped responsibility between payers and providers
- New identifiers:
  - Tax ID (hashed or LEI)
  - Network ID
  - Address ID

### Future Steps:
- Build dashboards to track data ingestion quality
- Normalize and crosswalk TIN ↔ NPI
- Promote adoption of GLEIF identifiers
- Create an open-source data infrastructure that enables scalable, verifiable provider-directory accuracy

