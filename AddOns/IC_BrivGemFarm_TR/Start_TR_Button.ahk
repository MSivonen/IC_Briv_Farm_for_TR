;v0.51
global VersionNumber := "2.00"
global CurrentDictionary := "2.00"

;Local File globals
global OutputLogFile := "idlecombolog.txt"
global SettingsFile := "idlecombosettings.json"
global UserDetailsFile := "userdetails.json"
global CurrentSettings := []
global GameInstallDir := "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\"
global WRLFile := GameInstallDir "IdleDragons_Data\StreamingAssets\downloaded_files\webRequestLog.txt"
global DictionaryFile := "https://raw.githubusercontent.com/dhusemann/idlecombos/master/idledict.ahk"

global ICSettingsFile := A_AppData
StringTrimRight, ICSettingsFile, ICSettingsFile, 7
ICSettingsFile := ICSettingsFile "LocalLow\Codename Entertainment\Idle Champions\localSettings.json"
global GameClient := GameInstallDir "IdleDragons.exe"

;Settings globals
global ServerName := "ps7"
global GetDetailsonStart := 0
global FirstRun := 1
global NoSaveSetting := 0
global SettingsCheckValue := 8 ;used to check for outdated settings file
global NewSettings := JSON.stringify({"servername":"ps7","firstrun":0,"user_id":0,"hash":0,"instance_id":0,"getdetailsonstart":0,"launchgameonstart":0, "NoSaveSetting":0})

;Server globals
global DummyData := "&language_id=1&timestamp=0&request_id=0&network_id=11&mobile_client_version=999"

;User info globals
global UserID := 0
global UserHash := 0
global InstanceID := 0
global UserDetails := []
global ActiveInstance := 0
global CurrentAdventure := ""
global CurrentArea := ""

;GUI globals
global oMyGUI := ""
global OutputText := "Test"
global CurrentTime := ""
global LastUpdated := "No data loaded."

UpdateLogTime()
FileAppend, (%CurrentTime%) IdleCombos v%VersionNumber% started.`n, %OutputLogFile%
FileRead, OutputText, %OutputLogFile%
if (!oMyGUI) {
	oMyGUI := new MyGui()
}
;First run checks and setup
if !FileExist(SettingsFile) {
	FileAppend, %NewSettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Settings file "idlecombosettings.json" created.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	oMyGUI.Update()
}
FileRead, rawsettings, %SettingsFile%
CurrentSettings := JSON.parse(rawsettings)
if !(CurrentSettings.Count() == SettingsCheckValue) {
	FileDelete, %SettingsFile%
	FileAppend, %NewSettings%, %SettingsFile%
	UpdateLogTime()
	FileAppend, (%CurrentTime%) Settings file "idlecombosettings.json" created.`n, %OutputLogFile%
	FileRead, OutputText, %OutputLogFile%
	FileRead, rawsettings, %SettingsFile%
	CurrentSettings := JSON.parse(rawsettings)
	oMyGUI.Update()
}
if FileExist(A_ScriptDir "\webRequestLog.txt") {
	MsgBox, 4, , % "WRL File detected. Use file?"
	IfMsgBox, Yes
	{
		WRLFile := A_ScriptDir "\webRequestLog.txt"
		FirstRun()
	}
}
if !(CurrentSettings.firstrun) {
	FirstRun()
}
if (CurrentSettings.user_id && CurrentSettings.hash) {
	UserID := CurrentSettings.user_id
	UserHash := CurrentSettings.hash
	InstanceID := CurrentSettings.instance_id
	SB_SetText("User ID & Hash ready.")
}
else {
	SB_SetText("User ID & Hash not found!")
}
;Loading current settings
ServerName := CurrentSettings.servername
GetDetailsonStart := CurrentSettings.getdetailsonstart
LaunchGameonStart := CurrentSettings.launchgameonstart
NoSaveSetting := CurrentSettings.NoSaveSetting
if (GetDetailsonStart == "1") {
	GetUserDetails()
}


Update_Clicked()
	{
		GetUserDetails()
		return
	}

Exit_Clicked()
	{
		ExitApp
		return
	}


Save_Settings()
	{
		oMyGUI.Submit()
		CurrentSettings.servername := ServerName
		CurrentSettings.getdetailsonstart := GetDetailsonStart
		CurrentSettings.nosavesetting := NoSaveSetting
		newsettings := JSON.stringify(CurrentSettings)
		FileDelete, %SettingsFile%
		FileAppend, %newsettings%, %SettingsFile%
		SB_SetText("Settings have been saved.")
		return
	}


	LoadAdventure() {
		GetUserDetails()
		
		while !(CurrentAdventure == "-1") {
			MsgBox, 5, , Please end your current adventure first.
			IfMsgBox Cancel
			return
		}
		advtoload := 592
		patrontoload := 0
		InputBox, advtoload, Adventure to Load, Please enter the adventure_id`nyou would like to load.`nTemporal Rift = 592, , 250, 180, , , , , %advtoload%
		if (ErrorLevel=1) {
			return
		}
		if !((advtoload > 0) && (advtoload < 9999)) {
			MsgBox % "Invalid adventure_id: " advtoload
			return
		}
		advparams := DummyData "&patron_tier=0&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance "&adventure_id=" advtoload "&patron_id=" patrontoload
		sResult := ServerCall("setcurrentobjective", advparams)
		GetUserDetails()
		msgbox Selected adventure has been loaded.`nSwitch to bg party and back.
		return
	}

	LoadAdventure_automatic() 
	{
		GetUserDetails()
		
		while !(CurrentAdventure == "-1") {
			MsgBox, 5, , Please end your current adventure first.`nSomething went wrong.
			; IfMsgBox Cancel
			; return
		}
		advtoload := 592
		patrontoload := 0

		advparams := DummyData "&patron_tier=0&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID "&game_instance_id=" ActiveInstance "&adventure_id=" advtoload "&patron_id=" patrontoload
		sResult := ServerCall("setcurrentobjective", advparams)
        while ( WinExist( "ahk_exe IdleDragons.exe" ) ) ; Kill after 10 seconds.
            WinKill
        programLoc := g_UserSettings[ "InstallPath" ] . g_UserSettings ["ExeName" ]
            Run, %programLoc%
		return
	}

	FirstRun() {
		MsgBox, 4, , Get User ID and Hash from webrequestlog.txt?
		IfMsgBox, Yes
		{
			GetIdFromWRL()
			UpdateLogTime()
			FileAppend, (%CurrentTime%) User ID: %UserID% & Hash: %UserHash% detected in WRL.`n, %OutputLogFile%
		}
		else
		{
			MsgBox, 4, , Choose install directory manually?
			IfMsgBox Yes
			{
				FileSelectFile, WRLFile, 1, webRequestLog.txt, Select webRequestLog file, webRequestLog.txt
				if ErrorLevel
					return
				GetIdFromWRL()
				GameInstallDir := SubStr(WRLFile, 1, -67)
				GameClient := GameInstallDir "IdleDragons.exe"
			}	
			else {
				InputBox, UserID, user_id, Please enter your "user_id" value., , 250, 125
				if ErrorLevel
					return
				InputBox, UserHash, hash, Please enter your "hash" value., , 250, 125
				if ErrorLevel
					return
				UpdateLogTime()
				FileAppend, (%CurrentTime%) User ID: %UserID% & Hash: %UserHash% manually entered.`n, %OutputLogFile%
			}
		}
		FileRead, OutputText, %OutputLogFile%
		oMyGUI.Update()
		CurrentSettings.user_id := UserID
		CurrentSettings.hash := UserHash
		CurrentSettings.firstrun := 1
		newsettings := JSON.stringify(CurrentSettings)
		FileDelete, %SettingsFile%
		FileAppend, %newsettings%, %SettingsFile%
		UpdateLogTime()
		FileAppend, (%CurrentTime%) IdleCombos setup completed.`n, %OutputLogFile%
		FileRead, OutputText, %OutputLogFile%
		oMyGUI.Update()
		SB_SetText("User ID & Hash ready.")
	}

	UpdateLogTime() {
		FormatTime, CurrentTime, , yyyy-MM-dd HH:mm:ss
	}

	GetIDFromWRL() {
		FileRead, oData, %WRLFile%
		if ErrorLevel {
			MsgBox, 4, , Could not find webRequestLog.txt file.`nChoose install directory manually?
			IfMsgBox Yes
			{
				FileSelectFile, WRLFile, 1, webRequestLog.txt, Select webRequestLog file, webRequestLog.txt
				if ErrorLevel
					return
				FileRead, oData, %WRLFile%
			}
			else
				return
		}
		FoundPos := InStr(oData, "getuserdetails&language_id=1&user_id=")
		oData2 := SubStr(oData, (FoundPos + 37))
		FoundPos := InStr(oData2, "&hash=")
		StringLeft, UserID, oData2, (FoundPos - 1)
		oData := SubStr(oData2, (FoundPos + 6))
		FoundPos := InStr(oData, "&instance_key=")
		StringLeft, UserHash, oData, (FoundPos - 1)
		oData := ; Free the memory.
		oData2 := ; Free the memory.
		return
	}

	GetUserDetails() {
		Gui, MyWindow:Default
		SB_SetText("Please wait a moment...")
		getuserparams := DummyData "&include_free_play_objectives=true&instance_key=1&user_id=" UserID "&hash=" UserHash
		rawdetails := ServerCall("getuserdetails", getuserparams)
		FileDelete, %UserDetailsFile%
		FileAppend, %rawdetails%, %UserDetailsFile%
		UserDetails := JSON.parse(rawdetails)
		InstanceID := UserDetails.details.instance_id
		CurrentSettings.instance_id := InstanceID
		ActiveInstance := UserDetails.details.active_game_instance_id
		newsettings := JSON.stringify(CurrentSettings)
		FileDelete, %SettingsFile%
		FileAppend, %newsettings%, %SettingsFile%
		ParseAdventureData()
		ParseTimestamps()
		oMyGUI.Update()
		SB_SetText("User details available.")
		return
	}

	ParseAdventureData() {
		bginstance := 0
		for k, v in UserDetails.details.game_instances
		if (v.game_instance_id == ActiveInstance) {
			CurrentAdventure := v.current_adventure_id
			CurrentArea := v.current_area
			CurrentPatron := PatronFromID(v.current_patron_id)
		}
		else if (bginstance == 0){
			BackgroundAdventure := v.current_adventure_id
			BackgroundArea := v.current_area
			BackgroundPatron := PatronFromID(v.current_patron_id)
			bginstance += 1
		}
		else {
			Background2Adventure := v.current_adventure_id
			Background2Area := v.current_area
			Background2Patron := PatronFromID(v.current_patron_id)
		}
		;
		FGCore := "`n"
		BGCore := "`n"
		BG2Core := "`n"
		If (ActiveInstance == 1) {
			bginstance := 2
		}
		Else {
			bginstance := 1
		}
		;
	}

	ParseTimestamps() {
		localdiff := (A_Now - A_NowUTC)
		if (localdiff < -28000000) {
			localdiff += 70000000
		}
		if (localdiff < -250000) {
			localdiff += 760000
		}
		StringTrimRight, localdiffh, localdiff, 4
		localdiffm := SubStr(localdiff, -3)
		StringTrimRight, localdiffm, localdiffm, 2
		if (localdiffm > 59) {
			localdiffm -= 40
		}
		timestampvalue := "19700101000000"
		timestampvalue += UserDetails.current_time, s
		EnvAdd, timestampvalue, localdiffh, h
		EnvAdd, timestampvalue, localdiffm, m
		FormatTime, LastUpdated, % timestampvalue, MMM d`, h:mm tt
		tgptimevalue := "19700101000000"
		tgptimevalue += UserDetails.details.stats.time_gate_key_next_time, s
		EnvAdd, tgptimevalue, localdiffh, h
		EnvAdd, tgptimevalue, localdiffm, m
		FormatTime, NextTGPDrop, % tgptimevalue, MMM d`, h:mm tt
		if (UserDetails.details.stats.time_gate_key_next_time < UserDetails.current_time) {
			Gui, Font, cGreen
			GuiControl, Font, NextTGPDrop
		}
		else {
			Gui, Font, cBlack
			GuiControl, Font, NextTGPDrop
		}
	}

	ServerCall(callname, parameters) {
		URLtoCall := "http://ps7.idlechampions.com/~idledragons/post.php?call=" callname parameters
		WR := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		WR.SetTimeouts("10000", "10000", "10000", "10000")
		Try {
			WR.Open("POST", URLtoCall, false)
			WR.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
			WR.Send()
			WR.WaitForResponse(-1)
			data := WR.ResponseText
		}
		UpdateLogTime()
		FileAppend, (%CurrentTime%) Server request: "%callname%"`n, %OutputLogFile%
		FileRead, OutputText, %OutputLogFile%
		oMyGUI.Update()
		return data
	}


		CustomMsgBox(Title,Message,Font="",FontOptions="",WindowColor="")
		{
			Gui,66:Destroy
			Gui,66:Color,%WindowColor%

			Gui,66:Font,%FontOptions%,%Font%
			Gui,66:Add,Text,,%Message%
			Gui,66:Font

			GuiControlGet,Text,66:Pos,Static1

			Gui,66:Add,Button,% "Default y+10 w75 g66OK xp+" (TextW / 2) - 38 ,OK

			Gui,66:-MinimizeBox
			Gui,66:-MaximizeBox

			SoundPlay,*-1
			Gui,66:Show,,%Title%

			Gui,66:+LastFound
			WinWaitClose
			Gui,66:Destroy
			return

			66OK:
				Gui,66:Destroy
			return
		}

KlehoImage()
{
	campaignid := 0
	currenttimegate := ""
	kleholink := "https://idle.kleho.ru/assets/fb/"
	for k, v in UserDetails.defines.campaign_defines {
		campaignid := v.id
	}
	if (campaignid == 17) {
		for k, v in UserDetails.details.game_instances {
			if (v.game_instance_id == ActiveInstance) {
				currenttimegate := JSON.stringify(v.defines.adventure_defines[1].requirements[1].champion_id)
			}
		}
		campaignid := KlehoFromID(currenttimegate)
	}
	else if !((campaignid < 3) or (campaignid == 15) or (campaignid > 21)) {
		for k, v in UserDetails.details.game_instances {
			if (v.game_instance_id == ActiveInstance) {
				campaignid := campaignid "a" JSON.stringify(v.defines.adventure_defines[1].requirements[1].adventure_id)
			}
		}
	}
	kleholink := kleholink campaignid "/"
	for k, v in UserDetails.details.game_instances {
		if (v.game_instance_id == ActiveInstance) {
			for kk, vv in v.formation {
				if (vv > 0) {
					kleholink := kleholink vv "_"
				}
				else {
					kleholink := kleholink "_"
				}
			}
		}
	}
	StringTrimRight, kleholink, kleholink, 1
	kleholink := kleholink ".png"
	InputBox, dummyvar, Kleho Image, % "Copy link for formation sharing.`n`nSave image to the following file?`nformationimages\Patron-" CurrentPatron "\AdvID-" CurrentAdventure "\Area-" CurrentArea ".png", , , , , , , , % kleholink
	if ErrorLevel {
		dummyvar := ""
		return
	}
	if !(FileExist("\formationimages\")) {
		FileCreateDir, formationimages
	}
	if !(FileExist("\formationimages\Patron-" CurrentPatron)) {
		FileCreateDir, % "formationimages\Patron-" CurrentPatron
	}
	if !(FileExist("\formationimages\Patron-" CurrentPatron "\AdvID-" CurrentAdventure)) {
		FileCreateDir, % "formationimages\Patron-" CurrentPatron "\AdvID-" CurrentAdventure
	}
	UrlDownloadToFile, %kleholink%, % "formationimages\Patron-" CurrentPatron "\AdvID-" CurrentAdventure "\Area-" CurrentArea ".png"
	dummyvar := ""
	return
}


AdventureList() {
	getparams := DummyData "&user_id=" UserID "&hash=" UserHash "&instance_id=" InstanceID
	sResult := ServerCall("getcampaigndetails", getparams)
	campaignresults := JSON.parse(sResult)
	freeplayids := {}
	freeplaynames := {}
	for k, v in campaignresults.defines.adventure_defines {
		freeplayids.push(v.id)
		freeplaynames.push(v.name)
	}
	count := 1
	testvar := "{"
	while (count < freeplayids.Count()) {
		testvar := testvar """" JSON.stringify(freeplayids[count]) """:"
		tempname := JSON.stringify(freeplaynames[count])
		testvar := testvar tempname ","
		count += 1
	}
	StringTrimRight, testvar, testvar, 1
	testvar := testvar "}"
	FileDelete, advdefs.json
	FileAppend, %testvar%, advdefs.json
	MsgBox % "advdefs.json saved to file."
	return
}


Start_TR()
{
	LoadAdventure()
}