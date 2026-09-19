# SCT Mover

A WoW: Forever addon that changes where combat text appears on screen. It moves the game's own text; it never draws text itself.

## Language

**Target Numbers**:
Damage and heal numbers that the game engine draws in world space above the unit the player hits.
_Avoid_: SCT, floating combat text, damage text

**Self Text**:
Two-dimensional text that scrolls near the player's character: damage taken, heals received, auras, and procs.
_Avoid_: SCT, floating combat text, scrolling combat text

**Nameplate**:
The health bar the game shows above a unit in the world. Target Numbers can start behind it.
_Avoid_: Enemy health bar
