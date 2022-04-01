;v0.51

GUIFunctions.AddTab("Briv TRmod")
;Load user settings
global g_BrivUserSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" )
counter := new SecondCounter
global prevtime := A_TickCount

Gui, ICScriptHub:Tab, Briv TR

Gui, ICScriptHub:Font, w700
Gui, ICScriptHub:Add, Picture, x0 y50 w500 h234 , %A_LineFile%\..\trmod3.gif
Gui, ICScriptHub:Font, w400

Gui, ICScriptHub:Add, GroupBox, x22 y302 w340 h200 c000000, 
Gui, ICScriptHub:Add, GroupBox, x22 y509 w405 h103 c000000, Logs
Gui, ICScriptHub:Add, GroupBox, x22 y612 w280 h50 c000000, Start Temporal Rift with this`, if you already completed it.



Gui, ICScriptHub:Add, Checkbox, vTRMod Checked%TRMod%  x32 y299 w90 h20 gBOXdynamic, Addon enabled
Gui, ICScriptHub:Add, Checkbox, vEarlyStacking Checked%EarlyStacking% gBOXstack x72 y409 w210 h20, Use early stacking? Stack after level:
Gui, ICScriptHub:Add, Checkbox, vVanillaDashWait Checked%VanillaDashWait% x32 y379 w150 h20 gBOXvanillaDashWait, Use dash wait at start?
Gui, ICScriptHub:Add, Checkbox, vEarlyDashWait Checked%EarlyDashWait% gBOXstack x72 y429 w200 h20, Use dash wait after early stacking?
Gui, ICScriptHub:Add, Checkbox, vTRForce Checked%TRForce%  x32 y319 w150 h20 gBOXforce, Force reset after this zone:
Gui, ICScriptHub:Add, Checkbox, vTRAvoid Checked%TRAvoid%  x32 y339 w240 h20 gBOXavoid, Avoid bosses and/or barriers? Jump from level:

Gui, ICScriptHub:Add, Edit, vTRHaste x302 y469 w50 h20, % g_BrivUserSettings[ "TRHaste" ]
Gui, ICScriptHub:Add, Edit, vStackZone x302 y409 w50 h20, % g_BrivUserSettings[ "StackZone" ]
Gui, ICScriptHub:Add, Edit, vMinZone x302 y359 w50 h20, % g_BrivUserSettings[ "MinStackZone" ]
Gui, ICScriptHub:Add, Edit, vTRForceZone x302 y319 w50 h20, % g_BrivUserSettings[ "TRForceZone" ]
Gui, ICScriptHub:Add, Edit, vTRJumpZone x302 y339 w50 h20, % g_BrivUserSettings[ "TRJumpZone" ]
Gui, ICScriptHub:Add, Edit, vTRexactStack x302 y449 w50 h20, % g_BrivUserSettings[ "TRexactStack" ]





UpdateGUICheckBoxesTR()
UpdateTRGUI()
FindIncluded()


GuiControlGet, xyVal, ICScriptHub:Pos, TRHaste
xyValX += 55
xyValY += 4
Gui, ICScriptHub:Add, Text, x89 y469 w180 h30, Don't do early stacking if haste stacks is less than this
Gui, ICScriptHub:Add, Text, x48 y362 w200 h20, Minimum zone Briv can farm SB stacks on
Gui, ICScriptHub:Add, Text, x89 y451 w170 h15, Walk this many levels to stack level

Gui, ICScriptHub:Add, Button, x362 y339 w50 h130 gTR_Save_Clicked, Save Settings
Gui, ICScriptHub:Add, Button , x242 y549 w90 h20 gViewLogButtonClicked, View ResetLog
Gui, ICScriptHub:Add, Button , x332 y549 w90 h20 gDeleteLogButtonClicked, Clear ResetLog
Gui, ICScriptHub:Add, Button , x242 y569 w90 h20 gViewStacksLogButtonClicked, View StacksLog
Gui, ICScriptHub:Add, Button , x332 y569 w90 h20 gDeleteStacksLogButtonClicked, Clear StacksLog
;Gui, ICScriptHub:Add, Button , x15 y+5 gFixStatsClicked, Fix log (quick bugfix)
;Gui, ICScriptHub:Add, Text, x+2 w100, Click if logs are not working
Gui, ICScriptHub:Add, Button, x267 y250 w70 h50 gBriv_Run_Clicked, Start gem farm
Gui, ICScriptHub:Add, Button, x+5 y250 w70 h50 gBriv_Run_Stop_Clicked, Stop gem farm
;Gui, ICScriptHub:Add, Button, x+5 y260 w70 h30 gTR_Reset_Clicked, Restart`nadventure


;*************LOG

Gui, ICScriptHub:Add, Text, x32 y529 w100 h20, Previous reset zone: 
Gui, ICScriptHub:Add, Text, x202 y529 w40 h20 vPrevTXT

Gui, ICScriptHub:Add, Text, x32 y549 w160 h20, Average reset zone (previous 10):
Gui, ICScriptHub:Add, Text, x202 y549 w40 h20 vAvgTXT

Gui, ICScriptHub:Add, Text, x32 y569 w90 h20, Previous stacks: 
Gui, ICScriptHub:Add, Text, x202 y569 w40 h20 vPrevStacksTXT

Gui, ICScriptHub:Add, Text, x32 y589 w150 h20, Average stacks (previous 10):
Gui, ICScriptHub:Add, Text, x202 y589 w40 h20 vAvgStacksTXT

;*************LOG

Gui, ICScriptHub:Add, Button, x60 y632 w80 h20 gStart_TR, Start adventure
Gui, ICScriptHub:Add, Button, x170 y632 w90 h20 gFirstRun, Setup user details

;Gui, ICScriptHub:Add, Button , x220 y690 gDelinaButtonClicked, .

TR_Save_Clicked()
counter.Start()


OnMessage(0x5555, "MsgMonitor")
OnMessage(0x5556, "MsgMonitor")

MsgMonitor(wParam, lParam, msg) ; receives command from farm script to start TR and restart farm script
{
	LoadAdventure_automatic()
	sleep,30000
	Briv_Run_Stop_Clicked()
	sleep,1000
	Briv_Run_Clicked()
}

UpdateTRLOG() ; read logs from files
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
BOXvanillaDashWait() ;send dash wait checkbox to Briv farm tab
	{
	global
	Gui, Submit, NoHide
	If VanillaDashWait = 1
		{
		GuiControl,ICScriptHub:, DisableDashWaitCheck, 0
		}
	Else If VanillaDashWait = 0
		{
		GuiControl,ICScriptHub:, DisableDashWaitCheck, 1
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
		GuiControl,ICScriptHub:, VanillaDashWait, % !g_BrivUserSettings[ "DisableDashWait" ]
    }





ViewLogButtonClicked() ; open notepad to view log
	{
	logfilepath=%A_LineFile%\..\trlog.json
	if FileExist(logfilepath)
		{
		Run, notepad.exe %A_LineFile%\..\trlog.json
		}
	else msgbox,, File not found, Empty log?
	}

FixStatsClicked() ;not in use. Forces log updater to start
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
	MsgBox, 4,, Delete StacksLog?
	IfMsgBox Yes
		{
		FileDelete, %A_LineFile%\..\trstacklog.json
		MsgBox StacksLog cleared
		}
	}
	

DelinaButtonClicked() ;button for testing shit
	{
	LoadAdventure_automatic()
    g_SF.RestartAdventure( "TR at world map" )

	}

TR_Save_Clicked() ;save settings
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
        g_BrivUserSettings[ "TRAvoid" ] := TRAvoid
        g_BrivUserSettings[ "DisableDashWait" ] := DisableDashWaitCheck
		if !TRexactStack
        	g_BrivUserSettings[ "TRexactStack" ] := 0
		else
        	g_BrivUserSettings[ "TRexactStack" ] := TRexactStack
		if !TRJumpZone
	    	g_BrivUserSettings[ "TRJumpZone" ] := 0
		else
 	    	g_BrivUserSettings[ "TRJumpZone" ] := TRJumpZone
		
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
	Loop, Read, %A_LineFile%\..\..\IC_BrivGemFarm_Performance\IC_BrivGemFarm_Settings.ahk ;find the included line in settings.ahk
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
			Line .= "`r`n" . A_LoopReadLine ;line found, break
			Break
		}
	}
	If (!Found) ;line not found. Add it and show first run messages
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

TR_Reset_Clicked()
{
	msgbox Restart adventure now?
	IfMsgBox, No
		Return
	IfMsgBox, yes
		msgbox Never gonna give farming up. Wip.
}