/* ================================================
      STYLEHUB RETAIL INTELLIGENCE - SQL PROJECT
-- ================================================*/

-- ================================================
--    1.   DATABASE SETUP
-- ================================================

CREATE DATABASE STYLEHUB_RETAIL;
USE STYLEHUB_RETAIL;

-- ================================================
--    2. TABLE CREATION AND DATA IMPORT 
-- ================================================

-- 1. CATEGORIES TABLE
CREATE TABLE CATEGORIES
(
category_id int PRIMARY KEY,
category_name VARCHAR (15));


-- 2. PRODUCTS TABLE
CREATE TABLE PRODUCTS
(
product_id INT PRIMARY KEY,
product_name VARCHAR (20) NOT NULL,	
category_id INT ,
cost_price	DECIMAL(10,2),
selling_price DECIMAL(10,2),
FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORIES (CATEGORY_ID)
);

-- 3. STORES TABLE
CREATE TABLE STORES
(
store_id INT PRIMARY KEY,	
store_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR (50),	
store_type VARCHAR(50)
);

-- 4. EMPLOYEES TABLE
CREATE TABLE EMPLOYEES
(
employee_id	int primary key,
employee_name varchar(30)not null,
store_id int,
JOB varchar(30),
foreign key (store_id) references stores (store_id)
);

-- 5. CUSTOMERS TABLE
create table customers
(
customer_id int primary key,
customer_name varchar(50)not null,
gender	varchar(20),
city	varchar(30),
state	varchar(30),
signup_date date not null);

-- 6. SALES TABLE
create table sales
(
sale_id int primary key,
customer_id int,
store_id int,
employee_id int	,
sale_date date not null,
foreign key (store_id) references stores (store_id),
foreign key (customer_id) references customers (customer_id),
foreign key (employee_id) references employees ( employee_id));

select * from sales;

-- 7. SALE ITEMS TABLE
create table sale_items 
(
sale_item_id int primary key,	
sale_id	int not null,
product_id int not null,
quantity int not null,
discount_pct decimal(5,2),
foreign key (sale_id) references sales (sale_id),
foreign key (product_id) references products (product_id));

select*from sale_items;

-- 8. RETURNS TABLE
create table returns_
(
return_id int primary key,
sale_item_id int ,
return_date date not null,
return_qty int,	
return_reason varchar (30),
foreign key (sale_item_id) references sale_items (sale_item_id));
 use stylehub_retail;
 SELECT*FROM RETURNS_;
 
 -- 9. INVENTORY TABLE
 CREATE TABLE INVENTORY
 (
inventory_id INT PRIMARY KEY,
store_id	INT,
product_id	INT,
stock_qty	INT,
last_restock_date DATE,
FOREIGN KEY (STORE_ID) REFERENCES STORES (STORE_ID),
FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS (PRODUCT_ID));


SELECT * FROM INVENTORY;
SHOW TABLES;

-- ===================================================================
-- CHECK ROW COUNTS
-- ====================================================================

SELECT 'CATEGORIES' AS STYLEHUB_TABLES, COUNT(*) AS ROWS_COUNT FROM CATEGORIES
UNION ALL 
SELECT' PRODUCTS', COUNT(*) FROM PRODUCTS
UNION ALL
SELECT 'STORES', COUNT(*) FROM STORES
UNION ALL
SELECT 'EMPLOYEES', COUNT(*) FROM EMPLOYEES
UNION ALL
SELECT 'CUSTOMERS', COUNT(*) FROM CUSTOMERS
UNION ALL
SELECT 'SALES', COUNT(*) FROM SALES
UNION ALL
SELECT 'SALE_ITEMS', COUNT(*) FROM SALE_ITEMS
UNION ALL 
SELECT 'RETURNS_', COUNT(*) FROM RETURNS_
UNION ALL
SELECT 'INVENTORY', COUNT(*) FROM INVENTORY;
SELECT*FROM CUSTOMERS;

-- =============================================================
--  3. DATA QUALITY CHECKS 
-- =============================================================

--  CUSTOMERS -> CHECK FOR MISSING CUSTOMER DATA
SELECT * 
FROM CUSTOMERS
WHERE CUSTOMER_ID IS NULL
OR CUSTOMER_NAME IS NULL
OR GENDER IS NULL
OR CITY IS NULL
OR STATE IS NULL
OR SIGNUP_DATE IS NULL;

DELETE FROM CUSTOMERS
WHERE CUSTOMER_ID IS NULL
OR CUSTOMER_NAME IS NULL
OR GENDER IS NULL
OR CITY IS NULL
OR STATE IS NULL
OR SIGNUP_DATE IS NULL;

-- CHECK FOR DUPLICATE VALUES

SELECT CUSTOMER_ID, COUNT(*)
FROM CUSTOMERS
GROUP BY CUSTOMER_ID
HAVING COUNT(*)>1;

--  PRODUCTS -> CHECK FOR NULL AND INVALID PRODUCT VALUES

SELECT * 
FROM PRODUCTS
WHERE PRODUCT_ID IS NULL
OR COST_PRICE <=0 OR SELLING_PRICE<=0;
SELECT * FROM PRODUCTS;

-- SALE ITEMS -> CHECK FOR INVALID QUANTITY AND DISCOUNT PRICES 

SELECT * FROM SALE_ITEMS;
SELECT * FROM SALE_ITEMS
WHERE SALE_ITEM_ID IS NULL
OR SALE_ID IS NULL
OR PRODUCT_ID IS NULL
OR QUANTITY IS NULL
OR QUANTITY <=0
OR DISCOUNT_PCT IS NULL
OR DISCOUNT_PCT <0
OR DISCOUNT_PCT >100;

-- INVENTORY -> CHECK FOR ANY MISSING VALUES AND INVALID STOCK QTY

SELECT * FROM INVENTORY;
SELECT* FROM INVENTORY
WHERE STORE_ID IS NULL
OR PRODUCT_ID IS NULL
OR STOCK_QTY IS NULL
OR STOCK_QTY<0
OR LAST_RESTOCK_DATE IS NULL;

-- RETURNS -> CHECK FOR ANY MISSING VALUES AND INVALID RETURNS

 SELECT * FROM RETURNS_;
 
 SELECT * FROM RETURNS_
 WHERE SALE_ITEM_id is null
 or return_date is null
 or return_qty is null
 or return_qty<=0
 or return_reason is null;
 
 -- SALES -> CHECK FOR MISSING VALUES AND INVALID SALE DATE
 
 select * from sales;
 select *
 from sales
 where customer_ID IS NULL
 or STORE_ID IS NULL
 OR EMPLOYEE_ID IS NULL
 OR SALE_DATE IS NULL
 OR SALE_DATE>curdate();
 
 --  EMPLOYEES -> CHECK FOR MISSING EMPLOYEE DATA
 
 SELECT * FROM EMPLOYEES;
 SELECT *
FROM EMPLOYEES 
WHERE EMPLOYEE_NAME IS NULL
OR STORE_ID IS NULL 
OR JOB IS NULL; 

-- ====================================================
--   4. EXPLORATORY DATA ANALYSIS
-- =====================================================
 
 # Q1. WHAT IS THE OVERALL DATE RANGE OF SALES DATA?
 
 
 SELECT MIN(SALE_DATE) AS EARLIEST_SALE_DATE,
        MAX(SALE_DATE) AS LATEST_SALE_DATE
 FROM SALES;
 
 # Q2. HOW MANY UNIQUE CUSTOMERS MADE PURCHASES?
 
 SELECT COUNT(DISTINCT(CUSTOMER_ID)) AS UNIQUE_CUSTOMERS
 FROM SALES;
 
 # 3. HOW MANY TOTAL SALES TRANSACTIONS WERE MADE?
 
 
 SELECT COUNT(*) AS TOTAL_TRANSACTIONS
 FROM SALES;
 
 # Q4. TOTAL NUMBER OF UNITS SOLD?
 
 SELECT SUM(QUANTITY) AS TOTAL_SOLD_QTY
 FROM SALE_ITEMS;
 
 # Q5. What is the average quantity of products sold per sale item?
 
 SELECT AVG(QUANTITY) AS AVG_QTY
 FROM SALE_ITEMS;
 
 # Q6. How many sales transactions were made by each store?
 
 
 SELECT  STORE_ID,COUNT( SALE_ID) AS STORE_WISE_TRANSACTIONS
 FROM SALES
 GROUP BY STORE_ID;
 
 # Q7. Which store has the highest number of sales transactions?
 
 SELECT STORE_ID, COUNT(SALE_ID) AS MAX_TRANSACTION
 FROM SALES
 GROUP BY STORE_ID
 ORDER BY MAX_TRANSACTION DESC;
 
 # Q8. How many customers are there in each city?
 
 SELECT CITY, COUNT(CUSTOMER_ID) AS NUMBER_OF_CUSTOMER
 FROM CUSTOMERS
 GROUP BY CITY
 ORDER BY NUMBER_OF_CUSTOMER DESC;
 
 # Q9. How many customers are there by gender?
 
 SELECT GENDER ,COUNT(CUSTOMER_ID) AS TOTAL_CUSTOMER
 FROM CUSTOMERS
 GROUP BY GENDER;
 
 # Q10. How many products are available in each category?
  
  select c.category_id, c.category_name, count( p.product_id) as product_count
  from products p inner join categories c
  on p.category_id = c.category_id
  group by c.category_id, c.category_name;
 
 # Q11. What is the average selling price of products in each category?
 
 select c.category_id,c.category_name, ROUND(avg(p.selling_price),2) as AVG_SELLING_PRICE
 from categories c inner join products p
 on c.category_id = p.category_id
 group by c.category_id,c.category_name
 ORDER BY AVG_SELLING_PRICE DESC;
 
 # Q12. Analyze the average cost price, average selling price, and average profit margin per unit for each product category.
 
 SELECT C.CATEGORY_NAME, 
 ROUND(AVG(P.COST_PRICE),2) AS AVG_COST_PRICE,
 ROUND(AVG (P.SELLING_PRICE),2) AS AVG_SELLING_PRICE,
 ROUND(AVG(((P.SELLING_PRICE-P.COST_PRICE)/P.SELLING_PRICE)*100 ),3)AS PROFIT_MARGIN_PCT
 FROM CATEGORIES C INNER JOIN PRODUCTS P 
 ON C.CATEGORY_ID =P.CATEGORY_ID
 GROUP BY C.CATEGORY_NAME;
 

# Q13. Identify products that are currently out of stock and show the store where the stock-out occurred.

SELECT S.STORE_NAME ,P.PRODUCT_NAME, I.STOCK_QTY
FROM STORES S INNER JOIN INVENTORY I
ON S.STORE_ID =I.STORE_ID
INNER JOIN PRODUCTS P
ON I.PRODUCT_ID =P.PRODUCT_ID
WHERE I.STOCK_QTY =0;

# Q14. Total inventory value at cost price for each store.

SELECT S.STORE_NAME, SUM(I.STOCK_QTY*P.COST_PRICE) AS TOTAL_INVENTORY_COST
FROM STORES S INNER JOIN INVENTORY I 
ON S.STORE_ID = I.STORE_ID
INNER JOIN PRODUCTS P 
ON P.PRODUCT_ID =I.PRODUCT_ID
GROUP BY S.STORE_NAME
ORDER BY TOTAL_INVENTORY_COST;

# Q15. Calculate the gross sales, total discounts given,
# and net sales revenue generated by each store after accounting for discounts applied to individual sale items.

SELECT S.STORE_NAME, 
ROUND(SUM( P.SELLING_PRICE*T.QUANTITY),2) AS GROSS_SALE,
ROUND(SUM((P.SELLING_PRICE*T.QUANTITY)*T.DISCOUNT_PCT/100)) AS DISCOUNT,
ROUND(SUM((P.SELLING_PRICE*T.QUANTITY)-((P.SELLING_PRICE*T.QUANTITY)*T.DISCOUNT_PCT/100)),2) AS NET_SALE
FROM STORES S INNER JOIN SALES Y
ON S.STORE_ID = Y.STORE_ID
INNER JOIN SALE_ITEMS T 
ON Y.SALE_ID = T.SALE_ID 
INNER JOIN PRODUCTS P
ON T.PRODUCT_ID = P.PRODUCT_ID
GROUP BY S.STORE_NAME
ORDER BY NET_SALE DESC;	

# Q16. Analyze store-wise profitability by calculating
-- total net sales, total cost of goods sold (COGS),
-- total profit, and profit margin percentage.

select s.store_name,
 ROUND(sum(
 (P.selling_price*t.quantity)-
( (P.selling_price*t.quantity)*t.discount_pct/100)
),2) as net_sale,
ROUND(SUM(P.COST_PRICE*T.QUANTITY),2) AS COGS,
ROUND(SUM(
(P.selling_price*t.quantity)-
( (P.selling_price*t.quantity)*t.discount_pct/100) 
-
(P.COST_PRICE*T.QUANTITY)
),2) AS PROFIT,

ROUND(
SUM(
((P.SELLING_PRICE*T.QUANTITY) - 
((P.SELLING_PRICE*T.QUANTITY)*T.DISCOUNT_PCT/100))
 - (P.COST_PRICE * T.QUANTITY)) /
 SUM(
(P.SELLING_PRICE*T.QUANTITY) - 
((P.SELLING_PRICE*T.QUANTITY)*T.DISCOUNT_PCT/100))*100,2) AS PROFIT_MARGIN
FROM STORES S INNER JOIN SALES Y
ON S.STORE_ID = Y.STORE_ID
INNER JOIN SALE_ITEMS T
ON Y.SALE_ID = T.SALE_ID
INNER JOIN PRODUCTS P
ON T.PRODUCT_ID = P.PRODUCT_ID
GROUP BY S.STORE_NAME;

# Q17. Identify the best-performing products based on total quantity sold and total sales revenue generated after discounts.

SELECT P.PRODUCT_NAME, 
SUM(S.QUANTITY) AS QTY_SOLD, 
ROUND(
SUM(
( P.SELLING_PRICE* S.QUANTITY) - ((P.SELLING_PRICE*S.QUANTITY)*S.DISCOUNT_PCT/100)
),2
) AS TOTAL_NET_REVENUE
FROM PRODUCTS P INNER JOIN SALE_ITEMS S 
ON P.PRODUCT_ID = S.PRODUCT_ID
GROUP BY P.PRODUCT_NAME
ORDER BY TOTAL_NET_REVENUE DESC;


# Q18. Analyze category-wise sales performance based on total quantity sold,
--  net sales revenue, and total profit generated, and rank the categories by profitability.

SELECT C.CATEGORY_NAME,
SUM(S.QUANTITY) AS TOTAL_QTY,
ROUND(
SUM( 
( P.SELLING_PRICE*S.QUANTITY) -((P.SELLING_PRICE *S.QUANTITY)*S.DISCOUNT_PCT/100)
),2
) AS NET_SALES_REVENUE,
ROUND(
SUM(
(P.SELLING_PRICE *S.QUANTITY) -((P.SELLING_PRICE *S.QUANTITY)*S.DISCOUNT_PCT/100)
- (P.COST_PRICE *S.QUANTITY)
),2
) AS PROFIT
 FROM CATEGORIES C INNER JOIN PRODUCTS P 
 ON C.CATEGORY_ID = P.CATEGORY_ID
 INNER JOIN SALE_ITEMS S 
 ON P.PRODUCT_ID = S.PRODUCT_ID
 
 GROUP BY C.CATEGORY_NAME
 ORDER BY PROFIT DESC;


# Q19. Identify products with low stock levels (less than 20 units) across stores, showing the store name, product name,
-- current stock quantity, and last restock date. Sort the results from lowest to highest stock.

SELECT S.STORE_NAME,P.PRODUCT_NAME, I.STOCK_QTY,I.LAST_RESTOCK_DATE
FROM PRODUCTS P INNER JOIN INVENTORY I 
ON P.PRODUCT_ID = I.PRODUCT_ID 
INNER JOIN STORES S 
on i.store_id = s.store_id
WHERE I.STOCK_QTY < 20
ORDER BY I.STOCK_QTY;

# Q20. Analyze product returns by calculating the total quantity returned and the return rate (%) for each product, 
-- and identify products with the highest return rates.

SELECT P.PRODUCT_NAME, SUM(COALESCE( R.RETURN_QTY,0)) AS TOTAL_RETURN_QTY, 
ROUND(
(SUM(COALESCE( R.RETURN_QTY,0)) / SUM(S.QUANTITY))*100,2
) AS RETURN_RATE
FROM PRODUCTS P INNER JOIN SALE_ITEMS S 
ON P.PRODUCT_ID = S.PRODUCT_ID
LEFT JOIN RETURNS_ R
ON S.SALE_ITEM_ID = R.SALE_ITEM_ID
GROUP BY P.PRODUCT_NAME
ORDER BY RETURN_RATE DESC;

# Q21. Analyze the main reasons for product returns by calculating the number of return transactions and total quantity returned for each return reason. 
-- Rank the reasons from most to least significant based on total returned quantity.

SELECT  RETURN_REASON,COUNT(RETURN_ID) AS RETURN_TRANSACTION, SUM(RETURN_QTY) AS TOTAL_QTY_RETURNED
FROM RETURNS_
GROUP BY RETURN_REASON
ORDER BY TOTAL_QTY_RETURNED DESC; 



# Q22. Analyze the monthly sales trend by calculating the number of transactions 
-- and net sales revenue generated each month. Sort the results chronologically.

SELECT  DATE_FORMAT (S.SALE_DATE, '%Y-%m') AS SALE_MONTH , COUNT(DISTINCT S.SALE_ID) AS TOTAL_TRANSACTIONS, 
ROUND(
SUM(( T.QUANTITY * P.SELLING_PRICE ) -(T.QUANTITY*P.SELLING_PRICE)*T.DISCOUNT_PCT/100
),2
) AS NET_SALES_REVENUE
FROM SALES S INNER JOIN SALE_ITEMS T
ON S.SALE_ID = T.SALE_ID 
INNER JOIN PRODUCTS P 
ON T.PRODUCT_ID = P.PRODUCT_ID

GROUP BY DATE_FORMAT (S.SALE_DATE, '%Y-%m')
ORDER BY SALE_MONTH;

# Q23. Analyze monthly net sales revenue and compare each month's performance with the previous
--  month using a CTE and the LAG() window function. Display the sales month, current month's net revenue, 
-- and previous month's net revenue in chronological order.


WITH NET_REVENUE AS ( SELECT  DATE_FORMAT( S.SALE_DATE, '%Y-%m') AS SALE_MONTH, 
ROUND( SUM( (T.QUANTITY*P.SELLING_PRICE) -(T.QUANTITY * P.SELLING_PRICE)*T.DISCOUNT_PCT/100),2) AS MONTHLY_NET_REVENUE
FROM SALES S INNER JOIN SALE_ITEMS T 
on s.sale_id = t.sale_id 
inner join products p 
on t.product_id = p.product_id 
GROUP BY DATE_FORMAT( S.SALE_DATE, '%Y-%m'))

SELECT 	SALE_MONTH, MONTHLY_NET_REVENUE,
 LAG(MONTHLY_NET_REVENUE) OVER (ORDER BY SALE_MONTH) AS PREVIOUS_MONTH_REVENUE 
FROM NET_REVENUE;

# Q24. Calculate the percentage increase or decrease in monthly net sales revenue compared with the previous month,
-- and identify the months with the largest growth and decline.

WITH NET_REVENUE AS ( SELECT DATE_FORMAT( S.SALE_DATE, '%Y-%m') AS SALE_MONTH,
ROUND(SUM( (T.QUANTITY * P.SELLING_PRICE) -(T.QUANTITY * P.SELLING_PRICE)*T.DISCOUNT_PCT/100
),2) AS MONTHLY_NET_REVENUE
from sales s inner join sale_items T 
ON S.SALE_ID = T.SALE_ID 
INNER JOIN PRODUCTS P
ON T.PRODUCT_ID = P.PRODUCT_ID 
GROUP BY DATE_FORMAT( S.SALE_DATE, '%Y-%m')),
MONTHLY_SALE_COMPARISON AS ( SELECT SALE_MONTH, MONTHLY_NET_REVENUE,
 LAG(MONTHLY_NET_REVENUE) OVER (ORDER BY SALE_MONTH) AS PREVIOUS_MONTH_REVENUE
FROM NET_REVENUE)

SELECT SALE_MONTH, MONTHLY_NET_REVENUE, PREVIOUS_MONTH_REVENUE, 
ROUND(((MONTHLY_NET_REVENUE - PREVIOUS_MONTH_REVENUE)/ NULLIF(PREVIOUS_MONTH_REVENUE,0)*100),2 )AS MOM_GROWTH
FROM MONTHLY_SALE_COMPARISON 
ORDER BY SALE_MONTH;

#Q25. Identify the top 3 revenue-generating products within each fashion category based on net sales revenue after discounts. 
-- Display the category name, product name, total quantity sold, net sales revenue, and rank within each category.
 
WITH NET_SALES_REVENUE AS (SELECT C.CATEGORY_NAME, P.PRODUCT_NAME,
ROUND(SUM((T.QUANTITY *P.SELLING_PRICE) - (T.QUANTITY *P.SELLING_PRICE)*T.DISCOUNT_PCT/100
),2) AS NET_REVENUE ,SUM(T.QUANTITY) AS QTY_SOLD
FROM CATEGORIES C INNER JOIN PRODUCTS P 
ON C.CATEGORY_ID = P. CATEGORY_ID 
INNER JOIN SALE_ITEMS T
ON P.PRODUCT_ID = T.PRODUCT_ID 
GROUP BY C.CATEGORY_NAME,P.PRODUCT_NAME),
RANKING_PRODUCTS AS ( SELECT  CATEGORY_NAME, PRODUCT_NAME, NET_REVENUE, QTY_SOLD,
 DENSE_RANK() OVER (PARTITION BY CATEGORY_NAME ORDER BY NET_REVENUE DESC) AS PRODUCT_RANK
 FROM NET_SALES_REVENUE )
 
 SELECT *
 FROM RANKING_PRODUCTS
 WHERE PRODUCT_RANK <=3
ORDER BY CATEGORY_NAME, PRODUCT_RANK;

#Q26. Identify StyleHub Retail's most valuable customers based on their total spending and purchase frequency.

WITH CUSTOMER_SPENDING AS ( SELECT C.CUSTOMER_NAME, COUNT(DISTINCT S.SALE_ID) AS TOTAL_ORDERS, 
ROUND(SUM((T.QUANTITY * P.SELLING_PRICE) -(T.QUANTITY * P.SELLING_PRICE)*DISCOUNT_PCT/100),2) AS TOTAL_SPENDING,
ROUND(SUM((T.QUANTITY * P.SELLING_PRICE) -(T.QUANTITY * P.SELLING_PRICE)*DISCOUNT_PCT/100)/ nullif(COUNT(distinct S.SALE_ID),0),2) AS AVG_ORDER_VALUE

FROM CUSTOMERS C INNER JOIN SALES S
ON C.CUSTOMER_ID = S.CUSTOMER_ID
INNER JOIN SALE_ITEMS T
ON S.SALE_ID = T.SALE_ID 
INNER JOIN PRODUCTS P
on T.PRODUCT_ID = P.PRODUCT_ID
group by c.customer_id , c.customer_name)

select customer_name,total_orders,total_spending,avg_order_value,
CASE
WHEN TOTAL_SPENDING >= 50000 THEN 'HIGH_VALUE'
WHEN TOTAL_SPENDING >=20000 THEN 'MEDIUM_VALUE'
ELSE 'LOW_VALUE'
END AS CUSTOMER_SEGMENT
FROM CUSTOMER_SPENDING
ORDER BY TOTAL_SPENDING DESC;

-- CUSTOMER DATA VALIDATION 
 
SELECT (SELECT COUNT(*) FROM CUSTOMERS ) AS TOTAL_CUSTOMERS,
( SELECT COUNT(DISTINCT CUSTOMER_ID ) FROM SALES ) AS CUSTOMERS_MADE_PURCHASE,
(SELECT COUNT(*) FROM SALES) AS TOTAL_TRANSACTIONS,
(SELECT COUNT(*) FROM CUSTOMERS )- (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SALES ) AS CUSTOMER_WITHOUT_PURCHASES;

#Q27. Identify High-Inventory, Low-Sales Products

WITH STORE_PRODUCT_SALES AS (
SELECT S.STORE_ID, SI.PRODUCT_ID, SUM(SI.QUANTITY) AS SOLD_QTY 
FROM SALES S INNER JOIN SALE_ITEMS SI 
ON S.SALE_ID = SI.SALE_ID 
GROUP BY S.STORE_ID, SI.PRODUCT_ID)

SELECT S.STORE_NAME, P.PRODUCT_NAME, I.STOCK_QTY, coalesce(X.SOLD_QTY,0), (I.STOCK_QTY *P.COST_PRICE) AS INVENTORY_VALUE,
ROUND(COALESCE (X.SOLD_QTY,0)*100.0/NULLIF(I.STOCK_QTY,0),2) AS SALE_TO_INVENTORY_PCT
FROM STORES S INNER JOIN INVENTORY I
ON S.STORE_ID  = I.STORE_ID 
INNER JOIN PRODUCTS P 
ON I.PRODUCT_ID = P.PRODUCT_ID
LEFT JOIN STORE_PRODUCT_SALES X
ON I.STORE_ID = X.STORE_ID 
AND I.PRODUCT_ID = X.PRODUCT_ID 
WHERE I.STOCK_QTY>=50 
AND coalesce(X.SOLD_QTY,0)<20
ORDER BY I.STOCK_QTY DESC;

-- END 


