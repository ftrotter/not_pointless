



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