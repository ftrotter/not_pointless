

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
    "id" SERIAL PRIMARY KEY,
    "NPI_id" BIGINT   NOT NULL,
    "Individual_id" INT   NOT NULL,
    "is_sole_proprietor" BOOLEAN   NOT NULL,
    "sex_code" CHAR(1)   NOT NULL
);

CREATE TABLE "NPIOrganization" (
    "id" SERIAL PRIMARY KEY,
    "NPI_id" BIGINT   NOT NULL,
    "Organization_id" INT   NOT NULL
);
