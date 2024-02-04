CREATE DATABASE IF NOT EXISTS salesdataWalmart;
CREATE TABLE IF NOT EXISTS data (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10 , 2 ) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT NOT NULL,
    total DECIMAL(12 , 4 ) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10 , 2 ) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12 , 4 ) NOT NULL,
    rating FLOAT
);

-- --------Feature Engineering-------------------------------------------------------------
-- --------Time_of_day-----------------------------------------

SELECT 
    time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS Time_of_day
FROM
    data;

ALTER TABLE data ADD COLUMN Time_of_day VARCHAR(20);

UPDATE data 
SET 
    Time_of_day = (CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);
    
SET SQL_SAFE_UPDATES = 0;

-- --------------day_name---------------------------------------------------------

SELECT 
    date, DAYNAME(date) AS day_name
FROM
    data;
ALTER TABLE data ADD column day_name VARCHAR(10);
UPDATE data 
SET 
    day_name = DAYNAME(date);

-- ------------------month_name----------------------------------------------------------------------
SELECT 
    date, MONTHNAME(date)
FROM
    data;
ALTER TABLE data ADD column month_name VARCHAR(20);
UPDATE data 
SET 
    month_name = MONTHNAME(date);

-- --------Generic-----------------------------------------------------
-- ----------------How many unique cities does the data have?---------------------------

SELECT DISTINCT
    city
FROM
    data;

-- In which city is each branch?----------------------------------------------------------------

SELECT DISTINCT
    city, branch
FROM
    data;

-- Product--------------------------------------------------------------------------
-- How many unique product lines does the data have?--------------------------------------

SELECT DISTINCT
    product_line
FROM
    data;

-- What is the most common payment method?-------

SELECT 
    payment_method, COUNT(payment_method)
FROM
    data
GROUP BY payment_method
ORDER BY COUNT(payment_method) DESC;

-- What is the most selling product line?-----

SELECT 
    product_line, COUNT(product_line)
FROM
    data
GROUP BY product_line
ORDER BY COUNT(product_line) DESC;

-- What is the total revenue by month?----------------

SELECT 
    month_name, SUM(total) AS total_revenue
FROM
    data
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?-----------------------------------------------

SELECT 
    month_name AS month, SUM(cogs) AS cogs
FROM
    data
GROUP BY month_name
ORDER BY cogs DESC;

-- What product line had the largest revenue?----------------------------------------

SELECT 
    product_line, SUM(total) AS revenue
FROM
    data
GROUP BY product_line
ORDER BY revenue DESC;

-- What is the city with the largest revenue?-----------------------

SELECT 
    city, branch, SUM(total) AS revenue
FROM
    data
GROUP BY city , branch
ORDER BY revenue DESC;

-- What product line had the largest VAT?--------------------------------

SELECT 
    product_line, SUM(VAT) AS VAT
FROM
    data
GROUP BY product_line
ORDER BY VAT;

-- Fetch each product line and
-- add a column to those product line showing "Good", "Bad".
-- Good if its greater than average sales----------------------------------------

SELECT 
    branch, SUM(quantity) AS Quantity
FROM
    data
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        data);
        
-- What is the most common product line by gender?-------------------------

SELECT 
    gender, product_line, COUNT(gender) AS total_cnt
FROM
    data
GROUP BY gender , product_line
ORDER BY COUNT(gender) DESC;

-- What is the average rating of each product line?----------------------

SELECT 
    AVG(rating) AS average_rating, product_line
FROM
    data
GROUP BY product_line
ORDER BY average_rating;

-- -----------------------sales-------------------------------------------------
-- ----------------Number of sales made in each time of the day per weekday------------------

SELECT 
    Time_of_day, COUNT(*) AS total_sales
FROM
    data
GROUP BY Time_of_day;

-- Which of the customer types brings the most revenue?----------------

SELECT 
    customer_type, SUM(total) AS revenue
FROM
    data
GROUP BY customer_type
ORDER BY revenue DESC;

-- -----------------Which city has the largest tax percent/ VAT (Value Added Tax)?---------------

SELECT 
    city, AVG(VAT) AS VAT
FROM
    data
GROUP BY city
ORDER BY VAT DESC;

-- -------------Which customer type pays the most in VAT?----------------------------------------

SELECT 
    customer_type, AVG(VAT) AS VAT
FROM
    data
GROUP BY customer_type
ORDER BY VAT DESC;

-- -----------------CUSTOMER----------------------------------------------------------

SELECT DISTINCT
    customer_type, COUNT(customer_type) AS number_of_customers
FROM
    data
GROUP BY customer_type
ORDER BY number_of_customers;

-- ---------How many unique payment methods does the data have?-------------------

SELECT DISTINCT
    payment_method,
    COUNT(payment_method) AS number_of_payment_types
FROM
    data
GROUP BY payment_method
ORDER BY number_of_payment_types DESC;

-- -------------------What is the most common customer type?--------------------------

SELECT DISTINCT
    customer_type, COUNT(customer_type) AS number_of_customers
FROM
    data
GROUP BY customer_type
ORDER BY number_of_customers
LIMIT 1;

-- ----------Which customer type buys the most?---------------------------------------------

SELECT 
    customer_type, COUNT(*) AS count
FROM
    data
GROUP BY customer_type
ORDER BY count;

-- What is the gender of most of the customers?----------------

SELECT 
    gender, COUNT(gender) AS gender_count
FROM
    data
GROUP BY gender
ORDER BY gender_count DESC;

-- ------------What is the gender distribution per branch?--------------------------

SELECT 
    branch, gender, COUNT(gender) AS gender_count
FROM
    data
GROUP BY branch , gender
ORDER BY branch , gender_count DESC;

-- -----------------Which time of the day do customers give most ratings?-----------------------

SELECT 
    Time_of_day, COUNT(rating) AS most_ratings
FROM
    data
GROUP BY Time_of_day
ORDER BY most_ratings DESC;

-- --------------Which time of the day do customers give most ratings per branch?-----------------

SELECT 
    Time_of_day, branch, COUNT(rating) AS most_ratings
FROM
    data
GROUP BY Time_of_day , branch
ORDER BY most_ratings DESC;

-- ----------Which day fo the week has the best avg ratings?--------------

SELECT 
    day_name, AVG(rating) AS best_avg_rating
FROM
    data
GROUP BY day_name
ORDER BY best_avg_rating DESC;

-- ---------
