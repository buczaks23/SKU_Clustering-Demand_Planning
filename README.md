# SKU_Clustering-Demand_Planning
SQL-based analysis to identify products with poor forecast performance and prioritize forecasting improvements.

## Overview
This query analyzes forecast accuracy and demand variability for each SKU to identify products that should be easier to forecast but aren't performing well. By combining forecast accuracy metrics with demand stability measures (Coefficient of Variation), it flags SKUs that need attention. **The results feed into a Power BI dashboard for visual analysis and tracking.**

## Purpose
The goal is to prioritize forecasting improvement efforts by identifying products where:
- Demand patterns are stable and predictable
- Forecast accuracy is poor (≤80%)

These represent the "low-hanging fruit" where improving forecasts should be easiest and most impactful.

## Metrics Calculated

**Forecast Accuracy (fcst_accy)**
- Measures how close forecasts are to actual demand
- Calculated as: `1 - |forecast - actual| / actual`
- Scale: 0 to 1, where 1.0 = 100% accurate
- Floors at 0 to handle extreme forecast errors

**Coefficient of Variation (CV)**
- Normalized measure of demand variability
- Calculated as: `standard deviation / average demand`
- Lower CV = more stable, predictable demand
    - <= 0.2 stable
    - 0.21-0.3 moderately stable
    - 0.31-0.5 high end of stable/becoming unstable
    - >0.5 unstable 

**Additional Metrics**
- Average demand
- Standard deviation of demand
- Total demand

## Priority Classification

The query flags SKUs based on the combination of demand stability and forecast accuracy:

- **Priority 1**: CV ≤ 0.2 and Accuracy ≤ 80%
  - Very stable demand with poor forecast accuracy
  - Highest priority for improvement

- **Priority 2**: CV 0.21-0.3 and Accuracy ≤ 80%
  - Moderately stable demand with poor forecast accuracy
  - Medium priority for improvement

- **Priority 3**: CV 0.31-0.5 and Accuracy ≤ 80%
  - Somewhat variable demand with poor forecast accuracy
  - Lower priority for improvement

## Data Source
- **Table**: `dbo.sku_clustering`
- **Required Columns**: `sku`, `forecast`, `actual_demand`

## Usage
Run this query to generate a SKU-level report showing forecast performance and priority flags. Use the results to:
- Identify which products need forecast model improvements
- Allocate resources to the most impactful improvements
- Track forecast accuracy trends over time

## Power BI Integration

This SQL query serves as the data source for a Power BI dashboard that visualizes:
- SKU-level forecast accuracy performance
- Demand variability patterns
- Priority flags for forecasting improvement efforts

The dashboard enables stakeholders to:
- Quickly identify underperforming SKUs
- Filter by priority level

## Technical Notes
- Uses `NULLIF()` to handle division by zero when actual demand is 0
- Rounds results for readability (2 decimal places for percentages, 0 for counts)
- Groups results by SKU for product-level analysis
