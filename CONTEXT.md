# SCT Mover

A WoW: Forever addon that changes where combat text appears on screen. It moves the game's own text; it never draws text itself.

## Language

**Target Text**:
Text that the game engine draws in world space above the unit the player hits: damage and heal numbers, and words such as "Dodge" or "Absorb".
_Avoid_: Target numbers, damage numbers, SCT, floating combat text

**Self Text**:
Two-dimensional text that scrolls near the player's character: damage taken, heals received, auras, and procs.
_Avoid_: SCT, floating combat text, scrolling combat text

**Nameplate**:
The health bar the game shows above a unit in the world. Target Text can start behind it.
_Avoid_: Enemy health bar

**Offset**:
The distance between where the game puts combat text by default and where the player wants it. An Offset of zero is the game default.
_Avoid_: Position, coordinates

**Raised Self Text**:
The setting that draws Self Text above other UI elements.
_Avoid_: Layer, strata, on top

**Move Mode**:
The state in which the player drags the Marker to set the Self Text Offset.
_Avoid_: Unlock, edit mode, config mode

**Marker**:
The box that shows where Self Text starts while Move Mode is on.
_Avoid_: Anchor, mover, handle

**Sample Text**:
The numbers the addon shows in Move Mode so the player sees the result of an Offset.
_Avoid_: Test message, preview, dummy text

**Character Override**:
The setting with which one character uses its own Self Text settings in place of the account settings.
_Avoid_: Profile
