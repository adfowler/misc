SELECT 
sql_text.text, 
st.last_execution_time,
DB_NAME(qp.dbid) as databasename
FROM sys.dm_exec_query_stats st 
CROSS APPLY sys.dm_exec_sql_text(st.sql_handle) AS sql_text
INNER JOIN sys.dm_exec_cached_plans cp
ON cp.plan_handle = st.plan_handle
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) as qp
WHERE st.last_execution_time >= DATEADD(minute, -30, getdate()) 
-- and text LIKE '%DirectMailChannel%'
ORDER BY last_execution_time DESC; 



select text, last_execution_time
FROM sys.dm_exec_query_stats st 
CROSS APPLY sys.dm_exec_sql_text(st.sql_handle) 
where text like '%DirectMailChannel%'
order by last_execution_time


 SET	 OFF; SET FMTONLY ON;SELECT [CampaignCode], [TouchPointID], [TouchPointDesc], [TouchPointDate], [TouchPointCount], [TouchpointStatus], [DropAfterSolicit] FROM [Campaigns].[dbo].[DirectMailChannel] SET FMTONLY OFF;