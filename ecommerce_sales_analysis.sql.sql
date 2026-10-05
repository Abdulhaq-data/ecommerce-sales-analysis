SELECT *
FROM ecommerce_sales_raw
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM ecommerce_sales_raw;

DESCRIBE ecommerce_sales_raw;

SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(customer_name IS NULL) AS missing_customer_name,
    SUM(city IS NULL) AS missing_city,
    SUM(product IS NULL) AS missing_product,
    SUM(category IS NULL) AS missing_category,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(unit_price IS NULL) AS missing_unit_price,
    SUM(payment_method IS NULL) AS missing_payment_method
FROM ecommerce_sales_raw;

SELECT
    order_id,
    COUNT(*) AS occurrences
FROM ecommerce_sales_raw
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM ecommerce_sales_raw
WHERE quantity <= 0;

SELECT *
FROM ecommerce_sales_raw
WHERE unit_price <= 0;

SELECT DISTINCT city
FROM ecommerce_sales_raw
ORDER BY city;

SELECT DISTINCT category
FROM ecommerce_sales_raw
ORDER BY category;

SELECT DISTINCT product
FROM ecommerce_sales_raw
ORDER BY product;

SELECT DISTINCT payment_method
FROM ecommerce_sales_raw
ORDER BY payment_method;

SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM ecommerce_sales_raw;

SELECT
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    MIN(unit_price) AS minimum_price,
    MAX(unit_price) AS maximum_price
FROM ecommerce_sales_raw;

SELECT
    order_id,
    product,
    quantity,
    unit_price,
    ROUND(quantity * unit_price, 2) AS revenue
FROM ecommerce_sales_raw
LIMIT 10;

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw;

SELECT
    ROUND(
        SUM(quantity * unit_price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales_raw;

SELECT
    product,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY product
ORDER BY total_revenue DESC;

SELECT
    product,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY product
ORDER BY total_revenue DESC
LIMIT 5;

SELECT
    category,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY category
ORDER BY total_revenue DESC;

SELECT
    city,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY city
ORDER BY total_revenue DESC;

SELECT
    customer_id,
    customer_name,
    city,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent
FROM ecommerce_sales_raw
GROUP BY customer_id, customer_name, city
ORDER BY total_spent DESC
LIMIT 10;

SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY payment_method
ORDER BY total_revenue DESC;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM ecommerce_sales_raw
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    ROUND(
        SUM(quantity * unit_price) /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM ecommerce_sales_raw
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_sales_raw
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),

previous_month AS (
    SELECT
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        100.0 * (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM previous_month
ORDER BY sales_month;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_sales_raw
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)

SELECT
    sales_month,
    ROUND(total_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY sales_month
        ),
        2
    ) AS running_revenue
FROM monthly_sales
ORDER BY sales_month;

WITH product_sales AS (
    SELECT
        product,
        category,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_sales_raw
    GROUP BY product, category
)

SELECT
    product,
    category,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank;

WITH product_sales AS (
    SELECT
        product,
        category,
        SUM(quantity * unit_price) AS total_revenue
    FROM ecommerce_sales_raw
    GROUP BY product, category
)

SELECT
    product,
    category,
    ROUND(total_revenue, 2) AS total_revenue,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY total_revenue DESC
    ) AS category_rank
FROM product_sales
ORDER BY category, category_rank;

-- =====================================================
-- 14. KEY BUSINESS FINDINGS
-- =====================================================

-- 1. Highest-Revenue Product
-- Laptop generated £528,789.12 in total revenue.

-- 2. Highest-Revenue Category
-- Electronics generated £681,412.60 in total revenue.

-- 3. Highest-Revenue City
-- Leeds generated £147,831.48 in total revenue.

-- 4. Best Revenue Month
-- November 2025 was the strongest month,
-- generating £102,070.77 in revenue.

-- 5. Worst Revenue Month
-- August 2025 was the weakest month,
-- generating £67,107.99 in revenue.

-- =====================================================
-- 15. CUSTOMER SEGMENTATION
-- =====================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(quantity * unit_price) AS total_spent
    FROM ecommerce_sales_raw
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent,
    CASE
        WHEN total_spent >= 5000 THEN 'High Value'
        WHEN total_spent >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_sales
ORDER BY total_spent DESC;

-- =====================================================
-- 16. CUSTOMER SEGMENTATION USING QUARTILES
-- =====================================================

WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(quantity * unit_price) AS total_spent
    FROM ecommerce_sales_raw
    GROUP BY customer_id, customer_name
),

customer_quartiles AS (
    SELECT
        customer_id,
        customer_name,
        total_spent,
        NTILE(4) OVER (
            ORDER BY total_spent DESC
        ) AS spending_quartile
    FROM customer_sales
)

SELECT
    customer_id,
    customer_name,
    ROUND(total_spent, 2) AS total_spent,
    spending_quartile,
    CASE
        WHEN spending_quartile = 1 THEN 'High Value'
        WHEN spending_quartile = 2 THEN 'Upper Medium'
        WHEN spending_quartile = 3 THEN 'Lower Medium'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_quartiles
ORDER BY total_spent DESC;

-- =====================================================
-- 17. REPEAT CUSTOMERS
-- =====================================================

SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM ecommerce_sales_raw
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;

-- =====================================================
-- 18. REPEAT CUSTOMER RATE
-- =====================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_sales_raw
    GROUP BY customer_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_orders > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN total_orders > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate

FROM customer_orders;

-- =====================================================
-- 19. NEW VS REPEAT CUSTOMERS
-- =====================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        customer_name,
        COUNT(DISTINCT order_id) AS total_orders
    FROM ecommerce_sales_raw
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    total_orders,
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type
FROM customer_orders
ORDER BY total_orders DESC;

-- =====================================================
-- 20. COHORT & RETENTION ANALYSIS
-- =====================================================

-- 20.1 CUSTOMER FIRST PURCHASE MONTH

SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
FROM ecommerce_sales_raw
GROUP BY customer_id
ORDER BY first_order_date;

-- 20.2 CUSTOMER COHORTS

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_sales_raw
    GROUP BY customer_id
)

SELECT *
FROM customer_cohort
ORDER BY cohort_month;

-- 20.3 CUSTOMER MONTHLY ACTIVITY

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_sales_raw
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        e.customer_id,
        cc.cohort_month,
        DATE_FORMAT(e.order_date, '%Y-%m-01') AS activity_month
    FROM ecommerce_sales_raw e
    JOIN customer_cohort cc
        ON e.customer_id = cc.customer_id
)

SELECT *
FROM customer_activity
ORDER BY customer_id, activity_month;

-- =====================================================
-- 21. COHORT INDEX
-- =====================================================

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_sales_raw
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        e.customer_id,
        cc.cohort_month,
        DATE_FORMAT(e.order_date, '%Y-%m-01') AS activity_month
    FROM ecommerce_sales_raw e
    JOIN customer_cohort cc
        ON e.customer_id = cc.customer_id
)

SELECT
    customer_id,
    cohort_month,
    activity_month,

    TIMESTAMPDIFF(
        MONTH,
        STR_TO_DATE(cohort_month, '%Y-%m-%d'),
        STR_TO_DATE(activity_month, '%Y-%m-%d')
    ) AS cohort_index

FROM customer_activity
ORDER BY cohort_month, customer_id, activity_month;

-- =====================================================
-- 22. COHORT RETENTION TABLE
-- =====================================================

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_sales_raw
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        e.customer_id,
        cc.cohort_month,
        DATE_FORMAT(e.order_date, '%Y-%m-01') AS activity_month
    FROM ecommerce_sales_raw e
    JOIN customer_cohort cc
        ON e.customer_id = cc.customer_id
),

cohort_data AS (
    SELECT
        customer_id,
        cohort_month,
        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(cohort_month, '%Y-%m-%d'),
            STR_TO_DATE(activity_month, '%Y-%m-%d')
        ) AS cohort_index
    FROM customer_activity
)

SELECT
    cohort_month,
    cohort_index,
    COUNT(DISTINCT customer_id) AS active_customers
FROM cohort_data
GROUP BY cohort_month, cohort_index
ORDER BY cohort_month, cohort_index;

-- =====================================================
-- 23. CUSTOMER RETENTION RATE
-- =====================================================

WITH customer_cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m-01') AS cohort_month
    FROM ecommerce_sales_raw
    GROUP BY customer_id
),

customer_activity AS (
    SELECT DISTINCT
        e.customer_id,
        cc.cohort_month,
        DATE_FORMAT(e.order_date, '%Y-%m-01') AS activity_month
    FROM ecommerce_sales_raw e
    JOIN customer_cohort cc
        ON e.customer_id = cc.customer_id
),

cohort_data AS (
    SELECT
        customer_id,
        cohort_month,
        TIMESTAMPDIFF(
            MONTH,
            STR_TO_DATE(cohort_month, '%Y-%m-%d'),
            STR_TO_DATE(activity_month, '%Y-%m-%d')
        ) AS cohort_index
    FROM customer_activity
),

cohort_counts AS (
    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_data
    GROUP BY cohort_month, cohort_index
),

retention_data AS (
    SELECT
        cohort_month,
        cohort_index,
        active_customers,

        MAX(
            CASE
                WHEN cohort_index = 0
                THEN active_customers
            END
        ) OVER (
            PARTITION BY cohort_month
        ) AS cohort_size

    FROM cohort_counts
)

SELECT
    cohort_month,
    cohort_index,
    active_customers,
    cohort_size,

    ROUND(
        100.0 * active_customers / cohort_size,
        2
    ) AS retention_rate

FROM retention_data
ORDER BY cohort_month, cohort_index;

-- =====================================================
-- 24. FINAL PROJECT SUMMARY
-- =====================================================

-- Project: E-commerce Sales & Customer Analysis
-- Tool: MySQL Workbench
-- Dataset: 2,500 e-commerce transactions from 2025

-- OBJECTIVES:
-- 1. Analyse overall sales performance
-- 2. Identify top-performing products and categories
-- 3. Compare sales performance across cities
-- 4. Analyse monthly revenue trends and growth
-- 5. Identify high-value and repeat customers
-- 6. Segment customers based on spending
-- 7. Analyse customer retention using cohorts

-- KEY FINDINGS:
-- Laptop was the highest-revenue product, generating £528,789.12.
-- Electronics was the highest-revenue category, generating £681,412.60.
-- Leeds was the highest-revenue city, generating £147,831.48.
-- November 2025 was the strongest sales month, generating £102,070.77.
-- August 2025 was the weakest sales month, generating £67,107.99.

-- SQL SKILLS DEMONSTRATED:
-- SELECT
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
-- Aggregate functions
-- CASE statements
-- Date functions
-- CTEs
-- Window functions
-- LAG()
-- DENSE_RANK()
-- NTILE()
-- Running totals
-- Month-over-month growth
-- Customer segmentation
-- Cohort analysis
-- Retention analysis

