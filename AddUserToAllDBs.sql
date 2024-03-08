CREATE TABLE #DBs (ID int IDENTITY(1,1), DBName varchar(50))
INSERT INTO #DBs (DBName)
SELECT name
FROM sys.databases


DECLARE @ID  int
SET @ID = 1

WHILE @ID <= (SELECT MAX(ID) FROM #DBs)
BEGIN
DECLARE @DBname varchar(50),
		@SQL varchar(1000)
SET @DBname = (SELECT DBName FROM #DBs WHERE ID = @ID )
SET @SQL = 'USE [' + @DBname + '] GRANT CONNECT, SELECT, INSERT, UPDATE, DELETE TO [dsi\AllenFowler]'
EXEC (@SQL)
SET @ID = @ID + 1
END

DROP TABLE #DBs

/*
--This is needed to create views
GRANT ALTER ON SCHEMA::dbo TO  [DSOFTWARE\DavidKravitz]



--This is needed for linked servers and altering logins
USE Master
GRANT ALTER ANY LOGIN, ALTER ANY LINKED SERVER TO [DSOFTWARE\DavidKravitz]

--Create database
USE Master
GRANT CREATE ANY DATABASE TO [Dsoftware\DavidKravitz]

*/
use surveys
GRANT CONNECT, SELECT, execute  TO SurveyProcessing

grant execute on [dbo] to SurveyProcessing