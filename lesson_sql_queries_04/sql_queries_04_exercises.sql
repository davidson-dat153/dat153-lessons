/* ================================================================
   DAT 153 -- Set Operations
   Exercises from lessons/lesson_sql_queries_04/_lesson.qmd
   Database: library
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Write a query that returns the distinct city of every patron
   whose membership_type is 'Student'. Write a second query that
   returns the distinct city of every patron whose membership_type
   is 'Senior'. Combine them with UNION so that each city appears
   only once in the final result, even if it shows up in both
   groups.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Re-run Exercise 1.1's two queries, but combine them with UNION
   ALL instead. Compare the row count to Exercise 1.1's result and
   explain, in a comment, why the counts differ (or don't).
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Write one query that joins books to book_genres to genres,
   filtered to 'Hardcover' format, and returns the genre name.
   Write a second query using the same three-table join, filtered
   to 'eBook' format instead. Combine them with INTERSECT to find
   genre names available in BOTH formats.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Write one query that returns patron_id, first_name, and
   last_name for every patron whose membership_type = 'Student'.
   Write a second query that joins patrons to checkouts to fines,
   filtered to fines.status = 'Outstanding', returning those same
   three columns. Combine them with INTERSECT to find patrons who
   are both a Student and currently have an outstanding fine.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Using the same three-table join from Exercise 2.1 (books to
   book_genres to genres, returning genre name directly), find
   genres that have at least one book in 'Paperback' format but NO
   books in 'Audiobook' format, using EXCEPT.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Write a query that returns the distinct city of every 'Adult'
   patron. Write a second query that returns the distinct city of
   every 'Child' patron. Use EXCEPT to find cities that have an
   adult patron but no child patron.
   ---------------------------------------------------------------- */
