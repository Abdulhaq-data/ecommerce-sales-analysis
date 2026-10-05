# E-commerce Sales Analysis

## Project Overview

This project analyzes an e-commerce sales dataset using **MySQL** and **Power BI** to identify sales trends, product performance, customer behaviour, and geographic performance.

The project demonstrates an end-to-end data analysis workflow, from querying and analyzing raw sales data in SQL to building an interactive Power BI dashboard for business decision-making.

## Business Questions

The analysis aims to answer questions such as:

- What is the total revenue generated?
- How many orders and customers are there?
- What is the average order value?
- Which products generate the most revenue?
- Which product categories perform best?
- Which cities generate the most revenue?
- How does revenue change month by month?
- Who are the highest-value customers?
- Which customers make repeat purchases?
- How can customers be segmented based on spending?
- How does customer retention change over time?

## Dataset

The dataset contains **2,500 e-commerce orders from 2025**.

Key fields include:

- Order ID
- Order Date
- Customer ID
- Customer Name
- City
- Product
- Category
- Quantity
- Unit Price
- Payment Method

Revenue was calculated using:

```sql
quantity * unit_price
```

## Tools Used

- **MySQL Workbench** — SQL querying and analysis
- **SQL** — data exploration, aggregation and advanced analysis
- **Power BI** — data visualization and interactive dashboard
- **DAX** — KPI calculations in Power BI

## SQL Analysis

The SQL analysis demonstrates:

- SELECT and filtering
- Aggregate functions
- GROUP BY and HAVING
- CASE expressions
- Date and string functions
- Subqueries
- Common Table Expressions (CTEs)
- Window functions
- ROW_NUMBER, RANK and DENSE_RANK
- LAG and LEAD
- Running totals
- Month-over-month analysis
- Customer segmentation
- Repeat customer analysis
- Cohort and retention analysis
- Indexing and query optimization

## Key KPIs

| KPI | Result |
|---|---:|
| Total Revenue | £1,004,792.45 |
| Total Orders | 2,500 |
| Total Customers | 300 |
| Average Order Value | £401.92 |

## Key Insights

- **Laptop** was the highest-revenue product, generating approximately **£528,789.12**.
- **Electronics** was the highest-revenue category, generating approximately **£681,412.60**.
- **Leeds** generated the highest revenue among the cities, at approximately **£147,831.48**.
- **November 2025** was the strongest month, generating approximately **£102,070.77**.
- **August 2025** was the weakest month, generating approximately **£67,107.99**.

## Power BI Dashboard

The interactive dashboard includes:

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Monthly Revenue Trend
- Top 5 Products by Revenue
- Revenue by Category
- Revenue by City
- City slicer
- Category slicer
- Payment Method slicer

![E-commerce Sales Dashboard](images/dashboard.png)

## Business Recommendations

Based on the analysis:

- Maintain sufficient inventory and marketing support for high-performing products, particularly laptops and other electronics.
- Investigate the factors contributing to strong sales performance in Leeds and assess whether similar strategies can be applied to other cities.
- Prepare inventory and marketing campaigns ahead of the strong November sales period.
- Investigate the weaker August performance to determine whether seasonality, promotions, or product mix contributed to lower revenue.
- Continue monitoring repeat purchasing and customer retention to identify opportunities to increase customer lifetime value.

## Project Structure

```text
ecommerce-sales-analysis/
│
├── README.md
├── ecommerce_sales_analysis.sql
├── ecommerce_sales_dashboard.pbix
│
├── data/
│   └── ecommerce_sales_raw.csv
│
└── images/
    └── dashboard.png
```

## Skills Demonstrated

**SQL:** Data querying, aggregation, CTEs, subqueries, window functions, ranking, customer segmentation, cohort analysis and query optimization.

**Power BI:** Data modeling, DAX measures, KPI cards, interactive visualizations, slicers and dashboard design.

**Data Analysis:** Business question development, KPI analysis, trend analysis, customer analysis and communicating actionable insights.