/* ================================================================
   DAT 153 -- INSERT, UPDATE, DELETE, and Transactions
   Exercises from lessons/lesson_db_design_03/_lesson.qmd
   Database: university

   Part 5 uses BEGIN, COMMIT, and ROLLBACK. A transaction belongs to
   your connection, so run those statements one at a time, in order,
   in the same query window. Don't close the window or reconnect in
   the middle of a transaction.
   ================================================================ */


/* ----------------------------------------------------------------
   Part 0 -- Exercise 0.1

   Run the provided setup code. It drops whatever is left of last
   week's tables and rebuilds the doctor's office with the same
   design, so everyone starts from the same rows. This is the same
   schema you wrote in Database Design I, with both ALTER TABLE
   changes already applied and one extra patient per doctor.
   ---------------------------------------------------------------- */

DROP TABLE IF EXISTS patients_backup, offices, doctor_credentials,
    credentials, patients, insurance_providers, doctors CASCADE;

CREATE TABLE doctors (
    doctor_id               INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name              TEXT     NOT NULL,
    last_name               TEXT     NOT NULL,
    license_number          TEXT     NOT NULL UNIQUE,
    accepting_new_patients  BOOLEAN  NOT NULL DEFAULT TRUE
);

CREATE TABLE insurance_providers (
    insurance_provider_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name                   TEXT     NOT NULL UNIQUE
);

CREATE TABLE patients (
    patient_id              INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name              TEXT     NOT NULL,
    last_name               TEXT     NOT NULL,
    age                     INTEGER  CHECK (age BETWEEN 0 AND 120),
    insurance_provider_id   INTEGER  REFERENCES insurance_providers(insurance_provider_id),
    primary_doctor_id       INTEGER  REFERENCES doctors(doctor_id)
);

CREATE TABLE credentials (
    credential_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    abbreviation   TEXT     NOT NULL UNIQUE,
    description    TEXT
);

CREATE TABLE doctor_credentials (
    doctor_credential_id  INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_id             INTEGER  REFERENCES doctors(doctor_id),
    credential_id         INTEGER  REFERENCES credentials(credential_id),
    UNIQUE (doctor_id, credential_id)
);

INSERT INTO doctors (first_name, last_name, license_number) VALUES
    ('Iris',  'Okonkwo', 'MD-10234'),
    ('Priya', 'Anand',   'MD-58291');

INSERT INTO insurance_providers (name) VALUES
    ('Ceres Health Collective'),
    ('Belt Mutual');

INSERT INTO patients (first_name, last_name, age, insurance_provider_id, primary_doctor_id) VALUES
    ('Marcus',  'Webb',     34, 1,    1),
    ('Talissa', 'Grey',     61, NULL, 1),
    ('Devon',   'Achebe',   27, 2,    2),
    ('Rosa',    'Lindqvist', 72, 1,   1),
    ('Samuel',  'Oduya',    45, 2,    2);

INSERT INTO credentials (abbreviation, description) VALUES
    ('MD',  'Doctor of Medicine'),
    ('DO',  'Doctor of Osteopathic Medicine'),
    ('PhD', 'Doctor of Philosophy'),
    ('MPH', 'Master of Public Health');

INSERT INTO doctor_credentials (doctor_id, credential_id) VALUES
    (1, 1), (1, 4),
    (2, 2), (2, 3), (2, 4);

SELECT * FROM patients ORDER BY patient_id;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Dr. Tomas Reyes is joining the practice with license number
   MD-77310. Add Dr. Reyes to doctors with a single-row INSERT, and
   use RETURNING to report the new doctor_id. Don't supply a value
   for accepting_new_patients. What value did it get, and why?
   ---------------------------------------------------------------- */



-- Check your result:
SELECT * FROM doctors ORDER BY doctor_id;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Three new patients are joining Dr. Reyes. Add all three with a
   single multi-row INSERT, using the doctor_id that RETURNING
   reported in Exercise 1.1.

     first_name  last_name  age  insurance provider
     ----------  ---------  ---  ---------------------------------------------------
     Keiko       Marsh      52   Ceres Health Collective (insurance_provider_id = 1)
     Omar        Haddad     19   none
     Lena        Brandt     38   Belt Mutual (insurance_provider_id = 2)
   ---------------------------------------------------------------- */



-- Check your result:
SELECT * FROM patients ORDER BY patient_id;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.3

   Dr. Reyes holds the MD and MPH credentials. Use INSERT INTO ...
   SELECT to add both rows to doctor_credentials. Pull each
   credential_id from credentials by its abbreviation instead of
   typing the IDs yourself.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT d.first_name, d.last_name, c.abbreviation AS credential
FROM doctor_credentials dc
INNER JOIN doctors d ON d.doctor_id = dc.doctor_id
INNER JOIN credentials c ON c.credential_id = dc.credential_id
ORDER BY d.last_name, c.abbreviation;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   You're about to change patient records in Part 3. First, take a
   snapshot. Use CREATE TABLE ... AS SELECT to create a new table
   named patients_backup that holds a copy of every row in patients.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT * FROM patients_backup ORDER BY patient_id;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Run the provided code, which adds a nonsense row to
   patients_backup: it reuses patient_id = 1 and has an age of -5.
   Does it succeed? What does that tell you about what CREATE TABLE
   AS copied from patients, and what it left behind?
   ---------------------------------------------------------------- */

INSERT INTO patients_backup (patient_id, first_name, last_name, age)
VALUES (1, 'Dupe', 'Licate', -5);

SELECT * FROM patients_backup WHERE patient_id = 1;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Dr. Okonkwo is no longer accepting new patients. Update doctors
   to reflect that. Before you run the UPDATE, run a SELECT with the
   same WHERE clause to confirm it matches exactly one row.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT * FROM doctors ORDER BY doctor_id;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Dr. Reyes is taking over every one of Dr. Okonkwo's patients who
   is 60 or older. Write a single UPDATE that reassigns them. Don't
   type either doctor's doctor_id. Instead, use a subquery to look
   up each one from doctors by license number (MD-77310 for Dr.
   Reyes, MD-10234 for Dr. Okonkwo).
   ---------------------------------------------------------------- */



-- Check your result. This compares patients to the snapshot you took
-- in Part 2 and shows only the rows whose doctor changed.
SELECT p.patient_id, p.first_name, p.last_name,
       b.primary_doctor_id AS old_doctor_id,
       p.primary_doctor_id AS new_doctor_id
FROM patients p
INNER JOIN patients_backup b ON b.patient_id = p.patient_id
WHERE p.primary_doctor_id <> b.primary_doctor_id;



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.1

   Delete the nonsense row you added to patients_backup in Exercise
   2.2, and ONLY that row. Why won't WHERE patient_id = 1 do the job
   here?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.2

   Samuel Oduya is transferring to another practice. Delete Samuel's
   row from patients.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT * FROM patients ORDER BY patient_id;



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.3

   Run the provided code, which tries to delete Belt Mutual from
   insurance_providers. What stops it? What would you have to do
   first to make the delete succeed?
   ---------------------------------------------------------------- */

DELETE FROM insurance_providers
WHERE name = 'Belt Mutual';



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.1

   Dr. Anand is leaving the practice. Three things have to happen,
   and they only make sense together:

     - Every one of Dr. Anand's patients moves to Dr. Reyes.
     - Dr. Anand's rows in doctor_credentials are removed.
     - Dr. Anand's row in doctors is removed.

   Write a single transaction that does all three, in an order the
   foreign keys will allow, and commits it. What would happen if the
   DELETE FROM doctors came first?
   ---------------------------------------------------------------- */



-- Check your result. Dr. Anand should be gone, and Dr. Reyes should
-- have six patients.
SELECT d.doctor_id, d.first_name, d.last_name,
       COUNT(p.patient_id) AS num_patients
FROM doctors d
LEFT JOIN patients p ON p.primary_doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name
ORDER BY d.doctor_id;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.2

   Start a transaction and delete EVERY row in patients (no WHERE
   clause). Run SELECT COUNT(*) FROM patients; to confirm the table
   is empty. Then undo the whole thing and run the count again to
   confirm every patient is back.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 6 -- Exercise 6.1

   Run the provided code one statement at a time. The UPDATE breaks
   a CHECK constraint. What happens to the SELECT that follows it,
   even though the SELECT itself is fine? What is the only way out?
   ---------------------------------------------------------------- */

BEGIN;

UPDATE patients
SET age = age + 100
WHERE last_name = 'Webb';

SELECT * FROM patients;

ROLLBACK;
