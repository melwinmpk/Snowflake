use amazonebooks;
use schema PUBLIC;

select * from PUBLIC.AMAZONE_BOOKS limit 50;



COPY INTO amazone_books from @amazone_books_stage;

REMOVE @amazone_books_stage;
truncate amazone_books;

use schema public;

select * from config.tbl_primary_key where table_name = 'amazone_books';

SELECT t.$7 FROM @AMAZONE_BOOKS_STAGE t  limit 1;

DESCRIBE STAGE AMAZONE_BOOKS_STAGE;


CREATE OR REPLACE STAGE amazone_books_stage
FILE_FORMAT = (TYPE= csv FIELD_DELIMITER = ',' FIELD_OPTIONALLY_ENCLOSED_BY = '"');


create or replace file format csv_format_0 
type = csv field_delimiter = ',' parse_header = true;

SELECT t.$7 FROM @AMAZONE_BOOKS_STAGE t  limit 1;

SELECT * FROM TABLE(INFER_SCHEMA(
 LOCATION=>'@AMAZONE_BOOKS_STAGE/20240227-amazone-books.csv'
 , FILE_FORMAT=>'csv_format_0'));


select distinct business_date from amazone_books;

use schema CONFIG;
SELECT * FROM tbl_primary_key where table_name = 'amazone_books';

-- Insert Last Extract Date
INSERT INTO CONFIG.TABLE_CONFIG VALUES ('amazone_books','2024-02-29');

-- Insert Primary Keys
INSERT INTO CONFIG.TBL_PRIMARY_KEY VALUES 
('amazone_books','book_id',1,1);

TRUNCATE CONFIG.TABLE_CONFIG;
TRUNCATE CONFIG.TBL_PRIMARY_KEY;

DROP TABLE CONFIG.TABLE_CONFIG;

DROP TABLE CONFIG.TBL_PRIMARY_KEY;

CREATE OR REPLACE TRANSIENT TABLE CONFIG.TABLE_CONFIG (
	TABLE_NAME TEXT,
	LAST_EXTRACT_DATE DATE
);

CREATE OR REPLACE TRANSIENT TABLE CONFIG.TBL_PRIMARY_KEY (
	TABLE_NAME TEXT,
	PRIMARY_COLUMN TEXT,
	ORDINAL_POSITION NUMBER(38,0),
	STAGE_POSITION NUMBER(38,0)
);

SELECT * FROM CONFIG.TABLE_CONFIG;

