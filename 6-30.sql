--Write queries for following scenarios
/*Author: Yifan Liao*/
--Using Northwind Database
USE Northwind
GO

--1.List all cities that have both Employees and Customers
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City IN (SELECT c.City FROM Customers c)

--2.List all cities that have Customers but no Employee
--a.Use sub-query
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (SELECT e.City FROM Employees e)

--b.not using subquery
SELECT DISTINCT c.City
FROM Customers c
EXCEPT
SELECT e.City FROM Employees e

--3.List all products and their total order quantities throughout all orders.
SELECT p.ProductID, SUM(od.quantity)[Total]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID

--4.List all Customer Cities and total products ordered by that city.
SELECT c.City, COUNT(od.quantity)[Total]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City
ORDER BY c.City

--Splited by product
SELECT c.City, p.ProductID, COUNT(od.quantity)[Total]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City, p.ProductID
ORDER BY c.City

--5.List all Customer Cities that have at least two customers
--a.use union
/*need to be fixed*/

--b.use subquery and no union
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City IN(
SELECT c.City FROM Customers c
GROUP BY c.City
HAVING COUNT(*)>=2
)

--6.List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(p.ProductID)[Total]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City--, p.ProductID
HAVING COUNT(DISTINCT p.ProductID)>=2

--7.List all Customers who have ordered products, but have the Å'ship cityÅ' on the order different from their own customer 
--	cities.
SELECT DISTINCT c.CustomerID
FROM Customers c JOIN Orders o ON c.CustomerID= o.CustomerID
WHERE c.City <> o.ShipCity

--8.List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 10 p.ProductID, AVG(p.UnitPrice)[AVG], c.City, SUM(od.Quantity)[Sum]
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
JOIN Orders o ON o.OrderID = od.OrderID 
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.City, p.ProductID
ORDER BY SUM(od.Quantity)
/*Buggy, need to be fixed*/

--9.List all cities that have never ordered something but we have employees there.
--a.use sub-query
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (SELECT c.City FROM Customers c)

SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
SELECT c.City 
FROM Customers c JOIN orders o 
ON c.CustomerID = o.CustomerID
)

--b.not using subquery
SELECT DISTINCT e.City
FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE e.City <>c.City
/*Buggy, need to be fixed*/

SELECT DISTINCT e.City
FROM Employees e
except
SELECT c.City 
FROM Customers c

--10.List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and 
--	also the city of most total quantity of products ordered from. (tip: join sub-query)
/*need to be fixed*/

--11.How do you remove the duplicates record of a table?
--Using normalization
--Or using GROUP BY with HAVING

