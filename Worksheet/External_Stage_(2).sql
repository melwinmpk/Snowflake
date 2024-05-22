-- amazone_books_ext_stage

Select METADATA$FILENAME as FileName FROM @amazone_books_ext_stage;

Select METADATA$FILENAME as FileName , split_part(METADATA$FILENAME,'/',4) as Partition_Name FROM @amazone_books_ext_stage limit 10;


CREATE OR REPLACE EXTERNAL TABLE AMAZONE_BOOKS_EXT(
	BOOK_ID NUMBER(38, 0) AS (value:c1::INTEGER)
	,BOOK_TITLE VARCHAR(16777216) AS (value:c2::TEXT)
	,BOOK_AMOUNT FLOAT AS (value:c3::FLOAT)
	,BOOK_AUTHOR VARCHAR(16777216) AS (value:c4::TEXT)
	,BOOK_RATING FLOAT AS (value:c5::float)
	,BOOK_LINK VARCHAR(16777216) AS (value:c6::TEXT)
	,BUSINESS_DATE DATE AS TO_DATE(value:c7::VARCHAR,'YYYY-MM-DD')
    ,FILE_DATE_PARTITION NUMBER(10,0) as (split_part(METADATA$FILENAME,'/',4)::int)
)
PARTITION BY (FILE_DATE_PARTITION)
WITH LOCATION = @amazone_books_ext_stage
FILE_FORMAT = (TYPE = CSV field_delimiter = ',' field_optionally_enclosed_by = '"'  SKIP_HEADER = 1);

select * from AMAZONE_BOOKS_EXT where FILE_DATE_PARTITION = 20240229 limit 10;

