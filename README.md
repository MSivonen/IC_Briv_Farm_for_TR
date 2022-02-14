# IC_Briv_Farm_for_TR

ver 0.3

Modified gem farm for temporal rift (not tested on other variants)
--
This modified script detects when you run out of haste stacks and does stacking and restarts the adventure at that point.
Early stacking is supported
Some failsafe resets are removed
More stuff will be added

---


Original made by Antilectual & mikebaldi1980

Dynamic reset zone modification by Thatman

---
 
 
Installation: Copy IC_BrivGemFarm_TR directory to your Briv Gem Farm\AddOns directory and enable the addon with IC Script Hub's addon manager or any other way you like.

At first run it writes one line to IC_BrivGemFarm_Mods.ahk:
 #include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk
If you remove this mod, you may want to remove that line also.
 

.
.


Usage:

"Use dynamic reset zone?" Enables this mod. Disable to have 100% original unmodded functionality. No need to restore backup files.

"Reset after stacking if haste stacks is less than this" for early stacking. Ignored if dynamic reset zone is unchecked.

Many times when changing adventures, I got 70 stacks left, then stack/restart, then use the few remaining stacks. If you don't like it, set it to 0.

In-game Modron core reset level is ignored when playing any variant, including Temporal Rift (that's kinda why I made this thing).

---

If you need help, ask here: https://discord.com/invite/N3U8xtB

Original script can be found here: https://github.com/mikebaldi/Idle-Champions/tree/IC-Script-Hub-Public

---

v0.1a initial release

v0.2 added support for early stacking

v0.21 minor update

v0.3 Primitive GUI and installer