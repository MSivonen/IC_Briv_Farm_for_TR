# IC_Briv_Farm_for_TR

ver 0.43

TRMod for IC Script Hub by Thatman

Modified gem farm for temporal rift (not tested on other variants)


This addon detects when you run out of haste stacks and does stacking and restarts the adventure at that point.

Early stacking is supported

Some failsafe resets are removed

More stuff will be added

---



---
 
 
Installation: Copy IC_BrivGemFarm_TR directory to your Briv Gem Farm\AddOns directory and enable the addon with IC Script Hub's addon manager or any other way you like.

At first run it writes one line to IC_BrivGemFarm_Settings.ahk:

 #include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk

If you remove this mod, you may want to remove that line also. You don't have to.
 

Note: When updating IC Briv Gem Farm with Github Desktop, the AddOns folder will be reverted to original, ie. this mod will be deleted.

.
.


Usage:

"Use dynamic reset zone?" Enables this mod. Disable to have 100% original unmodded functionality of Briv Gem Farm.

"Reset after stacking if haste stacks is less than this" for early stacking. Ignored if dynamic reset zone is unchecked.

Many times when changing adventures and come back, I got 70 stacks left, then stack/restart, then use the few remaining stacks and then restart the adventure. If you don't like it, set it to 0.

In-game Modron core reset level is ignored when playing any variant, including Temporal Rift (that's kinda why I made this thing).

Force reset after specified zone: If your click wall is lower than the zone Briv can reach, or if you start gem farm at high level and high number of stacks, (or any other reason), you can set the reset level yourself. If you run out of stacks before this level, the adventure will restart. Recommended to set this just a bit under your click wall to be safe.

Previous resets are stored in trlog.json file.

---

If you need help, ask here: https://discord.com/invite/N3U8xtB

IC Script Hub can be found here: https://github.com/mikebaldi/Idle-Champions/tree/IC-Script-Hub-Public

If you want to use any parts of this code to any non-profit purpose, feel free to do so.

---

v0.1a initial release

v0.2 added support for early stacking

v0.21 minor update

v0.3 Primitive GUI and installer

v0.4 Dash wait after early stacking. Logging. Gui fixes.

v0.41 fixed installer, found bug -> gui not updating... working on it

v0.42 fixed installer again, added forced reset zone

v0.421 minor gui tweaks

v0.43 major gui tweaks