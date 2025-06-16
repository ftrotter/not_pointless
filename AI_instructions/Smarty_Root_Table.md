## Root Table

| Field name | Type | Definition |
|------------|------|------------|
| input_id | varchar(36) | [Pass-through value] Any unique identifier that you use to reference the input address; the output will be identical to the input. |
| input_index | int | The order in which this address was submitted with the others (0 if alone) |
| candidate_index | int | An input address can match multiple valid addresses. This ties the candidates to the input index. (e.g., "1 Rosedale Street Baltimore Maryland" will return multiple candidates.) |
| addressee | varchar(64) | [Pass-through value] The name of the person or company as submitted by the client. This field may also include delivery information such as ATTN: Accounts Payable. This value is taken directly from the addressee input field. Very rarely, this field might be filled automatically with commercial information based on the USPS record. |
| delivery_line_1 | varchar(64) | Contains the first delivery line (usually the street address). This can include any of the following:<br><br>    urbanization (Puerto Rico only)<br>    primary number<br>    street predirection<br>    street name<br>    street suffix<br>    street postdirection<br>    secondary designator<br>    secondary number<br>    extra secondary designator<br>    extra secondary number<br>    PMB designator<br>    PMB number |
| delivery_line_2 | varchar(64) | The second delivery line (if needed). It is common for this field to remain empty. |
| last_line | varchar(64) | City, state, and ZIP Code combined |
| delivery_point_barcode | varchar(12) | 12-digit POSTNET™ barcode; consists of 5-digit ZIP Code, 4-digit add-on code, 2-digit delivery point, and 1-digit check digit. |
| smarty_key | varchar(10) | Smarty's unique identifier for an address. This identifier will only be displayed when an address is submitted with the match parameter set to "enhanced," with an appropriate product subscription. |
| components | [Object] | See "Components" table below. |
| metadata | [Object] | See "Metadata" table below. |
| analysis | [Object] | See "Analysis" table below. |
