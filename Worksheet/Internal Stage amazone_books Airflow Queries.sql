-- Dag Step  1 => Prepare Data

Select last_extract_date from config.table_config  where table_name = 'amazone_books';

-- MySQL Start

Select distinct business_date from amazonebooks.amazone_books where business_date > '2024-03-02';

Select * from amazonebooks.amazone_books where business_date = '2024-03-01';

-- MySQL End


--  Dag Step  2 =>  Load Data to Stage

PUT 'file://///home/de/Outputs/Snowflake/amazonebooks/amazone_books/20240301/20240301-amazone-books.csv' @amazone_books_stage;



--  Dag Step  3 => Load Stage To table

USE SCHEMA CONFIG;

SELECT * FROM CONFIG.tbl_primary_key where table_name = 'amazone_books';

USE SCHEMA PUBLIC;

DELETE FROM  amazone_books T1 USING ( SELECT  t.$1 as col1 FROM @amazone_books_stage t) T2 WHERE  T1.book_id = T2.col1 ;

COPY INTO amazone_books FROM @amazone_books_stage;



--  Dag Step  4=> Update Config

UPDATE CONFIG.TABLE_CONFIG
SET LAST_EXTRACT_DATE = (SELECT MAX(business_date) FROM PUBLIC.amazone_books)
WHERE TABLE_NAME = 'amazone_books';


REMOVE @amazone_books_stage;

-- Validation

SELECT * FROM AMAZONE_BOOKS limit 10;

SELECT business_date,count(*) FROM AMAZONE_BOOKS
GROUP BY business_date;
