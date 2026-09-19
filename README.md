# SCT Mover

A small WoW: Forever addon that moves the damage and healing numbers above your target up or down. It's handy when nameplates hide the numbers.

## Use

Open the game options, pick SCT Mover under AddOns, and drag the "Target number height" slider. `/sctmover` (or `/sctm`) takes you straight there. The Defaults button puts the numbers back where the game had them.

The addon only changes two game settings (`WorldTextScreenY_v2` and `WorldTextCritScreenY_v2`), so your choice stays even if you turn the addon off.

## Develop

Symlink the repo into the Forever AddOns folder as `SCTMover`
(`_classic_beta_/Interface/AddOns`). Lint with `luacheck .` and package with
the BigWigs packager; a `v*` tag cuts a release.
