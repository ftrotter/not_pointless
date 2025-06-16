--
-- Table structure for table "purchaseOrder"
-- Creation Order: 1 - This table should be created first as it depends on tables from the model file (supplier, employee, purchaseOrderStatus)
--

DROP TABLE IF EXISTS "purchaseOrder";
CREATE TABLE "purchaseOrder" (
  id SERIAL PRIMARY KEY,
  supplier_id integer DEFAULT NULL,
  "createdBy_employee_id" integer DEFAULT NULL,
  "submittedDate" timestamp DEFAULT NULL,
  "creationDate" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_id integer DEFAULT 0,
  "expectedDate" timestamp DEFAULT NULL,
  "shippingFee" decimal(19,4) NOT NULL DEFAULT 0.0000,
  taxes decimal(19,4) NOT NULL DEFAULT 0.0000,
  "paymentDate" timestamp DEFAULT NULL,
  "paymentAmount" decimal(19,4) DEFAULT 0.0000,
  "paymentMethod" varchar(50) DEFAULT NULL,
  notes text DEFAULT NULL,
  "approvedBy_employee_id" integer DEFAULT NULL,
  "approvedDate" timestamp DEFAULT NULL,
  "submittedBy_employee_id" integer DEFAULT NULL
);

CREATE UNIQUE INDEX purchaseorder_id_idx ON "purchaseOrder" (id);
CREATE INDEX purchaseorder_createdby_idx ON "purchaseOrder" ("createdBy_employee_id");
CREATE INDEX purchaseorder_status_id_idx ON "purchaseOrder" (status_id);
CREATE INDEX purchaseorder_supplier_id_idx ON "purchaseOrder" (supplier_id);

ALTER TABLE "purchaseOrder" ADD CONSTRAINT "fkPurchaseOrderEmployees1" 
  FOREIGN KEY ("createdBy_employee_id") REFERENCES "durc_northwind_model".employee (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "purchaseOrder" ADD CONSTRAINT "fkPurchaseOrderPurchaseOrderStatus1" 
  FOREIGN KEY (status_id) REFERENCES "durc_northwind_model"."purchaseOrderStatus" (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "purchaseOrder" ADD CONSTRAINT "fkPurchaseOrderSuppliers1" 
  FOREIGN KEY (supplier_id) REFERENCES "durc_northwind_model".supplier (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Dumping data for table "purchaseOrder"
--

INSERT INTO "purchaseOrder" VALUES (90,1,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(91,3,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(92,2,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(93,5,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(94,6,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(95,4,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-01-22 00:00:00',2),(96,1,5,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #30',2,'2006-01-22 00:00:00',5),(97,2,7,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #33',2,'2006-01-22 00:00:00',7),(98,2,4,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #36',2,'2006-01-22 00:00:00',4),(99,1,3,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #38',2,'2006-01-22 00:00:00',3),(100,2,9,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #39',2,'2006-01-22 00:00:00',9),(101,1,2,'2006-01-14 00:00:00','2006-01-22 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #40',2,'2006-01-22 00:00:00',2),(102,1,1,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #41',2,'2006-04-04 00:00:00',1),(103,2,1,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #42',2,'2006-04-04 00:00:00',1),(104,2,1,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #45',2,'2006-04-04 00:00:00',1),(105,5,7,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,'Check','Purchase generated based on Order #46',2,'2006-04-04 00:00:00',7),(106,6,7,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #46',2,'2006-04-04 00:00:00',7),(107,1,6,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #47',2,'2006-04-04 00:00:00',6),(108,2,4,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #48',2,'2006-04-04 00:00:00',4),(109,2,4,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #48',2,'2006-04-04 00:00:00',4),(110,1,3,'2006-03-24 00:00:00','2006-03-24 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #49',2,'2006-04-04 00:00:00',3),(111,1,2,'2006-03-31 00:00:00','2006-03-31 00:00:00',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,'Purchase generated based on Order #56',2,'2006-04-04 00:00:00',2),(140,6,NULL,'2006-04-25 00:00:00','2006-04-25 16:40:51',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-04-25 16:41:33',2),(141,8,NULL,'2006-04-25 00:00:00','2006-04-25 17:10:35',2,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,2,'2006-04-25 17:10:55',2),(142,8,NULL,'2006-04-25 00:00:00','2006-04-25 17:18:29',2,NULL,0.0000,0.0000,NULL,0.0000,'Check',NULL,2,'2006-04-25 17:18:51',2),(146,2,2,'2006-04-26 18:26:37','2006-04-26 18:26:37',1,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,NULL,NULL,2),(147,7,2,'2006-04-26 18:33:28','2006-04-26 18:33:28',1,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,NULL,NULL,2),(148,5,2,'2006-04-26 18:33:52','2006-04-26 18:33:52',1,NULL,0.0000,0.0000,NULL,0.0000,NULL,NULL,NULL,NULL,2);
