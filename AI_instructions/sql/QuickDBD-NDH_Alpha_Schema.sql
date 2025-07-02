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


-- Can be:
-- self_accessing_own_personal_NPI,
-- employer_managing_person_NPI,
-- person_managing_org_NPI,
-- person_owner_org_NPI,
-- service_managing_NPI,
-- CMSadmin_managing_NPI



























ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_User_id" FOREIGN KEY("User_id")
REFERENCES "User" ("id");

ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_Role_id" FOREIGN KEY("Role_id")
REFERENCES "Role" ("id");

ALTER TABLE "UserAccessRole" ADD CONSTRAINT "fk_UserAccessRole_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "OrganizationToHealthcareBrand" ADD CONSTRAINT "fk_OrganizationToHealthcareBrand_HealthcareBrand_id" FOREIGN KEY("HealthcareBrand_id")
REFERENCES "HealthcareBrand" ("id");

ALTER TABLE "OrganizationToHealthcareBrand" ADD CONSTRAINT "fk_OrganizationToHealthcareBrand_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "PayerToEndpoint" ADD CONSTRAINT "fk_PayerToEndpoint_Payer_id" FOREIGN KEY("Payer_id")
REFERENCES "Payer" ("id");

ALTER TABLE "PayerToEndpoint" ADD CONSTRAINT "fk_PayerToEndpoint_Endpoint_id" FOREIGN KEY("Endpoint_id")
REFERENCES "Endpoint" ("id");

ALTER TABLE "Plan" ADD CONSTRAINT "fk_Plan_Payer_id" FOREIGN KEY("Payer_id")
REFERENCES "Payer" ("id");

ALTER TABLE "Plan" ADD CONSTRAINT "fk_Plan_MarketCoverage_id" FOREIGN KEY("MarketCoverage_id")
REFERENCES "MarketCoverage" ("id");

ALTER TABLE "Plan" ADD CONSTRAINT "fk_Plan_ServiceArea_id" FOREIGN KEY("ServiceArea_id")
REFERENCES "ServiceArea" ("id");

ALTER TABLE "Plan" ADD CONSTRAINT "fk_Plan_PlanType_id" FOREIGN KEY("PlanType_id")
REFERENCES "PlanType" ("id");

ALTER TABLE "NetworkToPlan" ADD CONSTRAINT "fk_NetworkToPlan_Plan_id" FOREIGN KEY("Plan_id")
REFERENCES "Plan" ("id");

ALTER TABLE "NetworkToPlan" ADD CONSTRAINT "fk_NetworkToPlan_Network_id" FOREIGN KEY("Network_id")
REFERENCES "Network" ("id");

ALTER TABLE "NetworkToOrg" ADD CONSTRAINT "fk_NetworkToOrg_Network_id" FOREIGN KEY("Network_id")
REFERENCES "Network" ("id");

ALTER TABLE "NetworkToOrg" ADD CONSTRAINT "fk_NetworkToOrg_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "OrgToEndpoint" ADD CONSTRAINT "fk_OrgToEndpoint_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "OrgToEndpoint" ADD CONSTRAINT "fk_OrgToEndpoint_Endpoint_id" FOREIGN KEY("Endpoint_id")
REFERENCES "Endpoint" ("id");

ALTER TABLE "EHRToNPI" ADD CONSTRAINT "fk_EHRToNPI_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "EHRToNPI" ADD CONSTRAINT "fk_EHRToNPI_EHR_id" FOREIGN KEY("EHR_id")
REFERENCES "EHR" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_AddressType_id" FOREIGN KEY("AddressType_id")
REFERENCES "AddressTypeLUT" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_AddressUS_id" FOREIGN KEY("AddressUS_id")
REFERENCES "AddressUS" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_AddressInternational_id" FOREIGN KEY("AddressInternational_id")
REFERENCES "AddressInternational" ("id");

ALTER TABLE "Address" ADD CONSTRAINT "fk_Address_AddressNonstandard_id" FOREIGN KEY("AddressNonstandard_id")
REFERENCES "AddressNonstandard" ("id");

ALTER TABLE "AddressUS" ADD CONSTRAINT "fk_AddressUS_Address_id" FOREIGN KEY("Address_id")
REFERENCES "Address" ("id");

ALTER TABLE "AddressUS" ADD CONSTRAINT "fk_AddressUS_State_id" FOREIGN KEY("State_id")
REFERENCES "StateCodeLUT" ("id");

ALTER TABLE "AddressInternational" ADD CONSTRAINT "fk_AddressInternational_Address_id" FOREIGN KEY("Address_id")
REFERENCES "Address" ("id");

ALTER TABLE "AddressNonstandard" ADD CONSTRAINT "fk_AddressNonstandard_Address_id" FOREIGN KEY("Address_id")
REFERENCES "Address" ("id");

ALTER TABLE "IndividualToCredential" ADD CONSTRAINT "fk_IndividualToCredential_Individual_id" FOREIGN KEY("Individual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "IndividualToCredential" ADD CONSTRAINT "fk_IndividualToCredential_Credential_id" FOREIGN KEY("Credential_id")
REFERENCES "CredentialLUT" ("id");

ALTER TABLE "Organization" ADD CONSTRAINT "fk_Organization_AuthorizedOfficial_Individual_id" FOREIGN KEY("AuthorizedOfficial_Individual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "Organization" ADD CONSTRAINT "fk_Organization_ParentOrganization_id" FOREIGN KEY("ParentOrganization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "NPIIndividual" ADD CONSTRAINT "fk_NPIIndividual_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIIndividual" ADD CONSTRAINT "fk_NPIIndividual_Individual_id" FOREIGN KEY("Individual_id")
REFERENCES "Individual" ("id");

ALTER TABLE "NPIOrganization" ADD CONSTRAINT "fk_NPIOrganization_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIOrganization" ADD CONSTRAINT "fk_NPIOrganization_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "NPIIdentifier" ADD CONSTRAINT "fk_NPIIdentifier_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIIdentifier" ADD CONSTRAINT "fk_NPIIdentifier_IdentifierType_id" FOREIGN KEY("IdentifierType_id")
REFERENCES "IdentifierTypeLUT" ("id");

ALTER TABLE "Orgname" ADD CONSTRAINT "fk_Orgname_Organization_id" FOREIGN KEY("Organization_id")
REFERENCES "Organization" ("id");

ALTER TABLE "Orgname" ADD CONSTRAINT "fk_Orgname_OrgnameType_id" FOREIGN KEY("OrgnameType_id")
REFERENCES "OrgnameTypeLUT" ("id");

ALTER TABLE "NPIAddress" ADD CONSTRAINT "fk_NPIAddress_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIAddress" ADD CONSTRAINT "fk_NPIAddress_AddressType_id" FOREIGN KEY("AddressType_id")
REFERENCES "AddressTypeLUT" ("id");

ALTER TABLE "NPIAddress" ADD CONSTRAINT "fk_NPIAddress_Address_id" FOREIGN KEY("Address_id")
REFERENCES "Address" ("id");

ALTER TABLE "NPIPhone" ADD CONSTRAINT "fk_NPIPhone_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIPhone" ADD CONSTRAINT "fk_NPIPhone_PhoneType_id" FOREIGN KEY("PhoneType_id")
REFERENCES "PhoneTypeLUT" ("id");

ALTER TABLE "NPITaxonomy" ADD CONSTRAINT "fk_NPITaxonomy_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPITaxonomy" ADD CONSTRAINT "fk_NPITaxonomy_NUCCTaxonomyCode_id" FOREIGN KEY("NUCCTaxonomyCode_id")
REFERENCES "NUCCTaxonomyCode" ("id");

ALTER TABLE "NPITaxonomy" ADD CONSTRAINT "fk_NPITaxonomy_StateCode_id" FOREIGN KEY("StateCode_id")
REFERENCES "StateCodeLUT" ("id");

ALTER TABLE "NPIIdentifiers" ADD CONSTRAINT "fk_NPIIdentifiers_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIIdentifiers" ADD CONSTRAINT "fk_NPIIdentifiers_StateCode_id" FOREIGN KEY("StateCode_id")
REFERENCES "StateCodeLUT" ("id");

ALTER TABLE "NPIEndpoint" ADD CONSTRAINT "fk_NPIEndpoint_NPI_id" FOREIGN KEY("NPI_id")
REFERENCES "NPI" ("id");

ALTER TABLE "NPIEndpoint" ADD CONSTRAINT "fk_NPIEndpoint_Endpoint_id" FOREIGN KEY("Endpoint_id")
REFERENCES "Endpoint" ("id");

ALTER TABLE "Endpoint" ADD CONSTRAINT "fk_Endpoint_EndpointAddress_id" FOREIGN KEY("EndpointAddress_id")
REFERENCES "Address" ("id");

ALTER TABLE "Endpoint" ADD CONSTRAINT "fk_Endpoint_EndpointType_id" FOREIGN KEY("EndpointType_id")
REFERENCES "EndpointTypeLUT" ("id");

ALTER TABLE "NUCCTaxonomyCode" ADD CONSTRAINT "fk_NUCCTaxonomyCode_ParentNUCCTaxonomyCode_id" FOREIGN KEY("ParentNUCCTaxonomyCode_id")
REFERENCES "NUCCTaxonomyCode" ("id");

ALTER TABLE "NUCCTaxonomyCodePath" ADD CONSTRAINT "fk_NUCCTaxonomyCodePath_NUCCTaxonomyCodeDecendant_id" FOREIGN KEY("NUCCTaxonomyCodeDecendant_id")
REFERENCES "NUCCTaxonomyCode" ("id");

ALTER TABLE "NUCCTaxonomyCodePath" ADD CONSTRAINT "fk_NUCCTaxonomyCodePath_NUCCTaxonomyCodeAncestor_id" FOREIGN KEY("NUCCTaxonomyCodeAncestor_id")
REFERENCES "NUCCTaxonomyCode" ("id");

ALTER TABLE "NUCCMedicareProviderType" ADD CONSTRAINT "fk_NUCCMedicareProviderType_MedicareProviderType_id" FOREIGN KEY("MedicareProviderType_id")
REFERENCES "MedicareProviderType" ("id");

ALTER TABLE "NUCCMedicareProviderType" ADD CONSTRAINT "fk_NUCCMedicareProviderType_NUCCTaxonomyCode_id" FOREIGN KEY("NUCCTaxonomyCode_id")
REFERENCES "NUCCTaxonomyCode" ("id");
