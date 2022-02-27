# IC_Briv_Farm_for_TR

ver 0.45

TRMod for IC Script Hub by Thatman</br>
Modified gem farm for temporal rift (not tested on other variants)</br>

This addon detects when you run out of haste stacks and does stacking and restarts the adventure at that point.</br>
Early stacking is supported</br>
Some failsafe resets are removed</br>
More stuff will be added</br>

---
 </br>
 </br>
Installation: Copy IC_BrivGemFarm_TR directory to your Briv Gem Farm\AddOns directory and enable the addon with IC Script Hub's addon manager or any other way you like.</br>
At first run it writes one line to IC_BrivGemFarm_Settings.ahk:</br>
 #include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk</br>
If you remove this mod, you may want to remove that line also. You don't have to.</br>
 </br>
Note: When updating IC Briv Gem Farm with Github Desktop, the AddOns folder will be reverted to original, ie. this mod will be deleted.</br>
</br>
</br>
</br>
Usage:</br>
</br>
"Use dynamic reset zone?" Enables this mod. Disable to have 100% original unmodded functionality of Briv Gem Farm.</br>
"Reset after stacking if haste stacks is less than this" for early stacking. Ignored if dynamic reset zone is unchecked.</br>
Many times when changing adventures and come back, I got 70 stacks left, then stack/restart, then use the few remaining stacks and then restart the adventure. If you don't like it, set it to 0.</br>
In-game Modron core reset level is ignored when playing any variant, including Temporal Rift (that's kinda why I made this thing).</br>
</br>
Force reset after specified zone: If your click wall is lower than the zone Briv can reach, or if you start gem farm at high level and high number of stacks, (or any other reason), you can set the reset level yourself. If you run out of stacks before this level, the adventure will restart. Recommended to set this just a bit under your click wall to be safe.</br>
</br>
Previous resets are stored in trlog.json file.</br>

---

v0.44 added Start TR button. If you experience issues with it, replace the IC_BrivGemFarm_TR_Component.ahk with the file IC_BrivGemFarm_TR_Component_without_button.ahk

Read this readme for more: https://github.com/MSivonen/TR_Button

---

If you need help, ask here: https://discord.com/invite/N3U8xtB</br>
IC Script Hub can be found here: https://github.com/mikebaldi/Idle-Champions/tree/IC-Script-Hub-Public</br>
If you want to use any parts of this code to any non-profit purpose, feel free to do so.</br>

---

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