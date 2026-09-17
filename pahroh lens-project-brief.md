# Pharoh-Lens — Project Brief (for AI assistants)

This file gives an AI model the context it needs to help with this project without re-explaining it every time. Paste or upload it at the start of a new chat.

**Instructions for the AI reading this:** treat every decision below as already made unless it appears under "Open questions." Don't re-propose alternatives to settled decisions unless asked; do push back if a new request conflicts with what's here.

---

## Project overview

**Working name:** Pharoh-Lense

**What it is:** A mobile app that scans images of ancient Egyptian statues, reliefs, and museum plaques and returns historical information about them — built for use during an actual Egypt trip or museum visit, not just a reference app.

**Core loop:** point camera at an artifact → app identifies it → shows structured info (era, dynasty, location, history, audio guide) → user optionally adds it to a trip log or links it to a reservation.

**Who it's for:** travelers and museum visitors in Egypt who want on-the-spot context for what they're looking at, plus a way to track what they've seen and what's booked.

**Builder context:**
- Marwan, Computer Science undergraduate at Misr University for Science and Technology (MUST), Giza, Egypt, expected graduation 2027.
- Mobile Application Developer at Route; Cross Platform Mobile App Developer intern at the Digital Egypt Pioneers Initiative (DEPI).
- Builds in Flutter/Dart and native Android (Kotlin) — this is the default assumption for any implementation discussion unless stated otherwise.

---

## Features and screens

Nine screens, designed as a UI mockup already:

1. **Splash** — logo moment only.
2. **Onboarding** — 3-slide intro to the scan-first concept.
3. **Login** — email/password + social sign-in.
4. **Scanner** — full-screen camera view with a corner-bracket viewfinder; core feature of the app.
5. **Artifact info** — result screen after a scan: era/dynasty tags, title, location, tabbed overview/history/location, optional audio guide, "add to my trip" action.
6. **Trip tracker** — day-by-day itinerary view with a discovery-progress ring (e.g. "14 of 41 artifacts logged") and a timeline of sites per day.
7. **Reservations** — upcoming/past museum tickets and guided tours, shown as ticket cards with a QR code.
8. **Home** — greeting, primary "scan an artifact" call to action, recently viewed artifacts, nearby sites.
9. **Profile** — stats (artifacts discovered, sites visited), badges, account settings.

**Navigation:** Home, Trip tracker, Reservations, and Profile sit under one bottom tab bar with Scanner raised in the center. Onboarding, Login, and the Artifact info detail screen hide the tab bar.

**Open product question flagged during design:** Trip tracker and Reservations may be redundant as two separate tabs — a reservation is arguably just a future trip-tracker event. Not yet resolved; see "Open questions" below.

---

## Tech stack and data pipeline

**Client stack:** Flutter/Dart (cross-platform), native Android in Kotlin where needed.

**Primary data source:** The Met Museum Open Access API — chosen for free access, no API key requirement, and metadata depth (title, date, dynasty, period, medium, description, image URLs).

**Data pipeline decisions made so far:**
- Collect the full Egyptian Art department dataset from the Met (~30,000 objects, Department ID 10) rather than limiting to statues only.
- Pipeline: download the bulk `MetObjects.csv` from `https://github.com/metmuseum/openaccess`, filter for `Department == "Egyptian Art"`, then call the API per Object ID for image URLs and extended descriptions (base URL: `https://collectionapi.metmuseum.org/public/collection/v1`).
- Save incrementally to JSON or SQLite to avoid data loss during the long collection process; rate-limit to stay within the 80 req/sec API cap.
- A Python script to automate this pipeline was drafted; not yet confirmed as fully run.

**Supplementary datasets under consideration** (not yet integrated):
- Roboflow Ancient Egyptian Landmarks dataset
- Karnak Cachette Database
- British Museum collection
- EGYPT-v1 benchmark dataset

**Not yet built:** the actual image-scanning/matching layer that takes a photo and matches it against the collected dataset. This is the hardest unsolved part of the project — everything else (UI, trip tracker, reservations) assumes this exists.

---

## Open questions — not yet decided

Don't assume answers to these; ask or flag trade-offs instead of picking one silently.

- **Recognition approach:** real on-device/API visual recognition against the Met dataset vs. a simpler QR/plaque-code scan for a first version. This is the single biggest scope decision in the project.
- **Storage format** for the collected artifact dataset: JSON vs. SQLite.
- **Trip tracker vs. Reservations:** whether these should stay as two separate tabs or merge into one "Journey" flow.
- **Offline behavior:** artifact info and recognition likely need to work with poor/no connectivity at actual museum and site locations — not yet designed for.
- **Scope of "Egypt":** whether the app stays focused on Met Museum objects (many of which live outside Egypt, e.g. Berlin, New York) or expands to sites physically in Egypt (Cairo, Giza, Luxor) as the primary use case, which would need a different/additional data source.
