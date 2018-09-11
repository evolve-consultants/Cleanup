USE [master]
-- Script to check all databases whose name starts with 'ebate'
-- and delete those not containing the words dev, demo or test

--SELECT * FROM master.sys.databases WHERE name like 'eBate%' ORDER BY name ASC

DECLARE @dbId AS int
DECLARE @dbName AS sysname
DECLARE @DBDeleteByName AS NVARCHAR(max);

DECLARE MY_CURSOR CURSOR 
  LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR 
SELECT DISTINCT database_id
	FROM master.sys.databases WHERE name like 'eBate%' ORDER BY database_id ASC

OPEN MY_CURSOR
FETCH NEXT FROM MY_CURSOR INTO @dbId
WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @dbName = [name] FROM master.sys.databases WHERE database_id = @dbId

	IF NOT(@dbName LIKE '%dev' OR @dbName LIKE '%demo' OR @dbName LIKE '%test' OR @dbName LIKE '%api')
	BEGIN
		PRINT 'Deleting ' + @dbName + ' ...'
		SELECT @DBDeleteByName = 'DROP DATABASE IF EXISTS [' + @dbName + ']'
		EXEC sp_executesql @DBDeleteByName;
		--PRINT @DBDeleteByName
	END

    FETCH NEXT FROM MY_CURSOR INTO @dbId
END
CLOSE MY_CURSOR
DEALLOCATE MY_CURSOR