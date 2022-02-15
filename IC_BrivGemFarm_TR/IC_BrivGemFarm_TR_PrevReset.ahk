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
		
	setPrevReset(lvl) ; write last line of file, delete first line, if over 10 lines
	{
		FilePath := "%A_LineFile%\..\..\IC_BrivGemFarm_TR\trlog.json"
		FileAppend, `n%lvl%, % FilePath
		FileRead, LogFile, % FilePath

		nLines := InStr(LogFile, "`n",,, 10) ; max 10 lines
		if (nLines)
		{
	;	msgbox ifnlines
			NewLogFile := SubStr(LogFile, InStr(LogFile, "`n") + 1)
			FileDelete, % FilePath
			FileAppend, % NewLogFile, % FilePath
		}
	}
	
	getAVG()
	{
	fileread, variable, addons\IC_BrivGemFarm_TR\trlog.json
	loop, parse, variable, `n
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