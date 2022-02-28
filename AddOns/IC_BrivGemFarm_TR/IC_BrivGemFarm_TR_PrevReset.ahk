;v0.46

class TR_Prev_Reset
{
	getPrevReset() ; return last line of file
	{
		Loop, read, addons\IC_BrivGemFarm_TR\trlog.json
		{
			last_line := A_LoopReadLine
		}
	return last_line
	}	
	
	getLogFile()
	{
	   FileRead text, addons\IC_BrivGemFarm_TR\trlog.json
	   Loop Parse, text, `n
		return text
	}
		
	setPrevReset(lvl) ; write last line of file, delete first line, if over 100 lines
	{
		FilePath := "%A_LineFile%\..\..\IC_BrivGemFarm_TR\trlog.json"
		if FileExist(FilePath)
			{
			FileAppend, `n%lvl%, % FilePath
			}
		Else
			{
			FileAppend, %lvl%, % FilePath
			}

		FileRead, LogFile, % FilePath

		nLines := InStr(LogFile, "`n",,, 1000) ; max 1000 lines
		if (nLines)
		{
			NewLogFile := SubStr(LogFile, InStr(LogFile, "`n") + 1)
			FileDelete, % FilePath
			FileAppend, % NewLogFile, % FilePath
		}
	}
	
	getAVG()
	{
	   FileRead text, addons\IC_BrivGemFarm_TR\trlog.json
	   Loop Parse, text, `n
		lines++
	   Loop Parse, text, `n
	   {
		  If (A_Index < lines - 10)
			 Continue
		  L = %L%`n%A_Loopfield%
	   }
	   StringTrimLeft L, L, 1
	   	loop, parse, L, `n
				{
			if A_LoopField <>
			{
				sum += A_LoopField
				count += 1
			}
		}
		return floor(sum / count)
	}
}

class TR_Prev_Stacks
{
	getPrevReset() ; return last line of file
	{
		Loop, read, addons\IC_BrivGemFarm_TR\trStackLog.json
		{
			last_line := A_LoopReadLine
		}
	return last_line
	}	
	
	getLogFile()
	{
	   FileRead text, addons\IC_BrivGemFarm_TR\trStackLog.json
	   Loop Parse, text, `n
		return text
	}
		
	setPrevReset(lvl) ; write last line of file, delete first line, if over 100 lines
	{
		FilePath := "%A_LineFile%\..\..\IC_BrivGemFarm_TR\trStackLog.json"
		if FileExist(FilePath)
			{
			FileAppend, `n%lvl%, % FilePath
			}
		Else
			{
			FileAppend, %lvl%, % FilePath
			}

		FileRead, LogFile, % FilePath

		nLines := InStr(LogFile, "`n",,, 1000) ; max 1000 lines
		if (nLines)
		{
			NewLogFile := SubStr(LogFile, InStr(LogFile, "`n") + 1)
			FileDelete, % FilePath
			FileAppend, % NewLogFile, % FilePath
		}
	}
	
	getAVG()
	{
	   FileRead text, addons\IC_BrivGemFarm_TR\trStackLog.json
	   Loop Parse, text, `n
		lines++
	   Loop Parse, text, `n
	   {
		  If (A_Index < lines - 10)
			 Continue
		  L = %L%`n%A_Loopfield%
	   }
	   StringTrimLeft L, L, 1
	   	loop, parse, L, `n
				{
			if A_LoopField <>
			{
				sum += A_LoopField
				count += 1
			}
		}
		return floor(sum / count)
	}
}


class SecondCounter {
    __New() {
        this.interval := 10000
        this.count := 0
        this.timer := ObjBindMethod(this, "Tick")
    }
    Start() {
        timer := this.timer
        SetTimer % timer, % this.interval
    }
    Stop() {
        timer := this.timer
        SetTimer % timer, Off
    }
    Tick() {
		global
		prevRST = % PrevRSTobject.getPrevReset()
		GuiControl,ICScriptHub:,PrevTXT, % prevRST
		
		avgRST = % PrevRSTobject.getAVG()
		GuiControl,ICScriptHub:,AvgTXT, % avgRST

		prevStacks = % PrevStacksObject.getPrevReset()
		GuiControl,ICScriptHub:,PrevStacksTXT, % prevStacks
		
		AvgStacks = % PrevStacksObject.getAVG()
		GuiControl,ICScriptHub:,AvgStacksTXT, % avgStacks
    }
}