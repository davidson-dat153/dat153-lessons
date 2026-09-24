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

   Insert at least two doctors.
   ---------------------------------------------------------------- */



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

   Insert at least two insurance providers.
   ---------------------------------------------------------------- */



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

   Insert at least three patients, split across your two doctors,
   with at least one patient who has no insurance provider on file.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Try to insert a patient with a primary_doctor_id that does not
   exist in doctors. Confirm it fails, and read the error message
   closely enough that you could explain it to a partner.
   ---------------------------------------------------------------- */



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

   Insert at least three credentials (for example MD, DO, PhD, MPH).
   Then create a doctor_credentials table recording which doctors
   hold which credentials: a doctor can hold several credentials,
   and a credential can be held by several doctors, so this is many-
   to-many. Give doctor_credentials its own surrogate primary key
   doctor_credential_id, a doctor_id foreign key referencing
   doctors, a credential_id foreign key referencing credentials, and
   a constraint that stops the same doctor from being recorded with
   the same credential twice.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.3

   Try inserting the same (doctor_id, credential_id) pair a second
   time. What stops it, and what would have stopped it if
   doctor_credentials had used a composite primary key instead?
   ---------------------------------------------------------------- */



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
