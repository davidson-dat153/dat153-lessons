DROP TABLE IF EXISTS
    section_instructors, instructors, meetings,
    sections, courses, buildings, subjects, terms
CASCADE;

CREATE TABLE terms (
    term_code        INTEGER PRIMARY KEY,
    term_description TEXT    NOT NULL
);

CREATE TABLE subjects (
    subject_code        TEXT PRIMARY KEY,
    subject_description TEXT NOT NULL
);

CREATE TABLE buildings (
    building_code        TEXT PRIMARY KEY,
    building_description TEXT NOT NULL
);

CREATE TABLE courses (
    subject_code  TEXT NOT NULL REFERENCES subjects (subject_code),
    course_number TEXT NOT NULL,
    PRIMARY KEY (subject_code, course_number)
);

CREATE TABLE sections (
    term_code          INTEGER NOT NULL REFERENCES terms (term_code),
    crn                INTEGER NOT NULL,
    subject_code       TEXT    NOT NULL,
    course_number      TEXT    NOT NULL,
    section            TEXT    NOT NULL,
    course_title       TEXT    NOT NULL,
    credits            INTEGER NOT NULL,
    enrollment_current INTEGER NOT NULL,
    enrollment_max     INTEGER NOT NULL,
    PRIMARY KEY (term_code, crn),
    FOREIGN KEY (subject_code, course_number)
        REFERENCES courses (subject_code, course_number)
);

CREATE TABLE meetings (
    term_code      INTEGER NOT NULL,
    crn            INTEGER NOT NULL,
    meeting_number INTEGER NOT NULL,
    meeting_type   TEXT    NOT NULL,
    weekdays       TEXT,
    start_time     TIME,
    end_time       TIME,
    building_code  TEXT REFERENCES buildings (building_code),
    room           TEXT,
    PRIMARY KEY (term_code, crn, meeting_number),
    FOREIGN KEY (term_code, crn) REFERENCES sections (term_code, crn)
);

CREATE TABLE instructors (
    instructor_id         INTEGER PRIMARY KEY,
    instructor_first_name TEXT NOT NULL,
    instructor_last_name  TEXT NOT NULL,
    UNIQUE (instructor_first_name, instructor_last_name)
);

CREATE TABLE section_instructors (
    term_code     INTEGER NOT NULL,
    crn           INTEGER NOT NULL,
    instructor_id INTEGER NOT NULL REFERENCES instructors (instructor_id),
    PRIMARY KEY (term_code, crn, instructor_id),
    FOREIGN KEY (term_code, crn) REFERENCES sections (term_code, crn)
);
