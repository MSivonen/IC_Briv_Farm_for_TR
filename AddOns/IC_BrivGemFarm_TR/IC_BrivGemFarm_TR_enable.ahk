global g_BrivUserSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\..\IC_BrivGemFarm_Performance\BrivGemFarmSettings.json" )

	if (g_BrivUserSettings[ "TRHack" ] )
	{
		#include %A_LineFile%\..\IC_BrivGemFarm_TR_Functions.ahk
			g_BrivGemFarm := {}
			global g_BrivGemFarm := new TRClass
		#include %A_LineFile%\..\IC_BrivGemFarm_TR_SF.ahk
			g_SF := {}
			global g_SF := new IC_SharedFunctions_Class_TR
	}