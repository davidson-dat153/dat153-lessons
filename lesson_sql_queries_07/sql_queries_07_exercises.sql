/* ================================================================
   DAT 153 -- Window Functions
   Exercises from lessons/lesson_sql_queries_07/_lesson.qmd
   Database: northwind
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   For the products in category 1 ('Beverages'), write a query that
   ranks each product by unit_price from highest to lowest using
   RANK(), partitioned by category_id. Return product_name,
   unit_price, and the rank. Notice what happens to the ranking when
   two products share the same price.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Rewrite Exercise 1.1 using DENSE_RANK() instead of RANK().
   Compare the two result sets and, in a comment, describe the
   difference in how each function numbers a group of tied rows.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.3

   Extend Exercise 1.1 to cover every category, not just Beverages,
   by partitioning RANK() OVER (...) by category_id. Return
   category_id, product_name, unit_price, and the rank, and filter
   your final result to only the TOP 3 ranked products in each
   category. (Hint: window functions can't be filtered directly in
   WHERE, you'll need a subquery or CTE to filter on the rank
   afterward.)
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   For customer 'ALFKI', write a query that lists each of their
   orders (order_id, order_date, freight) along with a running total
   of freight ordered by order_date. Use SUM(freight) OVER
   (PARTITION BY customer_id ORDER BY order_date).
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Extend Exercise 2.1 to cover every customer, not just 'ALFKI'.
   Return customer_id, order_id, order_date, freight, and the
   running total, partitioned appropriately so each customer's
   running total starts over at their first order.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   For customer 'ALFKI', write a query that lists each order's
   order_date and freight, along with the freight of that customer's
   PREVIOUS order using LAG(freight) OVER (PARTITION BY customer_id
   ORDER BY order_date). Then add a column showing the difference
   between the current and previous freight.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Extend Exercise 3.1 to cover every customer. Return customer_id,
   order_id, order_date, freight, the previous order's freight, and
   the difference. For each customer's very first order, what does
   the LAG() column show? Explain in a comment.
   ---------------------------------------------------------------- */
