/****** Script for SELECTTopNRows commAND FROM SSMS  ******/
------SQL Ch3 Project & Solution-------------------------------------------- 

--project 1 ;Subquery/UNION\Aggregate Functions
-- USE table [AdventureWorks2012].[Sales].[SalesOrderDetail]
--  get all records (These Records can be any Month )that have the same price as the highest Unitprice in Aug (for ModifiedDate in August) together with records that have the same price as the lowest UnitPrice in Aug
-- sort Result by SalesOrderID, SalesOrderdetailID

	  SELECT *
	  FROM [AdventureWorks2012].[Sales].[SalesOrderDetail] s
	  WHERE s.UnitPrice=
	     (SELECT Max(Unitprice)
		  FROM [AdventureWorks2012].[Sales].[SalesOrderDetail] s1
		  WHERE Month(s1.ModifiedDate)=8)

	  UNION

	  SELECT *
	  FROM [AdventureWorks2012].[Sales].[SalesOrderDetail] s
	  WHERE s.UnitPrice=
		   (SELECT min(Unitprice)
			FROM [AdventureWorks2012].[Sales].[SalesOrderDetail] s1
			WHERE Month(s1.ModifiedDate)=8)

	  ORDER BY 1,2

--Project 2 :Join/CASE/Subquery/in
--USE table:
--[AdventureWorks2012].[Production].[ProductInventory],
--[Production].[Product],
--[Production].[Location] 
--columns: ProductID ,Name,ProductLine (if NULL value,display N/A,if M,display 'Mountain',if T display 'Touring',all others ,display 'others') ,SellStartDate,LocationID,Availability,shelf,quantity
--requirements: get products with "sellstartdate" in 2006, AND their location with Total Availability less than 50


USE [AdventureWorks2012]
SELECT p.[ProductID],p.Name
      ,CASE p.ProductLine
	      WHEN NULL THEN 'N/A'
		  WHEN 'M' THEN 'Mountain'
		  WHEN 'T' THEN 'Touring'
	      ELSE 'Others' 
	  END AS ProductLine 
	  ,p.SellStartDate
      ,i.[LocationID],l.Availability AS NumberofAvailability
      ,i.[Shelf]  ,i.[Quantity]
      
FROM [AdventureWorks2012].[Production].[ProductInventory] i
       INNER JOIN [Production].[Product] p ON i.ProductID=p.ProductID
	   INNER JOIN [Production].[Location] l ON i.LocationID=l.LocationID
WHERE YEAR(p.SellStartDate) =2006
	  AND  i.LocationID IN
		     (SELECT lo.LocationID 
		      FROM [Production].[Location] lo
		      GROUP BY lo.LocationID
		      HAVING SUM(lo.Availability ) < 50 )

ORDER BY 1

--if USE join,not USE subquery 

 SELECT p.[ProductID],p.Name
       ,CASE p.ProductLine
	      WHEN NULL THEN 'N/A'
		  WHEN 'M' THEN 'Mountain'
		  WHEN 'T' THEN 'Touring'
	      ELSE 'Others' 
	   END AS ProductLine 
	   ,p.SellStartDate
       ,i.[LocationID],l.Availability as NumberofAvailability
       ,i.[Shelf]  ,i.[Quantity]
      
 FROM [AdventureWorks2012].[Production].[ProductInventory] i
       INNER JOIN [Production].[Product] p on i.ProductID=p.ProductID
	   INNER JOIN [Production].[Location] l on i.LocationID=l.LocationID
 WHERE  YEAR(p.SellStartDate) =2006    
       AND  l.Availability <50
 ORDER BY 1	   
		 

--Project 3: self join---------
--USE [AdventureWorksDW2012] [dbo].[DimEmployee]
--show list of Employees in other Department that have the same baseRate as Employees in Information Services department 
--only show records with baseRate >30
--list Employee's DepartmentName,EmployeeKey,BaseRate,FirstName,LastName, AND the DepartmentName,EmployeeKey,BaseRate,FirstName,LastName of same base rate Employees who are 
--in  Information Services department ,it is to compare Side-by-Side

USE [AdventureWorksDW2012]
SELECT e1.DepartmentName,e1.EmployeeKey,e1.BaseRate,e1.FirstName,e1.LastName
      ,e2.DepartmentName,e2.EmployeeKey,e2.BaseRate,e2.FirstName,e2.LastName
FROM [dbo].[DimEmployee] e1,[dbo].[DimEmployee] e2
WHERE e1.BaseRate=e2.BaseRate
     AND e2.DepartmentName='Information Services'
     AND e1.DepartmentName<>'Information Services'
     AND e1.BaseRate>30


--Project 4: subquery +Aggregate Functions
--USE [AdventureWorksDW2012] [dbo].[DimEmployee]
--display DepartmentName ,Average BaseRate for each Department 
--only show a list of deps that have Female Employees whose average base Rates are more than the maximum baseRate
--of Current Status employees in Human Resources department 
 
 USE [AdventureWorksDW2012]

 SELECT DepartmentName,AVG(BaseRate)
 FROM [dbo].[DimEmployee] 
 WHERE DepartmentName in
     (SELECT e.DepartmentName
      FROM [dbo].[DimEmployee] e
      WHERE e.Gender='F'
      GROUP BY e.DepartmentName
      HAVING AVG(e.BaseRate) > (SELECT MAX(e1.BaseRate) 
							    FROM [dbo].[DimEmployee] e1
							    WHERE e1.Status='Current'
							    AND e1.DepartmentName='Human Resources') ) 
GROUP BY DepartmentName


--Project 5: CASE +date function
--USE [AdventureWorksDW2012]  table [DimEmployee]
--need a list of Employee in Production department
--show fields: EmployeeKey,DepartmentName,FirstName,LastName,BirthDate
--            ,Age (calculate age based on BirthDate up to today)
--            ,AgeFlag(if Age >50,show '>50'; if age 40-49,show 40s; if age 30-39 show 30s;if age <30 ,show '<30'
--calculate age: SELECT FLOOR(DATEDIFF(DAY, @date1 , @date2) / 365.25)		


USE [AdventureWorksDW2012]
SELECT e.EmployeeKey,e.DepartmentName,e.FirstName,e.LastName,e.BirthDate
     ,FLOOR(DATEDIFF(DAY, e.BirthDate , getdate())/ 365.25) AS EEAge
     , CASE WHEN FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) >=50 THEN '> 50'
            WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) BETWEEN 40 AND 49 THEN '40s'
	        WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) BETWEEN 30 AND 39 THEN '30s'
	        WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) <30 THEN '< 30'
	   END AS AgeFlag
--,AgeFlag=
--  CASE WHEN FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) >=50 THEN '> 50'
--       WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) BETWEEN 40 AND 49 THEN '40s'
--	   WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) BETWEEN 30 AND 39 THEN '30s'
--	   WHEN	FLOOR(DATEDIFF(DAY, e.BirthDate , getdate()) / 365.25) <30 THEN '< 30'
--	   end 

FROM [dbo].[DimEmployee] e
WHERE e.DepartmentName='Production'


---project 6--derived table------------- 
--USE  [AdventureWorksDW2012].[dbo].[FactSalesQuota] AND [DimEmployee]
--display fields;  EmployeeKey,TotalSalesQuota ,FirstName ,LastName
--need a list of top 10 Employees with the highest total SalesAmountQuota in CalendarYear 2008

 SELECT fq.EmployeeKey,fq.TotalSalesQuota,e.FirstName,e.LastName
 FROM [dbo].[DimEmployee] e
    INNER JOIN 
       (SELECT top 10 [EmployeeKey]  ,SUM([SalesAmountQuota]) AS TotalSalesQuota
        FROM [AdventureWorksDW2012].[dbo].[FactSalesQuota] f
        WHERE f.CalendarYear='2008'
        GROUP BY [EmployeeKey]
        ORDER BY 2 DESC	) AS fq 
    ON e.EmployeeKey=fq.EmployeeKey 


 --project 7
 --USE table [Sales].[SalesOrderHeader]
 --display CustomerID,OrderDate,SalesOrderID,SubTotal
 --Return all order details FROM the Customer who placed the highest Total number of orders (count SalesOrderID )
 
 USE [AdventureWorks2012]
SELECT h.CustomerID,h.OrderDate,h.SalesOrderID,h.SubTotal
FROM [Sales].[SalesOrderHeader] h
WHERE h.CustomerID = (SELECT TOP 1 CustomerID
                      FROM [Sales].[SalesOrderHeader]
                      GROUP BY CustomerID
                      ORDER BY COUNT(SalesOrderID) DESC )


-----USE the following code if more than 1 customers placed same highest Number of orders,you will understAND this query WHEN you complete Ch7
WITH cte_tbl(CustomerID,rankv)
AS
	   (SELECT  CustomerID,RANK() OVER(ORDER BY COUNT(SalesOrderID) DESC) AS rankv
        FROM [Sales].[SalesOrderHeader]
        GROUP BY CustomerID)

SELECT h.CustomerID,h.OrderDate,h.SalesOrderID,h.SubTotal
FROM [Sales].[SalesOrderHeader] h 
WHERE h.CustomerID IN
	(SELECT c.CustomerID
	 FROM  cte_tbl c
	 WHERE c.rankv=1	)	
ORDER BY 1		  
                      
