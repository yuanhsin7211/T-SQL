--*SQL Ch1--*--

--SELECT/WHERE/AND/OR/ORDER BY/Datatype conversion/

--use [AdventureWORksDW2012]

--SELECT-----------------------------------------------------------------------------------------------
SELECT 1 
--A column alias immediately follows a column name in the SELECT clause of a SELECT statement. 
--Enclose the alias in single or double quotes if it is a reserved keyword or if it contains spaces, punctuation, or special characters. 
--You can omit the quotes if the alias is a single non-reserved word that contains only letters, digits, or underscores.

--SELECT 1+3 as ID,'9/1/2016' as SDate

SELECT '9/1/2016' AS SDate,'9-1-2013',1 as "Col1",2 as 'Col2'

--
USE [AdventureWORks2012]
SELECT *
FROM [Person].[Person] p

SELECT Count(*)
FROM [Person].[Person]

SELECT e.BusinessEntityID,e.HireDate,e.JobTitle
FROM [HumanResources].[Employee] e

SELECT DISTINCT e.ORganizationLevel as 'Organization Level'
FROM [HumanResources].[Employee] e

SELECT TOP 10 e.BusinessEntityID,e.HireDate,e.JobTitle,e.ORganizationLevel
FROM [HumanResources].[Employee] e

SELECT TOP 1 PERCENT * 
FROM Sales.Customer;

SELECT [BusinessEntityID], [SalesYTD]*[CommissionPct] 'Annual Commission'
FROM [Sales].[SalesPerson]


--Using string concatenation

SELECT FirstName,LastName,FirstName+','+LastName AS 'Name'
FROM [Person].[Person]

 
USE AdventureWORks2012;
GO
SELECT 'The ORDER due Date: ' + CONVERT(varchar(12), DueDate, 101)
FROM Sales.SalesORDERHeader
WHERE SalesORDERID = 50000;
GO


USE AdventureWORks2012;
GO
SELECT (LastName + ',' + SPACE(1) + SUBSTRING(FirstName, 1, 1) + '.') AS Name
FROM Person.Person AS p
    JOIN HumanResources.Employee AS e
    ON p.BusinessEntityID = e.BusinessEntityID
WHERE e.JobTitle LIKE 'Vice%'
ORDER BY LastName ASC;
GO

---WHERE------------------------------------------------------------------------------

SELECT *
FROM [HumanResources].[Employee] 
WHERE ORganizationLevel = 1

SELECT *
FROM [HumanResources].[Employee] 
WHERE JobTitle in( 'Design Engineer','Research AND Development Engineer')

SELECT *
FROM [HumanResources].[Employee] 
WHERE 
--HireDate = '2002-03-03'
HireDate = '3/3/2002'

SELECT *
FROM [HumanResources].[Employee] 
WHERE HireDate between '01/01/2003' AND '01/01/2004'

SELECT 'The list price is ' + CAST(ListPrice AS varchar(12)) AS ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 350.00 AND 400.00;

SELECT *
FROM [HumanResources].[Employee] 
WHERE VacationHours>80

SELECT TOP 5 e.BusinessEntityID,e.JobTitle
FROM [HumanResources].[Employee] e
WHERE JobTitle like 'Marketing%'

SELECT TOP 5 *
FROM [HumanResources].[Employee] 
WHERE [LoginID] like '%works\ken_'

SELECT TOP 5 a.AddressID,a.City
FROM Person.Address a
WHERE City = 'Villeneuve-d''Ascq'

--know the difference between '%A%' AND '%A' AND 'A%'?
SELECT e.FirstName
FROM [AdventureWORksDW2012].[dbo].[DimEmployee] e
WHERE e.FirstName like '%A%'

SELECT e.FirstName
FROM [AdventureWORksDW2012].[dbo].[DimEmployee] e
WHERE e.FirstName like '%A'

SELECT e.FirstName
FROM [AdventureWORksDW2012].[dbo].[DimEmployee] e
WHERE e.FirstName like 'A%'

----AND /OR------------------------------------------------------------------------------------

SELECT *
FROM [HumanResources].[Employee] 
WHERE HireDate >'01/01/2003' AND ORganizationLevel=1

SELECT *
FROM [HumanResources].[Employee] 
WHERE JobTitle='Design Engineer' OR JobTitle='Chief Financial Officer'

SELECT e.BusinessEntityID,e.HireDate,e.JobTitle
FROM [HumanResources].[Employee] e
WHERE HireDate>'01/01/2003'
      AND (JobTitle='Design Engineer' OR JobTitle='Chief Financial Officer')

SELECT e.BusinessEntityID,e.HireDate,e.JobTitle
FROM [HumanResources].[Employee] e
WHERE (HireDate>'01/01/2003' AND JobTitle='Chief Financial Officer') 
     OR JobTitle='Design Engineer'


---ORDER BY -------------------------------------------------------------------------------

SELECT TOP 10 e.BusinessEntityID,e.HireDate,e.JobTitle,e.ORganizationLevel
FROM [HumanResources].[Employee] e
ORDER BY e.HireDate

SELECT TOP 10 e.BusinessEntityID,e.HireDate,e.JobTitle,e.ORganizationLevel
FROM [HumanResources].[Employee] e
ORDER BY e.HireDate desc

SELECT TOP 10 e.BusinessEntityID,e.HireDate,e.JobTitle,e.ORganizationLevel
FROM [HumanResources].[Employee] e
ORDER BY 4,2


---Datatype conversion-----------------------------------------------------------------------------------------
--When convert data types that differ in decimal places,the result value is truncated OR rounded.
SELECT CAST ( $157.27 AS VARCHAR(10) ),
       CAST(10.6496 AS int),
	   CAST(10.6496 AS decimal(6,2)),
       CAST(10.3496847 AS money),
	   CONVERT(int, 15.66)
	  
SELECT 
   GETDATE() AS UnconvertedDateTime,
   CAST(GETDATE() AS nvarchar(30)) AS UsingCast,
   CONVERT(nvarchar(30), GETDATE(), 126) AS UsingConvert

SELECT CONVERT(nvarchar(30), GETDATE(), 1)    ,1 AS sort
UNION
SELECT CONVERT(nvarchar(30), GETDATE(), 101)  ,2 
UNION
SELECT CONVERT(nvarchar(30), GETDATE(), 102)  ,3
UNION
SELECT CONVERT(nvarchar(30), GETDATE(), 105)  ,4
UNION
SELECT CONVERT(nvarchar(30), GETDATE(), 111)  ,5

ORDER BY 2

---conversion Error ----------------------
SELECT CAST('abc' AS int);



--sample dataset query for SSRS---------------------------------------------------------------
--1
SELECT DISTINCT CountryRegionCode
  FROM [AdventureWORks2012].[Sales].[SalesTerritORy]
  ORDER BY 1

--2
SELECT DISTINCT [DepartmentName]
FROM [AdventureWORksDW2012].[dbo].[DimEmployee]
ORDER BY 1

--3
SELECT DISTINCT    t.[Group] as TerritORy
FROM Sales.SalesTerritORy t
ORDER BY 1

--4
SELECT DISTINCT f.Shift
FROM            FactCallCenter f
ORDER BY 1

--5
SELECT DISTINCT  [EmployeeKey],ParentEmployeeKey
      ,[SalesTerritORyKey]
	   ,[DepartmentName]
      ,[FirstName]
      ,[LastName]
      ,[Title]
      ,[HireDate]
      ,[PayFrequency]
      ,[BaseRate]
      ,[VacationHours]
	  ,e.Status
FROM [AdventureWORksDW2012].[dbo].[DimEmployee] e
WHERE e.ParentEmployeeKey=3
AND e.Status is not null
ORDER BY 1,2,4,5

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
