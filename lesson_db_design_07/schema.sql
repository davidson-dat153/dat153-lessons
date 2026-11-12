-- SQL Injection lab: the library catalog's database.
-- Run it with: psql -d sqli_lab -f schema.sql
-- Running it again resets every table to its starting rows.

-- The functions you write in Parts 5 and 6, from a previous run
DROP FUNCTION IF EXISTS search_books, log_in, search_books_sorted;

DROP TABLE IF EXISTS staff_notes, members, books;

-- The table the catalog's search box is meant to show
CREATE TABLE books (
    id      INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title   TEXT     NOT NULL,
    author  TEXT     NOT NULL,
    year    INTEGER,
    genre   TEXT
);

INSERT INTO books (title, author, year, genre) VALUES
    ('The Great Gatsby',                       'F. Scott Fitzgerald',    1925, 'Fiction'),
    ('To Kill a Mockingbird',                  'Harper Lee',             1960, 'Fiction'),
    ('1984',                                   'George Orwell',          1949, 'Science Fiction'),
    ('Brave New World',                        'Aldous Huxley',          1932, 'Science Fiction'),
    ('The Catcher in the Rye',                 'J.D. Salinger',          1951, 'Fiction'),
    ('Pride and Prejudice',                    'Jane Austen',            1813, 'Romance'),
    ('The Lord of the Rings',                  'J.R.R. Tolkien',         1954, 'Fantasy'),
    ('Dune',                                   'Frank Herbert',          1965, 'Science Fiction'),
    ('The Hitchhiker''s Guide to the Galaxy',  'Douglas Adams',          1979, 'Science Fiction'),
    ('Crime and Punishment',                   'Fyodor Dostoevsky',      1866, 'Fiction'),
    ('One Hundred Years of Solitude',          'Gabriel Garcia Marquez', 1967, 'Fiction'),
    ('Moby Dick',                              'Herman Melville',        1851, 'Adventure'),
    ('A Brief History of Time',                'Stephen Hawking',        1988, 'Science'),
    ('Sapiens: A Brief History of Humankind',  'Yuval Noah Harari',      2011, 'History'),
    ('The Origin of Species',                  'Charles Darwin',         1859, 'Science'),
    ('Hamlet',                                 'William Shakespeare',    1603, 'Drama'),
    ('Frankenstein',                           'Mary Shelley',           1818, 'Horror'),
    ('The Picture of Dorian Gray',             'Oscar Wilde',            1890, 'Fiction'),
    ('Jane Eyre',                              'Charlotte Bronte',       1847, 'Romance'),
    ('Adventures of Huckleberry Finn',         'Mark Twain',             1884, 'Adventure'),
    ('The Count of Monte Cristo',              'Alexandre Dumas',        1844, 'Adventure'),
    ('Anna Karenina',                          'Leo Tolstoy',            1877, 'Fiction'),
    ('Thinking, Fast and Slow',                'Daniel Kahneman',        2011, 'Psychology'),
    ('The Alchemist',                          'Paulo Coelho',           1988, 'Fiction'),
    ('Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling',           1997, 'Fantasy'),
    ('Don Quixote',                            'Miguel de Cervantes',    1605, 'Fiction'),
    ('Les Miserables',                         'Victor Hugo',            1862, 'Historical Fiction'),
    ('War and Peace',                          'Leo Tolstoy',            1869, 'Historical Fiction'),
    ('The Shining',                            'Stephen King',           1977, 'Horror'),
    ('The Odyssey',                            'Homer',                   800, 'Epic');

-- Member accounts. The passwords are stored as plain text on purpose, so
-- you can see what an attacker gets. Never store passwords this way.
CREATE TABLE members (
    id                INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username          TEXT     NOT NULL UNIQUE,
    password          TEXT     NOT NULL,
    email             TEXT,
    membership_level  TEXT     NOT NULL
);

INSERT INTO members (username, password, email, membership_level) VALUES
    ('admin',    'P@ssw0rd1!',  'admin@library.davidson.edu', 'Admin'),
    ('jsmith',   'password123', 'jsmith@davidson.edu',        'Faculty'),
    ('mwilson',  'iloveyou',    'mwilson@davidson.edu',       'Faculty'),
    ('sgarcia',  'qwerty',      'sgarcia@davidson.edu',       'Student'),
    ('rlee',     'monkey123',   'rlee@davidson.edu',          'Student'),
    ('tmorris',  'letmein',     'tmorris@davidson.edu',       'Student'),
    ('adavis',   '12345678',    'adavis@davidson.edu',        'Student'),
    ('cjohnson', 'dragon99',    'cjohnson@davidson.edu',      'Student');

-- Notes for library staff only
CREATE TABLE staff_notes (
    id          INTEGER    GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author      TEXT       NOT NULL,
    note        TEXT       NOT NULL,
    created_at  TIMESTAMP  NOT NULL
);

INSERT INTO staff_notes (author, note, created_at) VALUES
    ('admin',
     'Reminder: system admin credentials are the same as your library portal login. Do not share.',
     '2026-01-15 09:00:00'),
    ('jsmith',
     'TODO: migrate legacy patron records from the backup server. Use db_admin / L1brary2026! to connect.',
     '2026-03-20 14:30:00'),
    ('admin',
     'Flag{un10n_b4s3d_sql1_ftw} Congratulations! You found the hidden staff note with SQL injection.',
     '2026-06-01 08:00:00');
