/*Step 1: Create Database*/
USE [master]
GO

/****** Object:  Database [ChicagoDataPortal]    Script Date: 3/16/2017 8:03:28 AM ******/
IF OBJECT_ID('ChicagoDataPortal') IS NULL
BEGIN
	CREATE DATABASE [ChicagoDataPortal]
	 CONTAINMENT = NONE;


	ALTER DATABASE [ChicagoDataPortal] SET COMPATIBILITY_LEVEL = 140;


	IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
	begin
	EXEC [ChicagoDataPortal].[dbo].[sp_fulltext_database] @action = 'enable'
	end


	ALTER DATABASE [ChicagoDataPortal] SET ANSI_NULL_DEFAULT OFF 


	ALTER DATABASE [ChicagoDataPortal] SET ANSI_NULLS OFF 


	ALTER DATABASE [ChicagoDataPortal] SET ANSI_PADDING OFF 


	ALTER DATABASE [ChicagoDataPortal] SET ANSI_WARNINGS OFF 


	ALTER DATABASE [ChicagoDataPortal] SET ARITHABORT OFF 


	ALTER DATABASE [ChicagoDataPortal] SET AUTO_CLOSE OFF 


	ALTER DATABASE [ChicagoDataPortal] SET AUTO_SHRINK OFF 


	ALTER DATABASE [ChicagoDataPortal] SET AUTO_UPDATE_STATISTICS ON 


	ALTER DATABASE [ChicagoDataPortal] SET CURSOR_CLOSE_ON_COMMIT OFF 


	ALTER DATABASE [ChicagoDataPortal] SET CURSOR_DEFAULT  GLOBAL 


	ALTER DATABASE [ChicagoDataPortal] SET CONCAT_NULL_YIELDS_NULL OFF 


	ALTER DATABASE [ChicagoDataPortal] SET NUMERIC_ROUNDABORT OFF 


	ALTER DATABASE [ChicagoDataPortal] SET QUOTED_IDENTIFIER OFF 


	ALTER DATABASE [ChicagoDataPortal] SET RECURSIVE_TRIGGERS OFF 


	ALTER DATABASE [ChicagoDataPortal] SET  DISABLE_BROKER 


	ALTER DATABASE [ChicagoDataPortal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 


	ALTER DATABASE [ChicagoDataPortal] SET DATE_CORRELATION_OPTIMIZATION OFF 


	ALTER DATABASE [ChicagoDataPortal] SET TRUSTWORTHY OFF 


	ALTER DATABASE [ChicagoDataPortal] SET ALLOW_SNAPSHOT_ISOLATION OFF 


	ALTER DATABASE [ChicagoDataPortal] SET PARAMETERIZATION SIMPLE 


	ALTER DATABASE [ChicagoDataPortal] SET READ_COMMITTED_SNAPSHOT OFF 


	ALTER DATABASE [ChicagoDataPortal] SET HONOR_BROKER_PRIORITY OFF 


	ALTER DATABASE [ChicagoDataPortal] SET RECOVERY FULL 


	ALTER DATABASE [ChicagoDataPortal] SET  MULTI_USER 


	ALTER DATABASE [ChicagoDataPortal] SET PAGE_VERIFY CHECKSUM  


	ALTER DATABASE [ChicagoDataPortal] SET DB_CHAINING OFF 


	ALTER DATABASE [ChicagoDataPortal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 


	ALTER DATABASE [ChicagoDataPortal] SET TARGET_RECOVERY_TIME = 60 SECONDS 


	ALTER DATABASE [ChicagoDataPortal] SET DELAYED_DURABILITY = DISABLED 


	ALTER DATABASE [ChicagoDataPortal] SET QUERY_STORE = OFF


	USE [ChicagoDataPortal]


	ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;


	ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;


	ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;


	ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;


	ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;

	
	ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;


	ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;


	ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;


	ALTER DATABASE [ChicagoDataPortal] SET  READ_WRITE 

END

/*Step 2: Create Table*/
USE [ChicagoDataPortal]
GO

/****** Object:  Table [dbo].[FoodInspections]    Script Date: 3/16/2017 8:02:00 AM ******/
IF OBJECT_ID('dbo.FoodInspections') IS NULL)
BEGIN
	SET ANSI_NULLS ON;

	SET QUOTED_IDENTIFIER ON;

	CREATE TABLE [dbo].[FoodInspections](
		[ID] [varchar](50) NOT NULL,
		[Inspection ID] [int] NULL,
		[DBA Name] [varchar](100) NULL,
		[AKA Name] [varchar](100) NULL,
		[License Number] [varchar](10) NULL,
		[Facility Type] [varchar](50) NULL,
		[Risk] [varchar](20) NULL,
		[Address] [varchar](50) NULL,
		[City] [varchar](25) NULL,
		[State] [char](2) NULL,
		[Zip] [char](5) NULL,
		[Inspection Date] [date] NULL,
		[Inspection Type] [varchar](50) NULL,
		[Results] [varchar](30) NULL,
		[Violations] [varchar](max) NULL,
		[Latitude] [float] NULL,
		[Longitude] [float] NULL,
	 CONSTRAINT [PK_FoodInspections] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

/*Step 3: Populate Table*/
WITH jsonData (BulkColumn)
AS
(
SELECT BulkColumn
/*!!!!UPDATE with your local file path and name!!!!*/
FROM OPENROWSET (BULK '/*!!!!UPDATE with your local file path and name!!!!*/', SINGLE_CLOB) AS jsonData
)
INSERT INTO dbo.FoodInspections
SELECT MAX(CAST(pvt.[id] AS varchar(50))) AS [ID]
      ,MAX(CAST(pvt.[Inspection ID] AS int)) AS [Inspection ID]
      ,MAX(CAST(pvt.[DBA Name] AS varchar(100))) AS [DBA Name]
      ,MAX(CAST(pvt.[AKA Name] AS varchar(100))) AS [AKA Name]
      ,MAX(CAST(pvt.[License #] AS varchar(10))) AS [License Number]
      ,MAX(CAST(pvt.[Facility Type] AS varchar(50))) AS [Facility Type]
      ,MAX(CAST(pvt.[Risk] AS varchar(20))) AS [Risk]
      ,MAX(CAST(pvt.[Address] AS varchar(50))) AS [Address]
      ,MAX(CAST(pvt.[City] AS varchar(25))) AS [City]
      ,MAX(CAST(pvt.[State] AS char(2))) AS [State]
      ,MAX(CAST(pvt.[Zip] AS char(5))) AS [Zip]
      ,MAX(CAST(pvt.[Inspection Date] AS date)) AS [Inspection Date]
      ,MAX(CAST(PVT.[Inspection Type] AS varchar(50))) AS [Inspection Type]
      ,MAX(CAST(pvt.[Results] AS varchar(30))) AS [Results]
      ,MAX(CAST(pvt.[Violations] AS varchar(max))) AS [Violations]
      ,MAX(CAST(pvt.[Latitude] AS float)) AS [Latitude]
      ,MAX(CAST(pvt.[Longitude] AS float)) AS [Longitude]
FROM(
SELECT rowkey
,ROW_NUMBER() OVER(PARTITION BY rowkey ORDER BY rowkey) AS datarownumber
,rawvalue
FROM
(SELECT CAST(dataColumns.[key] AS int) as rowkey, valueColumns.[value] AS [rawvalue]
FROM jsonData
CROSS APPLY OPENJSON(BulkColumn)
WITH ([data] nvarchar(max) AS json) AS dataNode
CROSS APPLY OPENJSON(dataNode.[data]) AS dataColumns
CROSS APPLY OPENJSON([value]) as valueColumns) AS dataValues) AS dataTable
INNER JOIN (SELECT [name] as columnname, ROW_NUMBER() OVER(order by position) AS columnrownumber
			FROM jsonData
			CROSS APPLY OPENJSON(BulkColumn)
			WITH (columns nvarchar(max) '$.meta.view.columns' as json) AS columnData
			CROSS APPLY OPENJSON(columnData.columns)
			WITH ([name] nvarchar(100), position int) AS idData) as columnTable
			ON dataTable.datarownumber = columnTable.columnrownumber
PIVOT
(
max(rawvalue)
FOR columnname IN ([sid],[id],[position],[created_at],[created_meta],[updated_at],[updated_meta],[meta],[Inspection ID],[DBA Name],[AKA Name],[License #],[Facility Type],[Risk],[Address],[City],[State],[Zip],[Inspection Date],[Inspection Type],[Results],[Violations],[Latitude],[Longitude],[Location])
) as pvt
GROUP BY rowkey