/* ================================================================
   DAT 153 -- Views, Functions, and Triggers
   Exercises from lessons/lesson_db_design_05/_lesson.qmd
   Database: streaming (Exercise 0.1 creates it)
   ================================================================ */


/* ----------------------------------------------------------------
   Part 0 -- Exercise 0.1

   Connect to the STREAMING database you created on Tuesday. Every
   exercise in this lesson runs there. If you don't have a streaming
   database, connect to the postgres database first and run the
   provided code to create it, then switch your connection to
   streaming.
   ---------------------------------------------------------------- */

CREATE DATABASE streaming;



/* ----------------------------------------------------------------
   Part 0 -- Exercise 0.2

   Run the provided setup code. It rebuilds Tuesday's listeners,
   songs, and plays tables with the same 2,000,000 plays, and adds
   back the two indexes you decided were worth keeping: one on
   plays(listener_id) and one on plays(song_id, played_at). It also
   drops anything left over from a previous run of today's lesson,
   so you can rerun it any time to start over. The setup takes
   anywhere from 10 seconds to a minute.

   Run the provided code to check the result. You should see 100,000
   listeners, 50,000 songs, and 2,000,000 plays.
   ---------------------------------------------------------------- */

DROP FUNCTION IF EXISTS fn_seconds_to_minutes, fn_play_status, fn_listening_history,
    fn_lowercase_email, fn_increment_play_count CASCADE;
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

ALTER TABLE plays
    ADD FOREIGN KEY (listener_id) REFERENCES listeners(listener_id),
    ADD FOREIGN KEY (song_id) REFERENCES songs(song_id);

-- The two indexes from Tuesday that earned their place.
CREATE INDEX idx_plays_listener_id ON plays (listener_id);
CREATE INDEX idx_plays_song_id_played_at ON plays (song_id, played_at);

VACUUM ANALYZE listeners, songs, plays;

SELECT 'listeners' AS table_name, COUNT(*) AS num_rows FROM listeners
UNION ALL
SELECT 'songs', COUNT(*) FROM songs
UNION ALL
SELECT 'plays', COUNT(*) FROM plays;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.1

   Almost every screen in the app needs plays joined to their
   listener and song. Create a view named vw_play_details that joins
   plays, listeners, and songs and has these columns, in this order:
   play_id, username, title, artist, played_at, device, and
   seconds_played.
   ---------------------------------------------------------------- */



-- Check your result. It queries the view exactly the way you'd query
-- a table.
SELECT *
FROM vw_play_details
WHERE username = 'user4217'
ORDER BY played_at;



/* ----------------------------------------------------------------
   Part 1 -- Exercise 1.2

   Run the provided code, which records a new play for user4217 on
   Halloween night and queries the view. Does the new play show up?
   Why didn't you have to do anything to the view to make that
   happen?
   ---------------------------------------------------------------- */

INSERT INTO plays (listener_id, song_id, played_at, device, seconds_played)
VALUES (4217, 40000, '2026-10-31 23:59', 'laptop', 200);

SELECT *
FROM vw_play_details
WHERE username = 'user4217'
ORDER BY played_at DESC
LIMIT 3;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.1

   The label dashboard shows the ten most-played songs of each
   month. Create a view named vw_monthly_song_plays with one row per
   song per month, and these columns: month (the first day of the
   month, as a DATE), song_id, title, artist, and num_plays. Then
   run the provided dashboard query with EXPLAIN ANALYZE in front of
   it, and write down the execution time.

   TIP: date_trunc('month', played_at) rounds a timestamp down to
   midnight on the first of its month. Add ::date to turn the result
   into a DATE.
   ---------------------------------------------------------------- */

SELECT *
FROM vw_monthly_song_plays
WHERE month = '2026-10-01'
ORDER BY num_plays DESC
LIMIT 10;



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.2

   Create a materialized view named mv_monthly_song_plays with the
   same query as vw_monthly_song_plays. Run the dashboard query
   against it with EXPLAIN ANALYZE. Then create an index on the
   materialized view's (month, num_plays DESC) and run it one more
   time. Compare all three execution times.
   ---------------------------------------------------------------- */



/* ----------------------------------------------------------------
   Part 2 -- Exercise 2.3

   Song 40000 goes viral on Halloween. Run the provided code, which
   records 6,000 new plays of it, then shows the top three songs for
   October from the view and from the materialized view. Why don't
   they agree? Make the materialized view catch up, and run the
   provided query on it again.
   ---------------------------------------------------------------- */

INSERT INTO plays (listener_id, song_id, played_at, device, seconds_played)
SELECT 1 + g * 13 % 100000, 40000,
       TIMESTAMP '2026-10-31' + g * INTERVAL '10 seconds', 'phone', 200
FROM generate_series(1, 6000) AS g;

SELECT *
FROM vw_monthly_song_plays
WHERE month = '2026-10-01'
ORDER BY num_plays DESC
LIMIT 3;

SELECT *
FROM mv_monthly_song_plays
WHERE month = '2026-10-01'
ORDER BY num_plays DESC
LIMIT 3;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.1

   Song lengths are stored in seconds, and the app shows them in
   minutes. Write a SQL-language function named
   fn_seconds_to_minutes that takes a number of seconds (INTEGER)
   and returns the number of minutes as a NUMERIC, rounded to one
   decimal place, so that 280 seconds becomes 4.7. Then run the
   provided code to test it.

   TIP: / between two integers drops the remainder, so 280 / 60 is
   4, not 4.666.... ROUND(x, 1) rounds x to one decimal place.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT title, artist, duration_sec,
       fn_seconds_to_minutes(duration_sec) AS duration_min
FROM songs
WHERE song_id IN (1, 40000);



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.2

   The label wants to know how listeners respond to each song. Write
   a PL/pgSQL function named fn_play_status that takes
   seconds_played and duration_sec (both INTEGER) and returns TEXT:

     - 'skipped' if the listener stopped in under 40 seconds
     - 'finished' if they listened for at least the length of the song
     - 'partial' otherwise

   Use IF, ELSIF, and ELSE. Then run the provided code, which uses
   your function to break down song 1's plays.
   ---------------------------------------------------------------- */



-- Check your result:
SELECT fn_play_status(p.seconds_played, s.duration_sec) AS status,
       COUNT(*) AS num_plays
FROM plays p
INNER JOIN songs s ON s.song_id = p.song_id
WHERE s.song_id = 1
GROUP BY status
ORDER BY status;



/* ----------------------------------------------------------------
   Part 3 -- Exercise 3.3

   In Part 1, vw_play_details showed every listener's plays at once,
   and you had to add WHERE username = ... each time you wanted one
   listener. A view can't take a parameter, but a TABLE FUNCTION
   can. Write a SQL-language table function named
   fn_listening_history that takes a username (TEXT) and returns
   that listener's plays as rows with four columns: title, artist,
   played_at, and seconds_played. Name the parameter p_username.
   Then run the provided code to test it.

   TIP: A table function says RETURNS TABLE (column TYPE, ...)
   instead of RETURNS a single type. Its body is a query whose
   columns match that list, in order.
   ---------------------------------------------------------------- */



-- Check your result. The function's rows work like a table's: you can
-- filter them, sort them, and count them.
SELECT *
FROM fn_listening_history('user4217')
ORDER BY played_at DESC
LIMIT 5;

SELECT COUNT(*) AS num_plays,
       SUM(seconds_played) AS total_seconds
FROM fn_listening_history('user4217');



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.1

   On Tuesday, mixed-case emails meant that looking up a listener
   needed LOWER(email) and an expression index. A trigger can fix
   the problem at the source. Write a trigger function named
   fn_lowercase_email that sets NEW.email to its lowercase version
   and returns NEW. Attach it to listeners with a trigger named
   tg_listeners_lowercase_email that runs BEFORE INSERT OR UPDATE,
   FOR EACH ROW. Then run the provided code to test it.
   ---------------------------------------------------------------- */



-- Check your result. The email should come back in lowercase.
INSERT INTO listeners (username, email, country, plan, signed_up_on)
VALUES ('davidson_dj', 'DJ.Wildcat@Davidson.EDU', 'US', 'free', '2026-11-05');

SELECT username, email
FROM listeners
WHERE username = 'davidson_dj';



/* ----------------------------------------------------------------
   Part 4 -- Exercise 4.2

   The app shows a play count next to every song, and counting
   2,000,000 plays on every page load is too slow. Run the provided
   code, which adds a play_count column to songs and fills it in.
   Then write a trigger function named fn_increment_play_count that
   adds 1 to a song's play_count and attach it to plays with a
   trigger named tg_plays_increment_play_count that runs FOR EACH
   ROW on every insert. Should it run BEFORE or AFTER the insert?
   Test it by recording one play of song 40000 and checking its
   count before and after.
   ---------------------------------------------------------------- */

ALTER TABLE songs
ADD COLUMN play_count INTEGER NOT NULL DEFAULT 0;

UPDATE songs s
SET play_count = c.num_plays
FROM (
    SELECT song_id, COUNT(*) AS num_plays
    FROM plays
    GROUP BY song_id
) AS c
WHERE c.song_id = s.song_id;



/* ----------------------------------------------------------------
   Part 5 -- Exercise 5.1

   A plain REFRESH MATERIALIZED VIEW blocks anyone from reading the
   materialized view until the refresh finishes. Try REFRESH
   MATERIALIZED VIEW CONCURRENTLY mv_monthly_song_plays;. What does
   PostgreSQL need first? Give it that, and refresh again.
   ---------------------------------------------------------------- */
