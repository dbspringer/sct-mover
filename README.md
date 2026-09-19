# SCT Mover - Scrolling Combat Text Mover

A simple WoW: Forever addon to allow you to move your scrolling combat text where you choose. Your font, your float mode, and every other combat text setting stay the way you set them.

## What it does

**Target text** (the damage, heals, and misses above your target)

- One "Target height" slider lifts or lowers it, so it clears the nameplate
- It only changes two game settings (`WorldTextScreenY_v2` and `WorldTextCritScreenY_v2`), so your choice stays even if you turn the addon off

**Self text** (the damage you take, heals you receive, and similar, near your character)

- "Show self text above other UI elements" draws it on top of whatever was covering it
- "Move" gives you a box to drag to where the text should start, with sample text so you can see the result
- "Horizontal" and "Vertical" sliders set exact values
- Settings are shared by all your characters, and one checkbox gives a character its own

Each section has a "Reset position" button, and a fresh install changes nothing until you move something.

## How to use it

Open the game options and pick SCT Mover under AddOns, or type `/sctm` (or `/sctmover`). `/sctm move` jumps straight to dragging the self text.

## Good to know

- Built for WoW: Forever (the 1.60 client). Other versions of WoW aren't supported yet.
- Target text can only move up and down. The game has no setting for left and right.
- Self text has to be turned on in the game's own options for the self text settings to do anything.

## Languages

English, plus machine translations for German, French, Spanish, Brazilian Portuguese, Russian, Korean, and Simplified and Traditional Chinese. If a line reads wrong in your language, a fix to the file in `locales/` is very welcome.

## Bugs and ideas

Open an issue at [github.com/dbspringer/sct-mover](https://github.com/dbspringer/sct-mover/issues). The version and locale at the bottom of the options panel help a lot in a bug report.

## Develop

Symlink the repo into the Forever AddOns folder as `SCTMover`
(`_classic_beta_/Interface/AddOns`). Lint with `luacheck .`, run the specs with
`busted` (on Lua 5.1 or LuaJIT, since that's what WoW runs), and package with
the BigWigs packager. Releases are plain numbers that go up by one each time
(`1`, `2`, `3`), and pushing that number as a tag cuts the release.

Until the release workflow has CurseForge and Wago keys, `./export.sh <version> [destination]`
builds the same zip by hand, for example `./export.sh 1 ~/Desktop`. It ships
exactly the files the TOC loads, plus the license.

Every release gets an entry in `CHANGELOG.md`, and the packager uses that file for the release notes.
