USE [s16guest03]
GO
/****** Object:  User [s16guest03]    Script Date: 2016/5/11 23:27:15 ******/
CREATE USER [s16guest03] FOR LOGIN [s16guest03] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [s16guest03]
GO
/****** Object:  StoredProcedure [dbo].[AddProduct]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddProduct]
(
  @ProductName nvarchar(50),
  @Desc nvarchar(50)
)
AS
begin
begin try
insert into Product ([Product Name],[Description])
values (@ProductName, @Desc)
end  try

begin catch

print 'not able to create new product!'
end catch
 end


GO
/****** Object:  StoredProcedure [dbo].[CountNewFeatures]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CountNewFeatures]
	@getVersion float,
	@getProduct varchar(32),
	@getPlatform varchar(32)

AS
BEGIN
	DECLARE @error varchar(100)

	SET NOCOUNT ON;

	IF EXISTS (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		BEGIN
			DECLARE @foundPlatformID int
			SET @foundPlatformID = (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		END
	ELSE
		BEGIN
			SET @error = 'Platform does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select productID from [dbo].[product] where productName = @getProduct)
		BEGIN
			DECLARE @foundProductID int
			SET @foundProductID = (Select productID from [dbo].[product] where productName = @getProduct)
		END
	ELSE
		BEGIN
			SET @error = 'Product does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select [versionID] from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		BEGIN
			DECLARE @foundVersionID int
			SET @foundVersionID = (Select versionID from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		END
	ELSE
		BEGIN
			SET @error = 'Version does not exist'
			RAISERROR (@error,10, 1) 	
		END

	IF EXISTS (Select [featureID] from [dbo].[versionFeatures] where [versionID] = @foundVersionID)
		BEGIN
			DECLARE @Count int
				SET @Count = (Select COUNT([featureID]) from [dbo].[versionFeatures] where [versionID] = @foundVersionID)
				PRINT str(@count) + ' features are in the ' + CONVERT (VARCHAR(50), @getVersion,128) + ' release'
			END
			
		ELSE
			BEGIN
				SET @error = 'It is a bug ¨Cfix release. There are no new features'
				RAISERROR (@error,10, 1) 	
			END			
END

GO
/****** Object:  StoredProcedure [dbo].[DisplayNewFeatures]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DisplayNewFeatures]
	@getVersion float,
	@getProduct varchar(32),
	@getPlatform varchar(32)

AS
BEGIN

	DECLARE @error varchar(100)

	SET NOCOUNT ON;

	IF EXISTS (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		BEGIN
			DECLARE @foundPlatformID int
			SET @foundPlatformID = (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		END
	ELSE
		BEGIN
			SET @error = 'Platform does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select productID from [dbo].[product] where productName = @getProduct)
		BEGIN
			DECLARE @foundProductID int
			SET @foundProductID = (Select productID from [dbo].[product] where productName = @getProduct)
		END
	ELSE
		BEGIN
			SET @error = 'Product does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select [versionID] from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		BEGIN
			DECLARE @foundVersionID int
			SET @foundVersionID = (Select versionID from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		END
	ELSE
		BEGIN
			SET @error = 'Version does not exist'
			RAISERROR (@error,10, 1) 	
		END


	IF EXISTS (Select [featureID] from [dbo].[versionFeatures] where [versionID] = @foundVersionID)
		BEGIN
			SELECT [description] FROM features WHERE featureID = ANY(Select [featureID] from [dbo].[versionFeatures] where [versionID] = @foundVersionID)
		END
	ELSE
		BEGIN
			SET @error = 'Feature does not exist'
			RAISERROR (@error,10, 1) 	
		END
		
END

GO
/****** Object:  StoredProcedure [dbo].[DownloadsPerMonth]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DownloadsPerMonth] 
	@getVersion float,
	@getProduct varchar(32),
	@getPlatform varchar(32),
	@getMonth int

AS
BEGIN
	DECLARE @error varchar(100)

	SET NOCOUNT ON;

	IF EXISTS (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		BEGIN
			DECLARE @foundPlatformID int
			SET @foundPlatformID = (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		END
	ELSE
		BEGIN
			SET @error = 'Platform does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select productID from [dbo].[product] where productName = @getProduct)
		BEGIN
			DECLARE @foundProductID int
			SET @foundProductID = (Select productID from [dbo].[product] where productName = @getProduct)
		END
	ELSE
		BEGIN
			SET @error = 'Product does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select [versionID] from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		BEGIN
			DECLARE @foundVersionID int
			SET @foundVersionID = (Select versionID from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		END
	ELSE
		BEGIN
			SET @error = 'Version does not exist'
			RAISERROR (@error,10, 1) 	
		END
	IF EXISTS (Select customerID from [dbo].[customerDownload] where MONTH([downloadDate]) = @getMonth AND customerDownloadID = 1)
		BEGIN
			DECLARE @Count int
				SET @Count = (Select COUNT([customerID]) from [dbo].[customerDownload] where MONTH([downloadDate]) = @getMonth 
				AND customerDownloadID = Any((Select [customerDownloadID] from [dbo].[customerRelease] where versionID = @foundVersionID)))
			
			Print  'Product: ' +CONVERT (VARCHAR(50), @getProduct,128) + ', Version: ' + CONVERT (VARCHAR(50), @getVersion,128) + ', Month: ' + CONVERT (VARCHAR(50), @getMonth,128) + ', Number of Downloads: ' + CONVERT (VARCHAR(50), @Count,128) 
			
		END
			
		ELSE
			BEGIN
				SET @error = 'There are 0'
				RAISERROR (@error,10, 1) 	
			END			
	
END

GO
/****** Object:  StoredProcedure [dbo].[InsertAddress]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertAddress] 
	@setStreetAddress varchar(32),
	@setZipCode numeric(5, 0),
	@setStateInitials varchar(2),
	@setCityName varchar(32),
	@setCountryName varchar(50)

AS
BEGIN
	DECLARE @error varchar(100)

	SET NOCOUNT ON;

	INSERT INTO [dbo].[address]
           ([streetAddress]
           ,[zipCode]
           ,[stateInitials]
           ,[cityName]
           ,[countryName])
     VALUES
           (@setStreetAddress
           ,@setZipCode
           ,@setStateInitials
           ,@setCityName
           ,@setCountryName)
	
END

GO
/****** Object:  StoredProcedure [dbo].[InsertPlatform]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertPlatform] 
	@setPlatform varchar(16)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[platform]
           ([platformName])
     VALUES
           (@setPlatform)
END


GO
/****** Object:  StoredProcedure [dbo].[NewFeatureCount]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[NewFeatureCount]
(
  @VersionID int 
  
)
AS
Begin
 declare @NewFeatureReleaseID float
 declare @sum  int
 declare @VersionNum nchar(10)

 set  @NewFeatureReleaseID = (select [Release ID] from Release
 where [Release Type] = 'new features release') 
 
 begin try


      set @VersionNum = (select [Version number] from PVersion 
                     where [Version ID] = @VersionID)

	  set @sum = (select count([Feature ID]) 
               from [dbo].[Version_FeatureID_Release] 
			   where [Release ID] = @NewFeatureReleaseID AND
			         [Version ID] = @VersionID )
			   
			   



	     if @sum >0 
    
            print 'There are ' + (convert(varchar(8), @sum)) + 'new features in the' 
	        + @VersionNum + 'release.'
   
        else print 'It is  bug fix release. There are no new feature.'

end  try

 begin catch
  
  DECLARE
   @ErMessage NVARCHAR(2048),
   @ErSeverity INT,
   @ErState INT
 
 SELECT
   @ErMessage = ERROR_MESSAGE(),
   @ErSeverity = ERROR_SEVERITY(),
   @ErState = ERROR_STATE()
 
 RAISERROR (@ErMessage,
             @ErSeverity,
             @ErState )


end catch

END

GO
/****** Object:  StoredProcedure [dbo].[ProductVersionUpdate]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ProductVersionUpdate]
(
@ProductName nvarchar(20),
@ProductID int,
@versionID int,
@versionNumber nchar(10)

)
AS
Begin
select @ProductID = [Product ID] from Product where [Product Name] = @ProductName
select @versionID = [Version ID] from Version_Product where [Product ID] = @ProductID
 
update PVersion 
set [Version number] = @versionNumber  where [Version ID] = @versionID 

END;



GO
/****** Object:  StoredProcedure [dbo].[RequestCount]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- procedure to count and report the number of requests with the version ID
create procedure [dbo].[RequestCount] 

 AS  
 begin
    begin TRY
    select  Product.[Product Name], PVersion.[Version number],  month(Request.[Date]) , count(Request.[Customer ID])
    from Request, Product, PVersion, Version_Product 
	group by [Product Name], [Version number], [Date] 
    Order by [Date] , count([Customer ID]) 
    end TRY

  begin catch

  print 'Error'
  end catch

end 


GO
/****** Object:  StoredProcedure [dbo].[UpdateProductVersion]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProductVersion] 
	@getVersion float,
	@getProduct varchar(32),
	@getPlatform varchar(32),
	@updateVersion float

AS
BEGIN
	DECLARE @error varchar(100)

	SET NOCOUNT ON;

	IF EXISTS (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		BEGIN
			DECLARE @foundPlatformID int
			SET @foundPlatformID = (Select platformID from [dbo].[platform] where platformName = @getPlatform )
		END
	ELSE
		BEGIN
			SET @error = 'Platform does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select productID from [dbo].[product] where productName = @getProduct)
		BEGIN
			DECLARE @foundProductID int
			SET @foundProductID = (Select productID from [dbo].[product] where productName = @getProduct)
		END
	ELSE
		BEGIN
			SET @error = 'Product does not exist'
			RAISERROR (@error,10, 1) 	
		END
	
	IF EXISTS (Select [versionID] from [dbo].[version] where versionNumber = @getVersion AND productID = @foundProductID AND platformID = @foundPlatformID)
		BEGIN
			UPDATE [dbo].[version]
			SET [versionNumber] = @updateVersion
			WHERE platformID = @foundPlatformID AND productID = @foundProductID AND versionNumber = @getVersion
		END
	ELSE
		BEGIN
			SET @error = 'Version does not exist'
			RAISERROR (@error,10, 1) 	
		END

	
END

GO
/****** Object:  Table [dbo].[branch]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branch](
	[branch number] [int] IDENTITY(1,1) NOT NULL,
	[development ID] [int] NOT NULL,
	[production ID] [int] NOT NULL,
	[version number] [decimal](18, 0) NOT NULL,
	[source contralID] [int] NOT NULL,
	[customer releaseID] [int] NOT NULL,
	[downloadID] [int] NOT NULL,
 CONSTRAINT [PK_branch] PRIMARY KEY CLUSTERED 
(
	[branch number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[company]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[company](
	[companyID] [int] IDENTITY(1,1) NOT NULL,
	[company name] [varchar](50) NULL,
	[address] [varchar](max) NULL,
	[country] [varchar](50) NULL,
 CONSTRAINT [PK_company] PRIMARY KEY CLUSTERED 
(
	[companyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[customer name] [varchar](50) NOT NULL,
	[companyID] [int] NOT NULL,
	[Title] [varchar](4) NOT NULL,
	[Email] [varchar](50) NULL,
	[customer phoneID] [int] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[customerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[customer release]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer release](
	[customerID] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[downloadID] [int] NULL,
	[customer releaseID] [int] NOT NULL,
 CONSTRAINT [PK_customer release_1] PRIMARY KEY CLUSTERED 
(
	[customer releaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[development information]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[development information](
	[developmentID] [int] IDENTITY(1,1) NOT NULL,
	[product ID] [int] NOT NULL,
	[version number] [decimal](18, 0) NOT NULL,
	[start date] [date] NOT NULL,
	[end date] [date] NOT NULL,
	[end dare in plan] [date] NOT NULL,
 CONSTRAINT [PK_development information] PRIMARY KEY CLUSTERED 
(
	[developmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[feature]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[feature](
	[versionID] [int] IDENTITY(1,1) NOT NULL,
	[feature] [varchar](50) NOT NULL,
	[new feature] [varchar](50) NOT NULL,
	[feature description] [nvarchar](max) NOT NULL,
	[last date of change] [date] NOT NULL,
 CONSTRAINT [PK_feature] PRIMARY KEY CLUSTERED 
(
	[versionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Phone]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Phone](
	[customer phoneID] [int] IDENTITY(1,1) NOT NULL,
	[phonenumber] [int] NULL,
	[phone type] [varchar](10) NULL,
 CONSTRAINT [PK_Phone] PRIMARY KEY CLUSTERED 
(
	[customer phoneID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[product description]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[product description](
	[productID] [int] IDENTITY(1,1) NOT NULL,
	[product name] [varchar](50) NOT NULL,
	[product feature] [nvarchar](max) NOT NULL,
	[product description] [nvarchar](max) NOT NULL,
	[versionID] [int] NOT NULL,
	[release number] [int] NOT NULL,
 CONSTRAINT [PK_product description] PRIMARY KEY CLUSTERED 
(
	[productID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[product information]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[product information](
	[productionID] [int] IDENTITY(1,1) NOT NULL,
	[release version] [decimal](18, 0) NOT NULL,
	[release date] [date] NOT NULL,
	[production type] [varchar](50) NULL,
	[release URL] [varchar](max) NOT NULL,
 CONSTRAINT [PK_product information] PRIMARY KEY CLUSTERED 
(
	[productionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[release download]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[release download](
	[DownloadID] [int] IDENTITY(1,1) NOT NULL,
	[customerID] [int] NOT NULL,
	[version number] [decimal](18, 0) NOT NULL,
	[productionID] [int] NOT NULL,
	[feature] [varchar](50) NOT NULL,
	[date] [datetime] NOT NULL,
	[branch number] [int] NOT NULL,
 CONSTRAINT [PK_release download] PRIMARY KEY CLUSTERED 
(
	[DownloadID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[version]    Script Date: 2016/5/11 23:27:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[version](
	[version ID] [int] IDENTITY(1,1) NOT NULL,
	[version number] [decimal](18, 1) NOT NULL,
	[version description] [nvarchar](max) NOT NULL,
	[version feature] [nvarchar](max) NULL,
 CONSTRAINT [PK_version_1] PRIMARY KEY CLUSTERED 
(
	[version ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[company] ON 

INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (1, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (2, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (3, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (4, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (5, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (6, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (7, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (8, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (9, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (10, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (11, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (12, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (13, N'ABC records', NULL, NULL)
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (14, N'ABC records', N'123 Privet Street Los Angeles CA 91601', N'USA')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (15, N'ABC records', N'123 Privet Street Los Angeles CA 91601', N'USA')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (16, N'ZYX Corp', N'348 Jinx Road London England', N'UK')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (17, N'ABC records', N'123 Privet Street Los Angeles CA 91601', N'USA')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (18, N'ZYX Corp', N'348 Jinx Road London England', N'UK')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (19, N'99 Store', N'', N'')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (20, N'ABC records', N'123 Privet Street Los Angeles CA 91601', N'USA')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (21, N'ZYX Corp', N'348 Jinx Road London England', N'UK')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (22, N'99 Store', N'', N'')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (23, N'99 Store', N'', N'')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (24, N'ABC records', N'123 Privet Street Los Angeles CA 91601', N'USA')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (25, N'ZYX Corp', N'348 Jinx Road London England', N'UK')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (26, N'99 Store', N'', N'')
INSERT [dbo].[company] ([companyID], [company name], [address], [country]) VALUES (27, N'99 Store', N'', N'')
SET IDENTITY_INSERT [dbo].[company] OFF
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (9, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (10, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (12, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (13, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (14, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (15, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (16, N'Maria Bounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (17, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (18, N'Maria Bounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (19, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (20, N'Maria Bounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (21, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (22, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (23, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (24, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (25, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (26, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (27, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (28, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (29, N'DavidSommerset', 3, N'Mr', N'david.sommerset@99cents.store', 3)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (30, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (31, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (32, N'DavidSommerset', 3, N'Mr', N'david.sommerset@99cents.store', 3)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (33, N'MariaBounte', 4, N'Mrs', N'maria.bounte@99cents.store', 4)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (34, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (35, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (36, N'DavidSommerset', 3, N'Mr', N'david.sommerset@99cents.store', 3)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (37, N'MariaBounte', 4, N'Mrs', N'maria.bounte@99cents.store', 4)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (38, N'PeterSmith', 1, N'Mr', N'p.smith@abc.com', 1)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (39, N'MariaBounte', 2, N'Mrs', N'maria@zyx.com', 2)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (40, N'DavidSommerset', 3, N'Mr', N'david.sommerset@99cents.store', 3)
INSERT [dbo].[Customer] ([customerID], [customer name], [companyID], [Title], [Email], [customer phoneID]) VALUES (41, N'MariaBounte', 4, N'Mrs', N'maria.bounte@99cents.store', 4)
SET IDENTITY_INSERT [dbo].[Customer] OFF
SET IDENTITY_INSERT [dbo].[feature] ON 

INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (1, N'Windows', N'new product release', N'login module', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (2, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (3, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (4, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (5, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (6, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (7, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (8, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (9, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (10, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (11, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (12, N'Windows', N'EHR System', N'health records system for the patients', CAST(0xAB240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (13, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (14, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (15, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (16, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (17, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (18, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (19, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (20, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (21, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (22, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (23, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (24, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (25, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (26, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x07240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (27, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (28, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (29, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (30, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (31, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (32, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (33, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (34, N'Windows', N'EHR System', N'health records system for the patients', CAST(0x80240B00 AS Date))
INSERT [dbo].[feature] ([versionID], [feature], [new feature], [feature description], [last date of change]) VALUES (35, N'Windows', N'EHR System', N'health records system for the patients', CAST(0xAB240B00 AS Date))
SET IDENTITY_INSERT [dbo].[feature] OFF
SET IDENTITY_INSERT [dbo].[Phone] ON 

INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (1, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (2, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (3, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (4, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (5, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (6, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (7, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (8, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (9, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (10, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (11, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (12, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (15, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (18, 1234858973, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (19, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (21, -9335, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (22, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (24, -9335, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (25, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (26, -88186, N'mobile')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (27, -9335, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (28, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (29, -88186, N'mobile')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (30, -99349, N'mobile')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (31, -9335, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (32, -397863923, N'work')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (33, -88186, N'mobile')
INSERT [dbo].[Phone] ([customer phoneID], [phonenumber], [phone type]) VALUES (34, -99349, N'mobile')
SET IDENTITY_INSERT [dbo].[Phone] OFF
SET IDENTITY_INSERT [dbo].[product description] ON 

INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (49, N'EHR System', N'Windows', N'health records system for the patients', 1, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (50, N'EHR System', N'Windows', N'health records system for the patients', 2, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (51, N'EHR System', N'Windows', N'health records system for the patients', 3, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (52, N'EHR System', N'Windows', N'health records system for the patients', 4, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (53, N'EHR System', N'Windows', N'health records system for the patients', 5, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (54, N'EHR System', N'Windows', N'health records system for the patients', 6, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (55, N'EHR System', N'Linux', N'health records system for the patients', 7, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (56, N'EHR System', N'Linux', N'health records system for the patients', 8, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (57, N'EHR System', N'Linux', N'health records system for the patients', 9, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (58, N'EHR System', N'Linux', N'health records system for the patients', 10, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (59, N'EHR System', N'Linux', N'health records system for the patients', 11, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (60, N'EHR System', N'Linux', N'health records system for the patients', 12, 11)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (61, N'EHR System', N'Windows', N'health records system for the patients', 13, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (62, N'EHR System', N'Windows', N'health records system for the patients', 14, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (63, N'EHR System', N'Windows', N'health records system for the patients', 15, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (64, N'EHR System', N'Windows', N'health records system for the patients', 16, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (65, N'EHR System', N'Linux', N'health records system for the patients', 17, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (66, N'EHR System', N'Linux', N'health records system for the patients', 18, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (67, N'EHR System', N'Linux', N'health records system for the patients', 19, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (68, N'EHR System', N'Linux', N'health records system for the patients', 20, 21)
INSERT [dbo].[product description] ([productID], [product name], [product feature], [product description], [versionID], [release number]) VALUES (69, N'EHR System', N'Linux', N'health records system for the patients', 21, 21)
SET IDENTITY_INSERT [dbo].[product description] OFF
SET IDENTITY_INSERT [dbo].[version] ON 

INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (1, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (2, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (3, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (4, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (5, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (6, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (7, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (8, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (9, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (10, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (11, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (12, CAST(1.0 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (13, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (14, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (15, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (16, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (17, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (18, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (19, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (20, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (21, CAST(2.0 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting bug fix')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (22, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (23, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (24, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (25, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (26, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (27, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (28, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (29, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (30, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (31, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (32, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (33, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (34, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (35, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (36, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (37, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (38, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (39, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (40, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (41, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (42, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting bug fix')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (43, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (44, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (45, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (46, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (47, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (48, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (49, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (50, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (51, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (52, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (53, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (54, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (55, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (56, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (57, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (58, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (59, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (60, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (61, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (62, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (63, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting bug fix')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (64, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (65, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (66, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (67, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (68, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (69, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (70, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'login module')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (71, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient registration')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (72, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (73, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient release form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (74, CAST(1.2 AS Decimal(18, 1)), N'health records system for the patients', N'physician profile')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (75, CAST(1.1 AS Decimal(18, 1)), N'health records system for the patients', N'address verification')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (76, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (77, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (78, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (79, CAST(2.1 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (80, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient authentication')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (81, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient medication form')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (82, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient e-bill')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (83, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting')
INSERT [dbo].[version] ([version ID], [version number], [version description], [version feature]) VALUES (84, CAST(2.2 AS Decimal(18, 1)), N'health records system for the patients', N'patient reporting bug fix')
SET IDENTITY_INSERT [dbo].[version] OFF
ALTER TABLE [dbo].[branch]  WITH CHECK ADD  CONSTRAINT [FK_branch_development information] FOREIGN KEY([development ID])
REFERENCES [dbo].[development information] ([developmentID])
GO
ALTER TABLE [dbo].[branch] CHECK CONSTRAINT [FK_branch_development information]
GO
ALTER TABLE [dbo].[branch]  WITH CHECK ADD  CONSTRAINT [FK_branch_product information] FOREIGN KEY([production ID])
REFERENCES [dbo].[product information] ([productionID])
GO
ALTER TABLE [dbo].[branch] CHECK CONSTRAINT [FK_branch_product information]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_company1] FOREIGN KEY([companyID])
REFERENCES [dbo].[company] ([companyID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_company1]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Phone1] FOREIGN KEY([customer phoneID])
REFERENCES [dbo].[Phone] ([customer phoneID])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Phone1]
GO
ALTER TABLE [dbo].[customer release]  WITH CHECK ADD  CONSTRAINT [FK_customer release_Customer] FOREIGN KEY([customerID])
REFERENCES [dbo].[Customer] ([customerID])
GO
ALTER TABLE [dbo].[customer release] CHECK CONSTRAINT [FK_customer release_Customer]
GO
ALTER TABLE [dbo].[customer release]  WITH CHECK ADD  CONSTRAINT [FK_customer release_release download] FOREIGN KEY([downloadID])
REFERENCES [dbo].[release download] ([DownloadID])
GO
ALTER TABLE [dbo].[customer release] CHECK CONSTRAINT [FK_customer release_release download]
GO
ALTER TABLE [dbo].[development information]  WITH CHECK ADD  CONSTRAINT [FK_development information_product description] FOREIGN KEY([product ID])
REFERENCES [dbo].[product description] ([productID])
GO
ALTER TABLE [dbo].[development information] CHECK CONSTRAINT [FK_development information_product description]
GO
ALTER TABLE [dbo].[product description]  WITH CHECK ADD  CONSTRAINT [FK_product description_feature] FOREIGN KEY([versionID])
REFERENCES [dbo].[feature] ([versionID])
GO
ALTER TABLE [dbo].[product description] CHECK CONSTRAINT [FK_product description_feature]
GO
ALTER TABLE [dbo].[product description]  WITH CHECK ADD  CONSTRAINT [FK_product description_version] FOREIGN KEY([versionID])
REFERENCES [dbo].[version] ([version ID])
GO
ALTER TABLE [dbo].[product description] CHECK CONSTRAINT [FK_product description_version]
GO
ALTER TABLE [dbo].[release download]  WITH CHECK ADD  CONSTRAINT [FK_release download_branch] FOREIGN KEY([branch number])
REFERENCES [dbo].[branch] ([branch number])
GO
ALTER TABLE [dbo].[release download] CHECK CONSTRAINT [FK_release download_branch]
GO
