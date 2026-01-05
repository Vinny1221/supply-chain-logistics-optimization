USE shipping;
GO

/* 1. SLA Breach Analysis by Warehouse */
SELECT
    Warehouse_Block,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Count,
    (SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS Late_Pct
FROM dbo.cleaned_shipping_data
GROUP BY Warehouse_Block
ORDER BY Late_Pct DESC;
GO

/* 2. Financial Impact of Late Shipments (by Warehouse) */
SELECT
    Warehouse_Block,
    COUNT(*) AS Late_Orders,
    SUM(TRY_CAST(Revenue_Impact AS FLOAT)) AS Late_Revenue_Impact
FROM dbo.cleaned_shipping_data
WHERE Delivery_Status = 'Late'
GROUP BY Warehouse_Block
ORDER BY Late_Revenue_Impact DESC;
GO

/* 3. On-Time Performance by Shipment Mode */
SELECT
    Shipment_Mode,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Orders,
    (SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS Late_Pct
FROM dbo.cleaned_shipping_data
GROUP BY Shipment_Mode
ORDER BY Late_Pct DESC, Total_Orders DESC;
GO

/* 4. High-Risk Customers: Frequent Purchases but Late Deliveries */
SELECT
    Customer_Rating,
    SUM(TRY_CAST(Prior_Purchases AS INT)) AS Total_Prior_Purchases,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Orders,
    (SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS Late_Pct
FROM dbo.cleaned_shipping_data
GROUP BY Customer_Rating
HAVING COUNT(*) >= 30
ORDER BY Late_Pct DESC, Total_Prior_Purchases DESC;
GO

/* 5. Discount vs On-Time Delivery */
SELECT
    CASE
        WHEN TRY_CAST(Discount_Offered AS INT) = 0 THEN '0'
        WHEN TRY_CAST(Discount_Offered AS INT) BETWEEN 1 AND 20 THEN '1-20'
        WHEN TRY_CAST(Discount_Offered AS INT) BETWEEN 21 AND 40 THEN '21-40'
        ELSE '41+'
    END AS Discount_Band,
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) AS Late_Orders,
    (SUM(CASE WHEN Delivery_Status = 'Late' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*)) AS Late_Pct
FROM dbo.cleaned_shipping_data
GROUP BY
    CASE
        WHEN TRY_CAST(Discount_Offered AS INT) = 0 THEN '0'
        WHEN TRY_CAST(Discount_Offered AS INT) BETWEEN 1 AND 20 THEN '1-20'
        WHEN TRY_CAST(Discount_Offered AS INT) BETWEEN 21 AND 40 THEN '21-40'
        ELSE '41+'
    END
ORDER BY Late_Pct DESC;
GO
