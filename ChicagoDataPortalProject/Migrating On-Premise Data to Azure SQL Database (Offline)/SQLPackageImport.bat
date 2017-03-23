cd C:\Program Files (x86)\Microsoft SQL Server\130\DAC\bin

SqlPackage.exe /a:import /tcs:"Data Source=SERVER;Initial Catalog=DBNAME;User Id=USER;Password=PASSWORD" /sf:C:\temp\ChicagoDataPortal_SS.bacpac /p:DatabaseEdition=Premium