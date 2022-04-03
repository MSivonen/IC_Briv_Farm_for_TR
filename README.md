# IC_Briv_Farm_for_TR

ver 0.511

<i>This addon is discontinued, since I'm not playing the game anymore. Anyone can freely use any/all parts of the addon, including all the files in this repository. Feel free to share your fixed version, if you make one.</br>
It's still working now, 3.4.22.</br>
If/when this stops working, could you please inform me (via discord/git), so I can add that information to this readme. Thank you.</i></br>

TRMod for IC Script Hub by Thatman</br>
Modified gem farm for temporal rift (not tested on other variants)</br>

This addon detects when you run out of haste stacks and does stacking and restarts the adventure at that point.</br>
Early stacking is supported</br>
Some failsafe resets are removed</br>
All of the original Briv Gem Farm tab settings are still in use, except enable manual resets does nothing</br>

---
 </br>
 </br>
Installation: </br>
You need to have Autohotkey and ICScriptHub installed. Links below. </br>
Copy IC_BrivGemFarm_TR directory to your (Briv Gem Farm)\AddOns directory (should look like \AddOns\IC_BrivGemFarm_TR\) and enable the addon with IC Script Hub's addon manager or any other way you like.</br>
At first run it writes one line to IC_BrivGemFarm_Settings.ahk:</br>
 #include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk</br>
If you remove this mod, you may want to remove that line also. You don't have to.</br>
At first run it also has some popups, which should be self-explanatory, or can be ignored by pressing yes yes yes yes ok ok ok ok.</br>
Some of it is related to Start Adventure button. Read this readme if needed: https://github.com/MSivonen/TR_Button </br>
 </br>
Note: When updating IC Briv Gem Farm with Github Desktop, the AddOns folder will be reverted to original, ie. this mod will be deleted.</br>
</br>
</br>
</br>
Usage:</br>
</br>
"Addon enabled" Enables this mod. Disable to have 100% original unmodded functionality of Briv Gem Farm.</br>
</br>
"Reset after stacking if haste stacks is less than this" for early stacking.</br>
Don't do early stacking if you have less than this amount of stacks.</br>
</br>
In-game Modron core reset level is ignored when playing any variant, including Temporal Rift (that's kinda why I made this thing).</br>
But you need to set it to high-ish level for dash wait to work. Reset enabled or not doesn't matter.</br>
</br>
Force reset after specified zone: If your click wall is lower than the zone Briv can reach, or if you start gem farm at high level and high number of stacks, (or any other reason), you can set the reset level yourself. If you run out of stacks before this level, the adventure will restart. Recommended to set this just a bit under your click wall.</br>
</br>
Avoid bosses/barriers: When enabled, the party will walk with e formation to desired jump zone and jump with q formation from there.</br>
For example with 3 jump Briv, you can set it to 2. You'll walk to zone 2, 7, 12, 17 etc and jump to zone 1, 6, 11, 16 etc. Repeat until end. You'll avoid all the bosses and the barriers at zones 3 and 48. By my testing, you'll need a high-percentage (80-90%?) 4J Briv for enabling this to be faster.</br>
</br>
Walk this many levels to stacking zone: With this, you'll walk in e formation to "stack after this zone" (+1 zone, because it's AFTER) and you can use potions after early stacking. Set to 0 to disable. (Possible bug; does it work with 0 or do you have to have 1 in there? If you encounter problems, this would be one thing to try)</br>
</br>
---</br>
</br>
If you need help, ask here: https://discord.com/invite/N3U8xtB</br>
IC Script Hub can be found here: https://github.com/mikebaldi/Idle-Champions/</br>
Autohotkey: https://www.autohotkey.com/ </br>
If you want to use any parts of this code to any non-profit purpose, feel free to do so.</br>
</br>
---</br>
</br>
v0.1a initial release</br>
v0.2 added support for early stacking</br>
v0.21 minor update</br>
v0.3 Primitive GUI and installer</br>
v0.4 Dash wait after early stacking. Logging. Gui fixes.</br>
v0.41 fixed installer, found bug -> gui not updating... working on it</br>
v0.42 fixed installer again, added forced reset zone</br>
v0.421 minor gui tweaks</br>
v0.43 major gui tweaks</br>
v0.44 added Start TR button</br>
v0.441 added description for TR button</br>
v0.443 minor bug fixes</br>
v0.45 sb stacks log</br>
v0.451 temporary quick fix for logs not loading</br>
v0.46 Avoid barriers and bosses</br>
v0.461 fixed disabling gui items</br>
v0.47 Walk to early stack zone</br>
v.0471 If out of stacks at a boss level, complete it before reset.</br>
v.0472 "fixed" issue with modron reset level and dash wait</br>
v.5 GUI rework</br>
v.501 after early stacking, delay dash wait for one level, so you can use potions before wait</br>
v.502 quick fix to gui buttons</br>
v.51 Automatic reset if stuck in world map</br>
v.511 minor stuff</br>
