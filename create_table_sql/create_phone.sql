

CREATE TABLE "PhoneTypeLUT" (
    "id" int   NOT NULL,
    "phone_type_description" TEXT   NOT NULL,
    CONSTRAINT "pk_PhoneTypeLUT" PRIMARY KEY (
        "id"
     ),
    CONSTRAINT "uc_PhoneTypeLUT_phone_type_description" UNIQUE (
        "phone_type_description"
    )
);



CREATE TABLE "NPIPhone" (
    "id" int   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    "PhoneType_id" INTEGER   NOT NULL,
    "phone_number" VARCHAR(20)   NOT NULL,
    "is_fax" BOOLEAN   NOT NULL,
    CONSTRAINT "pk_NPIPhone" PRIMARY KEY (
        "id"
     )
);