;v0.41

GUIFunctions.AddTab("Briv TR")
;Load user settings
;global g_BrivUserSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" )

Gui, ICScriptHub:Tab, Briv TR

Gui, ICScriptHub:Font, w700
Gui, ICScriptHub:Add, Text, ,Briv Gem Farm for Temporal Rift
Gui, ICScriptHub:Font, w400

;Gui, ICScriptHub:Add, Checkbox, vTRMod Checked%TRMod% gBOXdynamic x15 y+15, Use dynamic reset zone?
Gui, ICScriptHub:Add, Checkbox, vTRMod Checked%TRMod% x15 y+15, Use dynamic reset zone?
;Gui, ICScriptHub:Add, Checkbox, vEarlyStacking Checked%EarlyStacking% gBOXstack x15 y+5, Use early stacking?
Gui, ICScriptHub:Add, Checkbox, vEarlyStacking Checked%EarlyStacking% x15 y+5, Use early stacking?
;Gui, ICScriptHub:Add, Checkbox, vEarlyDashWait Checked%EarlyDashWait% gBOXstack x15 y+5, Use dash wait after early stacking?
Gui, ICScriptHub:Add, Checkbox, vEarlyDashWait Checked%EarlyDashWait% x15 y+5, Use dash wait after early stacking?
Gui, ICScriptHub:Add, Edit, vTRHaste x15 y+5 w50, % g_BrivUserSettings[ "TRHaste" ]
Gui, ICScriptHub:Add, Edit, vStackZone x15 y+5 w50, % g_BrivUserSettings[ "StackZone" ]
Gui, ICScriptHub:Add, Edit, vMinZone x15 y+5 w50, % g_BrivUserSettings[ "MinStackZone" ]

UpdateGUICheckBoxesTR()
UpdateTRGUI()
FindIncluded()


GuiControlGet, xyVal, ICScriptHub:Pos, TRHaste
xyValX += 55
xyValY += 4
Gui, ICScriptHub:Add, Text, x%xyValX% y%xyValY%+9, Reset immediately after stacking if haste stacks is less than this
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Farm SB stacks after this zone
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Minimum zone Briv can farm SB stacks on

Gui, ICScriptHub:Add, Button, x15 y+15 gTR_Save_Clicked, Save Settings

Gui, ICScriptHub:Add, Text, x15 y+25, Previous reset zone: 
Gui, ICScriptHub:Add, Text, x+2 w100 vPrevTXT

Gui, ICScriptHub:Add, Text, x15 y+5, Average reset zone (previous 10):
Gui, ICScriptHub:Add, Text, x+2 w100 vAvgTXT

Gui, ICScriptHub:Add, Button , x540 y735 gDelinaButtonClicked, .

/*
Loop
	{
	prevRST = % PrevRSTobject.getPrevReset()
	GuiControl,,PrevTXT, % prevRST
	
	avgRST = % PrevRSTobject.getAVG()
	GuiControl,,AvgTXT, % avgRST

	sleep 500
	}


;Disables check/text boxes when clicked
BOXdynamic:
	{
	Gui, Submit, NoHide
	If TRMod = 1
		{
		GuiControl, Enable, EarlyStacking
			If EarlyStacking = 1
				GuiControl, Enable, TRHaste
		}
	Else If TRMod = 0
		{
		GuiControl, Disable, TRHaste
		GuiControl, Disable, EarlyStacking
		}
	return
	}

BOXstack:
	{
	Gui, Submit, NoHide
	If EarlyStacking = 1
		{
		GuiControl, Enable, TRHaste
		GuiControl, Enable, StackZone
		GuiControl, Enable, EarlyDashWait
		}
	Else If EarlyStacking = 0
		{
		GuiControl, Disable, StackZone	
		GuiControl, Disable, EarlyDashWait	
		GuiControl, Disable, TRHaste
		}
	Return
	}
*/

UpdateTRGUI() ;Disables check/text boxes when script is loaded
	{
	If % g_BrivUserSettings[ "TRHack" ] = 1
		{
		GuiControl, Enable, TRHaste
		GuiControl, Enable, EarlyStacking
		}
	Else If % g_BrivUserSettings[ "TRHack" ] = 0
		{
		GuiControl, Disable, TRHaste
		GuiControl, Disable, EarlyStacking
		GuiControl, Enable, StackZone
		}
	If % g_BrivUserSettings[ "EarlyStacking" ] = 1
		{
		GuiControl, Enable, StackZone
		GuiControl, Enable, EarlyDashWait
		}
	Else If % g_BrivUserSettings[ "EarlyStacking" ] = 0
		{
		GuiControl, Disable, TRHaste
		GuiControl, Disable, StackZone	
		GuiControl, Disable, EarlyDashWait	
		}
	}

UpdateGUICheckBoxesTR() ;update gui according to settings file
    {
        GuiControl,ICScriptHub:, TRMod, % g_BrivUserSettings[ "TRHack" ]
        GuiControl,ICScriptHub:, EarlyStacking, % g_BrivUserSettings[ "EarlyStacking" ]
        GuiControl,ICScriptHub:, EarlyDashWait, % g_BrivUserSettings[ "EarlyDashWait" ]
    }



	

; ############################################################
;                          Buttons
; ############################################################

DelinaButtonClicked()
	{
		msgbox Do not read
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
        g_BrivUserSettings[ "EarlyDashWait" ] := EarlyDashWait
		
        g_SF.WriteObjectToJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" , g_BrivUserSettings )
        try ; avoid thrown errors when comobject is not available.
        {
            local SharedRunData := ComObjActive("{416ABC15-9EFC-400C-8123-D7D8778A2103}")
            SharedRunData.ReloadSettings("ReloadBrivGemFarmSettingsDisplay")
        }
        return
    }
	
	
	
FindIncluded() ; Check if TRMod is included in IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk
	{
	SearchFor := "#include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk"
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
			WriteInclude := "`n#include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk"
			FileAppend, %WriteInclude%, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Mods.ahk
			TR_Save_Clicked()
			MsgBox ,0,TRMod Installed, Please stop gem farm and restart ICSCripthub
		}
		else
			MsgBox ,0,TRMod NOT installed, It will not work.
		}
	}