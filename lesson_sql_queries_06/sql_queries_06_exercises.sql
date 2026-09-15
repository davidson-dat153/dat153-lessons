/* ================================================================
   DAT 153 -- Subqueries and CTEs
   Exercises from lessons/lesson_sql_queries_06/_lesson.qmd
   Database: actors
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Write a query that returns every actor whose total_box_office_usd
   is greater than the AVERAGE total_box_office_usd across all
   actors. Use a subquery in the WHERE clause to compute that
   average; don't hardcode the number. Return first_name, last_name,
   and total_box_office_usd, sorted descending.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Write a query that returns the single actor with the highest
   total_box_office_usd by comparing each row's value to a subquery
   that returns MAX(total_box_office_usd). (You'll practice a
   simpler way to do this with ORDER BY and LIMIT elsewhere, but for
   this exercise, use the subquery approach.)
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Write a query that returns every actor whose oscar_wins is
   greater than the AVERAGE oscar_wins for actors who share their
   primary_genre. This requires a correlated subquery: the
   subquery's WHERE clause needs to reference the outer query's
   current row (for example, WHERE a2.primary_genre =
   a1.primary_genre). Return first_name, last_name, primary_genre,
   and oscar_wins.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Write a query that returns every actor who is taller (height_cm)
   than the average height of actors who share their primary_genre.
   Return first_name, last_name, primary_genre, and height_cm,
   sorted by primary_genre.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Write a query using IN with a subquery to find actors whose
   birth_country matches the birth country of ANY actor with at
   least one oscar_wins. Return first_name, last_name, and
   birth_country, and make sure your results include actors who
   themselves have zero Oscar wins but share a birth country with
   someone who does.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Write a query using NOT IN with a subquery to find actors whose
   birth_country does NOT appear anywhere in the set of birth
   countries produced by Exercise 3.1's subquery. Return first_name,
   last_name, and birth_country.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.1

   Write a query that finds every actor whose oscar_nominations is
   greater than the AVERAGE oscar_nominations for actors who share
   their primary_genre, this time using a DERIVED TABLE in the FROM
   clause instead of a correlated subquery. Build the per-genre
   averages as a subquery aliased g in FROM, join it back to actors,
   and filter in the outer query's WHERE clause. Return first_name,
   last_name, primary_genre, and oscar_nominations, sorted by
   primary_genre.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.1

   Write a CTE named genre_avg_height that computes the average
   height_cm for each primary_genre. Then write a main query that
   joins the actors table back to your CTE to return every actor's
   first_name, last_name, primary_genre, height_cm, and the average
   height for their genre, side by side.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.2

   Extend Exercise 5.1 by adding a CASE expression to the main query
   that labels each actor 'Above Average' or 'Below Average'
   depending on whether their height_cm is greater than their
   genre's average height (from the CTE). Sort by primary_genre,
   then by height_cm descending.
   ---------------------------------------------------------------- */
