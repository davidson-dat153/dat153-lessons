/* ================================================================
   DAT 153 -- Conditional Expressions
   Exercises from lessons/lesson_sql_queries_05/_lesson.qmd
   Database: worldbank

   Unlike the flat table you may have seen elsewhere, worldbank is
   normalized: countries holds one row per country (with a
   region_id and income_group_id foreign key), and indicators holds
   one row per country per year with measures like population and
   gdp_per_capita_usd. Most exercises join to indicators and should
   filter to year = 2022 and exclude aggregate rows with NOT
   c.is_aggregate (where c is your alias for countries); a couple
   of exercises only touch countries directly and don't need a
   year filter at all, so read each prompt carefully rather than
   copying the same WHERE clause everywhere.
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Join countries to indicators and write a CASE expression that
   labels each country 'Landlocked or Small' if its land_area_km2
   is less than 20,000, and 'Larger Territory' otherwise. Return
   short_name, land_area_km2, and your new label column, sorted by
   land_area_km2.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   countries.income_group_id is NULL for every row where
   is_aggregate is true (regional groupings like "World" or "Euro
   area" don't have an income classification of their own). Join
   countries to income_groups with a LEFT JOIN, and use COALESCE
   to display 'Not classified' in place of a NULL income group
   name. Return short_name, is_aggregate, and the coalesced income
   group name, and sort so the aggregate rows are grouped together.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Join countries to indicators and write a CASE expression that
   buckets each country's gdp_per_capita_usd into one of the
   following labels:

     - 'Under $5,000' if less than 5000
     - '$5,000 - $19,999' if less than 20000
     - '$20,000 - $49,999' if less than 50000
     - '$50,000 and up' otherwise

   Return short_name, gdp_per_capita_usd, and the bucket label,
   sorted by gdp_per_capita_usd.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Using the bucket labels from Exercise 2.1, group by the bucket
   and count how many countries fall into each one. Sort the
   results from lowest bucket to highest. (Hint: you can repeat the
   full CASE expression in your GROUP BY clause, or give it an
   alias with AS and group by the alias, depending on what your
   version of PostgreSQL allows.)
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.3

   Write a similar bucketing CASE expression for population, using
   these labels:

     - 'Under 1 million' if less than 1,000,000
     - '1 million - 24.9 million' if less than 25,000,000
     - '25 million - 99.9 million' if less than 100,000,000
     - '100 million and up' otherwise

   Group by the bucket and count how many countries fall into each
   one, sorted from lowest bucket to highest.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Join countries, indicators, and regions together. For each
   region, count how many of its countries fall into the 'Under
   $5,000' GDP-per-capita bucket from Exercise 2.1 (hint: you can
   use CASE WHEN ... THEN 1 ELSE 0 END inside a SUM(), or use
   COUNT(*) FILTER (WHERE ...) if you'd like to try a different
   technique). Sort descending by that count.
   ---------------------------------------------------------------- */
