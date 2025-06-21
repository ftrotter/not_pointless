--Sourced from CHPL data and Lantern data


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