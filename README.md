# SCT Mover

A small WoW: Forever addon that moves combat text out from behind your UI. It lifts the damage and healing numbers above your target clear of nameplates, and it can draw the text near your character on top of other UI elements.

## Use

Open the game options and pick SCT Mover under AddOns. `/sctmover` (or `/sctm`) takes you straight there.

- **Target numbers.** Drag the "Target height" slider to lift or lower the numbers above your target. The reset button below it puts them back where the game had them. This only changes two game settings (`WorldTextScreenY_v2` and `WorldTextCritScreenY_v2`), so your choice stays even if you turn the addon off.
- **Self text.** Tick "Show self text above other UI elements" if other parts of your UI cover the text that scrolls near your character.

## Develop

Symlink the repo into the Forever AddOns folder as `SCTMover`
(`_classic_beta_/Interface/AddOns`). Lint with `luacheck .`, run the specs with
`busted` (on Lua 5.1 or LuaJIT, since that's what WoW runs), and package with
the BigWigs packager. Releases are plain numbers that go up by one each time
(`1`, `2`, `3`), and pushing that number as a tag cuts the release.
