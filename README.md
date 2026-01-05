# Logistics SLA & Revenue Risk Monitor

**Role:** Supply Chain Data Analyst  
**Tech Stack:** Python (Pandas), SQL Server, Tableau Public  
**View the interactive dashboard on Tableau Public:** https://public.tableau.com/views/LogisticsSLARevenueRiskMonitor/LogisticsSLARevenueRiskMonitor

---

## Project Background

A mid-sized ecommerce company is experiencing high rates of late deliveries across multiple warehouses and shipment modes. As a Supply Chain Analyst, the goal of this project is to quantify SLA breaches, identify where revenue is most at risk, and recommend actions to improve on-time performance.

The dataset contains order-level shipping records including warehouse, shipment mode, discounts, customer behaviour, and an estimated revenue impact measure for each shipment.

---

## Key Business Questions

1. Which warehouses have the highest percentage of late deliveries?
2. Which warehouses drive the greatest revenue impact from late shipments?
3. How does SLA performance differ across shipment modes (Flight, Ship, Road)?
4. Are higher discount bands correlated with worse on-time delivery?

---

## Data Cleaning

- **Source:** loaded and cleaned in Python (Pandas), then stored as `cleaned_shipping_data`.
- **Categorical flags** created for:
  - `DeliveryStatus` (On-time vs Late)
  - `ShipmentMode` (Flight, Ship, Road)
  - `DiscountBand` (0%, 1-20%, 21-40%, 41%+)
- **Numeric conversions and validation:**
  - Converted text fields such as `PriorPurchases`, `DiscountOffered`, and `RevenueImpact` to numeric using `TRY_CAST` in SQL Server to handle dirty values.
- **Final table:** `dbo.cleaned_shipping_data` is used both in SQL Server and Tableau.

---

## SQL Analysis Logic

Core queries are stored in `logistics_queries.sql` and include:

1. **SLA breach by warehouse** – `Late %` = `SUM(LateFlag) / COUNT(*)` by `WarehouseBlock`.
2. **Financial impact of delays** – `SUM(RevenueImpact)` for late shipments by warehouse.
3. **On-time performance by shipment mode** – `Late %` by `ShipmentMode` (Flight, Ship, Road).
4. **High-risk customers** – `Late %` and total prior purchases by `CustomerRating`.
5. **Discount vs on-time performance** – `Late %` by discount band (0%, 1-20%, 21-40%, 41%+).

These queries validate the same metrics that are visualised in Tableau.

---

## Dashboard Design

**Dashboard:** Logistics SLA & Revenue Risk Monitor  
Built in Tableau Public with four focused views:

- **Late % by Warehouse** – SLA breach rate per warehouse.
- **Revenue Impact by Warehouse** – total revenue at risk from late shipments.
- **Late % by Shipment Mode** – SLA performance across Flight, Ship, and Road.
- **Late % by Discount** – relationship between discount level and late delivery rate.

A single **Shipment Mode** filter slices all views, allowing operations managers to analyse SLA and revenue impact by transport mode.

---

## Key Insights

- **Warehouse performance:** All warehouses have late rates around 60%, with blocks such as F and B slightly higher, indicating systemic SLA issues rather than a single failing site.
- **Revenue risk concentration:** Warehouse F shows the highest revenue impact (≈$452K), making it the top priority for process improvement and carrier review.
- **Shipment mode:** Late % is very similar across Flight, Ship, and Road, suggesting that warehouse processes and order handling are bigger drivers than the transport leg alone.
- **Discount policy:** Higher discount bands (21-40% and 41%+) show 100% late deliveries in this dataset, indicating that heavily discounted campaigns may be linked with operational overload and service failures.

---

## Recommendations

1. **Prioritise Warehouse F for SLA improvement**
   - Deep-dive root causes: staffing levels, cut-off times, handoff to carriers.
   - Run a Pareto analysis on failure reasons for this warehouse first.

2. **Review promo and discount operations**
   - Coordinate large discount campaigns with capacity and staffing plans.
   - Consider capping daily orders under high discount bands to avoid SLA collapse.

3. **Standardise shipment-mode processes**
   - Because Late % is similar across modes, standardise picking/packing SLAs before orders leave the facility.

4. **Next steps**
   - Extend analysis with time-based trends (by month/week).
   - Add predictive modelling for late-delivery risk using historical patterns.

---

## Files in This Repository

- `logistics_analysis.ipynb` – Python notebook for cleaning and EDA.
- `cleaned_shipping_data.csv` – Final dataset used in SQL Server and Tableau.
- `logistics_queries.sql` – SQL Server queries for SLA and revenue analysis.
- `dashboard.png` – Static preview of the Tableau dashboard.
- `README.md` – This project description.

---

## Contact

Interested in discussing supply chain analytics or this project?

- **LinkedIn:** [https://www.linkedin.com/in/vincent-tshidino-a828a0335](https://www.linkedin.com/in/vincent-tshidino-a828a0335)
- **Email:** vincentvee@yahoo.com
- **GitHub:** [https://github.com/Vinny1221](https://github.com/Vinny1221)
