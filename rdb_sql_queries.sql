
SELECT * FROM rdb_sales

-- A. KPI 1: Total Revenue
SELECT
	SUM(total_price) AS Total_Revenue
FROM rdb_sales

-- A. KPI 2: Average Order Value
SELECT 
	SUM(total_price) / COUNT(DISTINCT order_id) AS avg_order_value
FROM rdb_sales

-- A. KPI 3: Total Birrias Sold
SELECT
SUM	(CASE
		WHEN product_name = 'QuesaBirria' THEN quantity
		WHEN product_name = 'COMBO MEAL 1' THEN quantity * 1
		WHEN product_name = 'COMBO MEAL 2' THEN quantity * 2
		ELSE 0
	 END) AS total_birria_pieces_sold
FROM rdb_sales

-- A. KPI 4 : Total Orders
SELECT 
	COUNT(DISTINCT order_id) AS total_orders
FROM rdb_sales

-- A. KPI 5: Average Birrias Per Order
SELECT
ROUND(CAST (SUM	(CASE
		WHEN product_name = 'QuesaBirria' THEN quantity
		WHEN product_name = 'COMBO MEAL 1' THEN quantity * 1
		WHEN product_name = 'COMBO MEAL 2' THEN quantity * 2
		ELSE 0
	 END)AS DECIMAL (10, 2))
/ COUNT(DISTINCT order_id),2) AS average_birrias_per_order
FROM rdb_sales

-- B: Daily Trend for Total Orders (Sales by Day of Week)
SELECT 
	DATENAME(Weekday, order_date) AS order_day, 
	COUNT(DISTINCT order_id) AS total_orders
FROM rdb_sales
GROUP BY DATENAME(Weekday, order_date)
ORDER BY COUNT(DISTINCT order_id) DESC

-- C: Hourly Trend for Orders (Peak Ordering Time)
SELECT 
	DATEPART(HOUR, order_time) as order_hours, 
	COUNT(DISTINCT order_id) as total_orders
FROM rdb_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY COUNT(DISTINCT order_id) DESC

-- D: % of Sales by Bazaar
SELECT 
    bazaar_location,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100.0 / (SELECT SUM(total_price) 
									 FROM rdb_sales)
									 AS DECIMAL(10,2)) AS percentage_of_sales
FROM rdb_sales
GROUP BY bazaar_location
ORDER BY total_revenue DESC;

-- E: Total Orders by Bazaars
SELECT
	bazaar_location,
	COUNT(DISTINCT order_id) AS total_order
FROM rdb_sales
GROUP BY bazaar_location
ORDER BY COUNT(DISTINCT order_id) DESC