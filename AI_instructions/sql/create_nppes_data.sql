-- NPI Core Entity Table
CREATE TABLE npidetail (
    npi BIGINT PRIMARY KEY,
    entity_type_code SMALLINT NOT NULL, -- 1 = individual, 2 = organization
    replacement_npi VARCHAR(11),
    enumeration_date DATE,
    last_update_date DATE,
    deactivation_reason_code VARCHAR(3),
    deactivation_date DATE,
    reactivation_date DATE,
    certification_date DATE
);

-- Individuals
CREATE TABLE npi_individual (
    npi BIGINT PRIMARY KEY REFERENCES npidetails(npi),
    last_name VARCHAR(36),
    first_name VARCHAR(36),
    middle_name VARCHAR(21),
    name_prefix VARCHAR(6),
    name_suffix VARCHAR(6),
    credential_text VARCHAR(21),
    is_sole_proprietor BOOLEAN,
    sex_code CHAR(1)
);

-- Organizations
CREATE TABLE npi_organization (
    npi BIGINT PRIMARY KEY REFERENCES npidetails(npi),
    organization_name VARCHAR(101),
    authorized_official_last_name VARCHAR(36),
    authorized_official_first_name VARCHAR(21),
    authorized_official_middle_name VARCHAR(21),
    authorized_official_prefix VARCHAR(6),
    authorized_official_suffix VARCHAR(6),
    authorized_official_title VARCHAR(36),
    authorized_official_credential_text VARCHAR(21),
    authorized_official_phone VARCHAR(21),
    parent_org_lbn VARCHAR(71),
    parent_org_tin VARCHAR(10),
    is_org_subpart BOOLEAN,
);




-- Identifiers
CREATE TABLE npi_identifier (
    id SERIAL PRIMARY KEY,
    npi BIGINT REFERENCES npidetails(npi),
    identifier VARCHAR(21),
    type_code VARCHAR(3),
    state VARCHAR(3),
    issuer VARCHAR(81)
);


-- Lookup: Address Type
CREATE TABLE address_type_lut (
    id SERIAL PRIMARY KEY,
    description TEXT UNIQUE NOT NULL
);

INSERT INTO address_type_lut (description) VALUES
    ('mailing_address_main'),
    ('practice_location_main'),
    ('secondary_practice_location');

-- Lookup: Phone Type
CREATE TABLE phone_type_lut (
    id SERIAL PRIMARY KEY,
    description TEXT UNIQUE NOT NULL
);

INSERT INTO phone_type_lut (description) VALUES
    ('main_mailing_phone'),
    ('main_practice_phone'),
    ('secondary_practice_phone'),
    ('main_mailing_fax'),
    ('main_practice_fax'),
    ('secondary_practice_fax');


-- Lookup: State Codes
CREATE TABLE state_code_lut (
    id SERIAL PRIMARY KEY,
    state_code VARCHAR(100) UNIQUE NOT NULL,
    state_name VARCHAR(100) NOT NULL
);

-- Organization Alternate Names
CREATE TABLE orgname (
    id SERIAL PRIMARY KEY,
    npi BIGINT REFERENCES npidetails(npi),
    organization_name VARCHAR(70),
    type_code VARCHAR(2),
    code_description VARCHAR(100)
);

-- Addresses
CREATE TABLE npi_address (
    id SERIAL PRIMARY KEY,
    npi BIGINT REFERENCES npidetails(npi),
    address_type_id INTEGER REFERENCES address_type_lut(id),
    line_1 VARCHAR(55),
    line_2 VARCHAR(55),
    city VARCHAR(40),
    state_id INTEGER REFERENCES state_code_lut(id),
    postal_code VARCHAR(20),
    country_code VARCHAR(2)
);

-- Phone Numbers
CREATE TABLE npi_phone (
    id SERIAL PRIMARY KEY,
    npi VARCHAR(10) REFERENCES npidetails(npi),
    phone_type_id INTEGER REFERENCES phone_type_lut(id),
    phone_number VARCHAR(20),
    is_fax BOOLEAN
);

-- Taxonomy Entries
CREATE TABLE npi_taxonomy (
    id SERIAL PRIMARY KEY,
    npi VARCHAR(10) REFERENCES npidetails(npi),
    taxonomy_code VARCHAR(10),
    license_number VARCHAR(20),
    license_state_id INTEGER REFERENCES state_code_lut(id),
    is_primary BOOLEAN,
    taxonomy_group VARCHAR(10)
);

-- Identifiers
CREATE TABLE npi_identifiers (
    id SERIAL PRIMARY KEY,
    npi VARCHAR(10) REFERENCES npidetails(npi),
    identifier VARCHAR(20),
    type_code VARCHAR(2),
    state_id INTEGER REFERENCES state_code_lut(id),
    issuer VARCHAR(80)
);

