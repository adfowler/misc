
SELECT loginame, DB_NAME(dbid) AS DBName, COUNT(dbid) AS NumberOfConnections
FROM    sys.sysprocesses
GROUP BY dbid, loginame
ORDER BY loginame, DB_NAME(dbid)
