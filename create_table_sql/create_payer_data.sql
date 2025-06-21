-- SOURCED FROM Payer FHIR / JSON Data or from the PUFs/Google Searches etc.

CREATE TABLE "PayerToEndpoint" (
    "id" int   NOT NULL,
    "Payer_id" int   NOT NULL,
    "Endpoint_id" int   NOT NULL,
    CONSTRAINT "pk_PayerToEndpoint" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Payer" (
    -- marketplace/network-puf.IssuerID
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IssuerMarketPlaceMarketingName
    "PayerName" varchar   NOT NULL,
    CONSTRAINT "pk_Payer" PRIMARY KEY (
        "id"
     )
);

-- There are a lot of atributes for plans, not sure how much we need to include
CREATE TABLE "Plan" (
    -- marketplace/plan-attributes-puf.PlanId
    "id" int   NOT NULL,
    "Payer_id" int   NOT NULL,
    "MarketCoverage_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "ServiceArea_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.DentalOnlyPlan
    "DentalOnlyPlan" boolean   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanMarketingName
    "PlanMarketingName" varchar   NOT NULL,
    -- marketplace/plan-attributes-puf.HIOSProductId
    "HIOSProductID" varchar   NOT NULL,
    "PlanType_id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.IsNewPlan
    "IsNewPlan" boolean   NOT NULL,
    CONSTRAINT "pk_Plan" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "PlanType" (
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.PlanType
    "PlanType" varchar   NOT NULL,
    CONSTRAINT "pk_PlanType" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "MarketCoverage" (
    "id" int   NOT NULL,
    -- marketplace/plan-attributes-puf.MarketCoverage
    "MarketCoverage" varchar   NOT NULL,
    CONSTRAINT "pk_MarketCoverage" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "NetworkToPlan" (
    "id" int   NOT NULL,
    "Plan_id" int   NOT NULL,
    "Network_id" int   NOT NULL,
    CONSTRAINT "pk_NetworkToPlan" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "Network" (
    -- marketplace/network-puf.NetworkID
    "id" int   NOT NULL,
    -- marketplace/network-puf.NetworkName
    "NetworkName" varchar   NOT NULL,
    -- marketplace/network-puf.NetworkURL
    "NetworkURL" varchar   NOT NULL,
    CONSTRAINT "pk_Network" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "ServiceArea" (
    -- marketplace/plan-attributes-puf.ServiceAreaId
    "id" int   NOT NULL,
    -- marketplace/service-area-puf.ServiceAreaName
    "ServiceAreaName" varchar   NOT NULL,
    -- marketplace/service-area-puf.StateCode
    "StateCode" varchar   NOT NULL,
    -- wishlist
    "shape" geometry   NOT NULL,
    CONSTRAINT "pk_ServiceArea" PRIMARY KEY (
        "id"
     )
);

-- PECOS Sourced initially, then UX Maintained
CREATE TABLE "NetworkToOrg" (
    "id" int   NOT NULL,
    "Network_id" int   NOT NULL,
    "Organization_id" int   NOT NULL,
    CONSTRAINT "pk_NetworkToOrg" PRIMARY KEY (
        "id"
     )
);