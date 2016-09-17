---SQL Ch1 Project & Solution

--1------------------------------------------------------------------------------------------	
--use [AdventureWorks2012].[Sales].[SalesPerson] table
--1a--Display all Records when terrotoryID is 6

SELECT *
FROM [AdventureWorks2012].[Sales].[SalesPerson] s
WHERE s.TerritoryID=6

--1b--Display a list of CommissionPct value (no duplicate) during modified date range  6/1/2005' AND '6/1/2006

SELECT DISTINCT s.[CommissionPct]
FROM [AdventureWorks2012].[Sales].[SalesPerson] s
WHERE s.ModifiedDate BETWEEN '6/1/2005' AND '6/1/2006'

--2---------------------------------------------------------------------------------------
--use Table [AdventureWorks2012].[Person].[Person]
--2a 
--Requirement : get records FROM Person Table for PersonType GC AND EM
--AND Modified Date  BETWEEN January AND June of 2004 
--sort by modified date in ascending order 

SELECT  *
--[FirstName], [LastName],[FirstName]+' | '+ [LastName] as Fullname
FROM  [Person].[Person]
WHERE [ModifiedDate] BETWEEN '1/1/2004' AND  '6/30/2004'
      AND [PersonType] IN ('GC','EM')
ORDER BY [ModifiedDate]  

--2b
--Requirement : get records FROM Person Table for Modified Date in 2008
--display fields:p.BusinessEntityID,Fullname ( Formate "First Name ,Last Name" ) ,p.ModifiedDate
--sort result by modified date in descending order,then by Last Name 

SELECT p.BusinessEntityID,p.[FirstName]+','+ p.[LastName] as FullName,p.ModifiedDate
FROM  [Person].[Person] p
WHERE year([ModifiedDate])=2008
ORDER BY [ModifiedDate] desc,p.LastName  

--3-------------------------------------------------------------------------------------------
--use table: [AdventureWorksDW2012].[dbo].[DimProduct]
--Requirements: 
--1 SELECT fields :[ProductKey] ,[EnglishProductName],[Color],[ListPrice] ,[DealerPrice],[ModelName] ,[StartDate] ,[Status]
--2 for products with red or silver color,not null Status,Start date later than 2007/1/1,  Model Name contain "Mountain" or Model name Start with "Road",AND Dealerprice more than 500
--AND less than 1500
--3) only display the top 5 records with higest dealerprice sorted FROM highest to lowest
 
 SELECT TOP 5 [ProductKey]  ,[EnglishProductName]    
       ,[Color] ,[ListPrice] ,[DealerPrice] ,[ModelName]
       ,[StartDate] ,[Status]
 FROM [AdventureWorksDW2012].[dbo].[DimProduct] p
 WHERE p.Status IS NOT NULL
    AND p.StartDate>'2007/01/01'
    AND (p.ModelName LIKE '%Mountain%' OR p.ModelName LIKE 'Road%')
    AND p.Color IN ('Silver','Red')
    AND p.DealerPrice BETWEEN 500 AND 1500
 ORDER BY [DealerPrice] DESC

--4 --use [AdventureWorks2012].[Sales].[SalesPerson] table
--display [BusinessEntityID] ,[TerritoryID] ,[Bonus] ,[SalesYTD],[ModifiedDate]
 --Requirements: 
 -- show [SalesYTD] with no digits to the right of the decimal,show  [ModifiedDate] as mm/dd/yyyy
 -- display [TerritoryID] column value as "Territory : number".for example : if [TerritoryID]=1,the displayed value should be "Territory :1"
 -- if [TerritoryID]=2 , the displayed value should be "Territory : 2"
 -- only need records for TerritoryID =1,4,or 6 AND  Bonus is 5000 or Bonus no more than 2000
 --Sort the result by SalesYTD FROM highest to lowest,then by TerritoryID,then businessEntityID
 
  SELECT  [BusinessEntityID]
      ,'Territory: '+CAST([TerritoryID] AS VARCHAR(2))
      ,[Bonus]
	  ,CAST([SalesYTD] AS int) AS SalesYTDc
      ,CONVERT(VARCHAR(10),[ModifiedDate],101) AS ModifiedDate,
	  len([ModifiedDate]),[ModifiedDate]
 FROM [AdventureWorks2012].[Sales].[SalesPerson] s
 WHERE s.TerritoryID IN (1,4,6)
     AND (s.Bonus=5000.00 OR s.Bonus<=2000)
 ORDER BY 4 DESC ,2,1
