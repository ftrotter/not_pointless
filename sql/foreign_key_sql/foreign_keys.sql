-- Generated PostgreSQL Foreign Key Statements
-- Source: DURC relational model
-- Generated on: 2025-07-02 02:22:55
-- Command: durc-mine-fkeys --input_json_file durc_config/DURC_relational_model.json --output_sql_file ./sql/foreign_key_sql/foreign_keys.sql

-- Database: postgres
ALTER TABLE postgres.address_international ADD CONSTRAINT fk_address_international_address_id FOREIGN KEY (address_id) REFERENCES postgres.address(id);
ALTER TABLE postgres.address ADD CONSTRAINT fk_address_address_us_id FOREIGN KEY (address_us_id) REFERENCES postgres.address_us(id);
ALTER TABLE postgres.address ADD CONSTRAINT fk_address_address_international_id FOREIGN KEY (address_international_id) REFERENCES postgres.address_international(id);
ALTER TABLE postgres.address ADD CONSTRAINT fk_address_address_nonstandard_id FOREIGN KEY (address_nonstandard_id) REFERENCES postgres.address_nonstandard(id);
ALTER TABLE postgres.address_us ADD CONSTRAINT fk_address_us_address_id FOREIGN KEY (address_id) REFERENCES postgres.address(id);
ALTER TABLE postgres.address_nonstandard ADD CONSTRAINT fk_address_nonstandard_address_id FOREIGN KEY (address_id) REFERENCES postgres.address(id);
ALTER TABLE postgres.npiaddress ADD CONSTRAINT fk_npiaddress_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.npiaddress ADD CONSTRAINT fk_npiaddress_address_id FOREIGN KEY (address_id) REFERENCES postgres.address(id);
ALTER TABLE postgres.clinicalorganization ADD CONSTRAINT fk_clinicalorganization_authorizedofficial_individual_id FOREIGN KEY (authorizedofficial_individual_id) REFERENCES postgres.individual(id);
ALTER TABLE postgres.clinicalorganization ADD CONSTRAINT fk_clinicalorganization_primary_vtin_id FOREIGN KEY (primary_vtin_id) REFERENCES postgres.vtin(id);
ALTER TABLE postgres.vtin ADD CONSTRAINT fk_vtin_clinicalorganization_id FOREIGN KEY (clinicalorganization_id) REFERENCES postgres.clinicalorganization(id);
ALTER TABLE postgres.orgname ADD CONSTRAINT fk_orgname_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.orgname ADD CONSTRAINT fk_orgname_orgname_type_code FOREIGN KEY (orgname_type_code) REFERENCES postgres.orgname_type_lut(id);
ALTER TABLE postgres.orgname ADD CONSTRAINT fk_orgname_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.orgname ADD CONSTRAINT fk_orgname_orgname_type_code_01 FOREIGN KEY (orgname_type_code) REFERENCES postgres.orgname_type_lut(id);
ALTER TABLE postgres.ehrtonpi ADD CONSTRAINT fk_ehrtonpi_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.ehrtonpi ADD CONSTRAINT fk_ehrtonpi_ehr_id FOREIGN KEY (ehr_id) REFERENCES postgres.ehr(id);
ALTER TABLE postgres.organizationtohealthcarebrand ADD CONSTRAINT fk_organizationtohealthcarebrand_healthcarebrand_id FOREIGN KEY (healthcarebrand_id) REFERENCES postgres.healthcarebrand(id);
ALTER TABLE postgres.npiidentifier ADD CONSTRAINT fk_npiidentifier_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.individualtocredential ADD CONSTRAINT fk_individualtocredential_individual_id FOREIGN KEY (individual_id) REFERENCES postgres.individual(id);
ALTER TABLE postgres.npitoendpoint ADD CONSTRAINT fk_npitoendpoint_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.orgtointeropendpoint ADD CONSTRAINT fk_orgtointeropendpoint_interopendpoint_id FOREIGN KEY (interopendpoint_id) REFERENCES postgres.interopendpoint(id);
ALTER TABLE postgres.npi_to_individual ADD CONSTRAINT fk_npi_to_individual_individual_id FOREIGN KEY (individual_id) REFERENCES postgres.individual(id);
ALTER TABLE postgres.npi_to_clinicalorganization ADD CONSTRAINT fk_npi_to_clinicalorganization_clinicalorganization_id FOREIGN KEY (clinicalorganization_id) REFERENCES postgres.clinicalorganization(id);
ALTER TABLE postgres.npi_to_clinicalorganization ADD CONSTRAINT fk_npi_to_clinicalorganization_primaryauthorizedofficial_individual_id FOREIGN KEY (primaryauthorizedofficial_individual_id) REFERENCES postgres.individual(id);
ALTER TABLE postgres.payertointeropendpoint ADD CONSTRAINT fk_payertointeropendpoint_payer_id FOREIGN KEY (payer_id) REFERENCES postgres.payer(id);
ALTER TABLE postgres.payertointeropendpoint ADD CONSTRAINT fk_payertointeropendpoint_interopendpoint_id FOREIGN KEY (interopendpoint_id) REFERENCES postgres.interopendpoint(id);
ALTER TABLE postgres.plan ADD CONSTRAINT fk_plan_payer_id FOREIGN KEY (payer_id) REFERENCES postgres.payer(id);
ALTER TABLE postgres.plan ADD CONSTRAINT fk_plan_marketcoverage_id FOREIGN KEY (marketcoverage_id) REFERENCES postgres.marketcoverage(id);
ALTER TABLE postgres.plan ADD CONSTRAINT fk_plan_servicearea_id FOREIGN KEY (servicearea_id) REFERENCES postgres.servicearea(id);
ALTER TABLE postgres.plan ADD CONSTRAINT fk_plan_plantype_id FOREIGN KEY (plantype_id) REFERENCES postgres.plantype(id);
ALTER TABLE postgres.plannetworktoplan ADD CONSTRAINT fk_plannetworktoplan_plan_id FOREIGN KEY (plan_id) REFERENCES postgres.plan(id);
ALTER TABLE postgres.plannetworktoplan ADD CONSTRAINT fk_plannetworktoplan_plannetwork_id FOREIGN KEY (plannetwork_id) REFERENCES postgres.plannetwork(id);
ALTER TABLE postgres.plannetworktoorg ADD CONSTRAINT fk_plannetworktoorg_plannetwork_id FOREIGN KEY (plannetwork_id) REFERENCES postgres.plannetwork(id);
ALTER TABLE postgres.npitophone ADD CONSTRAINT fk_npitophone_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.npitophone ADD CONSTRAINT fk_npitophone_phonenumber_id FOREIGN KEY (phonenumber_id) REFERENCES postgres.phonenumber(id);
ALTER TABLE postgres.npitophone ADD CONSTRAINT fk_npitophone_phoneextension_id FOREIGN KEY (phoneextension_id) REFERENCES postgres.phoneextension(id);
ALTER TABLE postgres.npitaxonomy ADD CONSTRAINT fk_npitaxonomy_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.npitaxonomy ADD CONSTRAINT fk_npitaxonomy_nucctaxonomycode_id FOREIGN KEY (nucctaxonomycode_id) REFERENCES postgres.nucctaxonomycode(id);
ALTER TABLE postgres.nuccmedicareprovidertype ADD CONSTRAINT fk_nuccmedicareprovidertype_medicareprovidertype_id FOREIGN KEY (medicareprovidertype_id) REFERENCES postgres.medicareprovidertype(id);
ALTER TABLE postgres.nuccmedicareprovidertype ADD CONSTRAINT fk_nuccmedicareprovidertype_nucctaxonomycode_id FOREIGN KEY (nucctaxonomycode_id) REFERENCES postgres.nucctaxonomycode(id);
ALTER TABLE postgres.useraccessrole ADD CONSTRAINT fk_useraccessrole_user_id FOREIGN KEY (user_id) REFERENCES postgres.user(id);
ALTER TABLE postgres.useraccessrole ADD CONSTRAINT fk_useraccessrole_npi_id FOREIGN KEY (npi_id) REFERENCES postgres.npi(id);
ALTER TABLE postgres.npi_individual ADD CONSTRAINT fk_npi_individual_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_individual ADD CONSTRAINT fk_npi_individual_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_organization ADD CONSTRAINT fk_npi_organization_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_organization ADD CONSTRAINT fk_npi_organization_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_identifier ADD CONSTRAINT fk_npi_identifier_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_identifier ADD CONSTRAINT fk_npi_identifier_identifier_type_code FOREIGN KEY (identifier_type_code) REFERENCES postgres.identifier_type_lut(id);
ALTER TABLE postgres.npi_identifier ADD CONSTRAINT fk_npi_identifier_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_identifier ADD CONSTRAINT fk_npi_identifier_identifier_type_code_01 FOREIGN KEY (identifier_type_code) REFERENCES postgres.identifier_type_lut(id);
ALTER TABLE postgres.npi_address ADD CONSTRAINT fk_npi_address_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_address ADD CONSTRAINT fk_npi_address_state_id FOREIGN KEY (state_id) REFERENCES postgres.state_code_lut(id);
ALTER TABLE postgres.npi_address ADD CONSTRAINT fk_npi_address_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_address ADD CONSTRAINT fk_npi_address_state_id_01 FOREIGN KEY (state_id) REFERENCES postgres.state_code_lut(id);
ALTER TABLE postgres.npi_phone ADD CONSTRAINT fk_npi_phone_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_phone ADD CONSTRAINT fk_npi_phone_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_taxonomy ADD CONSTRAINT fk_npi_taxonomy_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_taxonomy ADD CONSTRAINT fk_npi_taxonomy_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_identifiers ADD CONSTRAINT fk_npi_identifiers_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_identifiers ADD CONSTRAINT fk_npi_identifiers_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_endpoints ADD CONSTRAINT fk_npi_endpoints_npi FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_endpoints ADD CONSTRAINT fk_npi_endpoints_state_id FOREIGN KEY (state_id) REFERENCES postgres.state_code_lut(id);
ALTER TABLE postgres.npi_endpoints ADD CONSTRAINT fk_npi_endpoints_npi_01 FOREIGN KEY (npi) REFERENCES postgres.npidetail(id);
ALTER TABLE postgres.npi_endpoints ADD CONSTRAINT fk_npi_endpoints_state_id_01 FOREIGN KEY (state_id) REFERENCES postgres.state_code_lut(id);

