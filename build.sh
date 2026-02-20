#!/bin/bash
# Build script: generates index.html (latest briefing) and archive/index.html
set -e
cd "$(dirname "$0")"

mkdir -p archive

# Find the latest briefing
LATEST=$(ls archive/????-??-??.html 2>/dev/null | sort -r | head -1)
if [ -z "$LATEST" ]; then
  echo "No briefings found in archive/"
  exit 1
fi

LATEST_DATE=$(basename "$LATEST" .html)

# --- Generate index.html (latest briefing with nav) ---
# Extract the content between <body> and </body>, inject nav
python3 -c "
import re, glob, os

# Read latest briefing
with open('$LATEST') as f:
    html = f.read()

# Inject nav bar after <body> tag
nav = '''<div style=\"background:#2563eb;padding:0.6rem 1.5rem;margin:-2rem -2rem 2rem -2rem;text-align:center;\">
  <span style=\"color:white;font-weight:600;\">🧱 Clay\\'s Daily Briefing</span>
  <span style=\"float:right;\"><a href=\"archive/\" style=\"color:#dbeafe;text-decoration:none;\">📚 Archive</a></span>
</div>'''

# Insert nav inside container div
html = html.replace('<div class=\"container\">', '<div class=\"container\">' + nav, 1)

with open('index.html', 'w') as f:
    f.write(html)

# --- Generate archive/index.html ---
files = sorted(glob.glob('archive/????-??-??.html'), reverse=True)
rows = ''
for fp in files:
    date = os.path.basename(fp).replace('.html','')
    from datetime import datetime
    dt = datetime.strptime(date, '%Y-%m-%d')
    nice = dt.strftime('%A, %B %-d, %Y')
    rows += f'<li style=\"margin:0.5em 0;\"><a href=\"{date}.html\">{nice}</a></li>\n'

archive_html = f'''<!DOCTYPE html>
<html lang=\"en\">
<head>
<meta charset=\"UTF-8\">
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
<title>Briefing Archive</title>
<style>
  * {{ margin: 0; padding: 0; box-sizing: border-box; }}
  body {{
    background: #f8f9fa; color: #222;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.7; padding: 2rem;
  }}
  .container {{ max-width: 48rem; margin: 0 auto; }}
  a {{ color: #2563eb; }}
  ul {{ list-style: none; padding: 0; }}
</style>
</head>
<body>
<div class=\"container\">
<div style=\"background:#2563eb;padding:0.6rem 1.5rem;margin:-2rem -2rem 2rem -2rem;text-align:center;\">
  <span style=\"color:white;font-weight:600;\">🧱 Clay\\'s Daily Briefing</span>
  <span style=\"float:right;\"><a href=\"../\" style=\"color:#dbeafe;text-decoration:none;\">← Latest</a></span>
</div>
<h1 style=\"font-size:1.8rem;margin:1rem 0;\">📚 Briefing Archive</h1>
<ul>
{rows}
</ul>
</div>
</body>
</html>'''

with open('archive/index.html', 'w') as f:
    f.write(archive_html)

print(f'Built: index.html (latest: $LATEST_DATE), archive with {len(files)} briefings')
"
