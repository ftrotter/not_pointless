
CREATE TABLE "User" (
    "id" INT   NOT NULL,
    "Email" varchar   NOT NULL,
    "FirstName" varchar   NOT NULL,
    "LastName" varchar   NOT NULL,
    "IdentityVerified" boolean   NOT NULL,
    CONSTRAINT "pk_User" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "UserAccessRole" (
    "id" INT   NOT NULL,
    "User_id" INT   NOT NULL,
    "Role_id" INT   NOT NULL,
    "NPI_id" BIGINT   NOT NULL,
    CONSTRAINT "pk_UserAccessRole" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Role" (
    "id" INT   NOT NULL,
    "Role" varchar(100)   NOT NULL,
    CONSTRAINT "pk_Role" PRIMARY KEY (
        "id"
     )
);