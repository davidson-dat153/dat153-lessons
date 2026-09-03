/* ================================================================
   DAT 153 -- Joining Tables
   Exercises from lessons/lesson_sql_queries_03/_lesson.qmd
   Database: murdermystery
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Join person to drivers_license (on person.license_id =
   drivers_license.id) to return each person's name along with
   their eye_color, hair_color, and car_make. Limit to 10 rows.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Using the join from Exercise 1.1, filter to only people whose
   car_make is 'Toyota' and eye_color is 'blue'. Return name,
   car_make, eye_color, and car_model.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.3

   Join person to income (on person.ssn = income.ssn) to find the
   10 people with the highest annual_income. Return name and
   annual_income, sorted descending.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.4

   Join get_fit_now_member to get_fit_now_check_in (on id =
   membership_id) to find every check-in recorded for members
   whose membership_status is 'gold'. Return the member's name,
   check_in_date, and check_in_time.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Join person, drivers_license, and income together (three
   tables) to return name, car_make, car_model, and annual_income
   for every person whose annual_income is greater than 100000.
   Sort descending by annual_income.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Join get_fit_now_member, get_fit_now_check_in, and person (via
   get_fit_now_member.person_id = person.id) to find the names of
   everyone who checked in to the gym on '2018-01-09'. Return
   name, check_in_date, and check_in_time.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Not everyone in person has been interviewed. Write a LEFT JOIN
   from person to interview (on person.id = interview.person_id)
   and use IS NULL on a column from interview to find people who
   have NOT been interviewed. Return just the count of how many
   people that is.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Using the same anti-join pattern from Exercise 3.1, return the
   name and ssn (10 rows) of people who have not been interviewed,
   sorted by name.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.3

   Write a LEFT JOIN from person to get_fit_now_member (on
   person.id = get_fit_now_member.person_id) to find people who
   are NOT gym members at all. Return the count of how many people
   that is, and explain in a comment why a LEFT JOIN is necessary
   here instead of an INNER JOIN.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4: Solve the Case -- Exercise 4.1

   There's been a murder in SQL City! You are a police detective
   with access to the crime database you've been querying all
   lesson: crime_scene_report, person, interview, drivers_license,
   income, get_fit_now_member, get_fit_now_check_in, and
   facebook_event_checkin. Use the joins you just practiced in
   Parts 1-3 to follow the clues from the crime scene all the way
   to the person behind it.

   A murder occurred on January 15, 2018, in SQL City. Query
   crime_scene_report to get the details of the case we have so
   far.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.2: Identify Witness 1

   Use the crime scene report details from the previous query to
   identify the first witness. Return their name and address
   (number and street name).
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.3: Witness 1's statement

   Retrieve the interview transcript for the first witness. What
   useful details about our suspect can you glean from this?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.4: Identify Witness 2

   Use the crime scene report details from the previous query to
   identify the SECOND witness. Return their name and address
   (number and street name).
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.5: Witness 2's statement

   Retrieve the interview transcript for the second witness. Does
   this include any more useful details?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.6: Find the suspect

   Between the two statements, you now know the suspect is a man,
   is probably a gold member at "Get Fit Now Gym," drove a car
   with a plate containing "H42W," and was at the gym on
   2018-01-09.

   Using the data you've compiled so far and your knowledge of the
   database, can you identify our shooter? (HINT: This requires
   joining multiple tables.)
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.7: The shooter's own statement

   Get the interview transcript for your shooting suspect. What
   does this reveal?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.8: Find the mastermind

   This is the big one! Use the details about the mastermind
   behind this murder to identify them from our database. Again,
   this will require joining multiple tables together, and
   filtering!
   ---------------------------------------------------------------- */
