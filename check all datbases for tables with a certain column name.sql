select name, database_id
into #dblist
from sys.databases



DECLARE @ID  int
SET @ID = 1

WHILE @ID <= (SELECT MAX(database_id) FROM #dblist)
BEGIN
DECLARE @DBname varchar(50),
		@SQL varchar(1000)
SET @DBname = (SELECT name FROM #dblist WHERE database_id = @ID )
SET @SQL = 'USE [' + @DBname + '] SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = ''msrpsource_desc'''
EXEC (@SQL)
SET @ID = @ID + 1
END

--drop table #dblist