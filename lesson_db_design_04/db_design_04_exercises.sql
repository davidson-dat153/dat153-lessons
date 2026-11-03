/* ================================================================
   DAT 153 -- Indexes and Query Plans
   Exercises from lessons/lesson_db_design_04/_lesson.qmd
   Database: university
   ================================================================ */


/* ----------------------------------------------------------------
   Part 0 -- Exercise 0.1

   Run the provided setup code. It drops the three tables if they
   already exist, so you can rerun it any time to start over, and
   then builds them: listeners, songs, and plays. It fills them with
   fabricated data using generate_series, which produces a series of
   numbers, one row per number. Every copy of this database gets
   exactly the same rows, so your row counts will match the key. The
   setup takes anywhere from 10 seconds to a minute.

   Run the provided code to check the result. You should see 100,000
   listeners, 50,000 songs, and 2,000,000 plays, and a plays table
   of about 131 MB.
   ---------------------------------------------------------------- */

DROP TABLE IF EXISTS plays, songs, listeners CASCADE;

CREATE TABLE listeners (
    listener_id   INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username      TEXT     NOT NULL UNIQUE,
    email         TEXT     NOT NULL,
    country       TEXT     NOT NULL,
    plan          TEXT     NOT NULL,
    signed_up_on  DATE     NOT NULL
);

CREATE TABLE songs (
    song_id       INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title         TEXT     NOT NULL,
    artist        TEXT     NOT NULL,
    genre         TEXT     NOT NULL,
    duration_sec  INTEGER  NOT NULL
);

CREATE TABLE plays (
    play_id         BIGINT     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    listener_id     INTEGER    NOT NULL,
    song_id         INTEGER    NOT NULL,
    played_at       TIMESTAMP  NOT NULL,
    device          TEXT       NOT NULL,
    seconds_played  INTEGER    NOT NULL
);

INSERT INTO listeners (username, email, country, plan, signed_up_on)
SELECT
    'user' || g,
    CASE WHEN g % 3 = 0 THEN 'User' || g || '@Example.com'
         ELSE 'user' || g || '@example.com' END,
    (ARRAY['US', 'US', 'US', 'US', 'CA', 'MX', 'GB', 'DE', 'BR', 'IN', 'JP', 'KR'])[1 + g % 12],
    CASE WHEN g % 4 = 0 THEN 'premium' ELSE 'free' END,
    DATE '2020-01-01' + g % 2100
FROM generate_series(1, 100000) AS g;

INSERT INTO songs (title, artist, genre, duration_sec)
SELECT
    (ARRAY['Midnight', 'Golden', 'Electric', 'Paper', 'Velvet',
           'Neon', 'Quiet', 'Wild', 'Silver', 'Broken'])[1 + g % 10]
    || ' ' ||
    (ARRAY['Highway', 'Heart', 'Summer', 'Garden', 'Signal', 'River',
           'Static', 'Echo', 'Parade', 'Satellite', 'Avenue'])[1 + g / 10 % 11]
    || (ARRAY['', ' (Live)', ' (Remix)', ' (Acoustic)', ' Pt. 2', ' (Demo)', ' (Radio Edit)',
              ' (Reprise)', ' (Extended Mix)', ' (Remastered)', ' (Slowed)', ' (Sped Up)'])[1 + g / 4400 % 12],
    (ARRAY['The Lanterns', 'Cobalt Kids', 'Juniper', 'Harbor Theory', 'Marigold',
           'DJ Fable', 'Orbit Club', 'The Static Sisters', 'Velvet Machine', 'North Fork',
           'Lil Parade', 'Ghost Collective', 'Sunday Wolves', 'Mx. Echo', 'Paper Planets',
           'The Overpass', 'Saint Avenue', 'Low Tide', 'Neon Choir', 'Wildcat Strings'])[1 + g / 110 % 20]
    || CASE WHEN g / 2200 % 2 = 1 THEN ' & Friends' ELSE '' END,
    (ARRAY['pop', 'rock', 'hip-hop', 'country', 'jazz', 'electronic', 'r&b', 'indie'])[1 + g % 8],
    120 + g % 240
FROM generate_series(1, 50000) AS g;

-- Each play's "random" values come from the md5 hash of its row number,
-- so every copy of this database gets exactly the same 2,000,000 rows.
INSERT INTO plays (listener_id, song_id, played_at, device, seconds_played)
SELECT
    1 + ('x' || substr(h, 1, 8))::bit(32)::bigint % 100000,
    1 + floor(50000 * power(('x' || substr(h, 9, 8))::bit(32)::bigint / 4294967296.0, 3))::int,
    TIMESTAMP '2026-01-01'
        + ('x' || substr(h, 17, 8))::bit(32)::bigint % (304 * 86400) * INTERVAL '1 second',
    CASE WHEN ('x' || substr(h, 25, 2))::bit(8)::int < 179 THEN 'phone'
         WHEN ('x' || substr(h, 25, 2))::bit(8)::int < 243 THEN 'laptop'
         ELSE 'smart speaker' END,
    30 + ('x' || substr(h, 27, 6))::bit(24)::int % 300
FROM generate_series(1, 2000000) AS g,
     LATERAL (SELECT md5(g::text) AS h) AS hashed;

-- Adding the foreign keys after the load checks all 2,000,000 rows at
-- once, which is much faster than checking them one row at a time.
ALTER TABLE plays
    ADD FOREIGN KEY (listener_id) REFERENCES listeners(listener_id),
    ADD FOREIGN KEY (song_id) REFERENCES songs(song_id);

-- Collect the statistics the planner uses to estimate row counts.
VACUUM ANALYZE listeners, songs, plays;

SELECT 'listeners' AS table_name, COUNT(*) AS num_rows FROM listeners
UNION ALL
SELECT 'songs', COUNT(*) FROM songs
UNION ALL
SELECT 'plays', COUNT(*) FROM plays;

SELECT pg_size_pretty(pg_relation_size('plays')) AS plays_size;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   The listener with listener_id = 4217 wants to see their listening
   history. Write a query that returns every row in plays for that
   listener, and run it with EXPLAIN ANALYZE in front of it. Then
   use the plan to answer these:

     - What kind of scan did PostgreSQL use on plays?
     - How many rows did it read and throw away to find this listener's plays?
     - What was the execution time? Write it in a comment next to your query. You'll compare against it after you add an index.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   You've been creating indexes since Database Design I without
   writing CREATE INDEX. Run the provided code, which lists every
   index on the three tables. Which constraint created each one?
   Which column of plays that you'd join on doesn't have an index?
   ---------------------------------------------------------------- */

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('listeners', 'songs', 'plays')
ORDER BY tablename, indexname;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Create an index named idx_plays_listener_id on
   plays(listener_id). Then rerun your EXPLAIN ANALYZE query from
   Exercise 1.1 and compare the two plans: the scan type, the rows
   thrown away, and the execution time. Write the new time next to
   the old one. About how many times faster is the query now?
   Finally, run the provided code to compare the size of the plays
   table with the size of your new index.
   ---------------------------------------------------------------- */

SELECT pg_size_pretty(pg_relation_size('plays'))                 AS table_size,
       pg_size_pretty(pg_relation_size('idx_plays_listener_id')) AS index_size;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Create an index named idx_plays_device on plays(device). Then run
   EXPLAIN ANALYZE on a query that returns every play from a
   'phone'. Does PostgreSQL use your new index? Run the provided
   code to see how the plays are split among devices, and use it to
   explain the planner's choice.
   ---------------------------------------------------------------- */

SELECT device, COUNT(*) AS num_plays
FROM plays
GROUP BY device;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   Create an index named idx_plays_played_at on plays(played_at).
   Then run the provided query, which counts the plays on Pi Day,
   March 14, 2026, and put EXPLAIN ANALYZE in front of it. Does it
   use the index? Rewrite the WHERE clause so that it returns the
   same count AND uses the index.
   ---------------------------------------------------------------- */

SELECT COUNT(*)
FROM plays
WHERE played_at::date = '2026-03-14';



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.1

   The record label for song 1 wants to know how many times it was
   played in March 2026. Write that query and run it with EXPLAIN
   ANALYZE. You have an index on played_at from Exercise 3.2, but
   none on song_id. How does the plan use the index you have? Then
   create a single index named idx_plays_song_id_played_at on
   plays(song_id, played_at) and run EXPLAIN ANALYZE again. What
   changed?
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.2

   Drop idx_plays_played_at, leaving idx_plays_song_id_played_at in
   place. Then run EXPLAIN ANALYZE on the two provided queries.
   Which one can still use an index? Why don't you need a separate
   index on song_id, even though you might still want one on
   played_at?
   ---------------------------------------------------------------- */

SELECT COUNT(*)
FROM plays
WHERE song_id = 40000;

SELECT COUNT(*)
FROM plays
WHERE played_at >= '2026-03-14'
  AND played_at <  '2026-03-15';



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.1

   So far, every query has looked up a few rows. Analytical queries
   are different: a report reads thousands of rows and boils them
   down to a few totals. Can an index help with that?

   The analytics team runs a weekly report: for the last week of
   October, how many plays came from each device, and how many hours
   of listening did they add up to? Run the provided report with
   EXPLAIN ANALYZE in front of it. What kind of scan does it use,
   and how many rows does it read and throw away? Write down the
   execution time.
   ---------------------------------------------------------------- */

SELECT device,
       COUNT(*) AS num_plays,
       ROUND(SUM(seconds_played) / 3600.0, 1) AS listening_hours
FROM plays
WHERE played_at >= '2026-10-25'
  AND played_at <  '2026-11-01'
GROUP BY device
ORDER BY num_plays DESC;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.2

   The report filters on played_at, so an index on played_at seems
   like the obvious fix. Recreate idx_plays_played_at, the index you
   dropped in Exercise 4.2, and run the report with EXPLAIN ANALYZE
   again. Did it get faster? Look at the Heap Blocks line, and
   explain what happened.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.3

   The report needs three columns from each play: played_at to
   filter, and device and seconds_played to group and add up. If the
   index held all three, PostgreSQL would never have to visit the
   table at all. Drop idx_plays_played_at, and create this COVERING
   INDEX in its place. Then run the report with EXPLAIN ANALYZE
   again, and run the provided code to compare the sizes of the two
   indexes.
   ---------------------------------------------------------------- */

CREATE INDEX idx_plays_played_at_covering
ON plays (played_at)
INCLUDE (device, seconds_played);



-- Run the provided code to compare the covering index with a plain
-- index on played_at. The plain index is gone, so this code builds
-- one just long enough to measure it, inside a transaction it rolls
-- back. ::: {.content-visible when-meta="key"} The plain index is
-- about 43 MB, and the covering index is about 78 MB, more than half
-- the size of the 131 MB table. The payload is the price: two extra
-- columns in every one of 2,000,000 entries. A covering index is
-- worth it for a report that runs often, and not as a habit. :::
BEGIN;

CREATE INDEX idx_plays_played_at ON plays (played_at);

SELECT pg_size_pretty(pg_relation_size('idx_plays_played_at'))          AS plain_index,
       pg_size_pretty(pg_relation_size('idx_plays_played_at_covering')) AS covering_index,
       pg_size_pretty(pg_relation_size('plays'))                        AS whole_table;

ROLLBACK;

SELECT pg_size_pretty(pg_relation_size('idx_plays_played_at_covering')) AS covering_index,
       pg_size_pretty(pg_relation_size('plays'))                        AS whole_table;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.4

   The team now wants the same report for a whole quarter, July
   through September. Change the dates in the report and run it with
   EXPLAIN ANALYZE. Then run the provided code, which runs the
   quarterly report WITHOUT the covering index, by dropping it
   inside a transaction and rolling the drop back. How much does the
   covering index help now? Why so much less than for one week?
   ---------------------------------------------------------------- */

BEGIN;

DROP INDEX idx_plays_played_at_covering;

EXPLAIN ANALYZE
SELECT device,
       COUNT(*) AS num_plays,
       ROUND(SUM(seconds_played) / 3600.0, 1) AS listening_hours
FROM plays
WHERE played_at >= '2026-07-01'
  AND played_at <  '2026-10-01'
GROUP BY device
ORDER BY num_plays DESC;

ROLLBACK;



/* ----------------------------------------------------------------
   Part 6 -- Exercise 6.1

   Create an index named idx_plays_song_id on plays(song_id). Run
   the provided code to see how many times two songs have been
   played. Then run the two provided queries for those songs with
   EXPLAIN ANALYZE in front of each, and compare the plans,
   especially the Heap Blocks lines. Both queries use the same
   index. Why does one of them read so many more pages of the table
   than the other?
   ---------------------------------------------------------------- */

SELECT song_id, COUNT(*) AS num_plays
FROM plays
WHERE song_id IN (1, 40000)
GROUP BY song_id;

SELECT * FROM plays WHERE song_id = 40000;

SELECT * FROM plays WHERE song_id = 1;



/* ----------------------------------------------------------------
   Part 6 -- Exercise 6.2

   Some listeners typed their email with capital letters. Run the
   provided query, which finds a listener by email. It returns no
   rows, even though user4218@example.com exists. Fix the query by
   comparing LOWER(email) instead. Then create an index on
   listeners(email) and check whether your fixed query uses it. If
   it doesn't, create an index that it will use.
   ---------------------------------------------------------------- */

SELECT *
FROM listeners
WHERE email = 'user4218@example.com';



/* ----------------------------------------------------------------
   Part 6 -- Exercise 6.3

   A play counts as a SKIP if the listener stopped within 40
   seconds. Skips are only about 3% of all plays, and the label only
   ever asks about skips. Create an index on plays(song_id) that
   only includes skipped plays, by adding WHERE seconds_played < 40
   to the end of CREATE INDEX. Check that the provided query uses
   it. Then compare its size with a full index on plays(song_id),
   which you created in Exercise 6.1. If you skipped 6.1, create
   that index first.
   ---------------------------------------------------------------- */

SELECT COUNT(*)
FROM plays
WHERE song_id = 1
  AND seconds_played < 40;
