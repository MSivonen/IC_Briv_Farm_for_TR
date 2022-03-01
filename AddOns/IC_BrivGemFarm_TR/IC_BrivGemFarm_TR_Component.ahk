;v0.47

GUIFunctions.AddTab("Briv TRmod")
;Load user settings
global g_BrivUserSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" )
counter := new SecondCounter

Gui, ICScriptHub:Tab, Briv TR

Gui, ICScriptHub:Font, w700
Gui, ICScriptHub:Add, Text, ,Briv Gem Farm for Temporal Rift
Gui, ICScriptHub:Font, w400

Gui, ICScriptHub:Add, Checkbox, vTRMod Checked%TRMod%  x15 y+15 gBOXdynamic, Use dynamic reset zone (enable this addon)?
Gui, ICScriptHub:Add, Checkbox, vEarlyStacking Checked%EarlyStacking% gBOXstack x15 y+5, Use early stacking?
Gui, ICScriptHub:Add, Checkbox, vEarlyDashWait Checked%EarlyDashWait% gBOXstack x15 y+5, Use dash wait after early stacking?
Gui, ICScriptHub:Add, Checkbox, vTRForce Checked%TRForce%  x15 y+5 gBOXforce, Force reset after specified zone?
Gui, ICScriptHub:Add, Checkbox, vTRAvoid Checked%TRAvoid%  x15 y+5 gBOXavoid, Avoid bosses and/or barriers?

Gui, ICScriptHub:Add, Edit, vTRHaste x15 y+5 w50, % g_BrivUserSettings[ "TRHaste" ]
Gui, ICScriptHub:Add, Edit, vStackZone x15 y+5 w50, % g_BrivUserSettings[ "StackZone" ]
Gui, ICScriptHub:Add, Edit, vMinZone x15 y+5 w50, % g_BrivUserSettings[ "MinStackZone" ]
Gui, ICScriptHub:Add, Edit, vTRForceZone x15 y+5 w50, % g_BrivUserSettings[ "TRForceZone" ]
Gui, ICScriptHub:Add, Edit, vTRJumpZone x15 y+5 w50, % g_BrivUserSettings[ "TRJumpZone" ]
Gui, ICScriptHub:Add, Edit, vTRexactStack x15 y+5 w50, % g_BrivUserSettings[ "TRexactStack" ]





UpdateGUICheckBoxesTR()
UpdateTRGUI()

FindIncluded()


GuiControlGet, xyVal, ICScriptHub:Pos, TRHaste
xyValX += 55
xyValY += 4
Gui, ICScriptHub:Add, Text, x%xyValX% y%xyValY%+9, Reset immediately after stacking if haste stacks is less than this
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Farm SB stacks after this zone
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Minimum zone Briv can farm SB stacks on
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Force reset after this zone
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Jump only from this zone, mod5
Gui, ICScriptHub:Add, Text, x%xyValX% y+13, Walk this many levels to stack level

Gui, ICScriptHub:Add, Button, x15 y+15 gTR_Save_Clicked, Save Settings
Gui, ICScriptHub:Add, Button , x15 y+5 gViewLogButtonClicked, View ResetLog
Gui, ICScriptHub:Add, Button , x+15 gDeleteLogButtonClicked, Clear ResetLog
Gui, ICScriptHub:Add, Button , x15 y+5 gViewStacksLogButtonClicked, View StacksLog
Gui, ICScriptHub:Add, Button , x+15 gDeleteStacksLogButtonClicked, Clear StacksLog
Gui, ICScriptHub:Add, Button , x15 y+5 gFixStatsClicked, Fix log (quick bugfix)
Gui, ICScriptHub:Add, Text, x+2 w100, Click if logs are not working


;*************LOG

Gui, ICScriptHub:Add, Text, x15 y+25, Previous reset zone: 
Gui, ICScriptHub:Add, Text, x+2 w100 vPrevTXT

Gui, ICScriptHub:Add, Text, x15 y+5, Average reset zone (previous 10):
Gui, ICScriptHub:Add, Text, x+2 w100 vAvgTXT

Gui, ICScriptHub:Add, Text, x15 y+5, Previous stacks: 
Gui, ICScriptHub:Add, Text, x+2 w100 vPrevStacksTXT

Gui, ICScriptHub:Add, Text, x15 y+5, Average stacks (previous 10):
Gui, ICScriptHub:Add, Text, x+2 w100 vAvgStacksTXT

;*************LOG


Gui, ICScriptHub:Add, Text, x15 y600, Start Temporal Rift with this, if you already completed it.
Gui, ICScriptHub:Add, Button, x15 y+5  gStart_TR, Start TR
Gui, ICScriptHub:Add, Button, x15 y+5  gFirstRun, Setup user details

Gui, ICScriptHub:Add, Button , x220 y690 gDelinaButtonClicked, .

TR_Save_Clicked()
counter.Start()

UpdateTRLOG()
	{
	global
	prevRST = % PrevRSTobject.getPrevReset()
	prevStacks = % PrevStacPrevStacksObjectksObject.getPrevReset()
	GuiControl,,PrevTXT, % prevRST
	GuiControl,,PrevStacksTXT, % prevStacks
	
	avgRST = % PrevRSTobject.getAVG()
	avgStacks = % PrevStacksObject.getAVG()
	GuiControl,,AvgTXT, % avgRST
	GuiControl,,AvgStacksTXT, % avgStacks
	}

BOXdynamic() ;Disables check/text boxes when clicked

	{
	global
	Gui, Submit, NoHide
	If TRMod = 1
		{
		GuiControl, Enable, TRForceZone
		GuiControl, Enable, TRexactStack
		GuiControl, Enable, EarlyStacking
			If EarlyStacking = 1
			{
				GuiControl, Enable, TRHaste
				GuiControl, Enable, EarlyDashWait
			}
			else If EarlyStacking = 0
			{
				GuiControl, Disable, StackZone
			}
		GuiControl, Enable, TRforce
		GuiControl, Enable, TRAvoid
			If TRavoid = 1
			{
				GuiControl, Enable, TRJumpZone
			}
		}
	Else If TRMod = 0
		{
		GuiControl, Disable, TRHaste
		GuiControl, Disable, TRexactStack
		GuiControl, Disable, EarlyStacking
		GuiControl, Disable, TRForceZone	
		GuiControl, Disable, EarlyDashWait
		GuiControl, Disable, TRforce
		GuiControl, Disable, TRAvoid
		GuiControl, Disable, TRJumpZone
		GuiControl, Enable, StackZone
		}
	return
	}

BOXstack()
	{
	global
	Gui, Submit, NoHide
	If EarlyStacking = 1
		{
		GuiControl, Enable, TRHaste
		GuiControl, Enable, TRexactStack
		GuiControl, Enable, StackZone
		GuiControl, Enable, EarlyDashWait
		}
	Else If EarlyStacking = 0
		{
		GuiControl, Disable, StackZone	
		GuiControl, Disable, TRexactStack	
		GuiControl, Disable, EarlyDashWait	
		GuiControl, Disable, TRHaste
		}
	Return
	}
	
BOXforce()
	{
	global
	Gui, Submit, NoHide
	If TRForce = 1
		{
		GuiControl, Enable, TRForceZone
		}
	Else If TRForce = 0
		{
		GuiControl, Disable, TRForceZone	
		}
	Return
	}

BOXavoid()
	{
	global
	Gui, Submit, NoHide
	If TRAvoid = 1
		{
		GuiControl, ICScriptHub:Enable, TRJumpZone
		}
	Else If TRAvoid = 0
		{
		GuiControl, ICScriptHub:Disable, TRJumpZone	
		}
	Return
	}

UpdateTRGUI() ;Disables check/text boxes when script is loaded
	{
		; BOXavoid()
		; BOXforce()
		; BOXstack()
		; BOXdynamic()
	global
	Gui, Submit, NoHide

	
	If % g_BrivUserSettings[ "TRHack" ] = 1
		{
			{
			GuiControl, ICScriptHub:Enable, EarlyStacking
			GuiControl, ICScriptHub:Enable, TRForce
			GuiControl, ICScriptHub:Enable, TRAvoid
			GuiControl, ICScriptHub:Enable, TRexactStack
			}
			If % g_BrivUserSettings[ "TRForce" ] = 0
				{
				GuiControl, ICScriptHub:Disable, TRForceZone
				}
			If % g_BrivUserSettings[ "TRAvoid" ] = 0
				{
				GuiControl, ICScriptHub:Disable, TRJumpZone
				}
			If % g_BrivUserSettings[ "EarlyStacking" ] = 0
				{
				GuiControl, ICScriptHub:Disable, StackZone
				GuiControl, ICScriptHub:Disable, TRHaste
				GuiControl, ICScriptHub:Disable, EarlyDashWait	
				GuiControl, ICScriptHub:Disable, TRexactStack
				}

		}

		Else If % g_BrivUserSettings[ "TRHack" ] = 0
			{
			GuiControl, ICScriptHub:Disable, TRHaste
			GuiControl, ICScriptHub:Disable, EarlyStacking
			GuiControl, ICScriptHub:Disable, EarlyDashWait
			GuiControl, ICScriptHub:Disable, TRForceZone
			GuiControl, ICScriptHub:Disable, TRForce
			GuiControl, ICScriptHub:Enable, StackZone
			GuiControl, ICScriptHub:Disable, TRJumpZone
			GuiControl, ICScriptHub:Disable, TRAvoid
			}

	}

UpdateGUICheckBoxesTR() ;update gui according to settings file
    {
        GuiControl,ICScriptHub:, TRMod, % g_BrivUserSettings[ "TRHack" ]
        GuiControl,ICScriptHub:, TRForce, % g_BrivUserSettings[ "TRForce" ]
        GuiControl,ICScriptHub:, EarlyStacking, % g_BrivUserSettings[ "EarlyStacking" ]
        GuiControl,ICScriptHub:, EarlyDashWait, % g_BrivUserSettings[ "EarlyDashWait" ]
        GuiControl,ICScriptHub:, TRAvoid, % g_BrivUserSettings[ "TRAvoid" ]
    }





ViewLogButtonClicked()
	{
	logfilepath=%A_LineFile%\..\trlog.json
	if FileExist(logfilepath)
		{
		Run, notepad.exe %A_LineFile%\..\trlog.json
		}
	else msgbox,, File not found, Empty log?
	}

FixStatsClicked()
	{
		counter.Start()
	}	
DeleteLogButtonClicked()
	{
	MsgBox, 4,, Delete ResetLog?
	IfMsgBox Yes
		{
		FileDelete, %A_LineFile%\..\trlog.json
		MsgBox ResetLog cleared
		}
	}

ViewStacksLogButtonClicked()
	{
	logfilepath=%A_LineFile%\..\trlog.json
	if FileExist(logfilepath)
		{
		Run, notepad.exe %A_LineFile%\..\trstacklog.json
		}
	else msgbox,, File not found, Empty log?
	}
	
DeleteStacksLogButtonClicked()
	{
	MsgBox, 4,, Delete ResetLog?
	IfMsgBox Yes
		{
		FileDelete, %A_LineFile%\..\trstacklog.json
		MsgBox StacksLog cleared
		}
	}
	

DelinaButtonClicked()
	{
		UpdateTRGUI()
		msgbox,I got married on 22.2.22 wearing a superman shirt.`nThe wedding march was Manowar - Heart of Steel`nTry to outnerd that.
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
        g_BrivUserSettings[ "TRForceZone" ] := TRForceZone
        g_BrivUserSettings[ "TRForce" ] := TRForce
        g_BrivUserSettings[ "TRJumpZone" ] := TRJumpZone
        g_BrivUserSettings[ "TRAvoid" ] := TRAvoid
        g_BrivUserSettings[ "TRexactStack" ] := TRexactStack
		
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
	Loop, Read, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Settings.ahk
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
		msgbox,4,First time run?,TRMod not found in `n ..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Settings.ahk.`n`n Add it there now?
		IfMsgBox Yes
		{
			WriteInclude := "`n#include *i %A_LineFile%\..\..\IC_BrivGemFarm_TR\IC_BrivGemFarm_TR_enable.ahk"
			FileAppend, %WriteInclude%, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Settings.ahk
			TR_Save_Clicked()
			MsgBox ,0,TRMod Installed, Please stop gem farm and restart ICSCripthub
			MsgBox ,0,Annoying thing, TRMod Known bug: TRMod tab may have empty text fields on first run.`nRestart ICSCripthub twice. That should fix it.`nSorry.

		}
		else
			MsgBox ,0,TRMod NOT installed, It will not work.
		}
	}