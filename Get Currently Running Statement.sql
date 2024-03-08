SELECT  SUBSTRING(detail.text, 
                  requests.statement_start_offset / 2, 
                  (requests.statement_end_offset - requests.statement_start_offset) / 2)
FROM    sys.dm_exec_requests requests
CROSS APPLY sys.dm_exec_sql_text (requests.plan_handle) detail
--WHERE   requests.session_id = 67 --Update session id

--DBCC opentran()

SELECT *
FROM    sys.dm_exec_requests requests
CROSS APPLY sys.dm_exec_sql_text (requests.plan_handle) detail

	
select *
from sys.sysprocesses

	use Archive
	
	select *
	from sys.database_files

	DBCC SHRINKFILE (Staging, 1000);

