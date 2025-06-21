
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
