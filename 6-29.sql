--Write queries for following scenarios
--Using AdventureWorks Database
USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT Count(ProductID) [number]
FROM Production.Product

--2.Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory.
--	The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT Count(ProductID) [number]
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

/*
SELECT ProductID, Name, ProductSubcategoryID --[number]
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
*/
--SELECT * FROM Production.Product

--3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, Count(ProductSubcategoryID)[CountedProducts]
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID

--4.How many products that do not have a product subcategory.
SELECT Count(ProductID) [number]
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--5.Write a query to list the sum of products quantity in the Production.ProductInventory table.
--SELECT TOP 20 * FROM Production.ProductInventory WHERE LocationID = 10
SELECT SUM(Quantity)[sum]
FROM Production.ProductInventory
GROUP BY ProductID --may not need this one, the question is ambiguous.

--6.Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and 
--	limit the result to include just the ProductIds that have less than 100 total in sum.
SELECT ProductID, SUM(Quantity)[TheSum]
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity)<100

--7.Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and 
--	LocationID set to 40 and include the ProductIds that have less than 100 total in sum.
SELECT Shelf, ProductID, SUM(Quantity)[TheSum]
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity)<100

/*
SELECT Shelf, ProductID--, Name--, SUM(Quantity)[sum]
FROM Production.ProductInventory
WHERE ProductID=814
*/

--8.Write the query to list the average quantity for products where column LocationID has the value of 10 from the 
--	table Production.ProductInventory table.
SELECT AVG(quantity)[TheAvg] 
FROM Production.ProductInventory
WHERE LocationID = 10
--GROUP BY ProductID

--9.Write query to see the average quantity of products by shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(quantity)[TheAvg] 
FROM Production.ProductInventory
GROUP BY Shelf, ProductID

--10.Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the 
--	column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(quantity)[TheAvg] 
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY Shelf, ProductID

--11.List the members (rows) and average list price in the Production.Product table. This should be grouped 
--	independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, Count(*)[TheCount], AVG(ListPrice)[AvgPrice]
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color, Class

--Joins:
--12.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
--	Join them and produce a result set similar to the following.
SELECT c.Name [Country], s.Name [Province]
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
ORDER BY c.Name

/*
SELECT *
FROM Person.StateProvince s

SELECT *
FROM Person.CountryRegion c
*/

--13.Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables 
--	and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT c.Name [Country], s.Name [Province]
FROM Person.CountryRegion c JOIN Person.StateProvince s
ON c.CountryRegionCode = s.CountryRegionCode
WHERE c.Name IN ('Germany', 'Canada')
ORDER BY c.Name

--Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind
GO

--14.List all Products that has been sold at least once in last 25 years.
SELECT *
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE 2022-YEAR(o.OrderDate)<=25

/*
SELECT *
FROM Products

SELECT*
FROM [Order Details]

SELECT *
FROM Orders
*/

--15.List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 o.ShipPostalCode [ZipCode], COUNT(od.Quantity) [Num]
FROM Orders o JOIN [Order Details] od
ON o.OrderID=od.OrderID
WHERE o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY Num DESC

--16.List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 o.ShipPostalCode [ZipCode], COUNT(od.Quantity) [Num]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE 2022-YEAR(o.OrderDate)<=25 AND o.ShipPostalCode IS NOT NULL
GROUP BY o.ShipPostalCode
ORDER BY Num DESC

--17.List all city names and number of customers in that city. 
SELECT ShipCity [City], COUNT(CustomerID) [Num]
FROM Orders
GROUP BY ShipCity

SELECT City, COUNT(CustomerID) AS [Num] 
FROM Customers
GROUP BY City--Don't know which one is correct.

--18.List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) [Num] 
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2

--19.List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate
FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID
--JOIN Orders o ON od.OrderID = o.OrderID
WHERE o.OrderDate >= '1.1.1998'

--20.List the names of all customers with most recent order dates
SELECT c.ContactName, o.OrderDate
FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate DESC

--21.Display the names of all customers along with the count of products they bought
SELECT c.ContactName, SUM(od.Quantity)[Num]
FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName

--22.Display the customer ids who bought more than 100 Products with count of products.
SELECT c.ContactName, SUM(od.Quantity)[Num]
FROM Orders o JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.ContactName
HAVING SUM(od.Quantity) > 100

--23.List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT su.CompanyName [Supplier Company Name],sp.CompanyName [Shipping Company Name]
FROM Shippers sp CROSS JOIN Suppliers su

--24.Display the products order each day. Show Order date and Product Name.
SELECT DISTINCT o.OrderDate, p.ProductName
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
ORDER BY o.OrderDate

--25.Displays pairs of employees who have the same job title.
SELECT e.LastName, e.Title, m.LastName, m.Title
FROM Employees e JOIN Employees m
ON e.Title = m.Title

--SELECT *
--FROM Employees e --JOIN Employees m
--ON e.Title = m.Title

--26.Display all the Managers who have more than 2 employees reporting to them.
SELECT e.LastName, e.Title, e.ReportsTo, m.LastName, m.Title
FROM Employees e JOIN Employees m
ON e.ReportsTo = m.EmployeeID
GROUP BY e.ReportsTo
HAVING COUNT(e.ReportsTo) > 2

SELECT e.FirstName [Manager], COUNT(m.ReportsTo)[Num]
FROM Employees e Left JOIN Employees m
ON e.ReportsTo = m.EmployeeID
--ORDER BY e.EmployeeID
GROUP BY e.FirstName
HAVING e.ReportsTo IS NOT NULL
--HAVING COUNT(e.ReportsTo) > 2 
/*Buggy, need to be fixed*/

--27.Display the customers and suppliers by city. The results should have the following columns
SELECT csc.City, csc.CompanyName [Name], csc.ContactName, csc.Relationship [Type (Customer or Supplier)]
FROM [Customer and Suppliers by City] csc;