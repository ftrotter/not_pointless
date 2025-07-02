

CREATE TABLE ndh.PhoneTypeLUT (
    id SERIAL PRIMARY KEY,
    phone_type_description TEXT   NOT NULL,
    CONSTRAINT uc_PhoneTypeLUT_phone_type_description UNIQUE (
        phone_type_description
    )
);


CREATE TABLE ndh.NPIToPhone (
    id SERIAL PRIMARY KEY,
    NPI_id BIGINT   NOT NULL,
    PhoneType_id INTEGER   NOT NULL,
    PhoneNumber_id INTEGER   NOT NULL,
    PhoneExtension_id INTEGER  NULL,
    is_fax BOOLEAN   NOT NULL
);


Create TABLE ndh.PhoneNumber (
    id SERIAL PRIMARY KEY,
    phone_number VARCHAR(20)   NOT NULL
);

Create TABLE ndh.PhoneExtension (
    id SERIAL PRIMARY KEY,
    phone_extension VARCHAR(10)   NOT NULL
);
