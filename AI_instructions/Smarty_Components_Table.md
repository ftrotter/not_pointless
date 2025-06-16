## Components Table

| Field name | Type | Definition |
|------------|------|------------|
| urbanization | varchar(64) | The neighborhood, or city subdivision; used with Puerto Rican addresses |
| primary_number | varchar(30) | The house, PO Box, or building number |
| street_name | varchar(64) | The name of the street |
| street_predirection | char(16) | Directional information before a street name (N, SW, etc.) |
| street_postdirection | char(16) | Directional information after a street name (N, SW, etc.) |
| street_suffix | char(16) | Abbreviated value describing the street (St, Ave, Blvd, etc.) |
| secondary_number | varchar(32) | Apartment or suite number, if any |
| secondary_designator | varchar(16) | Describes location within a complex/building (Ste, Apt, etc.) |
| extra_secondary_number | varchar(32) | Descriptive information about the location of a building within a campus<br>(e.g., E-5 in "5619 Loop 1604, Bldg E-5, Ste. 101 San Antonio TX") |
| extra_secondary_designator | varchar(16) | Description of the location type within a campus<br>(e.g., Bldg, Unit, Lot, etc.) |
| pmb_designator | varchar(16) | The private mailbox unit designator, assigned by a CMRA |
| pmb_number | varchar(16) | The private mailbox number assigned by a CMRA; this value is not verified by Smarty. |
| city_name | varchar(64) | The USPS-preferred city name for this particular address, or an acceptable alternate if provided by the user |
| default_city_name | varchar(64) | The USPS default city name for this 5-digit ZIP Code |
| state_abbreviation | char(2) | The two-letter state abbreviation |
| zipcode | char(5) | The 5-digit ZIP Code |
| plus4_code | varchar(4) | The 4-digit add-on code (more specific than 5-digit ZIP) |
| delivery_point | char(2) | The last two digits of the house/box number, unless an "H" record is matched, in which case this is the secondary unit number representing the delivery point information to form the delivery point barcode (DPBC). |
| delivery_point_check_digit | char(1) | Correction character, or check digit, for the 11-digit barcode |
