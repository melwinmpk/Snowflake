-- DAG STEP => Get Current Data Path

Select last_extract_date from config.table_config  where table_name = 'amazonebook_reviews';

-- S3Key Sensor 


--  DAG STEP =>  Load_data_to_ext_table
ALTER EXTERNAL TABLE IF EXISTS amazonebook_reviews_ext ADD FILES ('20240302/20240302-amazonebook-reviews.csv');


--  DAG STEP => Load_data_to_table

SELECT * FROM CONFIG.tbl_primary_key where table_name = 'amazonebook_reviews';

Select last_extract_date from config.table_config  where table_name = 'amazonebook_reviews';

SHOW COLUMNS IN TABLE amazonebook_reviews_ext;

MERGE INTO amazonebook_reviews T1
USING (
    SELECT * FROM amazonebook_reviews_ext t
    WHERE FILE_DATE_PARTITION > 20240301
    ) T2 ON
    T1.BOOK_ID = T2.BOOK_ID and
    T1.REVIEWER_NAME = T2.REVIEWER_NAME and
    T1.BUSINESS_DATE = T2.BUSINESS_DATE
WHEN MATCHED THEN UPDATE SET
T1.BOOK_ID = T2.BOOK_ID,
T1.REVIEWER_NAME = T2.REVIEWER_NAME,
T1.RATING = T2.RATING,
T1.REVIEW_TITLE = T2.REVIEW_TITLE,
T1.REVIEW_CONTENT = T2.REVIEW_CONTENT,
T1.REVIEWED_ON = T2.REVIEWED_ON,
T1.BUSINESS_DATE = T2.BUSINESS_DATE,
T1.FILE_DATE_PARTITION = T2.FILE_DATE_PARTITION
WHEN NOT MATCHED THEN INSERT
    ( BOOK_ID, REVIEWER_NAME, RATING, REVIEW_TITLE, REVIEW_CONTENT, REVIEWED_ON, BUSINESS_DATE, FILE_DATE_PARTITION)
VALUES
    ( T2.BOOK_ID, T2.REVIEWER_NAME, T2.RATING, T2.REVIEW_TITLE, T2.REVIEW_CONTENT, T2.REVIEWED_ON, T2.BUSINESS_DATE, T2.FILE_DATE_PARTITION);


--  DAG STEP => Update_Config

UPDATE CONFIG.TABLE_CONFIG
SET LAST_EXTRACT_DATE = (SELECT MAX(business_date) FROM PUBLIC.amazonebook_reviews)
WHERE TABLE_NAME = 'amazonebook_reviews';