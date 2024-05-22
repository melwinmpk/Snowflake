-- FOR CLONING THE DATABASE (Note this does the entire  Entire DATABASE)

CREATE OR REPLACE DATABASE IF NOT EXISTS AMAZONEBOOKS_CLONING 
CLONE AMAZONEBOOKS_EXTERNAL;

select 
(select count(*) from AMAZONEBOOKS_EXTERNAL.PUBLIC.AMAZONE_BOOKS) as AMAZONEBOOKS_EXTERNAL,
(select count(*) from AMAZONEBOOKS_CLONING.PUBLIC.AMAZONE_BOOKS) as AMAZONEBOOKS_EXTERNAL;


-- INSERTING FEW DATA IN CLONED DATABASE 

INSERT INTO AMAZONEBOOKS_CLONING.PUBLIC.AMAZONE_BOOKS VALUES (
903, 
'How the World Made the West: A 4,000-Year History', 
900, 
'Josephine Quinn', 
5, 
'/How-World-Made-West-000-Year/dp/1526605198/ref=sr_1_102?dib=eyJ2IjoiMSJ9.-xDrNiHEBq_nxzC8Bk7bt9arZYaIG-2YfnKKi2zEL1BOyoPZ78vcz9HfuGPKSvY9Jjny1cUwYiB3F-Xc8PhhgRcOSuF8q5ZRAGj_eS3Ryu4Lz7TeTJiFSExLhOHqr7A7L0L7kvST4TU7nDi3KsB-E64LuCDratH8-h-s7s2EPVM_euQGtOz7CaEkVycmDyZFflhup1gCJGqO0VM4P8VfUalMVNGdmN36cy6OEMNKeBc.97Y1Yj1SzK3dzIVTpC-oU6LjRT3EfhZj9OLDdvYU5Mw&dib_tag=se&qid=1710956376&refinements=p_n_publication_date%3A2684819031%2Cp_n_feature_three_browse-bin%3A9141482031%2Cp_n_binding_browse-bin%3A1318376031&rnid=1318374031&s=books&sr=1-102',
'2024-03-02',
20240302);

-- NOW CLONING A Table ONLY
-- I was not able to create a clone of the table from one database to another.

CREATE OR REPLACE Transient TABLE AMAZONEBOOKS_CLONING.PUBLIC.AMAZONE_BOOKS_CLONING 
CLONE AMAZONEBOOKS_EXTERNAL.PUBLIC.AMAZONE_BOOKS;


-- cloning table from one table to another within the same database 

-- CREATE OR REPLACE TABLE AMAZONE_BOOKS_CLONING 
-- CLONE AMAZONE_BOOKS;






