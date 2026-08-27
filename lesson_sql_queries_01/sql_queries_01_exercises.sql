/* ================================================================
   DAT 153 -- SELECT Statements
   Exercises from lessons/lesson_sql_queries_01/_lesson.qmd
   Database: countries
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1

   Locate all countries with populations greater than 68 million
   people. Sort your results in ascending alphabetical order, first
   by region, then by country. Limit the results to 10 rows, and
   include only these columns:

     - region
     - country
     - capital
     - population
     - area
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   How many countries have fewer than 1 million inhabitants?
   Instead of returning columns, use the COUNT(*) function inside
   your SELECT clause to return a simple row count.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Write a SQL query to find the capital city of Liberia. Return
   only the capital city and country name.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.3

   Write a SQL query to find all countries where their region
   contains the word "Asia". Sort ascending by region, then
   country. Return only these columns:

     - region
     - country
     - population
     - capital
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.4

   Write a SQL query to find all South Asian countries OR countries
   with populations greater than 100 million. Sort ascending by
   region, then country. Return only these columns:

     - region
     - country
     - population
     - capital
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.5

   Write a SQL query to find all Middle East & North Africa
   countries whose land area is between 500,000 and 2,000,000
   square kilometers. Sort descending by area. Return only these
   columns:

     - country
     - area
     - region
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.6

   Find all countries located in either "East Asia & Pacific" or
   "South Asia" and that have either a population of more than 100
   million or an area greater than 1 million square kilometers.
   Sort descending by area. Return only these columns:

     - country
     - region
     - population
     - area

   This question requires both AND and OR operators. Read the
   prompt carefully and consider order of operations.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.7

   Use SELECT DISTINCT to find which regions have at least one
   country with a population greater than 200 million. Sort the
   regions alphabetically.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.8

   Use the IN operator to find all countries situated in either
   North America or Sub-Saharan Africa. Sort descending by area.
   Return only these columns:

     - country
     - area
     - region
   ---------------------------------------------------------------- */
