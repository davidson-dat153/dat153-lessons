/* ================================================================
   DAT 153 -- DDL, Keys, and Constraints
   Exercises from lessons/lesson_db_design_01/_lesson.qmd
   Database: university
   ================================================================ */


/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Create a doctors table with a surrogate primary key doctor_id,
   separate first_name and last_name columns (both required), and a
   license_number that is required and unique.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Run the provided code to add two doctors, then check the result.
   ---------------------------------------------------------------- */

INSERT INTO doctors (first_name, last_name, license_number) VALUES
    ('Iris',  'Okonkwo', 'MD-10234'),
    ('Priya', 'Anand',   'MD-58291');

SELECT * FROM doctors ORDER BY doctor_id;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   Create an insurance_providers table with a surrogate primary key
   insurance_provider_id and a required, unique name.

   An insurance provider's name is exactly the kind of value that
   shouldn't be typed directly into a patients row: the same
   provider name would end up copy-pasted (or worse, misspelled
   slightly differently) across every patient who uses it. Giving it
   its own table with its own primary key means every patient
   references ONE correctly-spelled row instead of repeating the
   text.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Run the provided code to add two insurance providers, then check
   the result.
   ---------------------------------------------------------------- */

INSERT INTO insurance_providers (name) VALUES
    ('Ceres Health Collective'),
    ('Belt Mutual');

SELECT * FROM insurance_providers ORDER BY insurance_provider_id;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.3

   Create a patients table with a surrogate primary key patient_id,
   separate first_name and last_name columns (both required), an age
   that must be a non-negative integer, an insurance_provider_id
   foreign key referencing insurance_providers, and a
   primary_doctor_id foreign key referencing doctors.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.4

   Run the provided code to add three patients, then check the
   result. Notice that Talissa Grey has no insurance provider on
   file.
   ---------------------------------------------------------------- */

INSERT INTO patients (first_name, last_name, age, insurance_provider_id, primary_doctor_id) VALUES
    ('Marcus',  'Webb',    34, 1,    1),
    ('Talissa', 'Grey',    61, NULL, 1),
    ('Devon',   'Achebe',  27, 2,    2);

SELECT * FROM patients ORDER BY patient_id;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Run the provided code, which tries to add a patient whose
   primary_doctor_id does not exist in doctors. Confirm it fails,
   and read the error message closely enough that you could explain
   it to a partner.
   ---------------------------------------------------------------- */

INSERT INTO patients (first_name, last_name, primary_doctor_id)
    VALUES ('No', 'Body', 999);



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.1

   Add an accepting_new_patients column to doctors.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.2

   Add a CHECK constraint to patients requiring age to be between 0
   and 120.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.1

   The bridge table in the video (mission_assignments) used a
   composite primary key: PRIMARY KEY (crew_id, mission_id). That's
   one valid way to build a bridge table, but it's not the only way,
   and it's not what we'll use going forward in this course. A
   stand-alone (surrogate) primary key keeps every table in this
   database following the same simple rule: one surrogate ID column,
   always. You still need SOMETHING to stop the same pairing from
   being inserted twice; that job just moves to a UNIQUE constraint
   instead of the primary key.

   Create a credentials table with a surrogate primary key
   credential_id, a required and unique abbreviation, and an
   optional description.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.2

   Run the provided code to add four credentials, then check the
   result.
   ---------------------------------------------------------------- */

INSERT INTO credentials (abbreviation, description) VALUES
    ('MD',  'Doctor of Medicine'),
    ('DO',  'Doctor of Osteopathic Medicine'),
    ('PhD', 'Doctor of Philosophy'),
    ('MPH', 'Master of Public Health');

SELECT * FROM credentials ORDER BY credential_id;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.3

   Create a doctor_credentials table recording which doctors hold
   which credentials. A doctor can hold several credentials, and a
   credential can be held by several doctors, so this is many-to-
   many. Give doctor_credentials its own surrogate primary key
   doctor_credential_id, a doctor_id foreign key referencing
   doctors, a credential_id foreign key referencing credentials, and
   a constraint that stops the same doctor from being recorded with
   the same credential twice.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.4

   Run the provided code to record which doctors hold which
   credentials, then check the result. Which doctor holds the most
   credentials? Which credential is held by more than one doctor?
   ---------------------------------------------------------------- */

INSERT INTO doctor_credentials (doctor_id, credential_id) VALUES
    (1, 1), (1, 4),
    (2, 2), (2, 3), (2, 4);

SELECT d.first_name, d.last_name, c.abbreviation AS credential
FROM doctor_credentials dc
INNER JOIN doctors d ON d.doctor_id = dc.doctor_id
INNER JOIN credentials c ON c.credential_id = dc.credential_id
ORDER BY d.last_name, c.abbreviation;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.5

   Run the provided code, which tries to record the same (doctor_id,
   credential_id) pair a second time. What stops it, and what would
   have stopped it if doctor_credentials had used a composite
   primary key instead?
   ---------------------------------------------------------------- */

INSERT INTO doctor_credentials (doctor_id, credential_id) VALUES (1, 1);



/* ----------------------------------------------------------------
   Part 6 -- Exercise 6.1

   Add an offices table with a one-to-one relationship to doctors:
   one office per doctor, one doctor per office. What constraint
   enforces "at most one" on the foreign key side of a one-to-one
   relationship, beyond just declaring it a foreign key?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 7 -- Exercise 7.1

   Try DROP TABLE doctors; and observe what happens. Then use the
   correct option to actually remove it, and explain in one sentence
   what that option did that a plain DROP TABLE did not.
   ---------------------------------------------------------------- */
