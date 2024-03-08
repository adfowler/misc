

SELECT 
    USER_NAME(grantee_principal_id) AS 'User'
  , state_desc AS 'Permission'
  , permission_name AS 'Action'
  , CASE class
      WHEN 0 THEN 'Database::' + DB_NAME()
      WHEN 1 THEN OBJECT_NAME(major_id)
      WHEN 3 THEN 'Schema::' + SCHEMA_NAME(major_id) END AS 'Securable',
	  *
FROM sys.database_permissions dp
WHERE class IN (0, 1, 3) and
    USER_NAME(grantee_principal_id)  = 'valid_user' and
    minor_id = 0; 

select *
FROM sys.database_permissions
where USER_NAME(grantee_principal_id)  = 'valid_user' 