Create Address Table
==================

Please create a CREATE TABLE statement in AI_instructions/sql/create_address.sql for an address table that holds data from the smarty streets API. 
In order to do this, read the API documentation available here: AI_instructions/Smarty_API_Documentation.md
And then study the example results in AI_instructions/smarty_streets_json_samples

Generally there should be a table called "address_us", which contains the contents from the all of the Smarty API fields except the "International ddress" Table. 
Then there should be a table called "address_international".
Then there should be a table called "address_nonstandard"

All of these tables should have a primary key called "id" and also have an "address_id", which links back to the main address table. 

Then there should be a central table called "address", which has the following columns: 

everything can be "NULL" except the "id" field, which should be an auto-incrimenting primary key. 

id,
barcode_delivery_code varchar(12),
smarty_key varchar(10),
address_us_id INT(10),
address_international_id INT(10),
address_nonstandard_id INT(10)  