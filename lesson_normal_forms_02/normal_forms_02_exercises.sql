/* ================================================================
   DAT 153 -- Normal Forms II: Normalizing the City of Houston Budget
   Exercises from lessons/lesson_normal_forms_02/_lesson.qmd
   Database: budget (run normal_forms_02_setup.sql first)
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1: Find the grain and the key

   What does one row of staging.houston_budget represent? Find the
   smallest combination of columns that identifies every row, and
   write a query that proves it. Your query should return any
   combination of values that appears more than once, so no rows
   means you've found a key. Then make sure every column in your key
   has to be there: if you can leave one out and still get no rows,
   it doesn't belong.

   TIP: Using GROUP BY with HAVING COUNT(*) is a great way to solve
   this.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2: Test the functional dependencies

   A functional dependency A → B holds when no value of A ever
   appears with more than one value of B. That translates directly
   into SQL: group by A, and keep only the groups with more than one
   distinct B, as in SELECT a FROM some_table GROUP BY a HAVING
   COUNT(DISTINCT b) > 1. Every row a query like that returns is a
   counterexample. No rows means the dependency holds in this data.
   The staging table holds both years, so each test also checks that
   nothing changed between FY2024 and FY2025.

   Use that pattern to find the dependencies your design will rest
   on. Find out which columns each code (fund_code, department_code,
   and gl_account_code) determines, and check whether any non-key
   column determines another non-key column.

   TIP: Using GROUP BY with HAVING COUNT(DISTINCT ...) can help you
   solve this.

   It's also worth validating the data by flipping the script: does
   each name/description belong to only one code? If every name
   belongs to exactly one code, there should be as many distinct
   names as distinct codes. Count both for funds, departments, and
   GL accounts. But pay close attention to gl_description: if its
   count doesn't match, find out why.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3: Plan the 3NF design

   This part doesn't need SQL. Talk it through with a partner, and
   sketch the tables you'll build.

   Take staging.houston_budget to third normal form (3NF). Start by
   deciding whether it's already in first normal form (1NF). Then
   use what you found in Part 2 to remove every partial dependency
   on the Part 1 key, and after that every transitive dependency.

   The city also wants each fiscal year's start and end dates in the
   database. Houston's fiscal year runs from July 1 through June 30,
   so FY2025 ran from July 1, 2024 through June 30, 2025. Your
   design needs a place for those dates.

   Your finished sketch should show every table, its columns, its
   primary key, its foreign keys, and which columns have to be
   unique.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4: Create the tables

   Write a CREATE TABLE statement for every table in your Part 3
   design. Follow these conventions:

     - Every table gets an identity primary key named after it (order_id for orders).
     - Every natural key gets a UNIQUE constraint, even one made of several columns.
     - Every column is required: the staging data has no missing values.
     - A column whose values must follow a rule gets a CHECK constraint.

   Only declare a column UNIQUE if Part 2 showed that it is. Create
   each parent table before the tables that reference it. At the
   top, write one DROP TABLE IF EXISTS ... CASCADE statement that
   lists all of your tables, so you can start this part over any
   time.

   Write this part in a new file named
   dat153_normalforms_create.sql, connected to the budget database.
   Use the table and column names from the design in the Part 3
   review, spelled exactly the same way: the autograder looks for
   those names.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5: Load the tables

   Load every table from the staging table with INSERT ... SELECT,
   in the same order you created them: a row can't reference a
   parent row that doesn't exist yet. To fill in a foreign key, join
   the staging table to the parent table on the city's own value (a
   code, or the year), and insert the parent's surrogate key.

   The staging table only has the fiscal year numbers, so you'll
   have to compute each year's dates: fiscal year N runs from July 1
   of year N - 1 through June 30 of year N. (MAKE_DATE(year, month,
   day) builds a date from three numbers.)

   Every staging row is one budget line, so the table that holds the
   amounts should end up with 9,827 rows.

   Write this part in a new file named
   dat153_normalforms_insert.sql. When you're done, submit both
   files to the Normal Forms II assignment on Gradescope. The
   autograder starts from a fresh copy of the staging table, runs
   your files, and checks your tables' structure and contents. It
   checks each file on its own, so a mistake in your CREATE TABLE
   file won't cost you anything on your INSERT file. Nothing here is
   graded, and you can resubmit as often as you like.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 6: Prove nothing was lost

   Write a query that rebuilds staging.houston_budget from your
   tables: the same 14 columns, in the same order, with the same
   names. Then use EXCEPT to prove that your rebuilt table matches
   the staging table exactly. Check both directions: rows in staging
   that are missing from the rebuild, and rows in the rebuild that
   aren't in staging.

   Finally, what did all this buy you? Count how many rows of the
   staging table store the General Fund's name and type, then count
   how many rows store them now.
   ---------------------------------------------------------------- */
