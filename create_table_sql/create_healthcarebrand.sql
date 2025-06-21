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