Diagram Documentation
================

This document details how to make a diagram that works well with quickdatabasediagrams.com


Table names are defined by a newline followed by a string.

```
# The begining of the script
Customer
Order
```

Table name aliases are defined with the as keyword. Multiple comma-delimited aliases are allowed. Aliases can be used instead of full table names in relationship definitions.

```
# The begining of the script
Customer as c
Order as o, or
```

Table fields are defined after the table name followed by an arbitrary amount of hyphens. Each table field must be defined on a separate line in the following format: "FieldName FieldType" or "FieldName, FieldType". Field name needs to go first and any additional params (such as data type, PK, FK, UNIQUE, INDEX, IDENTITY or AUTOINCREMENT, DEFAULT, NULL or NULLABLE) may follow in any order.

```
Order
-----
OrderID PK int IDENTITY
OrderDate dateTime default=GETUTCDATE()
SignedByID int FK
Address3 string NULL
```

* All table fields are defined as NOT NULL by default. Explicitly defining it as such will at the moment result in a parser error. For better clarity, we intend to add support for defining explicit non-nullable fields in the future.
* UNIQUE constraints can be defined by setting the UNIQUE keyword on the field which has to be an unique constraint.
* INDEX constraints can be defined by setting the INDEX keyword on the field which has to be an index constraint.
* A field can't be a PK and an unique or an index, since a PK is already an unique and an index, and also an unique constraint can't be an index, since the unique constraint is already an index.
* Composite PKs can be defined by setting the PK keyword on all the fields which are a part of the composite key.
* Non-standard table and field names can be defined using double quotes:

```
"Non-Standard #1"
--
"Non-Standard #2"
OtherTable
--
OtherField FK -< "Non-Standard #1"."Non-Standard #2"
```

Default values are defined with the default keyword or as a part of type definition.

```
DateCreated dateTime default=GETUTCDATE()
Temperature int=27
Address string="Some default address"
```

Documentation comments can be added before or in-line with table or field definitions. These comments will appear in PDF/RTF exports.
```
# Table documentation comment 1 (try the PDF/RTF export)
Product# Table documentation comment 2
------------
ProductID PK int
# Field documentation comment 1
# Field documentation comment 2
Name varchar(200) # Field documentation comment 3
```

Table relationships can be defined either as a part of table metadata or inline as a part of a table field definition.

Relationships as a part of table metadata definition can be defined between the table name definition and the table fields separator ("------") using the rel keyword followed by relationship type and the related table. If the relationship type is omitted one-to-one relationship type will be used by default. Relationship table fields may or may not be specified.

```
# Relation type and field
# not specified
Order
rel Customer
---
OrderID
CustomerID
```

```
# Relation type and field
# specified
Order
rel >- Customer.CustomerID
------
OrderID
CustomerID
```

Relationships as a part of table field definition (inline) can be defined at any position after the field name has been defined. In this case relationship type is mandatory, but the connection relation field name is still optional.

```
Order
-
OrderID PK int
CustomerID int FK >- cst.CustomerID
```

Allowed relationship types are:

-     - one TO one
-<    - one TO many
>-    - many TO one
>-<   - many TO many
-0    - one TO zero or one
0-    - zero or one TO one
0-0   - zero or one TO zero or one
-0<   - one TO zero or many
>0-   - zero or many TO one

