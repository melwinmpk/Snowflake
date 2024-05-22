-- Dag Step  1 => Prepare Data

Select last_extract_date from config.table_config  where table_name = 'amazonebook_reviews';


-- MySQL Start

Select distinct business_date from amazonebooks.amazonebook_reviews where business_date > '2024-02-29';

Select * from amazonebooks.amazonebook_reviews where business_date = '2024-03-01';

-- MySQL End


--  Dag Step  2 =>  Load Data to Stage

PUT 'file://///home/de/Outputs/Snowflake/amazonebooks/amazonebook_reviews/20240301/20240301-amazonebook-reviews.csv' @amazonebook_reviews_stage;


--  Dag Step  3 => Load Stage To table

USE SCHEMA CONFIG;

SELECT * FROM CONFIG.tbl_primary_key where table_name = 'amazonebook_reviews';

USE SCHEMA PUBLIC;

DELETE FROM  amazonebook_reviews T1 USING ( SELECT  t.$1 as col1, t.$2 as col2, t.$7 as col7 FROM @amazonebook_reviews_stage t) T2 WHERE  T1.book_id = T2.col1 and T1.reviewer_name = T2.col2 and T1.business_date = T2.col7 ;

COPY INTO amazonebook_reviews FROM @amazonebook_reviews_stage;


--  Dag Step  4=> Update Config


UPDATE CONFIG.TABLE_CONFIG
SET LAST_EXTRACT_DATE = (SELECT MAX(business_date) FROM PUBLIC.amazonebook_reviews)
WHERE TABLE_NAME = 'amazonebook_reviews';

REMOVE @amazonebook_reviews_stage;


SELECT * FROM amazonebook_reviews limit 10;

SELECT business_date,count(*) FROM amazonebook_reviews
GROUP BY business_date;


