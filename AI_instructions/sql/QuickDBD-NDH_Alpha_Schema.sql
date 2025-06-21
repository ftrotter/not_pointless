-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/yDhfcP
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- Modify this code to update the DB schema diagram.
-- To reset the sample schema, replace everything with
-- two dots ('..' - without quotes).
-- Features Currently Out Of Scope for the MVP
-- what about mid-leveld?
-- what about the "Am I at the front door where I am covered" problem?
-- Which is a permutation of "Am I at the front door"
-- What about patients complaining about "never there" providers for network adequacy
-- What else should patients/public be able to complain about?
-- What about the search by "Mayo Clinic" brand search problem?
-- What about the "right doctor wrong EHR endpoint" problem?
-- What about the "excluded provider at TIN" problem?
-- What about plan formularies? Do you want to be able to search for a medication and get a plan back?
-- What about provider schedules?
-- What about provider avaiiaiblity?
-- Totally New

CREATE TABLE "Users" (
    "id" INT   NOT NULL,
    "Email" varchar   NOT NULL,
    "FirstName" varchar   NOT NULL,
    "LastName" varchar   NOT NULL,
    "IdentityVerified" boolean   NOT NULL,
    CONSTRAINT "pk_Users" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "UserAccessRole" (
    "id" INT   NOT NULL,
    "User_id" INT   NOT NULL,
    "Role_id" INT   NOT NULL,
    "AccessToNPI" INT   NOT NULL,
    CONSTRAINT "pk_UserAccessRole" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Roles" (
    "id" INT   NOT NULL,
    "Role" varchar(100)   NOT NULL,
    CONSTRAINT "pk_Roles" PRIMARY KEY (
        "id"
     )
);

-- Can be:
-- self_accessing_own_personal_NPI,
-- employer_managing_person_NPI,
-- person_managing_org_NPI,
-- person_owner_org_NPI,
-- service_managing_NPI,
-- CMSadmin_managing_NPI
CREATE TABLE "HealthcareBrand" (
    "id" int(10)   NOT NULL,
    "HealthcareBrand_name" VARCHAR(200)   NOT NULL,
    "TrademarkSerialNumber" VARCHAR(20)   NOT NULL,
    CONSTRAINT "pk_HealthcareBrand" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "OrganizationToHealthcareBrand" (
    "id" int(10)   NOT NULL,
    "HealthcareBrand_id" INT   NOT NULL,
    "Organization_id" INT   NOT NULL,
    CONSTRAINT "pk_OrganizationToHealthcareBrand" PRIMARY KEY (
        "id"
     )
);

-- SOURCED FROM Payer FHIR / JSON Data or from the PUFs/Google Searches etc.
CREATE TABLE "PayerToEndpoint" (
    "PayerID" int   NOT NULL,
    "EndpointID" int   NOT NULL
);

CREATE TABLE "Payer" (
    -- marketplace/network-puf.IssuerID
    "PayerID" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IssuerMarketPlaceMarketingName
    "PayerName" varchar   NOT NULL,
    CONSTRAINT "pk_Payer" PRIMARY KEY (
        "PayerID"
     )
);

-- There are a lot of atributes for plans, not sure how much we need to include
CREATE TABLE "Plans" (
    -- marketplace/plan-attributes-puf.PlanId
    "PlanID" int   NOT NULL,
    "IssuingPayerID" int   NOT NULL,
    "MarketCoverageID" int   NOT NULL,
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "ServiceAreaId" varchar   NOT NULL,
    -- marketplace/plan-attributes-puf.DentalOnlyPlan
    "DentalOnlyPlan" boolean   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanMarketingName
    "PlanMarketingName" varchar   NOT NULL,
    -- marketplace/plan-attributes-puf.HIOSProductId
    "HIOSProductID" varchar   NOT NULL,
    "PlanTypeID" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IsNewPlan
    "IsNewPlan" boolean   NOT NULL,
    CONSTRAINT "pk_Plans" PRIMARY KEY (
        "PlanID"
     )
);

CREATE TABLE "PlanTypes" (
    "ID" int   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanType
    "PlanType" varchar   NOT NULL,
    CONSTRAINT "pk_PlanTypes" PRIMARY KEY (
        "ID"
     )
);

CREATE TABLE "MarketCoverage" (
    "ID" int   NOT NULL,
    -- marketplace/plan-attributes-puf.MarketCoverage
    "MarketCoverage" varchar   NOT NULL,
    CONSTRAINT "pk_MarketCoverage" PRIMARY KEY (
        "ID"
     )
);

CREATE TABLE "NetworksToPlans" (
    "PlanID" int   NOT NULL,
    "NetworkID" int   NOT NULL
);

CREATE TABLE "Networks" (
    -- marketplace/network-puf.NetworkID
    "NetworkID" int   NOT NULL,
    -- marketplace/network-puf.NetworkName
    "NetworkName" varchar   NOT NULL,
    -- marketplace/network-puf.NetworkURL
    "NetworkURL" varchar   NOT NULL,
    CONSTRAINT "pk_Networks" PRIMARY KEY (
        "NetworkID"
     )
);

CREATE TABLE "ServiceArea" (
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "ID" int   NOT NULL,
    -- marketplace/service-area-puf.ServiceAreaName
    "ServiceAreaName" varchar   NOT NULL,
    -- marketplace/service-area-puf.StateCode
    "StateCode" varchar   NOT NULL,
    -- wishlist
    "shape" geometry   NOT NULL,
    CONSTRAINT "pk_ServiceArea" PRIMARY KEY (
        "ID"
     )
);

-- PECOS Sourced initially, then UX Maintained
CREATE TABLE "NetworkToOrg" (
    "NetworkID" int   NOT NULL,
    "Organization_id" int   NOT NULL
);

CREATE TABLE "OrgToEndpoint" (
    "Organization_id" int   NOT NULL,
    "EndpointID" int   NOT NULL
);

CREATE TABLE "EHR_to_NPI" (
    "NPI" int   NOT NULL,
    "EHR_ID" int   NOT NULL
);

CREATE TABLE "EHR" (
    "EHR_ID" int   NOT NULL,
    -- Sourced from CHPL data here https://chpl.healthit.gov/
    "CHPL_ID" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_EHR" PRIMARY KEY (
        "EHR_ID"
     )
);

-- There are multiple sources for addresses: NPPES, PECOS, Multiple claims flow service locations, Payer FHIR servers, etc.
-- Then we feed these throught the International or US Smarty API and keep all of the results.
CREATE TABLE "Address" (
    "id" INT   NOT NULL,
    -- Required for FHIR Locations
    "address_name" VARCHAR(200)   NOT NULL,
    "barcode_delivery_code" VARCHAR(12)   NOT NULL,
    "smarty_key" VARCHAR(10)   NOT NULL,
    "Address_Type_id" INT   NOT NULL,
    "address_us_id" INT   NULL,
    "address_international_id" INT   NULL,
    "address_nonstandard_id" INT   NULL,
    CONSTRAINT "pk_Address" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Address_US" (
    "id" INT   NOT NULL,
    "address_id" INT   NOT NULL,
    "input_id" VARCHAR(36)   NOT NULL,
    "input_index" INT   NOT NULL,
    "candidate_index" INT   NOT NULL,
    "addressee" VARCHAR(64)   NOT NULL,
    "delivery_line_1" VARCHAR(64)   NOT NULL,
    "delivery_line_2" VARCHAR(64)   NOT NULL,
    "last_line" VARCHAR(64)   NOT NULL,
    "delivery_point_barcode" VARCHAR(12)   NOT NULL,
    "urbanization" VARCHAR(64)   NOT NULL,
    "primary_number" VARCHAR(30)   NOT NULL,
    "street_name" VARCHAR(64)   NOT NULL,
    "street_predirection" VARCHAR(16)   NOT NULL,
    "street_postdirection" VARCHAR(16)   NOT NULL,
    "street_suffix" VARCHAR(16)   NOT NULL,
    "secondary_number" VARCHAR(32)   NOT NULL,
    "secondary_designator" VARCHAR(16)   NOT NULL,
    "extra_secondary_number" VARCHAR(32)   NOT NULL,
    "extra_secondary_designator" VARCHAR(16)   NOT NULL,
    "pmb_designator" VARCHAR(16)   NOT NULL,
    "pmb_number" VARCHAR(16)   NOT NULL,
    "city_name" VARCHAR(64)   NOT NULL,
    "default_city_name" VARCHAR(64)   NOT NULL,
    "state_abbreviation" CHAR(2)   NOT NULL,
    "State_id" INT   NOT NULL,
    "zipcode" CHAR(5)   NOT NULL,
    "plus4_code" VARCHAR(4)   NOT NULL,
    "delivery_point" CHAR(2)   NOT NULL,
    "delivery_point_check_digit" CHAR(1)   NOT NULL,
    "record_type" CHAR(1)   NOT NULL,
    "zip_type" VARCHAR(32)   NOT NULL,
    "county_fips" CHAR(5)   NOT NULL,
    "county_name" VARCHAR(64)   NOT NULL,
    "ews_match" CHAR(5)   NOT NULL,
    "carrier_route" CHAR(4)   NOT NULL,
    "congressional_district" CHAR(2)   NOT NULL,
    "building_default_indicator" CHAR(1)   NOT NULL,
    "rdi" VARCHAR(12)   NOT NULL,
    "elot_sequence" VARCHAR(4)   NOT NULL,
    "elot_sort" VARCHAR(4)   NOT NULL,
    "latitude" DECIMAL(9,6)   NOT NULL,
    "longitude" DECIMAL(9,6)   NOT NULL,
    "coordinate_license" INT   NOT NULL,
    "precision" VARCHAR(18)   NOT NULL,
    "time_zone" VARCHAR(48)   NOT NULL,
    "utc_offset" DECIMAL(4,2)   NOT NULL,
    "dst" CHAR(5)   NOT NULL,
    "dpv_match_code" VARCHAR(1)   NOT NULL,
    "dpv_footnotes" VARCHAR(32)   NOT NULL,
    "dpv_cmra" VARCHAR(1)   NOT NULL,
    "dpv_vacant" VARCHAR(1)   NOT NULL,
    "dpv_no_stat" VARCHAR(1)   NOT NULL,
    "active" VARCHAR(1)   NOT NULL,
    "footnotes" VARCHAR(24)   NOT NULL,
    "lacslink_code" VARCHAR(2)   NOT NULL,
    "lacslink_indicator" VARCHAR(1)   NOT NULL,
    "suitelink_match" VARCHAR(5)   NOT NULL,
    "enhanced_match" VARCHAR(64)   NOT NULL,
    CONSTRAINT "pk_Address_US" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Address_International" (
    "id" INT   NOT NULL,
    "address_id" INT   NOT NULL,
    "input_id" VARCHAR(36)   NOT NULL,
    "country" VARCHAR(64)   NOT NULL,
    "geocode" VARCHAR(4)   NOT NULL,
    "language" VARCHAR(6)   NOT NULL,
    "freeform" VARCHAR(512)   NOT NULL,
    "address1" VARCHAR(64)   NOT NULL,
    "address2" VARCHAR(64)   NOT NULL,
    "address3" VARCHAR(64)   NOT NULL,
    "address4" VARCHAR(64)   NOT NULL,
    "organization" VARCHAR(64)   NOT NULL,
    "locality" VARCHAR(64)   NOT NULL,
    "administrative_area" VARCHAR(32)   NOT NULL,
    "postal_code" VARCHAR(16)   NOT NULL,
    "administrative_area_iso2" VARCHAR(8)   NOT NULL,
    "sub_administrative_area" VARCHAR(64)   NOT NULL,
    "country_iso_3" VARCHAR(3)   NOT NULL,
    "premise" VARCHAR(64)   NOT NULL,
    "premise_number" VARCHAR(64)   NOT NULL,
    "thoroughfare" VARCHAR(64)   NOT NULL,
    "latitude" DECIMAL(9,6)   NOT NULL,
    "longitude" DECIMAL(9,6)   NOT NULL,
    "geocode_precision" VARCHAR(32)   NOT NULL,
    "max_geocode_precision" VARCHAR(32)   NOT NULL,
    "address_format" VARCHAR(128)   NOT NULL,
    "verification_status" VARCHAR(32)   NOT NULL,
    "address_precision" VARCHAR(32)   NOT NULL,
    "max_address_precision" VARCHAR(32)   NOT NULL,
    CONSTRAINT "pk_Address_International" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Address_Nonstandard" (
    "id" INT   NOT NULL,
    "address_id" INT   NOT NULL,
    "raw_address" TEXT   NOT NULL,
    "notes" TEXT   NOT NULL,
    CONSTRAINT "pk_Address_Nonstandard" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Credential_LUT" (
    "id" INT   NOT NULL,
    -- i.e. M.D.
    "Credential_acronym" VARCHAR(20)   NOT NULL,
    -- i.e. Medical Doctor
    "Credential_name" VARCHAR(100)   NOT NULL,
    -- for when there is only one source for the credential (unlike medical schools etc)
    "Credential_source_url" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_Credential_LUT" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "IndividualToCredential" (
    "id" int(10)   NOT NULL,
    "Individual_id" int   NOT NULL,
    "Credential_id" int   NOT NULL,
    CONSTRAINT "pk_IndividualToCredential" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Individual" (
    "id" INT   NOT NULL,
    "last_name" VARCHAR(100)   NOT NULL,
    "first_name" VARCHAR(100)   NOT NULL,
    "middle_name" VARCHAR(21)   NOT NULL,
    "name_prefix" VARCHAR(6)   NOT NULL,
    "name_suffix" VARCHAR(6)   NOT NULL,
    "email_address" VARCHAR(200)   NOT NULL,
    "maybe_SSN" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_Individual" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Organization" (
    "id" int(10)   NOT NULL,
    "org_legal_name" VARCHAR(200)   NOT NULL,
    "AuthorizedOfficial_Invidual_id" INT   NOT NULL,
    "ParentOrganization_id" INT   NOT NULL,
    "OrganizationTIN" VARCHAR(10)   NOT NULL,
    "VTIN" VARCHAR(32)   NOT NULL,
    "OrganizationGLIEF" VARCHAR(300)   NOT NULL,
    CONSTRAINT "pk_Organization" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Organization_OrganizationTIN" UNIQUE (
        "OrganizationTIN"
    )
);

CREATE TABLE "NPI" (
    "npi" BIGINT   NOT NULL,
    "entity_type_code" SMALLINT   NOT NULL,
    "replacement_npi" VARCHAR(11)   NOT NULL,
    "enumeration_date" DATE   NOT NULL,
    "last_update_date" DATE   NOT NULL,
    "deactivation_reason_code" VARCHAR(3)   NOT NULL,
    "deactivation_date" DATE   NOT NULL,
    "reactivation_date" DATE   NOT NULL,
    "certification_date" DATE   NOT NULL,
    CONSTRAINT "pk_NPI" PRIMARY KEY (
        "npi"
     )
);

CREATE TABLE "NPI_Individual" (
    "id" INT   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "Individual_id" INT   NOT NULL,
    "is_sole_proprietor" BOOLEAN   NOT NULL,
    "sex_code" CHAR(1)   NOT NULL,
    CONSTRAINT "pk_NPI_Individual" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Organization" (
    "id" INT   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "Organization_id" INT   NOT NULL,
    CONSTRAINT "pk_NPI_Organization" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Identifier_Type_LUT" (
    "id" int   NOT NULL,
    "identifier_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_Identifier_Type_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Identifier_Type_LUT_identifier_type_description" UNIQUE (
        "identifier_type_description"
    )
);

CREATE TABLE "NPI_Identifier" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "identifier" VARCHAR(21)   NOT NULL,
    "identifier_type_code" INTEGER   NOT NULL,
    "state" VARCHAR(3)   NOT NULL,
    "issuer" VARCHAR(81)   NOT NULL,
    CONSTRAINT "pk_NPI_Identifier" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Address_Type_LUT" (
    "id" int   NOT NULL,
    "address_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_Address_Type_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Address_Type_LUT_address_type_description" UNIQUE (
        "address_type_description"
    )
);

CREATE TABLE "Phone_Type_LUT" (
    "id" int   NOT NULL,
    "phone_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_Phone_Type_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Phone_Type_LUT_phone_type_description" UNIQUE (
        "phone_type_description"
    )
);

-- We keep this seperate because there are several state-data-not-address data elements we need it for.
CREATE TABLE "State_Code_LUT" (
    "id" int   NOT NULL,
    "state_code" VARCHAR(100)   NOT NULL,
    "state_name" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_State_Code_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_State_Code_LUT_state_code" UNIQUE (
        "state_code"
    )
);

CREATE TABLE "Orgname_Type_LUT" (
    "id" int   NOT NULL,
    "orgname_description" TEXT   NOT NULL,
    "source_file" TEXT   NOT NULL,
    "source_field" TEXT   NOT NULL,
    CONSTRAINT "pk_Orgname_Type_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Orgname_Type_LUT_orgname_description" UNIQUE (
        "orgname_description"
    )
);

CREATE TABLE "Orgname" (
    "id" int   NOT NULL,
    "Organization_id" INT   NOT NULL,
    "organization_name" VARCHAR(70)   NOT NULL,
    "orgname_type_code" INTEGER   NOT NULL,
    "code_description" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_Orgname" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Address" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "address_type_id" INTEGER   NOT NULL,
    "address_id" INT   NOT NULL,
    CONSTRAINT "pk_NPI_Address" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Phone" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "phone_type_id" INTEGER   NOT NULL,
    "phone_number" VARCHAR(20)   NOT NULL,
    "is_fax" BOOLEAN   NOT NULL,
    CONSTRAINT "pk_NPI_Phone" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Taxonomy" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "NUCC_Taxonomy_Code_id" INT   NOT NULL,
    "license_number" VARCHAR(20)   NOT NULL,
    "license_state_id" INTEGER   NOT NULL,
    "is_primary" BOOLEAN   NOT NULL,
    "taxonomy_group" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_NPI_Taxonomy" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Identifiers" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "identifier" VARCHAR(20)   NOT NULL,
    "type_code" VARCHAR(2)   NOT NULL,
    "state_id" INTEGER   NOT NULL,
    "issuer" VARCHAR(80)   NOT NULL,
    CONSTRAINT "pk_NPI_Identifiers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPI_Endpoint" (
    "id" int   NOT NULL,
    "npi" BIGINT   NOT NULL,
    "Endpoint_id" INT   NOT NULL,
    CONSTRAINT "pk_NPI_Endpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Endpoint_Type_LUT" (
    "id" INT   NOT NULL,
    "identifier_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_Endpoint_Type_LUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_Endpoint_Type_LUT_identifier_type_description" UNIQUE (
        "identifier_type_description"
    )
);

CREATE TABLE "Endpoint" (
    "id" INT   NOT NULL,
    -- for now only FHIR and Direct
    "endpoint_url" VARCHAR(500)   NOT NULL,
    -- endpoint NPPES file as endpoint_description
    "endpoint_name" VARCHAR(100)   NOT NULL,
    -- endpoint NPPES file as endpoint_comments
    "endpoint_desc" VARCHAR(100)   NOT NULL,
    "endpoint_address_id" int   NOT NULL,
    "endpoint_type_id" int   NOT NULL,
    CONSTRAINT "pk_Endpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NUCC_Taxonomy_Code" (
    "id" int   NOT NULL,
    "parent_nucc_taxonomy_code_id" INT   NOT NULL,
    "taxonomy_code" VARCHAR(10)   NOT NULL,
    "tax_grouping" TEXT   NOT NULL,
    "tax_classification" TEXT   NOT NULL,
    "tax_specialization" TEXT   NOT NULL,
    "tax_definition" TEXT   NOT NULL,
    "tax_notes" TEXT   NOT NULL,
    "tax_display_name" TEXT   NOT NULL,
    "tax_certifying_board_name" TEXT   NOT NULL,
    "tax_certifying_board_url" TEXT   NOT NULL,
    CONSTRAINT "pk_NUCC_Taxonomy_Code" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_NUCC_Taxonomy_Code_taxonomy_code" UNIQUE (
        "taxonomy_code"
    )
);

CREATE TABLE "NUCC_Taxonomy_Code_Path" (
    "nucc_taxonomy_code_decendant_id" INT   NOT NULL,
    "nucc_taxonomy_code_ancestor_id" INT   NOT NULL
);

CREATE TABLE "MedicareProviderType" (
    "id" INT   NOT NULL,
    "MedicareProviderType_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_MedicareProviderType" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NUCC_MedicareProviderType" (
    "MedicareProviderType_id" INT   NOT NULL,
    "NUCC_Taxonomy_Code_id" INT   NOT NULL
);

ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_User_id" FOREIGN KEY("User_id")
REFERENCES "Users" ("id");

ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_Role_id" FOREIGN KEY("Role_id")
REFERENCES "Roles" ("id");

ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_AccessToNPI" FOREIGN KEY("AccessToNPI")
REFERENCES "NPI" ("npi");

ALTER TABLE "OrganizationToHealthcareBrand" ADD CONSTRAINT "fk_OrganizationToHealthcareBrand_HealthcareBrand_id" FOREIGN KEY("HealthcareBrand_id")
REFERENCES "HealthcareBrand" ("id");

ALTER TABLE "OrganizationToHealthcareBrand" ADD CONSTRAINT "fk_OrganizationToHealthcareBrand_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "PayerToEndpoint" ADD CONSTRAINT "fk_PayerToEndpoint_PayerID" FOREIGN KEY("PayerID")
REFERENCES "Payer" ("PayerID");

ALTER TABLE "PayerToEndpoint" ADD CONSTRAINT "fk_PayerToEndpoint_EndpointID" FOREIGN KEY("EndpointID")
REFERENCES "Endpoint" ("id");

ALTER TABLE "Plans" ADD CONSTRAINT "fk_Plans_IssuingPayerID" FOREIGN KEY("IssuingPayerID")
REFERENCES "Payer" ("PayerID");

ALTER TABLE "Plans" ADD CONSTRAINT "fk_Plans_MarketCoverageID" FOREIGN KEY("MarketCoverageID")
REFERENCES "MarketCoverage" ("ID");

ALTER TABLE "Plans" ADD CONSTRAINT "fk_Plans_ServiceAreaId" FOREIGN KEY("ServiceAreaId")
REFERENCES "ServiceArea" ("ID");

ALTER TABLE "Plans" ADD CONSTRAINT "fk_Plans_PlanTypeID" FOREIGN KEY("PlanTypeID")
REFERENCES "PlanTypes" ("ID");

ALTER TABLE "NetworksToPlans" ADD CONSTRAINT "fk_NetworksToPlans_PlanID" FOREIGN KEY("PlanID")
REFERENCES "Plans" ("PlanID");

ALTER TABLE "NetworksToPlans" ADD CONSTRAINT "fk_NetworksToPlans_NetworkID" FOREIGN KEY("NetworkID")
REFERENCES "Networks" ("NetworkID");

ALTER TABLE "NetworkToOrg" ADD CONSTRAINT "fk_NetworkToOrg_NetworkID" FOREIGN KEY("NetworkID")
REFERENCES "Networks" ("NetworkID");

ALTER TABLE "NetworkToOrg" ADD CONSTRAINT "fk_NetworkToOrg_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "OrgToEndpoint" ADD CONSTRAINT "fk_OrgToEndpoint_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "OrgToEndpoint" ADD CONSTRAINT "fk_OrgToEndpoint_EndpointID" FOREIGN KEY("EndpointID")
REFERENCES "Endpoint" ("id");

ALTER TABLE "EHR_to_NPI" ADD CONSTRAINT "fk_EHR_to_NPI_NPI" FOREIGN KEY("NPI")
REFERENCES "NPI" ("npi");

ALTER TABLE "EHR_to_NPI" ADD CONSTRAINT "fk_EHR_to_NPI_EHR_ID" FOREIGN KEY("EHR_ID")
REFERENCES "EHR" ("EHR_ID");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_Address_Type_id" FOREIGN KEY("Address_Type_id")
REFERENCES "Address_Type_LUT" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_address_us_id" FOREIGN KEY("address_us_id")
REFERENCES "Address_US" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_address_international_id" FOREIGN KEY("address_international_id")
REFERENCES "Address_International" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_address_nonstandard_id" FOREIGN KEY("address_nonstandard_id")
REFERENCES "Address_Nonstandard" ("id");

ALTER TABLE "Address_US" ADD CONSTRAINT "fk_Address_US_address_id" FOREIGN KEY("address_id")
REFERENCES "Address" ("id");

ALTER TABLE "Address_US" ADD CONSTRAINT "fk_Address_US_State_id" FOREIGN KEY("State_id")
REFERENCES "State_Code_LUT" ("id");

ALTER TABLE "Address_International" ADD CONSTRAINT "fk_Address_International_address_id" FOREIGN KEY("address_id")
REFERENCES "Address" ("id");

ALTER TABLE "Address_Nonstandard" ADD CONSTRAINT "fk_Address_Nonstandard_address_id" FOREIGN KEY("address_id")
REFERENCES "Address" ("id");

ALTER TABLE "IndividualToCredential" ADD CONSTRAINT "fk_IndividualToCredential_Individual_id" FOREIGN KEY("Individual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "IndividualToCredential" ADD CONSTRAINT "fk_IndividualToCredential_Credential_id" FOREIGN KEY("Credential_id")
REFERENCES "Credential_LUT" ("id");

ALTER TABLE "Organization" ADD CONSTRAINT "fk_Organization_AuthorizedOfficial_Invidual_id" FOREIGN KEY("AuthorizedOfficial_Invidual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "Organization" ADD CONSTRAINT "fk_Organization_ParentOrganization_id" FOREIGN KEY("ParentOrganization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "NPI_Individual" ADD CONSTRAINT "fk_NPI_Individual_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Individual" ADD CONSTRAINT "fk_NPI_Individual_Individual_id" FOREIGN KEY("Individual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "NPI_Organization" ADD CONSTRAINT "fk_NPI_Organization_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Organization" ADD CONSTRAINT "fk_NPI_Organization_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "NPI_Identifier" ADD CONSTRAINT "fk_NPI_Identifier_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Identifier" ADD CONSTRAINT "fk_NPI_Identifier_identifier_type_code" FOREIGN KEY("identifier_type_code")
REFERENCES "Identifier_Type_LUT" ("id");

ALTER TABLE "Orgname" ADD CONSTRAINT "fk_Orgname_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "Orgname" ADD CONSTRAINT "fk_Orgname_orgname_type_code" FOREIGN KEY("orgname_type_code")
REFERENCES "Orgname_Type_LUT" ("id");

ALTER TABLE "NPI_Address" ADD CONSTRAINT "fk_NPI_Address_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Address" ADD CONSTRAINT "fk_NPI_Address_address_type_id" FOREIGN KEY("address_type_id")
REFERENCES "Address_Type_LUT" ("id");

ALTER TABLE "NPI_Address" ADD CONSTRAINT "fk_NPI_Address_address_id" FOREIGN KEY("address_id")
REFERENCES "Address" ("id");

ALTER TABLE "NPI_Phone" ADD CONSTRAINT "fk_NPI_Phone_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Phone" ADD CONSTRAINT "fk_NPI_Phone_phone_type_id" FOREIGN KEY("phone_type_id")
REFERENCES "Phone_Type_LUT" ("id");

ALTER TABLE "NPI_Taxonomy" ADD CONSTRAINT "fk_NPI_Taxonomy_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Taxonomy" ADD CONSTRAINT "fk_NPI_Taxonomy_NUCC_Taxonomy_Code_id" FOREIGN KEY("NUCC_Taxonomy_Code_id")
REFERENCES "NUCC_Taxonomy_Code" ("id");

ALTER TABLE "NPI_Taxonomy" ADD CONSTRAINT "fk_NPI_Taxonomy_license_state_id" FOREIGN KEY("license_state_id")
REFERENCES "State_Code_LUT" ("id");

ALTER TABLE "NPI_Identifiers" ADD CONSTRAINT "fk_NPI_Identifiers_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Identifiers" ADD CONSTRAINT "fk_NPI_Identifiers_state_id" FOREIGN KEY("state_id")
REFERENCES "State_Code_LUT" ("id");

ALTER TABLE "NPI_Endpoint" ADD CONSTRAINT "fk_NPI_Endpoint_npi" FOREIGN KEY("npi")
REFERENCES "NPI" ("npi");

ALTER TABLE "NPI_Endpoint" ADD CONSTRAINT "fk_NPI_Endpoint_Endpoint_id" FOREIGN KEY("Endpoint_id")
REFERENCES "Endpoint" ("id");

ALTER TABLE "Endpoint" ADD CONSTRAINT "fk_Endpoint_endpoint_address_id" FOREIGN KEY("endpoint_address_id")
REFERENCES "Address" ("id");

ALTER TABLE "Endpoint" ADD CONSTRAINT "fk_Endpoint_endpoint_type_id" FOREIGN KEY("endpoint_type_id")
REFERENCES "Endpoint_Type_LUT" ("id");

ALTER TABLE "NUCC_Taxonomy_Code" ADD CONSTRAINT "fk_NUCC_Taxonomy_Code_parent_nucc_taxonomy_code_id" FOREIGN KEY("parent_nucc_taxonomy_code_id")
REFERENCES "NUCC_Taxonomy_Code" ("id");

ALTER TABLE "NUCC_Taxonomy_Code_Path" ADD CONSTRAINT "fk_NUCC_Taxonomy_Code_Path_nucc_taxonomy_code_decendant_id" FOREIGN KEY("nucc_taxonomy_code_decendant_id")
REFERENCES "NUCC_Taxonomy_Code" ("id");

ALTER TABLE "NUCC_Taxonomy_Code_Path" ADD CONSTRAINT "fk_NUCC_Taxonomy_Code_Path_nucc_taxonomy_code_ancestor_id" FOREIGN KEY("nucc_taxonomy_code_ancestor_id")
REFERENCES "NUCC_Taxonomy_Code" ("id");

ALTER TABLE "NUCC_MedicareProviderType" ADD CONSTRAINT "fk_NUCC_MedicareProviderType_MedicareProviderType_id" FOREIGN KEY("MedicareProviderType_id")
REFERENCES "MedicareProviderType" ("id");

ALTER TABLE "NUCC_MedicareProviderType" ADD CONSTRAINT "fk_NUCC_MedicareProviderType_NUCC_Taxonomy_Code_id" FOREIGN KEY("NUCC_Taxonomy_Code_id")
REFERENCES "NUCC_Taxonomy_Code" ("id");

