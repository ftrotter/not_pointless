


CREATE TABLE "NPIToEndpoint" (
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

CREATE TABLE "OrgToEndpoint" (
    "id" int   NOT NULL,
    "Organization_id" int   NOT NULL,
    "Endpoint_id" int   NOT NULL,
    CONSTRAINT "pk_OrgToEndpoint" PRIMARY KEY (
        "id"
     )
);