;v0.472

class IC_SharedFunctions_Class_TR extends IC_BrivSharedFunctions_Class ; extends IC_SharedFunctions_Class ; note to self: do not extend the wrong class you british word for donkey
{


    BenchBrivConditions(settings)
     {
         if (g_BrivUserSettings[ "TRAvoid" ] AND mod(g_SF.Memory.ReadCurrentZone(),5) != g_BrivUserSettings[ "TRJumpZone" ] ) ;Decide between walk or jump to next level
            return true

        if (g_BrivUserSettings[ "TRexactStack" ] > 0 AND g_SF.Memory.ReadCurrentZone() <= g_BrivUserSettings[ "StackZone" ] +1)
            if (g_SF.Memory.ReadCurrentZone() >= g_BrivUserSettings[ "StackZone" ] - g_BrivUserSettings[ "TRexactStack" ] AND g_SF.Memory.ReadCurrentZone() AND g_BrivUserSettings[ "EarlyStacking" ] )
                return true
        ;bench briv if jump animation override is added to list and it isn't a quick transition (reading ReadFormationTransitionDir makes sure QT isn't read too early)
        if (this.Memory.ReadTransitionOverrideSize() == 1 AND this.Memory.ReadTransitionDirection() != 2 AND this.Memory.ReadFormationTransitionDir() == 3 )
            return true
        ;bench briv if avoid bosses setting is on and on a boss zone
        if (settings[ "AvoidBosses" ] AND !Mod( this.Memory.ReadCurrentZone(), 5 ))
            return true
        ;perform no other checks if 'Briv Jump Buffer' setting is disabled
        if !(settings[ "BrivJumpBuffer" ])
            return false
        ;bench briv if within the 'Briv Jump Buffer'-supposedly this reduces chances of failed conversions by having briv on bench during modron reset.
        maxSwapArea := this.ModronResetZone - settings[ "BrivJumpBuffer" ]
        if (this.Memory.ReadCurrentZone() >= maxSwapArea)
            return true 


        return false
    }

    ; True/False on whether Briv should be unbenched based on game conditions.
    UnBenchBrivConditions(settings)
    {
        if (g_BrivUserSettings[ "TRAvoid" ] AND mod(g_SF.Memory.ReadCurrentZone(),5) != g_BrivUserSettings[ "TRJumpZone" ] ) ;Decide between walk or jump to next level
            return false
        if (g_BrivUserSettings[ "TRexactStack" ] > 0 AND g_SF.Memory.ReadCurrentZone() <= g_BrivUserSettings[ "StackZone" ] +1)
            if (g_SF.Memory.ReadCurrentZone() >= g_BrivUserSettings[ "StackZone" ] - g_BrivUserSettings[ "TRexactStack" ] AND g_SF.Memory.ReadCurrentZone() AND g_BrivUserSettings[ "EarlyStacking" ] )
                return false
       
        ;keep Briv benched if 'Avoid Bosses' setting is enabled and on a boss zone
        if (settings[ "AvoidBosses" ] AND !Mod( this.Memory.ReadCurrentZone(), 5 ))
            return false
        ;unbench briv if 'Briv Jump Buffer' setting is disabled and transition direction is "OnFromLeft"
        if (!(settings[ "BrivJumpBuffer" ]) AND this.Memory.ReadFormationTransitionDir() == 0)
            return true
        ;perform no other checks if 'Briv Jump Buffer' setting is disabled
        else if !(settings[ "BrivJumpBuffer" ])
            return false
        ;keep briv benched if within the 'Briv Jump Buffer'-supposedly this reduces chances of failed conversions by having briv on bench during modron reset.
        maxSwapArea := this.ModronResetZone - settings[ "BrivJumpBuffer" ]
        if (this.Memory.ReadCurrentZone() >= maxSwapArea)
            return false
        ;unbench briv if outside the 'Briv Jump Buffer' and a jump animation override isn't added to the list
        else if (this.Memory.ReadTransitionOverrideSize() != 1)
            return true

        return false
    } 

}