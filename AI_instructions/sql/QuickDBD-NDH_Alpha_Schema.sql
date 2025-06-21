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

CREATE TABLE "User" (
    "id" INT   NOT NULL,
    "Email" varchar   NOT NULL,
    "FirstName" varchar   NOT NULL,
    "LastName" varchar   NOT NULL,
    "IdentityVerified" boolean   NOT NULL,
    CONSTRAINT "pk_User" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "UserAccessRole" (
    "id" INT   NOT NULL,
    "User_id" INT   NOT NULL,
    "Role_id" INT   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    CONSTRAINT "pk_UserAccessRole" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Role" (
    "id" INT   NOT NULL,
    "Role" varchar(100)   NOT NULL,
    CONSTRAINT "pk_Role" PRIMARY KEY (
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
    "id" int   NOT NULL,
    "Payer_id" int   NOT NULL,
    "Endpoint_id" int   NOT NULL,
    CONSTRAINT "pk_PayerToEndpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Payer" (
    -- marketplace/network-puf.IssuerID
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IssuerMarketPlaceMarketingName
    "PayerName" varchar   NOT NULL,
    CONSTRAINT "pk_Payer" PRIMARY KEY (
        "id"
     )
);

-- There are a lot of atributes for plans, not sure how much we need to include
CREATE TABLE "Plan" (
    -- marketplace/plan-attributes-puf.PlanId
    "id" int   NOT NULL,
    "Payer_id" int   NOT NULL,
    "MarketCoverage_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "ServiceArea_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.DentalOnlyPlan
    "DentalOnlyPlan" boolean   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanMarketingName
    "PlanMarketingName" varchar   NOT NULL,
    -- marketplace/plan-attributes-puf.HIOSProductId
    "HIOSProductID" varchar   NOT NULL,
    "PlanType_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IsNewPlan
    "IsNewPlan" boolean   NOT NULL,
    CONSTRAINT "pk_Plan" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "PlanType" (
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanType
    "PlanType" varchar   NOT NULL,
    CONSTRAINT "pk_PlanType" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "MarketCoverage" (
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.MarketCoverage
    "MarketCoverage" varchar   NOT NULL,
    CONSTRAINT "pk_MarketCoverage" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NetworkToPlan" (
    "id" int   NOT NULL,
    "Plan_id" int   NOT NULL,
    "Network_id" int   NOT NULL,
    CONSTRAINT "pk_NetworkToPlan" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Network" (
    -- marketplace/network-puf.NetworkID
    "id" int   NOT NULL,
    -- marketplace/network-puf.NetworkName
    "NetworkName" varchar   NOT NULL,
    -- marketplace/network-puf.NetworkURL
    "NetworkURL" varchar   NOT NULL,
    CONSTRAINT "pk_Network" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "ServiceArea" (
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "id" int   NOT NULL,
    -- marketplace/service-area-puf.ServiceAreaName
    "ServiceAreaName" varchar   NOT NULL,
    -- marketplace/service-area-puf.StateCode
    "StateCode" varchar   NOT NULL,
    -- wishlist
    "shape" geometry   NOT NULL,
    CONSTRAINT "pk_ServiceArea" PRIMARY KEY (
        "id"
     )
);

-- PECOS Sourced initially, then UX Maintained
CREATE TABLE "NetworkToOrg" (
    "id" int   NOT NULL,
    "Network_id" int   NOT NULL,
    "Organization_id" int   NOT NULL,
    CONSTRAINT "pk_NetworkToOrg" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "OrgToEndpoint" (
    "id" int   NOT NULL,
    "Organization_id" int   NOT NULL,
    "Endpoint_id" int   NOT NULL,
    CONSTRAINT "pk_OrgToEndpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "EHRToNPI" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "EHR_id" int   NOT NULL,
    CONSTRAINT "pk_EHRToNPI" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "EHR" (
    "id" int   NOT NULL,
    -- Sourced from CHPL data here https://chpl.healthit.gov/
    "CHPL_ID" VARCHAR(200)   NOT NULL,
    CONSTRAINT "pk_EHR" PRIMARY KEY (
        "id"
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
    "AddressType_id" INT   NOT NULL,
    "AddressUS_id" INT   NULL,
    "AddressInternational_id" INT   NULL,
    "AddressNonstandard_id" INT   NULL,
    CONSTRAINT "pk_Address" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "AddressUS" (
    "id" INT   NOT NULL,
    "Address_id" INT   NOT NULL,
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
    CONSTRAINT "pk_AddressUS" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "AddressInternational" (
    "id" INT   NOT NULL,
    "Address_id" INT   NOT NULL,
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
    CONSTRAINT "pk_AddressInternational" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "AddressNonstandard" (
    "id" INT   NOT NULL,
    "Address_id" INT   NOT NULL,
    "raw_address" TEXT   NOT NULL,
    "notes" TEXT   NOT NULL,
    CONSTRAINT "pk_AddressNonstandard" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "CredentialLUT" (
    "id" INT   NOT NULL,
    -- i.e. M.D.
    "Credential_acronym" VARCHAR(20)   NOT NULL,
    -- i.e. Medical Doctor
    "Credential_name" VARCHAR(100)   NOT NULL,
    -- for when there is only one source for the credential (unlike medical schools etc)
    "Credential_source_url" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_CredentialLUT" PRIMARY KEY (
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
    "AuthorizedOfficial_Individual_id" INT   NOT NULL,
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
    "id" BIGINT   NOT NULL,
    "entity_type_code" SMALLINT   NOT NULL,
    "replacement_npi" VARCHAR(11)   NOT NULL,
    "enumeration_date" DATE   NOT NULL,
    "last_update_date" DATE   NOT NULL,
    "deactivation_reason_code" VARCHAR(3)   NOT NULL,
    "deactivation_date" DATE   NOT NULL,
    "reactivation_date" DATE   NOT NULL,
    "certification_date" DATE   NOT NULL,
    CONSTRAINT "pk_NPI" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIIndividual" (
    "id" INT   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "Individual_id" INT   NOT NULL,
    "is_sole_proprietor" BOOLEAN   NOT NULL,
    "sex_code" CHAR(1)   NOT NULL,
    CONSTRAINT "pk_NPIIndividual" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIOrganization" (
    "id" INT   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "Organization_id" INT   NOT NULL,
    CONSTRAINT "pk_NPIOrganization" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "IdentifierTypeLUT" (
    "id" int   NOT NULL,
    "identifier_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_IdentifierTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_IdentifierTypeLUT_identifier_type_description" UNIQUE (
        "identifier_type_description"
    )
);

CREATE TABLE "NPIIdentifier" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "identifier" VARCHAR(21)   NOT NULL,
    "IdentifierType_id" INTEGER   NOT NULL,
    "state" VARCHAR(3)   NOT NULL,
    "issuer" VARCHAR(81)   NOT NULL,
    CONSTRAINT "pk_NPIIdentifier" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "AddressTypeLUT" (
    "id" int   NOT NULL,
    "address_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_AddressTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_AddressTypeLUT_address_type_description" UNIQUE (
        "address_type_description"
    )
);

CREATE TABLE "PhoneTypeLUT" (
    "id" int   NOT NULL,
    "phone_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_PhoneTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_PhoneTypeLUT_phone_type_description" UNIQUE (
        "phone_type_description"
    )
);

-- We keep this seperate because there are several state-data-not-address data elements we need it for.
CREATE TABLE "StateCodeLUT" (
    "id" int   NOT NULL,
    "state_code" VARCHAR(100)   NOT NULL,
    "state_name" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_StateCodeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_StateCodeLUT_state_code" UNIQUE (
        "state_code"
    )
);

CREATE TABLE "OrgnameTypeLUT" (
    "id" int   NOT NULL,
    "orgname_description" TEXT   NOT NULL,
    "source_file" TEXT   NOT NULL,
    "source_field" TEXT   NOT NULL,
    CONSTRAINT "pk_OrgnameTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_OrgnameTypeLUT_orgname_description" UNIQUE (
        "orgname_description"
    )
);

CREATE TABLE "Orgname" (
    "id" int   NOT NULL,
    "Organization_id" INT   NOT NULL,
    "organization_name" VARCHAR(70)   NOT NULL,
    "OrgnameType_id" INTEGER   NOT NULL,
    "code_description" VARCHAR(100)   NOT NULL,
    CONSTRAINT "pk_Orgname" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIAddress" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "AddressType_id" INTEGER   NOT NULL,
    "Address_id" INT   NOT NULL,
    CONSTRAINT "pk_NPIAddress" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIPhone" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "PhoneType_id" INTEGER   NOT NULL,
    "phone_number" VARCHAR(20)   NOT NULL,
    "is_fax" BOOLEAN   NOT NULL,
    CONSTRAINT "pk_NPIPhone" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPITaxonomy" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "NUCCTaxonomyCode_id" INT   NOT NULL,
    "license_number" VARCHAR(20)   NOT NULL,
    "StateCode_id" INTEGER   NOT NULL,
    "is_primary" BOOLEAN   NOT NULL,
    "taxonomy_group" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_NPITaxonomy" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIIdentifiers" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "identifier" VARCHAR(20)   NOT NULL,
    "type_code" VARCHAR(2)   NOT NULL,
    "StateCode_id" INTEGER   NOT NULL,
    "issuer" VARCHAR(80)   NOT NULL,
    CONSTRAINT "pk_NPIIdentifiers" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NPIEndpoint" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "Endpoint_id" INT   NOT NULL,
    CONSTRAINT "pk_NPIEndpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "EndpointTypeLUT" (
    "id" INT   NOT NULL,
    "identifier_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_EndpointTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_EndpointTypeLUT_identifier_type_description" UNIQUE (
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
    "EndpointAddress_id" int   NOT NULL,
    "EndpointType_id" int   NOT NULL,
    CONSTRAINT "pk_Endpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NUCCTaxonomyCode" (
    "id" int   NOT NULL,
    "ParentNUCCTaxonomyCode_id" INT   NOT NULL,
    "taxonomy_code" VARCHAR(10)   NOT NULL,
    "tax_grouping" TEXT   NOT NULL,
    "tax_classification" TEXT   NOT NULL,
    "tax_specialization" TEXT   NOT NULL,
    "tax_definition" TEXT   NOT NULL,
    "tax_notes" TEXT   NOT NULL,
    "tax_display_name" TEXT   NOT NULL,
    "tax_certifying_board_name" TEXT   NOT NULL,
    "tax_certifying_board_url" TEXT   NOT NULL,
    CONSTRAINT "pk_NUCCTaxonomyCode" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_NUCCTaxonomyCode_taxonomy_code" UNIQUE (
        "taxonomy_code"
    )
);

CREATE TABLE "NUCCTaxonomyCodePath" (
    "id" int   NOT NULL,
    "NUCCTaxonomyCodeDecendant_id" INT   NOT NULL,
    "NUCCTaxonomyCodeAncestor_id" INT   NOT NULL,
    CONSTRAINT "pk_NUCCTaxonomyCodePath" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "MedicareProviderType" (
    "id" INT   NOT NULL,
    "MedicareProviderType_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_MedicareProviderType" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NUCCMedicareProviderType" (
    "id" int   NOT NULL,
    "MedicareProviderType_id" INT   NOT NULL,
    "NUCCTaxonomyCode_id" INT   NOT NULL,
    CONSTRAINT "pk_NUCCMedicareProviderType" PRIMARY KEY (
        "id"
     )
);

