-- nucc taxonomy codes from https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57
CREATE TABLE nucc_taxonomy_code (
    id SERIAL PRIMARY KEY,
    parent_nucc_taxonomy_code_id INT REFERENCES nucc_taxonomy_code(id), -- Self-referential for hierarchy
    taxonomy_code VARCHAR(10) PRIMARY KEY,           -- e.g., '207Q00000X'
    tax_grouping TEXT NOT NULL,                 -- e.g., 'Allopathic & Osteopathic Physicians'
    tax_classification TEXT NOT NULL,           -- e.g., 'Family Medicine'
    tax_specialization TEXT,                    -- e.g., 'Sports Medicine'
    tax_definition TEXT,                        -- Full description of the classification/specialization
    tax_notes TEXT,                             -- Optional usage notes
    tax_display_name TEXT NOT NULL              -- Suggested UI label
);

CREATE TABLE nucc_taxonomy_code_path (
    nucc_taxonomy_code_decendant_id INT NOT NULL REFERENCES nucc_taxonomy_code(id),
    nucc_taxonomy_code_ancestor_id  INT NOT NULL REFERENCES nucc_taxonomy_code(id)
)