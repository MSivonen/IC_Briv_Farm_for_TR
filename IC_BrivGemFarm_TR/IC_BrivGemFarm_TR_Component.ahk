;v0.3

GUIFunctions.AddTab("Briv TR")
;Load user settings
global g_BrivUserSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" )
FindIncluded()

Gui, ICScriptHub:Tab, Briv TR

Gui, ICScriptHub:Font, w700
Gui, ICScriptHub:Add, Text, ,Briv Gem Farm for Temporal Rift
Gui, ICScriptHub:Font, w400

Gui, ICScriptHub:Add, Checkbox, vTRMod Checked%TRMod% gBOXdynamic x15 y+15, Use dynamic reset zone?
Gui, ICScriptHub:Add, Checkbox, vEarlyStacking Checked%EarlyStacking% gBOXstack x15 y+5, Use early stacking?
Gui, ICScriptHub:Add, Edit, vTRHaste x15 y+5 w50, % g_BrivUserSettings[ "TRHaste" ]
Gui, ICScriptHub:Add, Edit, vStackZone x15 y+5 w50, % g_BrivUserSettings[ "StackZone" ]
Gui, ICScriptHub:Add, Edit, vMinZone x15 y+5 w50, % g_BrivUserSettings[ "MinStackZone" ]

;GuiControlGet, xyVal, ICScriptHub:Pos, TRMod
;Gui, ICScriptHub:Add, Text, x230 y%xyValY%, Previous reset zone:
;Gui, ICScriptHub:Add, Text, x+2 w100 vPrevTXT ; vg_prevLVL



GuiControlGet, xyVal, ICScriptHub:Pos, TRHaste
xyValX += 55
xyValY += 4
Gui, ICScriptHub:Add, Text, x%xyValX% y%xyValY%+9, Reset immediately after stacking if haste stacks is less than this
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Farm SB stacks after this zone
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Minimum zone Briv can farm SB stacks on

Gui, ICScriptHub:Add, Button, x15 y+15 gTR_Save_Clicked, Save Settings
Gui, ICScriptHub:Add, Button , x540 y735 gDelinaButtonClicked, .

Loop
	{
	g_prevLVL = % g_SF.Memory.ReadHighestZone()
	GuiControl,,PrevTXT, % g_prevLVL
	sleep 500
	}


;Disables text boxes
BOXdynamic:
		{
		Gui, Submit, NoHide
		If TRMod = 1
			{
			GuiControl, Enable, TRHaste
			}
		Else If TRMod = 0
			{
			GuiControl, Disable, TRHaste
			}
		Return
		}

	BOXstack:
		{
		Gui, Submit, NoHide
		If EarlyStacking = 1
			{
			GuiControl, Enable, StackZone
			}
		Else If EarlyStacking = 0
			{
			GuiControl, Disable, StackZone	
			}
		Return
		}

	Gui, Show
Return







FindIncluded() ; Check if TRMod is included in IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk
	{
		SearchFor := "#include %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk"
	Found := False
	Line := False


	Line := False
	Loop, Read, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk
	{
		If !Trim(A_LoopReadLine)
			Continue
		If InStr(A_LoopReadLine, SearchFor)
		{
			Line := A_LoopReadLine
			Found = 1
			Continue
		}
		If Line
		{
			Line .= "`r`n" . A_LoopReadLine
			Break
		}
	}
	If (!Found)
		{
		msgbox,4,First time run?,TRMod not found in `n ..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk.`n`n Add it there now?
		IfMsgBox Yes
		{
			WriteInclude := "`n#include %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk"
			FileAppend, %WriteInclude%, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk
			TR_Save_Clicked()
			MsgBox ,0,TRMod Installed, Please stop gem farm and restart ICSCripthub
		}
		else
			MsgBox ,0,TRMod NOT installed, It will not work.
		}
	}
	
	
; ############################################################
;                          Buttons
; ############################################################

DelinaButtonClicked()
	{
	Run https://www.youtube.com/watch?v=dQw4w9WgXcQ
	}

TR_Save_Clicked()
    {
        global
        Gui, ICScriptHub:Submit, NoHide
        g_BrivUserSettings[ "TRHaste" ] := TRHaste
        g_BrivUserSettings[ "MinStackZone" ] := MinZone
        g_BrivUserSettings[ "TRHack" ] := TRMod
        g_BrivUserSettings[ "StackZone" ] := StackZone
        g_BrivUserSettings[ "EarlyStacking" ] := EarlyStacking
		
        g_SF.WriteObjectToJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" , g_BrivUserSettings )
        try ; avoid thrown errors when comobject is not available.
        {
            local SharedRunData := ComObjActive("{416ABC15-9EFC-400C-8123-D7D8778A2103}")
            SharedRunData.ReloadSettings("ReloadBrivGemFarmSettingsDisplay")
        }
        return
    }