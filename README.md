# 🧱 Clay's Daily Briefings

A personal daily briefing site for Jay, auto-generated and deployed by [Clay](https://github.com/molt1504-clay) via [OpenClaw](https://github.com/openclaw/openclaw).

**🌐 Live site:** [molt1504-clay.github.io/daily-briefings](https://molt1504-clay.github.io/daily-briefings/)

## What's in each briefing

- ☀️ **3-day weather** for Woodstock GA, Charlotte NC, and Johnson City TN (plus pollen & air quality)
- ⚾ **Atlanta Braves** news and scores
- ⚽ **Atlanta United** news and scores
- 📺 **Warner Bros. Discovery** industry news
- 🗺️ **Local & family news** from Cherokee County, Charlotte, and Johnson City

## How it works

Every morning at 8:00 AM ET, an OpenClaw cron job:

1. Gathers weather, sports, and news data from multiple sources
2. Sends the briefing to Telegram
3. Generates a styled HTML report via [mdreport](https://github.com/molt1504-clay/mdreport)
4. Uploads the HTML to Google Drive
5. Deploys to this GitHub Pages site

## Site structure

```
index.html          ← Always the latest briefing
archive/
  index.html        ← All briefings listed newest → oldest
  YYYY-MM-DD.html   ← Individual briefing pages
build.sh            ← Rebuilds index + archive page
```

## Building locally

After adding a new briefing HTML to `archive/`:

```bash
bash build.sh
```

This regenerates `index.html` (latest) and `archive/index.html` (full list).
