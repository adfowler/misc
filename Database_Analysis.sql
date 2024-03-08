USE Extracts_AIZ

DELETE Xref..TableStats

DECLARE @Tablename VARCHAR(50)
DECLARE @Fieldname VARCHAR(50)

  DECLARE TableList CURSOR FOR
  select table_name, column_name
  from information_schema.columns
  where DATA_TYPE IN ('varchar', 'char')
--    and table_name = 'Lead_Product'
--    and column_name = 'Address1'
  order by table_name, ordinal_position

  OPEN TableList
  FETCH NEXT FROM TableList INTO @TableName, @FieldName

  WHILE @@FETCH_STATUS = 0
  BEGIN
--    SELECT @TableName, @FieldName

    PRINT 'INSERT INTO Xref..TableStats SELECT ''' + @Tablename + ''' ''Table Name'', ''' + @Fieldname + ''' ''Field Name'', COUNT(*) ''Values'', COUNT(DISTINCT ' + @Fieldname + ') ''Distinct Values'', MIN(ISNULL(LTRIM(' + @Fieldname + '), '' '')) ''Min Value'', MAX(ISNULL(LTRIM(' + @Fieldname + '), '' '')) ''Max Value'', MIN(CAST(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 OR ' + @Fieldname + ' LIKE ''%[^0123456789 ]%'' OR ' + @Fieldname + ' = '' '' THEN CAST(0 AS REAL) ELSE CAST(' + @Fieldname + ' AS REAL) END AS REAL)), MAX(CAST(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 OR ' + @Fieldname + ' LIKE ''%[^0123456789 ]%'' OR ' + @Fieldname + ' = '' '' THEN CAST(0 AS REAL) ELSE CAST(' + @Fieldname + ' AS REAL) END AS REAL)), SUM(CASE WHEN CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL THEN 1 ELSE 0 END) ''Blanks or Nulls'', SUM(CASE WHEN CAST(' + @Fieldname + ' AS VARCHAR(500)) = ''0'' THEN 1 ELSE 0 END) ''Zeros'', SUM(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 1 OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' THEN 1 ELSE 0 END) ''Numeric'', SUM(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 THEN 1 ELSE 0 END) ''Non-Numeric'', SUM(CASE WHEN ISDATE(' + @Fieldname + ') = 1 OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' THEN 1 ELSE 0 END) ''Date'', SUM(CASE WHEN ISDATE(' + @Fieldname + ') = 0 THEN 1 ELSE 0 END) ''Non-Date'', MAX(LEN(ISNULL(' + @Fieldname + ', '' ''))) ''Character Size'' FROM ' + @Tablename + ''
    EXEC('INSERT INTO Xref..TableStats SELECT ''' + @Tablename + ''' ''Table Name'', ''' + @Fieldname + ''' ''Field Name'', COUNT(*) ''Values'', COUNT(DISTINCT ' + @Fieldname + ') ''Distinct Values'', MIN(ISNULL(LTRIM(' + @Fieldname + '), '' '')) ''Min Value'', MAX(ISNULL(LTRIM(' + @Fieldname + '), '' '')) ''Max Value'', MIN(CAST(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 OR ' + @Fieldname + ' LIKE ''%[^0123456789 ]%'' OR ' + @Fieldname + ' = '' '' OR LEN(' + @Fieldname + ') > 20 THEN CAST(0 AS REAL) ELSE CAST(' + @Fieldname + ' AS REAL) END AS REAL)), MAX(CAST(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 OR ' + @Fieldname + ' LIKE ''%[^0123456789 ]%'' OR ' + @Fieldname + ' = '' '' OR LEN(' + @Fieldname + ') > 20 THEN CAST(0 AS REAL) ELSE CAST(' + @Fieldname + ' AS REAL) END AS REAL)), SUM(CASE WHEN CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL THEN 1 ELSE 0 END) ''Blanks or Nulls'', SUM(CASE WHEN CAST(' + @Fieldname + ' AS VARCHAR(500)) = ''0'' THEN 1 ELSE 0 END) ''Zeros'', SUM(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 1 OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' THEN 1 ELSE 0 END) ''Numeric'', SUM(CASE WHEN ISNUMERIC(' + @Fieldname + ') = 0 THEN 1 ELSE 0 END) ''Non-Numeric'', SUM(CASE WHEN ISDATE(' + @Fieldname + ') = 1 OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = ''NULL'' OR ' + @Fieldname + ' IS NULL OR CAST(' + @Fieldname + ' AS VARCHAR(50)) = '' '' THEN 1 ELSE 0 END) ''Date'', SUM(CASE WHEN ISDATE(' + @Fieldname + ') = 0 THEN 1 ELSE 0 END) ''Non-Date'', MAX(LEN(ISNULL(' + @Fieldname + ', '' ''))) ''Character Size'' FROM ' + @Tablename + '')

    FETCH NEXT FROM TableList INTO @TableName, @FieldName

  END

  CLOSE TableList
  DEALLOCATE TableList

DROP TABLE Xref..TableStats2

SELECT *, CAST(
CASE WHEN [Blanks or Nulls] = [Values] THEN 'Delete Field'
     WHEN [Distinct Values] = 1 THEN 'Delete Field'
     WHEN Date = [Values] THEN 'SMALLDATETIME'
     WHEN [Numeric] = [Values] AND CAST([Max Numeric] AS NUMERIC(50)) > 9223372036854775807 THEN 'NUMERIC'
     WHEN [Numeric] = [Values] AND [Max Numeric] > 2147483647 THEN 'BIGINT'
     WHEN [Numeric] = [Values] AND [Max Numeric] > 32767 THEN 'INT'
     WHEN [Numeric] = [Values] AND [Max Numeric] > 255 THEN 'SMALLINT'
     WHEN [Numeric] = [Values] AND [Max Numeric] > 1 THEN 'TINYINT'
     WHEN [Numeric] = [Values] AND [Max Numeric] = 1 THEN 'BIT'
     ELSE 'CHARACTER - ' + CAST([Character Size] AS VARCHAR(50)) END AS VARCHAR(50)
) 'Recommended Type'
INTO Xref..TableStats2
FROM Xref..TableStats

SELECT *
FROM Xref..TableStats2

/*
SELECT 'Consumer_Upd' 'Table Name',
       'MarketingConsumerNumber' 'Field Name',
--       COUNT(DISTINCT ' + @Fieldname + ') ''Distinct Values'', 
--MIN(' + @Fieldname + ') ''Min Value'', 
--MAX(' + @Fieldname + ') ''Max Value'', 
--SUM(CASE WHEN ' + @Fieldname + ' = '' '' OR ' + @Fieldname + ' = ''NULL'' OR ' + @Fieldname + ' IS NULL THEN 1 ELSE 0 END) ''Blanks or Nulls'', 
--SUM(CASE WHEN ' + @Fieldname + ' = ''0'' THEN 1 ELSE 0 END) ''Zeros'', 
      SUM(CASE WHEN ISNUMERIC(MarketingConsumerNumber) = 1 OR MarketingConsumerNumber = 'NULL' OR MarketingConsumerNumber IS NULL OR CAST(MarketingConsumerNumber AS VARCHAR(50)) = ' ' THEN 1 ELSE 0 END) 'Numeric', 
      SUM(CASE WHEN ISNUMERIC(MarketingConsumerNumber) = 0 THEN 1 ELSE 0 END) 'Non-Numeric', 
      SUM(CASE WHEN ISDATE(MarketingConsumerNumber) = 1 OR CAST(MarketingConsumerNumber AS VARCHAR(50)) = 'NULL' OR MarketingConsumerNumber IS NULL OR CAST(MarketingConsumerNumber AS VARCHAR(50)) = ' ' THEN 1 ELSE 0 END) 'Date', 
      SUM(CASE WHEN ISDATE(MarketingConsumerNumber) = 0 THEN 1 ELSE 0 END) 'Non-Date', 
      MAX(LEN(MarketingConsumerNumber)) 'Character Size'
FROM Consumer_Upd
*/



--SELECT TOP 258142 FullModelNumber
--CAST(CASE WHEN ISNUMERIC(FullModelNumber) = 0 OR FullModelNumber LIKE '%[^0123456789 ]%' OR FullModelNumber = ' ' THEN CAST(0 AS REAL) ELSE CAST(FullModelNumber AS REAL) END AS REAL), 
--CAST(CASE WHEN ISNUMERIC(FullModelNumber) = 0  OR FullModelNumber = ' ' THEN CAST(0 AS REAL) ELSE CAST(FullModelNumber AS REAL) END AS REAL)
--FROM Lead_Product

