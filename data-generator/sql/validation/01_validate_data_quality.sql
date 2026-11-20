
SET NOCOUNT ON;

-- LogiCore - Data Quality Validation
-- Basic checks after importing data into SQL Server.

-- 1. Row counts

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows
FROM dbo.Customers
UNION ALL
SELECT 'Products', COUNT(*)
FROM dbo.Products
UNION ALL
SELECT 'Orders', COUNT(*)
FROM dbo.Orders
UNION ALL
SELECT 'OrderDetails', COUNT(*)
FROM dbo.OrderDetails
UNION ALL
SELECT 'Invoices', COUNT(*)
FROM dbo.Invoices
UNION ALL
SELECT 'InvoiceLines', COUNT(*)
FROM dbo.InvoiceLines
UNION ALL
SELECT 'Payments', COUNT(*)
FROM dbo.Payments;

-- 2. Referential integrity

SELECT
    'Orders without customers' AS CheckName,
    COUNT(*) AS IssueCount
FROM dbo.Orders AS o
LEFT JOIN dbo.Customers AS c
    ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IS NULL

UNION ALL

SELECT
    'Order details without products',
    COUNT(*)
FROM dbo.OrderDetails AS od
LEFT JOIN dbo.Products AS p
    ON p.ProductID = od.ProductID
WHERE p.ProductID IS NULL

UNION ALL

SELECT
    'Invoices without orders',
    COUNT(*)
FROM dbo.Invoices AS i
LEFT JOIN dbo.Orders AS o
    ON o.OrderID = i.OrderID
WHERE o.OrderID IS NULL

UNION ALL

SELECT
    'Payments without invoices',
    COUNT(*)
FROM dbo.Payments AS p
LEFT JOIN dbo.Invoices AS i
    ON i.InvoiceID = p.InvoiceID
WHERE i.InvoiceID IS NULL;

-- 3. Business rules

SELECT 'Invalid order quantities' AS CheckName, COUNT(*) AS IssueCount
FROM dbo.OrderDetails
WHERE Quantity <= 0

UNION ALL

SELECT 'Negative product prices', COUNT(*)
FROM dbo.Products
WHERE UnitPrice < 0

UNION ALL

SELECT 'Invalid discounts', COUNT(*)
FROM dbo.OrderDetails
WHERE DiscountPercent < 0
   OR DiscountPercent > 100;

-- 4. Temporal tables

SELECT
    t.name AS TableName,
    t.temporal_type_desc AS TemporalType
FROM sys.tables AS t
WHERE t.schema_id = SCHEMA_ID('dbo')
  AND t.temporal_type = 2
ORDER BY t.name;
