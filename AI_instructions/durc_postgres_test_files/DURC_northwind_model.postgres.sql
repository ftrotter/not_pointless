SET search_path TO durc_northwind_model;


--
-- PostgreSQL database dump
-- Converted from MySQL
--

--
-- Table structure for table appstring
--

DROP TABLE IF EXISTS appstring CASCADE ;
CREATE TABLE appstring (
  id SERIAL PRIMARY KEY,
  "stringData" varchar(255) DEFAULT NULL
);

--
-- Dumping data for table appstring
--

INSERT INTO appstring VALUES (2,'Northwind Traders'),(3,'Cannot remove posted inventory!'),(4,'Back ordered product filled for Order #|'),(5,'Discounted price below cost!'),(6,'Insufficient inventory.'),(7,'Insufficient inventory. Do you want to create a purchase order?'),(8,'Purchase order were successfully created for | product'),(9,'There are no product below their respective reorder levels'),(10,'Must specify customer name!'),(11,'Restocking will generate purchase order for all product below desired inventory levels.  Do you want to continue?'),(12,'Cannot create purchase order.  No supplier listed for specified product'),(13,'Discounted price is below cost!'),(14,'Do you want to continue?'),(15,'Order is already invoiced. Do you want to print the invoice?'),(16,'Order does not contain any line items'),(17,'Cannot create invoice!  Inventory has not been allocated for each specified product.'),(18,'Sorry, there are no sales in the specified time period'),(19,'Product successfully restocked.'),(21,'Product does not need restocking! Product is already at desired inventory level.'),(22,'Product restocking failed!'),(23,'Invalid login specified!'),(24,'Must first select reported!'),(25,'Changing supplier will remove purchase line items, continue?'),(26,'Purchase order were successfully submitted for | product.  Do you want to view the restocking report?'),(27,'There was an error attempting to restock inventory levels.'),(28,'| product(s) were successfully restocked.  Do you want to view the restocking report?'),(29,'You cannot remove purchase line items already posted to inventory!'),(30,'There was an error removing one or more purchase line items.'),(31,'You cannot modify quantity for purchased product already received or posted to inventory.'),(32,'You cannot modify price for purchased product already received or posted to inventory.'),(33,'Product has been successfully posted to inventory.'),(34,'Sorry, product cannot be successfully posted to inventory.'),(35,'There are order with this product on back order.  Would you like to fill them now?'),(36,'Cannot post product to inventory without specifying received date!'),(37,'Do you want to post received product to inventory?'),(38,'Initialize purchase, order, and inventory data?'),(39,'Must first specify employee name!'),(40,'Specified user must be logged in to approve purchase!'),(41,'Purchase order must contain completed line items before it can be approved'),(42,'Sorry, you do not have permission to approve purchases.'),(43,'Purchase successfully approved'),(44,'Purchase cannot be approved'),(45,'Purchase successfully submitted for approval'),(46,'Purchase cannot be submitted for approval'),(47,'Sorry, purchase order does not contain line items'),(48,'Do you want to cancel this order?'),(49,'Canceling an order will permanently delete the order.  Are you sure you want to cancel?'),(100,'Your order was successfully canceled.'),(101,'Cannot cancel an order that has items received and posted to inventory.'),(102,'There was an error trying to cancel this order.'),(103,'The invoice for this order has not yet been created.'),(104,'Shipping information is not complete.  Please specify all shipping information and try again.'),(105,'Cannot mark as shipped.  Order must first be invoiced!'),(106,'Cannot cancel an order that has already shipped!'),(107,'Must first specify salesperson!'),(108,'Order is now marked closed.'),(109,'Order must first be marked shipped before closing.'),(110,'Must first specify payment information!'),(111,'There was an error attempting to restock inventory levels.  | product(s) were successfully restocked.'),(112,'You must supply a Unit Cost.'),(113,'Fill back ordered product, Order #|'),(114,'Purchase generated based on Order #|');

--
-- Table structure for table customer
--

DROP TABLE IF EXISTS customer CASCADE;
CREATE TABLE customer (
  id SERIAL PRIMARY KEY,
  "companyName" varchar(50) DEFAULT NULL,
  "lastName" varchar(50) DEFAULT NULL,
  "firstName" varchar(50) DEFAULT NULL,
  "emailAddress" varchar(50) DEFAULT NULL,
  "jobTitle" varchar(50) DEFAULT NULL,
  "businessPhone" varchar(25) DEFAULT NULL,
  "homePhone" varchar(25) DEFAULT NULL,
  "mobilePhone" varchar(25) DEFAULT NULL,
  "faxNumber" varchar(25) DEFAULT NULL,
  address text DEFAULT NULL,
  city varchar(50) DEFAULT NULL,
  "stateProvince" varchar(50) DEFAULT NULL,
  "zipPostalCode" varchar(15) DEFAULT NULL,
  "countryRegion" varchar(50) DEFAULT NULL,
  "webPage" text DEFAULT NULL,
  notes text DEFAULT NULL,
  attachments bytea DEFAULT NULL,
  random_date timestamp NOT NULL,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  deleted_at timestamp NOT NULL
);

CREATE INDEX customer_city_idx ON customer (city);
CREATE INDEX customer_company_idx ON customer ("companyName");
CREATE INDEX customer_firstName_idx ON customer ("firstName");
CREATE INDEX customer_lastName_idx ON customer ("lastName");
CREATE INDEX customer_zipPostalCode_idx ON customer ("zipPostalCode");
CREATE INDEX customer_stateProvince_idx ON customer ("stateProvince");

--
-- Dumping data for table customer
--

INSERT INTO customer VALUES (1,'Company A','Bedecs','Anna',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','123 1st Street','Seattle','WA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(2,'Company B','Gratacos Solsona','Antonio',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','123 2nd Street','Boston','MA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(3,'Company C','Axen','Thomas',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','123 3rd Street','Los Angelas','CA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(4,'Company D','Lee','Christina',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 4th Street','New York','NY','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(5,'Company E','O''Donnell','Martin',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','123 5th Street','Minneapolis','MN','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(6,'Company F','Pérez-Olaeta','Francisco',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 6th Street','Milwaukee','WI','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(7,'Company G','Xie','Ming-Yang',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','123 7th Street','Boise','ID','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(8,'Company H','Andersen','Elizabeth',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','123 8th Street','Portland','OR','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(9,'Company I','Mortensen','Sven',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 9th Street','Salt Lake City','UT','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(10,'Company J','Wacker','Roland',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 10th Street','Chicago','IL','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(11,'Company K','Krschne','Peter',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 11th Street','Miami','FL','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(12,'Company L','Edwards','John',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','123 12th Street','Las Vegas','NV','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(13,'Company M','Ludick','Andre',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','456 13th Street','Memphis','TN','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(14,'Company N','Grilo','Carlos',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','456 14th Street','Denver','CO','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(15,'Company O','Kupkova','Helena',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','456 15th Street','Honolulu','HI','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(16,'Company P','Goldschmidt','Daniel',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','456 16th Street','San Francisco','CA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(17,'Company Q','Bagel','Jean Philippe',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','456 17th Street','Seattle','WA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(18,'Company R','Autier Miconi','Catherine',NULL,'Purchasing Representative','(123)555-0100',NULL,NULL,'(123)555-0101','456 18th Street','Boston','MA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(19,'Company S','Eggerer','Alexander',NULL,'Accounting Assistant','(123)555-0100',NULL,NULL,'(123)555-0101','789 19th Street','Los Angelas','CA','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(20,'Company T','Li','George',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 20th Street','New York','NY','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(21,'Company U','Tham','Bernard',NULL,'Accounting Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 21th Street','Minneapolis','MN','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(22,'Company V','Ramos','Luciana',NULL,'Purchasing Assistant','(123)555-0100',NULL,NULL,'(123)555-0101','789 22th Street','Milwaukee','WI','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(23,'Company W','Entin','Michael',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 23th Street','Portland','OR','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(24,'Company X','Hasselberg','Jonas',NULL,'Owner','(123)555-0100',NULL,NULL,'(123)555-0101','789 24th Street','Salt Lake City','UT','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(25,'Company Y','Rodman','John',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 25th Street','Chicago','IL','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(26,'Company Z','Liu','Run',NULL,'Accounting Assistant','(123)555-0100',NULL,NULL,'(123)555-0101','789 26th Street','Miami','FL','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(27,'Company AA','Toh','Karen',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 27th Street','Las Vegas','NV','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(28,'Company BB','Raghav','Amritansh',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 28th Street','Memphis','TN','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01'),(29,'Company CC','Lee','Soo Jung',NULL,'Purchasing Manager','(123)555-0100',NULL,NULL,'(123)555-0101','789 29th Street','Denver','CO','99999','USA',NULL,NULL,'','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01','1900-01-01 01:01:01');

--
-- Table structure for table employee
--

DROP TABLE IF EXISTS employee CASCADE;
CREATE TABLE employee (
  id SERIAL PRIMARY KEY,
  company varchar(50) DEFAULT NULL,
  "lastName" varchar(50) DEFAULT NULL,
  "firstName" varchar(50) DEFAULT NULL,
  "emailAddress" varchar(50) DEFAULT NULL,
  "jobTitle" varchar(50) DEFAULT NULL,
  "businessPhone" varchar(25) DEFAULT NULL,
  "homePhone" varchar(25) DEFAULT NULL,
  "mobilePhone" varchar(25) DEFAULT NULL,
  "faxNumber" varchar(25) DEFAULT NULL,
  address text DEFAULT NULL,
  city varchar(50) DEFAULT NULL,
  "stateProvince" varchar(50) DEFAULT NULL,
  "zipPostalCode" varchar(15) DEFAULT NULL,
  "countryRegion" varchar(50) DEFAULT NULL,
  "webPage" text DEFAULT NULL,
  notes text DEFAULT NULL,
  attachments bytea DEFAULT NULL
);

CREATE INDEX employee_city_idx ON employee (city);
CREATE INDEX employee_company_idx ON employee (company);
CREATE INDEX employee_firstName_idx ON employee ("firstName");
CREATE INDEX employee_lastName_idx ON employee ("lastName");
CREATE INDEX employee_zipPostalCode_idx ON employee ("zipPostalCode");
CREATE INDEX employee_stateProvince_idx ON employee ("stateProvince");

--
-- Dumping data for table employee
--

INSERT INTO employee VALUES (1,'Northwind Traders','Freehafer','Nancy','nancy@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 1st Avenue','Seattle','WA','99999','USA','#http://northwindtraders.com#',NULL,''),(2,'Northwind Traders','Cencini','Andrew','andrew@northwindtraders.com','Vice President, Sales','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 2nd Avenue','Bellevue','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales.',''),(3,'Northwind Traders','Kotas','Jan','jan@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 3rd Avenue','Redmond','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Was hired as a sales associate and was promoted to sales representative.',''),(4,'Northwind Traders','Sergienko','Mariya','mariya@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 4th Avenue','Kirkland','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#',NULL,''),(5,'Northwind Traders','Thorpe','Steven','steven@northwindtraders.com','Sales Manager','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 5th Avenue','Seattle','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Joined the company as a sales representative and was promoted to sales manager.  Fluent in French.',''),(6,'Northwind Traders','Neipper','Michael','michael@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 6th Avenue','Redmond','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Fluent in Japanese and can read and write French, Portuguese, and Spanish.',''),(7,'Northwind Traders','Zare','Robert','robert@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 7th Avenue','Seattle','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#',NULL,''),(8,'Northwind Traders','Giussani','Laura','laura@northwindtraders.com','Sales Coordinator','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 8th Avenue','Redmond','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Reads and writes French.',''),(9,'Northwind Traders','Hellung-Larsen','Anne','anne@northwindtraders.com','Sales Representative','(123)555-0100','(123)555-0102',NULL,'(123)555-0103','123 9th Avenue','Seattle','WA','99999','USA','http://northwindtraders.com#http://northwindtraders.com/#','Fluent in French and German.','');

--
-- Table structure for table "employeePrivilege"
--

DROP TABLE IF EXISTS "employeePrivilege" CASCADE ;
CREATE TABLE "employeePrivilege" (
  employee_id integer NOT NULL,
  privilege_id integer NOT NULL,
  PRIMARY KEY (employee_id, privilege_id)
);

CREATE INDEX "employeePrivilege_employee_id_idx" ON "employeePrivilege" (employee_id);
CREATE INDEX "employeePrivilege_privilege_id_idx" ON "employeePrivilege" (privilege_id);



--
-- Dumping data for table "employeePrivilege"
--

INSERT INTO "employeePrivilege" VALUES (2,2);

--
-- Table structure for table "inventoryTransactionType"
--

DROP TABLE IF EXISTS "inventoryTransactionType" CASCADE ;
CREATE TABLE "inventoryTransactionType" (
  id smallint NOT NULL PRIMARY KEY,
  "typeName" varchar(50) NOT NULL
);

--
-- Dumping data for table "inventoryTransactionType"
--

INSERT INTO "inventoryTransactionType" VALUES (1,'Purchased'),(2,'Sold'),(3,'On Hold'),(4,'Waste');

--
-- Table structure for table "orderDetailStatus"
--

DROP TABLE IF EXISTS "orderDetailStatus" CASCADE;
CREATE TABLE "orderDetailStatus" (
  id integer NOT NULL PRIMARY KEY,
  "statusName" varchar(50) NOT NULL
);

--
-- Dumping data for table "orderDetailStatus"
--

INSERT INTO "orderDetailStatus" VALUES (0,'None'),(1,'Allocated'),(2,'Invoiced'),(3,'Shipped'),(4,'On Order'),(5,'No Stock');

--
-- Table structure for table "orderStatus"
--

DROP TABLE IF EXISTS "orderStatus" CASCADE;
CREATE TABLE "orderStatus" (
  id smallint NOT NULL PRIMARY KEY,
  "statusName" varchar(50) NOT NULL
);

--
-- Dumping data for table "orderStatus"
--

INSERT INTO "orderStatus" VALUES (0,'New'),(1,'Invoiced'),(2,'Shipped'),(3,'Closed');

--
-- Table structure for table "orderTaxStatus"
--

DROP TABLE IF EXISTS "orderTaxStatus" CASCADE;
CREATE TABLE "orderTaxStatus" (
  id smallint NOT NULL PRIMARY KEY,
  "taxStatName" varchar(50) NOT NULL
);

--
-- Dumping data for table "orderTaxStatus"
--

INSERT INTO "orderTaxStatus" VALUES (0,'Tax Exempt'),(1,'Taxable');

--
-- Table structure for table privilege
--

DROP TABLE IF EXISTS privilege CASCADE;
CREATE TABLE privilege (
  id SERIAL PRIMARY KEY,
  "privilegeName" varchar(50) DEFAULT NULL
);

--
-- Dumping data for table privilege
--

INSERT INTO privilege VALUES (2,'Purchase Approvals');

--
-- Table structure for table product
--

DROP TABLE IF EXISTS product CASCADE;
CREATE TABLE product (
  supplier_ids text DEFAULT NULL,
  id SERIAL PRIMARY KEY,
  "productCode" varchar(25) DEFAULT NULL,
  "productName" varchar(50) DEFAULT NULL,
  description text DEFAULT NULL,
  "standardCost" decimal(19,4) DEFAULT 0.0000,
  "listPrice" decimal(19,4) NOT NULL DEFAULT 0.0000,
  "reorderLevel" integer DEFAULT NULL,
  "targetLevel" integer DEFAULT NULL,
  "quantityPerUnit" varchar(50) DEFAULT NULL,
  discontinued boolean NOT NULL DEFAULT false,
  "minimumReorderQuantity" integer DEFAULT NULL,
  category varchar(50) DEFAULT NULL,
  attachments bytea DEFAULT NULL
);

CREATE INDEX product_productCode_idx ON product ("productCode");

--
-- Dumping data for table product
--

INSERT INTO product
VALUES ('4', 1, 'NWTB-1', 'Northwind Traders Chai', NULL, 13.5000, 18.0000, 10, 40, '10 boxes x 20 bags', FALSE, 10,
        'Beverages', ''),
       ('10', 3, 'NWTCO-3', 'Northwind Traders Syrup', NULL, 7.5000, 10.0000, 25, 100, '12 - 550 ml bottles', FALSE, 25,
        'Condiments', ''),
       ('10', 4, 'NWTCO-4', 'Northwind Traders Cajun Seasoning', NULL, 16.5000, 22.0000, 10, 40, '48 - 6 oz jars',
        FALSE, 10, 'Condiments', ''),
       ('10', 5, 'NWTO-5', 'Northwind Traders Olive Oil', NULL, 16.0125, 21.3500, 10, 40, '36 boxes', FALSE, 10, 'Oil',
        ''),
       ('2;6', 6, 'NWTJP-6', 'Northwind Traders Boysenberry Spread', NULL, 18.7500, 25.0000, 25, 100, '12 - 8 oz jars',
        FALSE, 25, 'Jams, Preserves', ''),
       ('2', 7, 'NWTDFN-7', 'Northwind Traders Dried Pears', NULL, 22.5000, 30.0000, 10, 40, '12 - 1 lb pkgs.', FALSE,
        10, 'Dried Fruit & Nuts', ''),
       ('8', 8, 'NWTS-8', 'Northwind Traders Curry Sauce', NULL, 30.0000, 40.0000, 10, 40, '12 - 12 oz jars', FALSE, 10,
        'Sauces', ''),
       ('2;6', 14, 'NWTDFN-14', 'Northwind Traders Walnuts', NULL, 17.4375, 23.2500, 10, 40, '40 - 100 g pkgs.', FALSE,
        10, 'Dried Fruit & Nuts', ''),
       ('6', 17, 'NWTCFV-17', 'Northwind Traders Fruit Cocktail', NULL, 29.2500, 39.0000, 10, 40, '15.25 OZ', FALSE, 10,
        'Canned Fruit & Vegetables', ''),
       ('1', 19, 'NWTBGM-19', 'Northwind Traders Chocolate Biscuits Mix', NULL, 6.9000, 9.2000, 5, 20,
        '10 boxes x 12 pieces', FALSE, 5, 'Baked Goods & Mixes', ''),
       ('2;6', 20, 'NWTJP-6', 'Northwind Traders Marmalade', NULL, 60.7500, 81.0000, 10, 40, '30 gift boxes', FALSE, 10,
        'Jams, Preserves', ''),
       ('1', 21, 'NWTBGM-21', 'Northwind Traders Scones', NULL, 7.5000, 10.0000, 5, 20, '24 pkgs. x 4 pieces', FALSE, 5,
        'Baked Goods & Mixes', ''),
       ('4', 34, 'NWTB-34', 'Northwind Traders Beer', NULL, 10.5000, 14.0000, 15, 60, '24 - 12 oz bottles', FALSE, 15,
        'Beverages', ''),
       ('7', 40, 'NWTCM-40', 'Northwind Traders Crab Meat', NULL, 13.8000, 18.4000, 30, 120, '24 - 4 oz tins', FALSE,
        30, 'Canned Meat', ''),
       ('6', 41, 'NWTSO-41', 'Northwind Traders Clam Chowder', NULL, 7.2375, 9.6500, 10, 40, '12 - 12 oz cans', FALSE,
        10, 'Soups', ''),
       ('3;4', 43, 'NWTB-43', 'Northwind Traders Coffee', NULL, 34.5000, 46.0000, 25, 100, '16 - 500 g tins', FALSE, 25,
        'Beverages', ''),
       ('10', 48, 'NWTCA-48', 'Northwind Traders Chocolate', NULL, 9.5625, 12.7500, 25, 100, '10 pkgs', FALSE, 25,
        'Candy', ''),
       ('2', 51, 'NWTDFN-51', 'Northwind Traders Dried Apples', NULL, 39.7500, 53.0000, 10, 40, '50 - 300 g pkgs.',
        FALSE, 10, 'Dried Fruit & Nuts', ''),
       ('1', 52, 'NWTG-52', 'Northwind Traders Long Grain Rice', NULL, 5.2500, 7.0000, 25, 100, '16 - 2 kg boxes',
        FALSE, 25, 'Grains', ''),
       ('1', 56, 'NWTP-56', 'Northwind Traders Gnocchi', NULL, 28.5000, 38.0000, 30, 120, '24 - 250 g pkgs.', FALSE, 30,
        'Pasta', '')
;


ALTER TABLE "employeePrivilege" ADD CONSTRAINT "fkEmployeePrivilegeEmployees1"
  FOREIGN KEY (employee_id) REFERENCES employee (id) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "employeePrivilege" ADD CONSTRAINT "fkEmployeePrivilegePrivilege1"
  FOREIGN KEY (privilege_id) REFERENCES privilege (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

