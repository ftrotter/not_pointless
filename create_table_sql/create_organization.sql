


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