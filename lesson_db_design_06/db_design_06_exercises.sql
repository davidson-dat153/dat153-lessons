/* ================================================================
   DAT 153 -- Database Security: Roles and Privileges
   Exercises from lessons/lesson_db_design_06/_lesson.qmd
   Database: postgres on your Supabase __demo project (see the
   lesson page for how to connect with psql)
   ================================================================ */


/* ----------------------------------------------------------------
   Part 0 -- Exercise 0.1

   Connect to Supabase as described in Connecting to Supabase, and
   run the provided setup code. It creates the registrar schema with
   four tables: students, courses, enrollments, and advisors. It
   also drops anything left over from a previous run, so you can
   rerun it any time to start over.

   Run the provided code to check the result. You should see 10
   students, 5 courses, 28 enrollments, and 3 advisors.
   ---------------------------------------------------------------- */

DROP SCHEMA IF EXISTS registrar CASCADE;
DROP ROLE IF EXISTS jordan;
DROP ROLE IF EXISTS etl_loader;
DROP ROLE IF EXISTS analyst;

CREATE SCHEMA registrar;

CREATE TABLE registrar.students (
    student_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name  TEXT     NOT NULL,
    last_name   TEXT     NOT NULL,
    email       TEXT     NOT NULL UNIQUE,
    class_year  INTEGER  NOT NULL,
    major       TEXT
);

CREATE TABLE registrar.courses (
    course_id  TEXT  PRIMARY KEY,
    title      TEXT  NOT NULL
);

CREATE TABLE registrar.enrollments (
    enrollment_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id     INTEGER  NOT NULL REFERENCES registrar.students (student_id),
    course_id      TEXT     NOT NULL REFERENCES registrar.courses (course_id),
    term           TEXT     NOT NULL,
    grade          TEXT
);

CREATE TABLE registrar.advisors (
    advisor_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        TEXT     NOT NULL,
    department  TEXT     NOT NULL
);

-- Supabase can turn on Row Level Security for new tables automatically.
-- This lesson doesn't use it, so turn it off.
ALTER TABLE registrar.students DISABLE ROW LEVEL SECURITY;
ALTER TABLE registrar.courses DISABLE ROW LEVEL SECURITY;
ALTER TABLE registrar.enrollments DISABLE ROW LEVEL SECURITY;
ALTER TABLE registrar.advisors DISABLE ROW LEVEL SECURITY;

INSERT INTO registrar.students (first_name, last_name, email, class_year, major) VALUES
    ('Ava',     'Chen',      'avchen@davidson.edu',     2027, 'Data Science'),
    ('Marcus',  'Bell',      'mabell@davidson.edu',     2028, 'Economics'),
    ('Sofia',   'Ramirez',   'soramirez@davidson.edu',  2027, 'Biology'),
    ('Ethan',   'Okafor',    'etokafor@davidson.edu',   2029, NULL),
    ('Grace',   'Kim',       'grkim@davidson.edu',      2028, 'Data Science'),
    ('Liam',    'Novak',     'linovak@davidson.edu',    2027, 'Mathematics'),
    ('Priya',   'Shah',      'prshah@davidson.edu',     2029, NULL),
    ('Noah',    'Fischer',   'nofischer@davidson.edu',  2028, 'Economics'),
    ('Maya',    'Thompson',  'mathompson@davidson.edu', 2027, 'Data Science'),
    ('Diego',   'Morales',   'dimorales@davidson.edu',  2028, 'Computer Science');

INSERT INTO registrar.courses (course_id, title) VALUES
    ('DAT 153', 'Database Programming'),
    ('DAT 201', 'Data Visualization'),
    ('ECO 101', 'Principles of Economics'),
    ('MAT 140', 'Calculus II'),
    ('CSC 121', 'Programming and Problem Solving');

INSERT INTO registrar.enrollments (student_id, course_id, term, grade) VALUES
    (1,  'MAT 140', '2025FA', 'A-'), (1,  'CSC 121', '2026SP', 'A'),  (1,  'DAT 153', '2026FA', 'B+'),
    (2,  'ECO 101', '2025FA', 'B'),  (2,  'MAT 140', '2026SP', 'C+'), (2,  'DAT 201', '2026FA', 'B'),
    (3,  'MAT 140', '2025FA', 'B+'), (3,  'DAT 201', '2026SP', 'A-'), (3,  'DAT 153', '2026FA', 'A'),
    (4,  'CSC 121', '2026SP', 'B-'), (4,  'ECO 101', '2026FA', 'C'),
    (5,  'CSC 121', '2025FA', 'A'),  (5,  'DAT 201', '2026SP', 'A'),  (5,  'DAT 153', '2026FA', 'A-'),
    (6,  'MAT 140', '2025FA', 'A'),  (6,  'ECO 101', '2026SP', 'B+'), (6,  'DAT 153', '2026FA', 'B'),
    (7,  'ECO 101', '2026SP', 'B'),  (7,  'CSC 121', '2026FA', 'D'),
    (8,  'ECO 101', '2025FA', 'A-'), (8,  'MAT 140', '2026SP', 'B'),  (8,  'DAT 201', '2026FA', 'B+'),
    (9,  'DAT 201', '2025FA', 'A'),  (9,  'CSC 121', '2026SP', 'A-'), (9,  'DAT 153', '2026FA', 'A'),
    (10, 'CSC 121', '2025FA', 'B+'), (10, 'MAT 140', '2026SP', 'B-'), (10, 'DAT 153', '2026FA', 'C+');

INSERT INTO registrar.advisors (name, department) VALUES
    ('Dr. Ortiz', 'Data Science'),
    ('Dr. Patel', 'Economics'),
    ('Dr. Nguyen', 'Biology');

SELECT 'students' AS table_name, COUNT(*) AS num_rows FROM registrar.students
UNION ALL
SELECT 'courses', COUNT(*) FROM registrar.courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM registrar.enrollments
UNION ALL
SELECT 'advisors', COUNT(*) FROM registrar.advisors;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Create a role named analyst that can't log in. Then let your own
   role switch into it, with GRANT analyst TO postgres;. Run the
   provided test. What happens, and why?
   ---------------------------------------------------------------- */

BEGIN; SET LOCAL ROLE analyst; SELECT current_user; ROLLBACK;
BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.courses; ROLLBACK;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   The analyst should be able to read courses and enrollments, and
   nothing else. Grant exactly the privileges that takes. Then run
   the provided tests. Which ones fail, and with what message?
   ---------------------------------------------------------------- */

BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.courses; ROLLBACK;
BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.students; ROLLBACK;
BEGIN; SET LOCAL ROLE analyst; DELETE FROM registrar.enrollments WHERE term = '2025FA'; ROLLBACK;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.3

   To study enrollment patterns, the analyst needs each student's
   class_year and major, and student_id to join to enrollments. The
   analyst shouldn't see names or emails. Grant SELECT on just those
   three columns of students. Then run the provided tests. Why does
   SELECT * fail, instead of just leaving out the columns the
   analyst can't see?
   ---------------------------------------------------------------- */

BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.students; ROLLBACK;

BEGIN;
SET LOCAL ROLE analyst;
SELECT s.major, COUNT(*) AS num_enrollments
FROM registrar.enrollments e
INNER JOIN registrar.students s ON s.student_id = e.student_id
GROUP BY s.major
ORDER BY num_enrollments DESC;
ROLLBACK;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Jordan, a new analyst, starts today. Create a role named jordan
   that CAN log in, with a password, and make Jordan a member of
   analyst. Then run GRANT jordan TO postgres; so you can test as
   Jordan, and run the provided tests. You never granted Jordan
   anything on a table. Why can Jordan read enrollments?
   ---------------------------------------------------------------- */

BEGIN; SET LOCAL ROLE jordan; SELECT current_user; ROLLBACK;
BEGIN; SET LOCAL ROLE jordan; SELECT course_id, term, grade FROM registrar.enrollments LIMIT 3; ROLLBACK;
BEGIN; SET LOCAL ROLE jordan; SELECT first_name FROM registrar.students; ROLLBACK;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   The setup script created an advisors table, which you haven't
   granted to anyone. Use ALTER DEFAULT PRIVILEGES so that the
   analyst can read every table you create in registrar from now on.
   Then run the provided code, which creates a terms table, and test
   both tables as the analyst. Why can the analyst read terms but
   not advisors?
   ---------------------------------------------------------------- */

CREATE TABLE registrar.terms (
    term       TEXT  PRIMARY KEY,
    starts_on  DATE  NOT NULL,
    ends_on    DATE  NOT NULL
);

INSERT INTO registrar.terms (term, starts_on, ends_on) VALUES
    ('2025FA', '2025-08-25', '2025-12-12'),
    ('2026SP', '2026-01-12', '2026-05-01'),
    ('2026FA', '2026-08-24', '2026-12-11');

BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.terms; ROLLBACK;
BEGIN; SET LOCAL ROLE analyst; SELECT * FROM registrar.advisors; ROLLBACK;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Your ETL pipeline should be able to add enrollments, but never
   read, change, or delete them. Create a role named etl_loader that
   can't log in, let postgres switch into it, and grant it only what
   adding an enrollment takes. Then run the provided tests as
   etl_loader. Which ones work?
   ---------------------------------------------------------------- */

BEGIN;
SET LOCAL ROLE etl_loader;
INSERT INTO registrar.enrollments (student_id, course_id, term)
VALUES (4, 'DAT 153', '2027SP');
ROLLBACK;

BEGIN; SET LOCAL ROLE etl_loader; SELECT * FROM registrar.enrollments; ROLLBACK;
