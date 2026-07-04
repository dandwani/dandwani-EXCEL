-- =====================================================
-- PROJECT: Regional Sales Analysis 2025
-- Database: RegionalSalesDB
-- =====================================================

-- =====================================================
-- 1. Create Database
-- =====================================================

CREATE DATABASE RegionalSalesDB;

USE RegionalSalesDB;

-- =====================================================
-- 2. Create Table
-- =====================================================

CREATE TABLE RegionalSales2025 (
    OrderID INT PRIMARY KEY,
    Date DATE,
    CustomerID VARCHAR(20),
    Region VARCHAR(20),
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    SalesAgent VARCHAR(50)
);

-- =====================================================
-- 3. Database Verification
-- =====================================================

SHOW DATABASES;

SELECT DATABASE();

-- =====================================================
-- 4. Basic Data Validation
-- =====================================================

-- Total Records

SELECT COUNT(*) AS TotalRows
FROM RegionalSales2025;

-- Preview Data

SELECT *
FROM RegionalSales2025
LIMIT 10;

-- =====================================================
-- 5. Monthly Sales Trend
-- =====================================================

SELECT
    MONTH(Date) AS Month,
    COUNT(OrderID) AS TotalOrders
FROM RegionalSales2025
GROUP BY MONTH(Date)
ORDER BY Month;

-- =====================================================
-- 6. Region-wise Total Orders
-- =====================================================

SELECT
    Region,
    COUNT(OrderID) AS TotalOrders
FROM RegionalSales2025
GROUP BY Region;

-- =====================================================
-- 7. Region-wise Cancelled Orders
-- =====================================================

SELECT
    Region,
    COUNT(OrderID) AS CancelledOrders
FROM RegionalSales2025
WHERE OrderStatus = 'Cancelled'
GROUP BY Region;

-- =====================================================
-- 8. Region-wise Returned Orders
-- =====================================================

SELECT
    Region,
    COUNT(OrderID) AS ReturnedOrders
FROM RegionalSales2025
WHERE OrderStatus = 'Returned'
GROUP BY Region;

-- =====================================================
-- 9. Cancelled & Returned Order Percentage by Region
-- =====================================================

SELECT
    Region,

    COUNT(OrderID) AS TotalOrders,

    SUM(CASE
            WHEN OrderStatus = 'Cancelled' THEN 1
            ELSE 0
        END) AS CancelledOrders,

    ROUND(
        SUM(CASE
                WHEN OrderStatus = 'Cancelled' THEN 1
                ELSE 0
            END) * 100 / COUNT(OrderID),
        2
    ) AS CancelledPercentage,

    SUM(CASE
            WHEN OrderStatus = 'Returned' THEN 1
            ELSE 0
        END) AS ReturnedOrders,

    ROUND(
        SUM(CASE
                WHEN OrderStatus = 'Returned' THEN 1
                ELSE 0
            END) * 100 / COUNT(OrderID),
        2
    ) AS ReturnedPercentage

FROM RegionalSales2025
GROUP BY Region;

-- =====================================================
-- 10. Top 3 Regions with Highest Revenue Loss
-- =====================================================

SELECT
    Region,
    SUM(TotalAmount) AS RevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY Region
ORDER BY RevenueLoss DESC
LIMIT 3;

-- =====================================================
-- 11. Top 3 Products with Highest Revenue Loss
-- =====================================================

SELECT
    ProductName,
    SUM(TotalAmount) AS RevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY ProductName
ORDER BY RevenueLoss DESC
LIMIT 3;

-- =====================================================
-- 12. Average Selling Price by Product Category
-- =====================================================

SELECT
    Category,
    ROUND(AVG(UnitPrice), 2) AS AverageSellingPrice
FROM RegionalSales2025
GROUP BY Category;

-- =====================================================
-- 13. Top 5 Performing Sales Agents
-- (Based on Completed Order Revenue)
-- =====================================================

SELECT
    SalesAgent,
    SUM(TotalAmount) AS TotalRevenue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY SalesAgent
ORDER BY TotalRevenue DESC
LIMIT 5;

-- =====================================================
-- 14. Category-wise Revenue Contribution
-- =====================================================

SELECT
    Category,

    SUM(TotalAmount) AS TotalSales,

    ROUND(
        SUM(TotalAmount) * 100 /
        (SELECT SUM(TotalAmount) FROM RegionalSales2025),
        2
    ) AS ContributionPercentage

FROM RegionalSales2025
GROUP BY Category
ORDER BY TotalSales DESC;

-- =====================================================
-- 15. Customers with Frequent Orders (3 or More)
-- =====================================================

SELECT
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM RegionalSales2025
GROUP BY CustomerID
HAVING COUNT(OrderID) >= 3
ORDER BY TotalOrders DESC;