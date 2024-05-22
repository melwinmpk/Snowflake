--  Reference => https://docs.snowflake.com/en/user-guide/security-column-ddm-use

USE ROLE useradmin;

CREATE ROLE masking_admin;

USE ROLE securityadmin;

GRANT CREATE MASKING POLICY on SCHEMA AMAZONEBOOKS_CLONING.PUBLIC to ROLE masking_admin;

-- below query. I was only able to execute it after switching to account admin
GRANT APPLY MASKING POLICY on ACCOUNT to ROLE masking_admin;

-- CREATE A USER 
CREATE OR REPLACE USER alwin
    -- objectProperties ::=
    PASSWORD = 'welcome123'
    LOGIN_NAME = alwin
    DISPLAY_NAME = alwin
    FIRST_NAME = alwin
    MUST_CHANGE_PASSWORD = FALSE
    DISABLED = FALSE
    DEFAULT_WAREHOUSE = COMPUTE_WH
    DEFAULT_NAMESPACE = AMAZONEBOOKS_CLONING   
    DEFAULT_ROLE = masking_admin;
    
-- GRANT ROLE masking_admin TO USER jsmith;

-- Create a masking policy

CREATE OR REPLACE MASKING POLICY user_name_mask AS (val string) RETURNS string ->
  CASE
    WHEN CURRENT_ROLE() IN ('ANALYST') THEN val
    ELSE '*********'
  END;

ALTER TABLE IF EXISTS user_info MODIFY COLUMN email SET MASKING POLICY email_mask;


