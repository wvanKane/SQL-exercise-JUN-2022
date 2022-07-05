--Write queries for following scenarios
/*Author: Yifan Liao*/
--Using Northwind Database
USE Northwind
GO

--1.Create a view named Å'view_product_order_[your_last_name]Å', list all products and total ordered quantity for that product..
DROP VIEW IF EXISTS view_product_order_Liao
GO
CREATE VIEW view_product_order_Liao AS
SELECT p.ProductName, sum(od.Quantity) [Total]
FROM Products p JOIN [Order Details] od ON p.ProductID=od.ProductID
GROUP BY p.ProductName

-- 2.Create a stored procedure Å'sp_product_order_quantity_[your_last_name]Å' that accept product id as an input and total 
--   quantities of order as output parameter.
DROP PROCEDURE IF EXISTS sp_product_order_quantity_Liao
GO

-- 3.Create a stored procedure Å'sp_product_order_city_[your_last_name]Å' that accept product name as an input and top 5 cities 
--   that ordered most that product combined with the total quantity of that product ordered from that city as output.
/*To Be Continued*/


