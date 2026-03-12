# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Utime** is a Chrome extension (Manifest V3) that converts UNIX timestamps to human-readable dates and vice versa. It supports conversion via popup UI, omnibox (`ut` keyword), and right-click context menu on selected text.

## Build Commands

```bash
npm install                # Install dev dependencies (Grunt and plugins)
npx grunt                  # Production build: uglify JS, concat with libs, compile LESS
npx grunt watch            # Dev mode: watch JS and LESS files, rebuild on change
npx grunt css              # Build CSS only
npx grunt js               # Build JS only
npx grunt zip              # Package extension into releases/utime-v{version}.zip
```

The build uses Grunt. There are no tests or linting configured.

## Architecture

### Chrome Extension Structure (Manifest V3)

- **`manifest.json`** — Extension manifest. Service worker is `dist/utime-background.js`, popup is `popup.html`.
- **`popup.html`** — Main popup UI, loads jQuery, date.js lib, and `dist/utime-popup.js` + `dist/utime.css`.
- **`offscreen.html`** — Offscreen document used solely for clipboard write operations (required by MV3).

### Source Files (`js/`)

- **`utime.js`** — Core `Utime` class. Handles timestamp↔date conversion, options management via `chrome.storage.local`, and timezone offset logic. Uses the `Date.js` library for date parsing/formatting.
- **`popup.js`** — Popup UI controller. Manages "input groups" (pairs of inputs for bidirectional conversion), options form, keyboard shortcuts, and navigation between app/options/help views. Uses jQuery for DOM manipulation.
- **`background.js`** — Service worker. Initializes context menu, omnibox handlers, and notification system. Converts selected text or omnibox input and shows results via `chrome.notifications`. Delegates clipboard writes to offscreen document via message passing.
- **`offscreen.js`** — Receives `copy-data-to-clipboard` messages and writes to clipboard using `document.execCommand('copy')`.

### Build Output (`dist/`)

Grunt concatenates and minifies source files with vendored libraries:
- `dist/utime-popup.js` = `libs/jquery.js` + `libs/date.js` + `js/utime.js` + `js/popup.js`
- `dist/utime-background.js` = `libs/date.js` + `js/utime.js` + `js/background.js`
- `dist/offscreen.js` = `js/offscreen.js`
- `dist/utime.css` = compiled from `less/utime.less`

### Key Patterns

- **Options** are stored as JSON string in `chrome.storage.local` under key `"options"`. The `Utime` class manages loading/saving.
- **Input groups** (popup state) are persisted in `chrome.storage.local` under key `"inputGroups"`.
- **Inter-context messaging** uses `chrome.runtime.sendMessage` with `target` and `type` fields to route messages between popup → background and background → offscreen document.
- **Input modes**: `auto` (detect input type), `timestamp-date`, or `date-timestamp` — controls which conversion direction each input field uses.
