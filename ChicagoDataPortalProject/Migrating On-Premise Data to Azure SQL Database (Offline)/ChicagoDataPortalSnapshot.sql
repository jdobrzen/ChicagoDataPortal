DECLARE @dbname varchar(40)
DECLARE @CREATE_TEMPLATE varchar(max)
DECLARE @SQL varchar(max)

SET @dbname = 'ChicagoDataPortal_SS_' + REPLACE(CAST(CAST(GETDATE() AS DATE) AS varchar(10)), '-','')

SET @CREATE_TEMPLATE = 'CREATE DATABASE {dbname} ON  
						( NAME = ChicagoDataPortal, FILENAME =   
						''C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Data\{dbname}.ss'' )  
						AS SNAPSHOT OF ChicagoDataPortal;'

SET @SQL = REPLACE(@CREATE_TEMPLATE, '{dbname}', @dbname)

EXECUTE (@SQL)
GO  

