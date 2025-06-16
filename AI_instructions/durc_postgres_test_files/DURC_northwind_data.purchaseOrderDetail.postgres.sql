--
-- Table structure for table "purchaseOrderDetail"
-- Creation Order: 4 - This table should be created last as it depends on inventoryTransaction, product, and purchaseOrder
--

DROP TABLE IF EXISTS "purchaseOrderDetail";
CREATE TABLE "purchaseOrderDetail" (
  id SERIAL PRIMARY KEY,
  "purchaseOrder_id" integer NOT NULL,
  product_id integer DEFAULT NULL,
  quantity decimal(18,4) NOT NULL,
  "unitCost" decimal(19,4) NOT NULL,
  "dateReceived" timestamp DEFAULT NULL,
  "postedToInventory" boolean NOT NULL DEFAULT false,
  inventory_id integer DEFAULT NULL
);

CREATE INDEX purchaseorderdetail_id_idx ON "purchaseOrderDetail" (id);
CREATE INDEX purchaseorderdetail_inventory_id_idx ON "purchaseOrderDetail" (inventory_id);
CREATE INDEX purchaseorderdetail_purchaseOrder_id_idx ON "purchaseOrderDetail" ("purchaseOrder_id");
CREATE INDEX purchaseorderdetail_product_id_idx ON "purchaseOrderDetail" (product_id);

ALTER TABLE "purchaseOrderDetail" ADD CONSTRAINT "fkPurchaseOrderDetailInventoryTransaction1" 
  FOREIGN KEY (inventory_id) REFERENCES "inventoryTransaction" (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "purchaseOrderDetail" ADD CONSTRAINT "fkPurchaseOrderDetailProducts1" 
  FOREIGN KEY (product_id) REFERENCES "durc_northwind_model".product (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "purchaseOrderDetail" ADD CONSTRAINT "fkPurchaseOrderDetailPurchaseOrder1" 
  FOREIGN KEY ("purchaseOrder_id") REFERENCES "purchaseOrder" (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Dumping data for table "purchaseOrderDetail"
--

INSERT INTO "purchaseOrderDetail" VALUES (238,90,1,40.0000,14.0000,'2006-01-22 00:00:00',true,59),(239,91,3,100.0000,8.0000,'2006-01-22 00:00:00',true,54),(240,91,4,40.0000,16.0000,'2006-01-22 00:00:00',true,55),(241,91,5,40.0000,16.0000,'2006-01-22 00:00:00',true,56),(242,92,6,100.0000,19.0000,'2006-01-22 00:00:00',true,40),(243,92,7,40.0000,22.0000,'2006-01-22 00:00:00',true,41),(244,92,8,40.0000,30.0000,'2006-01-22 00:00:00',true,42),(245,92,14,40.0000,17.0000,'2006-01-22 00:00:00',true,43),(246,92,17,40.0000,29.0000,'2006-01-22 00:00:00',true,44),(247,92,19,20.0000,7.0000,'2006-01-22 00:00:00',true,45),(248,92,20,40.0000,61.0000,'2006-01-22 00:00:00',true,46),(249,92,21,20.0000,8.0000,'2006-01-22 00:00:00',true,47),(250,90,34,60.0000,10.0000,'2006-01-22 00:00:00',true,60),(251,92,40,120.0000,14.0000,'2006-01-22 00:00:00',true,48),(252,92,41,40.0000,7.0000,'2006-01-22 00:00:00',true,49),(253,90,43,100.0000,34.0000,'2006-01-22 00:00:00',true,61),(254,92,48,100.0000,10.0000,'2006-01-22 00:00:00',true,50),(255,92,51,40.0000,40.0000,'2006-01-22 00:00:00',true,51),(256,93,52,100.0000,5.0000,'2006-01-22 00:00:00',true,37),(257,93,56,120.0000,28.0000,'2006-01-22 00:00:00',true,38),(258,93,57,80.0000,15.0000,'2006-01-22 00:00:00',true,39),(259,91,65,40.0000,16.0000,'2006-01-22 00:00:00',true,57),(260,91,66,80.0000,13.0000,'2006-01-22 00:00:00',true,58),(261,94,72,40.0000,26.0000,'2006-01-22 00:00:00',true,36),(262,92,74,20.0000,8.0000,'2006-01-22 00:00:00',true,52),(263,92,77,60.0000,10.0000,'2006-01-22 00:00:00',true,53),(264,95,80,75.0000,3.0000,'2006-01-22 00:00:00',true,35),(265,90,81,125.0000,2.0000,'2006-01-22 00:00:00',true,62),(266,96,34,100.0000,10.0000,'2006-01-22 00:00:00',true,82),(267,97,19,30.0000,7.0000,'2006-01-22 00:00:00',true,80),(268,98,41,200.0000,7.0000,'2006-01-22 00:00:00',true,78),(269,99,43,300.0000,34.0000,'2006-01-22 00:00:00',true,76),(270,100,48,100.0000,10.0000,'2006-01-22 00:00:00',true,74),(271,101,81,200.0000,2.0000,'2006-01-22 00:00:00',true,72),(272,102,43,300.0000,34.0000,NULL,false,NULL),(273,103,19,10.0000,7.0000,'2006-04-17 00:00:00',true,111),(274,104,41,50.0000,7.0000,'2006-04-06 00:00:00',true,115),(275,105,57,100.0000,15.0000,'2006-04-05 00:00:00',true,100),(276,106,72,50.0000,26.0000,'2006-04-05 00:00:00',true,113),(277,107,34,300.0000,10.0000,'2006-04-05 00:00:00',true,107),(278,108,8,25.0000,30.0000,'2006-04-05 00:00:00',true,105),(279,109,19,25.0000,7.0000,'2006-04-05 00:00:00',true,109),(280,110,43,250.0000,34.0000,'2006-04-10 00:00:00',true,103),(281,90,1,40.0000,14.0000,NULL,false,NULL),(282,92,19,20.0000,7.0000,NULL,false,NULL),(283,111,34,50.0000,10.0000,'2006-04-04 00:00:00',true,102),(285,91,3,50.0000,8.0000,NULL,false,NULL),(286,91,4,40.0000,16.0000,NULL,false,NULL),(288,140,85,10.0000,9.0000,NULL,false,NULL),(289,141,6,10.0000,18.7500,NULL,false,NULL),(290,142,1,1.0000,13.5000,NULL,false,NULL),(292,146,20,40.0000,60.0000,NULL,false,NULL),(293,146,51,40.0000,39.0000,NULL,false,NULL),(294,147,40,120.0000,13.0000,NULL,false,NULL),(295,148,72,40.0000,26.0000,NULL,false,NULL);
