-- SUPPLY CHAIN PERFORMANCE QUERIES
-- Author: Vincent Tshidino
-- Purpose: Analyze SLA breaches, financial impact of delays, warehouse performance, and high-risk SKUs.
-- Database: shipping

USE shipping;  -- Change if your database name is different
GO

---------------------------------------------------------------------
-- 1. SLA Breach Analysis by Warehouse
-- Objective: Calculate 'Late %' for each warehouse to identify bottlenecks against SLA targets.
---------------------------------------------------------------------
SELECT 
    [Warehouse Block],
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) AS LateCount,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LatePct
FROM 
    shipping_data
GROUP BY 
    [Warehouse Block]
ORDER BY 
    LatePct DESC;
GO

---------------------------------------------------------------------
-- 2. Financial Impact of Late Shipments
-- Objective: Quantify the revenue cost tied up in late deliveries.
---------------------------------------------------------------------
SELECT 
    [Warehouse Block],
    COUNT(*) AS LateOrders,
    SUM(CAST([Revenue Impact] AS FLOAT)) AS LateRevenueImpact
FROM 
    shipping_data
WHERE 
    [Delivery Status] = 'Late'
GROUP BY 
    [Warehouse Block]
ORDER BY 
    LateRevenueImpact DESC;
GO

---------------------------------------------------------------------
-- 3. On-Time Performance by Region and Carrier
-- Objective: Compare SLA performance across regions and carriers.
---------------------------------------------------------------------
SELECT 
    [Order Region],
    [Carrier Name],
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) AS LateOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LatePct
FROM 
    shipping_data
GROUP BY 
    [Order Region], [Carrier Name]
HAVING 
    COUNT(*) > 50
ORDER BY 
    LatePct DESC;
GO

---------------------------------------------------------------------
-- 4. High-Risk SKUs: Fast-Moving but Frequently Late
-- Objective: Find products that sell frequently AND are often late.
---------------------------------------------------------------------
SELECT 
    [Product ID],
    [Product Name],
    [Category Name],
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) AS LateOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LatePct
FROM 
    shipping_data
GROUP BY 
    [Product ID], [Product Name], [Category Name]
HAVING 
    COUNT(*) > 30
    AND SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) > 20
ORDER BY 
    LatePct DESC;
GO

---------------------------------------------------------------------
-- 5. Shipment Mode Performance
-- Objective: Analyze late delivery rates by shipment mode.
---------------------------------------------------------------------
SELECT 
    [Shipment Mode],
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) AS LateOrders,
    SUM(CASE WHEN [Delivery Status] = 'Late' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS LatePct
FROM 
    shipping_data
GROUP BY 
    [Shipment Mode]
ORDER BY 
    LatePct DESC;
GO
