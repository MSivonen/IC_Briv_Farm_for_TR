;v0.3

class TRClass extends IC_BrivGemFarm_Class
{
    TestForSteelBonesStackFarming()
    {
			;	    msgbox "TEST TRSTACK modified"

        CurrentZone := g_SF.Memory.ReadCurrentZone()
        stacks := this.GetNumStacksFarmed()
        stackfail := 0
        forcedReset := false
        forcedResetReason := ""
		
		if (g_BrivUserSettings[ "TRHack" ] )
		{
	;Early stacking
		if ( g_BrivUserSettings[ "EarlyStacking" ] AND stacks < g_BrivUserSettings[ "TargetStacks" ] AND CurrentZone > g_BrivUserSettings[ "StackZone" ] AND g_SF.Memory.ReadHasteStacks() > g_BrivUserSettings[ "TRHaste" ]  )
			{
				this.StackFarm()
	            g_SF.DoDashWait( Max(g_SF.ModronResetZone - g_BrivUserSettings[ "DashWaitBuffer" ], 0) )
			}
			
	;End of run stacking		
		if ( g_SF.Memory.ReadHasteStacks() < 50 AND g_SF.Memory.ReadHighestZone() > 10 AND CurrentZone > g_BrivUserSettings[ "MinStackZone" ] )
		{
			this.StackFarm()
			g_SF.RestartAdventure( "TR stack and reset" )
			}
	}

		if (!g_BrivUserSettings[ "TRHack" ] )
		{
	
			; passed stack zone, start stack farm. Normal operation.
			if ( stacks < g_BrivUserSettings[ "TargetStacks" ] AND CurrentZone > g_BrivUserSettings[ "StackZone" ] )
				this.StackFarm()
			else
			{
				; stack briv between min zone and stack zone if briv is out of jumps (if stack fail recovery is on)
				if (g_SF.Memory.ReadHasteStacks() < 50 AND g_SF.Memory.ReadSBStacks() < g_BrivUserSettings[ "TargetStacks" ] AND CurrentZone > g_BrivUserSettings[ "MinStackZone" ] AND g_BrivUserSettings[ "StackFailRecovery" ] AND CurrentZone < g_BrivUserSettings[ "StackZone" ] )
				{
					stackFail := StackFailStates.FAILED_TO_REACH_STACK_ZONE ; 1
					g_SharedData.StackFailStats.TALLY[stackfail] += 1
					this.StackFarm()
				}
				else
				{ 
					; Briv ran out of jumps but has enough stacks for a new adventure, restart adventure
					if ( g_SF.Memory.ReadHasteStacks() < 50 AND stacks > g_BrivUserSettings[ "TargetStacks" ] AND g_SF.Memory.ReadHighestZone() > 10)
					{
						stackFail := StackFailStates.FAILED_TO_REACH_STACK_ZONE_HARD ; 4
						g_SharedData.StackFailStats.TALLY[stackfail] += 1
						forcedReset := true
						forcedResetReason := "Briv ran out of jumps but has enough stacks for a new adventure"
					}
					; stacks are more than the target stacks and party is more than "ResetZoneBuffer" levels past stack zone, restart adventure
					; (for restarting after stacking without going to modron reset level)
					if ( stacks > g_BrivUserSettings[ "TargetStacks" ] AND CurrentZone > g_BrivUserSettings[ "StackZone" ] + g_BrivUserSettings["ResetZoneBuffer"])
					{
						stackFail := StackFailStates.FAILED_TO_RESET_MODRON ; 6
						g_SharedData.StackFailStats.TALLY[stackfail] += 1
						forcedReset := true
						forcedResetReason := " Stacks > target stacks & party > " . g_BrivUserSettings["ResetZoneBuffer"] . " levels past stack zone"
					}
					if(forcedReset)
						g_SF.RestartAdventure(forcedResetReason)
				}
			}
		}
        return stackfail
    }
	
	StackFarm()
    {
        if ( g_BrivUserSettings[ "RestartStackTime" ] AND stacks < g_BrivUserSettings[ "TargetStacks" ] )
            this.StackRestart()
        else if (stacks < g_BrivUserSettings[ "TargetStacks" ])
            this.StackNormal()
        currentFormation := g_SF.Memory.GetCurrentFormation()
        isShandieInFormation := g_SF.IsChampInFormation( 47, currentFormation )
        if ( !g_BrivUserSettings[ "TRHack" ] AND !g_BrivUserSettings[ "DisableDashWait" ] AND isShandieInFormation ) ;AND g_SF.Memory.ReadHighestZone() + 50 < g_BrivUserSettings[ "StackZone"] )
            g_SF.DoDashWait( Max(g_SF.ModronResetZone - g_BrivUserSettings[ "DashWaitBuffer" ], 0) )
    }
}
