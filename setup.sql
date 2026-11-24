-- 1. Create warehouses
show warehouses;
create or replace warehouse management_wh;


-- 2. Network policies and PAT token
USE ROLE SECURITYADMIN;

CREATE NETWORK POLICY stug_demo_net_policy
  ALLOWED_IP_LIST = ('0.0.0.0/0')
  COMMENT = 'Temporary permissive policy for STUG Perth DCM demo';
  
USE ROLE ACCOUNTADMIN;

ALTER USER JAMES_PROD SET NETWORK_POLICY = stug_demo_net_policy;

ALTER USER JAMES_PROD
  ADD PROGRAMMATIC ACCESS TOKEN stug_dcm_pat
  DAYS_TO_EXPIRY = 30;


-- 3. Create a DCM role
USE ROLE USERADMIN;
CREATE ROLE DCM_DEPLOYER;


--4. Grant specific infrastructure permissions
USE ROLE SYSADMIN;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE DCM_DEPLOYER;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE DCM_DEPLOYER;


-- 5. Grant specific security power (via SECURITYADMIN)
USE ROLE SECURITYADMIN;
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE DCM_DEPLOYER;


-- 6. Give access to account admin
USE ROLE ACCOUNTADMIN;
GRANT ROLE DCM_DEPLOYER TO ROLE ACCOUNTADMIN;


-- 7. Create the database and schema for the project
USE ROLE SYSADMIN;
CREATE DATABASE MANAGEMENT_DB;
CREATE SCHEMA MANAGEMENT_DB.DCM;


-- 8. Grant to privilege to create DCM projects.
GRANT CREATE DCM PROJECT ON SCHEMA MANAGEMENT_DB.DCM TO ROLE DCM_DEPLOYER;