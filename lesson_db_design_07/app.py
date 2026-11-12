"""Davidson Library Catalog: a deliberately vulnerable web application.

FOR CLASSROOM USE ONLY. This app builds SQL by pasting what users type into
a string, so it is open to SQL injection on purpose. Never deploy it, and
never point it at a database that matters.

Run it from this folder, after building sqli_lab with schema.sql:

    set -a; source ../../.env; set +a
    /opt/conda/envs/DAT153-shared/bin/python app.py

(The full path is the course's shared Python environment. A plain `python`
in the terminal doesn't have the database libraries this app needs.)

It prints a link. Open it in your browser. Press Ctrl+C here to stop it.
The terminal doubles as the server's log: every query the app runs is
printed here, the way a developer would see it (an attacker wouldn't).
"""

import getpass
import html
import os
import secrets
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlsplit

from sqlalchemy import URL, create_engine, text

# Your database credentials come from .env. Loading it in the terminal first
# (set -a; source ../../.env; set +a) is enough; python-dotenv, if it's
# installed, also finds .env on its own.
try:
    from dotenv import find_dotenv, load_dotenv
    load_dotenv(find_dotenv(usecwd=True))
except ImportError:
    pass

if "PGUSER" not in os.environ:
    raise SystemExit("No database credentials found. Run this first, then try again:\n\n"
                     "    set -a; source ../../.env; set +a\n")

engine = create_engine(URL.create(
    "postgresql+psycopg2",
    username=os.environ["PGUSER"],
    password=os.environ["PGPASSWORD"],
    host=os.environ["PGHOST"],
    port=int(os.environ["PGPORT"]),
    database="sqli_lab",
))


# ---------------------------------------------------------------------------
# Database code
# ---------------------------------------------------------------------------

def run_query(sql, params=None):
    """Run sql and return (columns, rows, error). One of rows or error is None."""
    print(f"[sql] {sql}" + (f"   params={params}" if params else ""), flush=True)
    try:
        with engine.begin() as conn:
            result = conn.execute(text(sql), params or {})
            if not result.returns_rows:
                return [], [], None
            return list(result.keys()), result.fetchall(), None
    except Exception as e:
        return None, None, str(getattr(e, "orig", e)).strip()


def search_books(term, sort="title"):
    """Search the catalog by title."""
    # VULNERABLE: term and sort are pasted straight into the SQL.
    sql = (f"SELECT id, title, author, year, genre FROM books "
           f"WHERE title ILIKE '%{term}%' ORDER BY {sort}")
    return run_query(sql)


def log_in(username, password):
    """Check a username and password. Returns (columns, rows, error)."""
    # VULNERABLE: username and password are pasted straight into the SQL.
    sql = (f"SELECT username, membership_level FROM members "
           f"WHERE username = '{username}' AND password = '{password}'")
    return run_query(sql)


# ---------------------------------------------------------------------------
# Web pages
# ---------------------------------------------------------------------------

STYLE = """
body { font-family: system-ui, sans-serif; margin: 0; background: #f6f4f1; color: #1d1d1f; }
header { background: #d42121; color: white; padding: 18px 32px; display: flex;
         align-items: baseline; gap: 28px; }
header h1 { margin: 0; font-size: 1.5rem; font-family: Georgia, serif; }
header a { color: white; }
main { max-width: 960px; margin: 28px auto; padding: 0 24px; }
form { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; margin-bottom: 20px; }
input, select, button { font-size: 1rem; padding: 8px 10px; border: 1px solid #bbb; border-radius: 6px; }
input[type=text], input[type=password] { min-width: 320px; }
button { background: #d42121; color: white; border: none; cursor: pointer; }
table { border-collapse: collapse; width: 100%; background: white; }
th, td { text-align: left; padding: 8px 10px; border-bottom: 1px solid #e3e0dc; }
th { background: #efebe6; }
.error { background: #fdecea; border: 1px solid #f5c2bd; color: #8a1c13; padding: 12px;
         border-radius: 6px; white-space: pre-wrap; font-family: monospace; }
.ok { background: #e8f5e9; border: 1px solid #b7dfba; padding: 12px; border-radius: 6px; }
.muted { color: #666; }
"""


def page(title, body):
    return f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>{title}</title>
<style>{STYLE}</style></head>
<body>
<header><h1>Davidson Library Catalog</h1>
<nav><a href="./">Search</a> &nbsp; <a href="login">Member log-in</a></nav></header>
<main>{body}</main>
</body></html>"""


def results_html(columns, rows, error):
    if error is not None:
        return f'<div class="error">Database error: {html.escape(error)}</div>'
    if not columns:
        return '<p class="muted">The query ran and returned no rows.</p>'
    head = "".join(f"<th>{html.escape(str(c))}</th>" for c in columns)
    body = "".join(
        "<tr>" + "".join(f"<td>{html.escape('' if v is None else str(v))}</td>" for v in row) + "</tr>"
        for row in rows)
    return (f'<p class="muted">{len(rows)} result{"" if len(rows) == 1 else "s"}</p>'
            f"<table><tr>{head}</tr>{body}</table>")


def search_page(query):
    q = query.get("q", [None])[0]
    sort = query.get("sort", ["title"])[0]
    options = "".join(
        f'<option value="{c}"{" selected" if c == sort else ""}>{c.capitalize()}</option>'
        for c in ("title", "author", "year"))
    body = f"""
<h2>Search the catalog</h2>
<form method="get" action="">
  <input type="text" name="q" placeholder="Search by title" value="{html.escape(q or '')}">
  <label>Sort by <select name="sort">{options}</select></label>
  <button type="submit">Search</button>
</form>"""
    if q is not None:
        body += results_html(*search_books(q, sort))
    return page("Search", body)


def login_page(form=None):
    body = """
<h2>Member log-in</h2>
<form method="post" action="login">
  <input type="text" name="username" placeholder="Username">
  <input type="password" name="password" placeholder="Password">
  <button type="submit">Log in</button>
</form>"""
    if form is not None:
        username = form.get("username", [""])[0]
        password = form.get("password", [""])[0]
        columns, rows, error = log_in(username, password)
        if error is not None:
            body += results_html(columns, rows, error)
        elif rows:
            user = dict(zip(columns, rows[0]))
            body += (f'<div class="ok">Welcome, <b>{html.escape(str(user.get("username")))}</b>! '
                     f'Membership level: <b>{html.escape(str(user.get("membership_level")))}</b></div>')
        else:
            body += '<div class="error">Log-in failed: wrong username or password.</div>'
    return page("Log in", body)


# ---------------------------------------------------------------------------
# Web server
# ---------------------------------------------------------------------------

# Every page lives under a random token, so nobody else on the shared
# JupyterHub server can open your copy of the app.
TOKEN = secrets.token_urlsafe(8)


class Handler(BaseHTTPRequestHandler):
    def _route(self):
        parts = urlsplit(self.path)
        prefix = f"/{TOKEN}/"
        if parts.path == f"/{TOKEN}":
            return "redirect", parts
        if not parts.path.startswith(prefix):
            return None, parts
        return parts.path[len(prefix):], parts

    def _send(self, status, content="", location=None):
        data = content.encode("utf-8")
        self.send_response(status)
        if location:
            self.send_header("Location", location)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        route, parts = self._route()
        if route == "redirect":
            self._send(302, location=f"{TOKEN}/")
        elif route == "":
            self._send(200, search_page(parse_qs(parts.query, keep_blank_values=True)))
        elif route == "login":
            self._send(200, login_page())
        else:
            self._send(404, "Not found")

    def do_POST(self):
        route, _ = self._route()
        if route != "login":
            self._send(404, "Not found")
            return
        length = int(self.headers.get("Content-Length", 0))
        form = parse_qs(self.rfile.read(length).decode("utf-8"), keep_blank_values=True)
        self._send(200, login_page(form))

    def log_message(self, fmt, *args):
        pass  # keep the terminal for the [sql] log


def main():
    server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)  # port 0: any free port
    port = server.server_address[1]
    hub = os.environ.get("JUPYTERHUB_PUBLIC_URL", "https://dat153.jupyter.davidson.edu").rstrip("/")
    prefix = os.environ.get("JUPYTERHUB_SERVICE_PREFIX", f"/user/{getpass.getuser()}/")
    print("Davidson Library Catalog is running. Open:\n")
    print(f"    {hub}{prefix}proxy/{port}/{TOKEN}/\n")
    print("Press Ctrl+C to stop. Each query the app runs is logged below.\n", flush=True)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
