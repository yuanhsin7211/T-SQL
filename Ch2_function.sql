--*SQL Ch2--*--

--Concatenate/substring/RTRIM/LETRIM/LEN/Replace-----------------------------------------

SELECT [FirstName], [LAStName],[FirstName]+' , '+ [LAStName] AS Fullname
      ,SUBSTRING ([FirstName], 1, 3) AS First3Char
      ,RTRIM('   Sample   ') AS RightTrim ,LTRIM('   Sample   ') AS LeftTrim
      ,Len([FirstName]) AS LengthofFName
      ,Replace([LAStName],'cromb','-b')AS ReplaceName
      ,UPPER([FirstName]) AS UpperName

FROM  [Person].[Person] 


--Null ,ISNULL(),nullif ,COALESCE() ----------------------------------------------
SELECT *
FROM [Person].Address 
WHERE [AddressLine2] IS NULL

SELECT *
FROM [Person].Address 
WHERE [AddressLine2] IS NOT NULL


SELECT a.AddressLine1,a.AddressLine2,isnull(a.AddressLine2,'MissingAddress2') AS ErrorInfo
FROM [Person].Address a
WHERE [AddressLine2] IS NULL



---COALESCE--------------------------------------------------------------------------------
SELECT [EEID],[EEName], COALESCE ([BusinessPhone],[CellPhone],[HomePhone]) Contact_Phone
FROM A_ContactPhone 



---nullif---------------------------------------------------------------
SELECT [EEID],[EEName], NULLIF ([Actual],[Goal]) NULLIFResult
FROM A_ContactPhone 




---Date function-----------------------------------------------------------------------
 
 SELECT GETDATE(),DATEPART(M,'8/1/13'), DATEADD(d,-1,'8/1/13'), DATEDIFF(m,'8/1/12','8/1/13')


 SELECT CONVERT(VARCHAR(19),GETDATE())
	,CONVERT(VARCHAR(10),GETDATE(),10)
	,CONVERT(VARCHAR(10),GETDATE(),110)
	,CONVERT(VARCHAR(11),GETDATE(),6)
	,CONVERT(VARCHAR(11),GETDATE(),106)
	,CONVERT(VARCHAR(24),GETDATE(),113)


SELECT month('8/1/13'),year('8/1/13'),day('8/1/13')

SELECT YEAR(0), MONTH(0), DAY(0);

----Aggregate Functions
--only unique values are considered in the calculation
SELECT AVG(DISTINCT ListPrice)
FROM Production.Product;

--including any duplicate values
SELECT AVG(ListPrice)
FROM Production.Product;

SELECT AVG(f.SalesAmount) AS SalesAverage,MAX(f.SalesAmount) AS HighestSales
,MIN(f.SalesAmount) AS LowestSales,SUM(f.SalesAmount) AS TotalSales
,COUNT(*) AS NumberofRecords,COUNT(DISTINCT f.SalesOrderNumber) AS NumberofSalesOrder
FROM dbo.FactInternetSales f

---MATH FUNCTIONS---
---ABS:eturns the absolute (positive) value of the specified numeric expression----
SELECT ABS(-1.9), ABS(0.0), ABS(5.0); 

-- / ; DIVIDE , %: MODULO REMAINER OF ONE NUMBER DIVIDED BY ANOTHER--
SELECT 100/10,105%10

---ROUND Returns a numeric expression, rounded to the specified length or precision---
SELECT ROUND(123.5678, 2), ROUND(321.9965, 3) 
GO

---CEILING£ºReturns the smallest integer greater than, or equal to, the specified numeric expression¡¡----
SELECT CEILING($123.456), CEILING($-123.456), CEILING($0.0) 


--GROUP BY

SELECT f.SalesTerritoryKey,AVG(f.SalesAmount) AS SalesAverage,MAX(f.SalesAmount) AS HighestSales
    ,MIN(f.SalesAmount) AS LowestSales,SUM(f.SalesAmount) AS TotalSales
    ,COUNT(*) AS NumberofRecords,COUNT(DISTINCT f.SalesOrderNumber) AS NumberofSalesOrder
FROM dbo.FactInternetSales f
GROUP BY f.SalesTerritoryKey
ORDER BY 1


SELECT Color, SUM(ListPrice), SUM(StandardCost)
FROM Production.Product
WHERE Color IS NOT NULL 
    AND ListPrice != 0.00 
    AND Name LIKE 'Mountain%'
GROUP BY Color
ORDER BY Color;

--HAVING

SELECT f.SalesTerritoryKey,AVG(f.SalesAmount) AS SalesAverage,MAX(f.SalesAmount) AS HighestSales
   ,MIN(f.SalesAmount) AS LowestSales,SUM(f.SalesAmount) AS TotalSales
   ,COUNT(*) AS NumberofRecords,COUNT(DISTINCT f.SalesOrderNumber) AS NumberofSalesOrder
FROM dbo.FactInternetSales f
GROUP BY f.SalesTerritoryKey
HAVING AVG(f.SalesAmount)>400
ORDER BY 1
