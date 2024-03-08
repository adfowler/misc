--Last update
SELECT OBJECT_NAME(OBJECT_ID) AS TableName, last_user_update,*
FROM sys.dm_db_index_usage_stats
WHERE database_id = DB_ID( 'campaigns')
  --AND OBJECT_ID=OBJECT_ID('DealerID_Lkup')

--recent queriesnn
SELECT *-- dest.text
FROM    sys.dm_exec_query_stats AS deqs
        CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
WHERE   deqs.last_execution_time > '09/27/2018 15:00'
        AND dest.text LIKE '%UPDATE%' AND
		     creation_time >= '09/27/2018 15:00'
			 and text like '%directmail%'
ORDER BY creation_time


