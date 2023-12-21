variable string sZoneShortName="exp05_dun_najena_forge"
variable string sZoneName="The Deep Forge"
; If you want to only get the data about a specific zone, the variable that will hold the return value, MUST be a global collection:string, just like below.
; If you are going to check all the zones and scan them, you do not need this variable.
variable(global) collection:string gcsRetValue
variable(global) int iZoneResetTime=0

;First Named - The Doomsmith
variable point3f DF_FirstSymbolLocation="112.348305,-0.012104,15.766435"
variable point3f DF_SecondSymbolLocation="117.842834,-0.012104,-13.940908"
variable point3f DF_ThirdSymbolLocation="109.134857,-0.422464,-9.154116"
variable point3f DF_FourthSymbolLocation="101.070633,-0.422465,-1.808460"
variable point3f DF_FifthSymbolLocation="125.428520,-0.012312,2.367479"

;Second Named - Cruhm the Overseer
variable point3f DF_Overseer_TankLocation="1.132958,-0.012252,-65.594528"
variable point3f DF_Overseer_GroupLocation="-0.200504,-0.012155,-72.497955"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(int _StartingPoint=0)
{
	;// This creates all the required variables, and calls "RunInstances". 
	call function_Handle_Startup_Process "-NoAutoLoadMapOnZone"
}

;// This is optional. I like it so I can confirm when the file has been exited.
atom atexit()
{
	echo ${Time} \agFinished auto-running ${sZoneName}
}

;// This object definition must be exactly this name.
objectdef Object_Instance
{
    ;// This is our main function. The name must be exactly this.
	function:bool RunInstance(int _StartingPoint=0)
	{        
	call Obj_OgreIH.Obj_OgreTravelMesh.Travel "${sZoneName}" -delay 95
        ;// While you can do anything you want here, this will handle getting into any zone from the mission area. If you'd like to customize it, you're free to do so!
		if ${_StartingPoint} == 0
		{
			; Load Ogre Instance Controller Assister - it handles the internal stuff.
            ogre ica
            wait 2

			echo ${Time} \agStarting to auto-run ${sZoneName} Version 1.4
			
			Obj_OgreIH:Actor_Click["To the Deep Forge"]
			call Obj_OgreUtilities.HandleWaitForZoning
			call Obj_OgreIH.ZoneNavigation.GetIntoZone "${sZoneName}"
            if !${Return}
            {
                Obj_OgreIH:Message_FailedZone
                return FALSE
            }
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_outofcombatscanning",TRUE]
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_settings_disableabilitycollisionchecks",TRUE]
			
			Ogre_Instance_Controller:ZoneSet
		;	Obj_OgreUtilities.OgreNavLib:ChangeLoadingPath["InstanceController"]
			Obj_OgreUtilities.OgreNavLib:LoadMap
			
			call Obj_OgreIH.Set_VariousOptions
			call Obj_OgreIH.Set_PriestAscension FALSE
			OgreBotAPI:AutoTarget_SetScanRadius[igw:${Me.Name}, "30"]

			Obj_OgreIH:Set_NoMove
			_StartingPoint:Inc
		;	 _StartingPoint:Set[3]
		}

        ;// Now it's your turn! Start coding. I've left in an example of a named to give you a starting point.
        if ${_StartingPoint} == 1
		{
			wait 50
			 Me.Inventory["Chrono Dungeons: [Level 130]"]:Use
		 	oc !c -ReplyDialog ${Me.Name} 1
			call This.Named1 "The Doomsmith"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: The Doomsmith"]
				return FALSE
			}
			
			_StartingPoint:Inc
		}
		
        if ${_StartingPoint} == 2
		{
			call This.Named2 "Cruhm the Overseer"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Cruhm the Overseer"]
				return FALSE
			}
			
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Firelord Kaern"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Firelord Kaern"]
				return FALSE
			}
			
			_StartingPoint:Inc
		}
						
		;// Finish zone (zone out)
		if ${_StartingPoint} == 4
		{
            Obj_OgreIH:LetsGo
        	Ob_AutoTarget:Clear
			
			oc !c -cfw igw:${Me.Name} -Evac
			
			wait 50
			call Obj_OgreUtilities.HandleWaitForZoning
			wait 50
			
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_outofcombatscanning",FALSE]
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_settings_disableabilitycollisionchecks",FALSE]
			/*
			;Check if the zone can be reset.
			call This.CheckZoneResetStatus
			if !${Return}
            {             
                return FALSE
            }
			;Reset the zone
			call This.ResetZone
			if !${Return}
            {                
                return FALSE
            }		
			*/
			_StartingPoint:Inc
		}

        return TRUE
    }
	
	
	
	function:bool CheckZoneResetStatus()
	{
		echo ${Time}: Entering CheckZoneResetStatus
		; Populate the information. This will open the zone reuse window and scan it.
		Ogre_Instance_Controller_Assister:PopulateInternalMemory
		wait 2
		while ${Ogre_Instance_Controller_Assister.bPopulateInternalMemoryRunning}
		wait 2
	   
		; Pick how you want the data. Put both options in, but realistically you will only be using 1 at a time.
		call CheckASpecificZone "${sZoneName}"
		
		echo ${Time}: Is the zone able to be reset? [${gcsRetValue.Element["Resettable"]}]
		if !${gcsRetValue.Element["Resettable"]}
		{
			iZoneResetTime:Set[${Math.Calc[${Time.Timestamp}+${gcsRetValue.Element["TimeLeft"]}+5].Int}]
			echo ${Time}: \arWaiting until zone can be reset. [${Math.Calc[${iZoneResetTime}-${Time.Timestamp}].Int} seconds] [${Math.Calc[(${iZoneResetTime}-${Time.Timestamp})/60].Int} minutes]
			while ${Time.Timestamp} < ${iZoneResetTime}
			{
			;	echo ${Time}: Time remaining until reset: [${Math.Calc[${iZoneResetTime}-${Time.Timestamp}].Int} seconds] [${Math.Calc[(${iZoneResetTime}-${Time.Timestamp})/60].Int} minutes]
				wait 50
			}
			
			echo ${Time}: \agZone can now be reset!	
			return TRUE
		}			
	}
	
	function:bool ResetZone()
	{
		echo ${Time}: Entering ResetZone
		if ${Zone.ShortName.Equal["${sZoneShortName}"]} && ${Zone.Name.Equal["${sZoneName}"]}
		{
			echo ${Time}: I am still in ${sZoneName} and I can reset it. Zoning out to reset.
			;I need to zone out before I can reset.
			oc !c -cfw igw:${Me.Name} -Zone
			
			call Obj_OgreUtilities.HandleWaitForZoning
				
			
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone
				return FALSE
			}
			
			wait 100
		}
		
		echo ${Time}: Resetting the zone.
		relay all OgreBotAPI:ResetZone["igw:${Me.Name}","${sZoneName}"]
		
		wait 20
		
		echo ${Time}: Checking to see if the zone reset was successful.
		call This.CheckZoneResetStatus
		if !${Return}
		{
			echo ${Time}: Failed to reset zone.
			oc Failed to reset zone.
			return FALSE
		}
		
		return TRUE
	}

    function:bool Named1(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:LetsGo
        call Obj_OgreIH.Set_Follow
        
        echo ${Time}: Moving to OutsideDoomsmithRoom
        call Obj_OgreUtilities.PreCombatBuff 5
        call Obj_OgreUtilities.NavToLocation "OutsideDoomsmithRoom" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
		
		echo ${Time}: Moving to InsideDoomsmithRoom
		call Obj_OgreUtilities.PreCombatBuff 5
		call Obj_OgreUtilities.NavToLocation "InsideDoomsmithRoom" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
		
		call Obj_OgreUtilities.PreCombatBuff 5
		
        echo ${Time} Targeting The Doomsmith
		Ob_AutoTarget:AddActor["${_NamedNPC}",0,FALSE,FALSE]
        Obj_OgreIH:SetCampSpot
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}"
		wait 50
		call chestSummon
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 20
		Obj_OgreIH:LetsGo
		
		echo ${Time}: Moving to PullDoomsmithAdds
        call Obj_OgreUtilities.NavToLocation "PullDoomsmithAdds" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2

		echo ${Time}: Clean up any mobs left
		oc !c -CampSpot igw:${Me.Name}
		oc !c -ChangeCampSpotWho igw:${Me.Name} 117.176422 -0.034396 14.530641
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40

		oc !c -ChangeCampSpotWho igw:${Me.Name} 101.463791 -0.295121 11.265581
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40

		call chestSummon
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 20
		Obj_OgreIH:LetsGo
		
		call This.LightSymbols

        return TRUE
    }
	
	function LightSymbols()
	{
		;Move to first symbol
		oc !c -CampSpot ${Me.Name}
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_FirstSymbolLocation.X} ${DF_FirstSymbolLocation.Y} ${DF_FirstSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50
		call This.ClickSymbol
		
		;Move to second symbol
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_FifthSymbolLocation.X} ${DF_FifthSymbolLocation.Y} ${DF_FifthSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_SecondSymbolLocation.X} ${DF_SecondSymbolLocation.Y} ${DF_SecondSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50
		call This.ClickSymbol
		
		;Move to third symbol
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_ThirdSymbolLocation.X} ${DF_ThirdSymbolLocation.Y} ${DF_ThirdSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50		
		call This.ClickSymbol
		
		;Move to fourth symbol
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_FourthSymbolLocation.X} ${DF_FourthSymbolLocation.Y} ${DF_FourthSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50		
		call This.ClickSymbol
		
		;Move to fifth symbol
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_SecondSymbolLocation.X} ${DF_SecondSymbolLocation.Y} ${DF_SecondSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50
		oc !c -ChangeCampSpotWho ${Me.Name} ${DF_FifthSymbolLocation.X} ${DF_FifthSymbolLocation.Y} ${DF_FifthSymbolLocation.Z}
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
        call Obj_OgreUtilities.HandleWaitForCombat 40
		wait 50		
		call This.ClickSymbol
	}
	
	function ClickSymbol()
	{
		variable index:actor Index
		variable iterator Iter
		
		EQ2:GetActors[Index,range,15]
		Index:GetIterator[Iter]
			
		if ${Iter:First(exists)}
		{
			do
			{
				;;Find the symbol. You should be closer than 15m to it.
				if ${Iter.Value.Type.Equals["NoKill NPC"]} && ${Iter.Value.Interactable}
				{
					Actor[id,${Iter.Value.ID}]:DoubleClick	
					wait 30
				
					break
				}
			}
			while ${Iter:Next(exists)}
		}	
	}
	
    function:bool Named2(string _NamedNPC="Doesnotexist")
	{
		Obj_OgreIH:LetsGo
		
        call Obj_OgreUtilities.NavToLocation "TightTurn0" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
        call Obj_OgreUtilities.NavToLocation "TightTurn1" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
        call Obj_OgreUtilities.NavToLocation "TightTurn2" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat

        echo move to SetupForOverseer
		call Obj_OgreUtilities.PreCombatBuff 5
        call Obj_OgreUtilities.NavToLocation "SetupForOverseer" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		;Prepare to pull the named.
		call Obj_OgreUtilities.PreCombatBuff 8
		oc !c -CampSpot igw:${Me.Name}
		oc !c -ChangeCampSpotWho igw:${Me.Name} ${DF_Overseer_TankLocation.X} ${DF_Overseer_TankLocation.Y} ${DF_Overseer_TankLocation.Z}
		oc !c -ChangeCampSpotWho igwbn:${Me.Name} ${DF_Overseer_GroupLocation.X} ${DF_Overseer_GroupLocation.Y} ${DF_Overseer_GroupLocation.Z}
		Ob_AutoTarget:AddActor["${_NamedNPC}",0,FALSE,FALSE]
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}" 
        wait 80

		if ${Actor[${_NamedNPC}](exists)}
		{
			echo ${Time}: Waiting for ${_NamedNPC} to not exist.
			while ${Actor[${_NamedNPC}](exists)}
				waitframe
		}		

		call chestSummon
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 20

        return TRUE
    }
	
    function:bool Named3(string _NamedNPC="Doesnotexist")
	{	
		Obj_OgreIH:LetsGo

        call Obj_OgreUtilities.NavToLocation "TightTurn3" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
        call Obj_OgreUtilities.NavToLocation "TightTurn4" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat

        call Obj_OgreUtilities.NavToLocation "TightTurn5" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to OutsideKeyMobRoom
        call Obj_OgreUtilities.NavToLocation "OutsideKeyMobRoom" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to InsideKeyMobRoom
		call Obj_OgreUtilities.PreCombatBuff 8
        call Obj_OgreUtilities.NavToLocation "InsideKeyMobRoom" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to Bridge1		
        call Obj_OgreUtilities.NavToLocation "Bridge1" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to Bridge2		
        call Obj_OgreUtilities.NavToLocation "Bridge2" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to ValveEast		
        call Obj_OgreUtilities.NavToLocation "ValveEast" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		wait 20
		oc !c -Special igw:${Me.Name}
		wait 30
		
		echo move to ValveWest		
        call Obj_OgreUtilities.NavToLocation "ValveWest" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		wait 20
		oc !c -Special igw:${Me.Name}
		wait 30
		
		echo move to RoamingMobs		
        call Obj_OgreUtilities.NavToLocation "RoamingMobs" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo ${Time}: Waiting 60 seconds to make sure that I kill the roaming mobs before attacking the Firelord.
		wait 600
		
		echo move to SetupForFirelord
		call Obj_OgreUtilities.PreCombatBuff 8
        call Obj_OgreUtilities.NavToLocation "SetupForFirelord" 3
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		Ob_AutoTarget:AddActor["${_NamedNPC}",0,FALSE,FALSE]
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}" 
        wait 300
		
		if ${Actor[${_NamedNPC}](exists)}
		{
			echo ${Time}: Waiting for ${_NamedNPC} to not exist.
			while ${Actor[${_NamedNPC}](exists)}
				waitframe
		}	

		call chestSummon
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 20		
		
		call Obj_OgreUtilities.HandleWaitForGroupDistance 2
        call Obj_OgreUtilities.HandleWaitForCombat
		
		echo move to VoidShardChest		
		oc !c -CampSpot ${Me.Name} 5 200
		oc !c -ChangeCampSpotWho ${Me.Name} ${Actor["Najena's Treasure"].X} ${Actor["Najena's Treasure"].Y} ${Actor["Najena's Treasure"].Z}
        wait 200		

        return TRUE
    }
	
    function chestSummon_old()
    {
        if ${Me.IsMoving}
        {
            while ${Me.IsMoving}
                waitframe
        }
        
        echo ${Time}: Summoning chests in range.
		eq2execute summon
		wait 60
    }

	function chestSummon()
    {
        variable int actorID=0
        variable int lastActorID=0
        variable int chestTypeCounter=1
        variable string chestName="BLANK"
        variable bool failure=FALSE
        variable bool moveToLootNeeded=FALSE
        variable bool isOgreBotCampspotChecked=FALSE
        variable point3f previousCampspotLocation="0,0,0"

        if ${Me.IsMoving}
        {
            while ${Me.IsMoving}
                waitframe
        }

        while ${chestTypeCounter} <= 4
        {
            if ${chestTypeCounter} == 1
                chestName:Set["Exquisite Chest"]
            if ${chestTypeCounter} == 2
                chestName:Set["Ornate Chest"]
            if ${chestTypeCounter} == 3
                chestName:Set["Treasure Chest"]
            if ${chestTypeCounter} == 4
                chestName:Set["Small Chest"]

            failure:Set[FALSE]

            if ${Actor[query, Name = "${chestName}" && Type = "chest" && Distance <= 20](exists)}
            {
                actorID:Set[${Actor[query, Name = "${chestName}" && Type = "chest"].ID}] 

                echo ${Time}: DEBUG: ${actorID} == ${lastActorID}
                if ${actorID} == ${lastActorID}
                {
                    echo ${Time}: It appears to be stuck on the same chest, skipping chest type.
                    chestTypeCounter:Inc
                    continue
                }

                ;Attempt to summon the chest if it's further away than 2m.
                if ${Math.Distance[${Me.Loc},${Actor[id,${actorID}].Loc}]} > 2
                {
                    echo ${Time}: Summoning [${chestName}] - ${actorID} from ${Math.Distance[${Me.Loc},${Actor[id,${actorID}].Loc}]}m away.
                    Eq2Execute apply_verb ${actorID} Summon
                    wait 40
                }

                ;Check if the attempt to summon was successful.
                echo ${Time}: If chest summon was successful, the distance to the chest should be less than 2m. Exists? [${Actor[id,${actorID}](exists)}] Distance: [${Math.Distance[${Me.Loc},${Actor[id,${actorID}].Loc}]}]
                if ${Actor[id,${actorID}](exists)} && ${Math.Distance[${Me.Loc},${Actor[id,${actorID}].Loc}]} > 2
                {                       
                    if !${Actor[id,${actorID}].CheckCollision}
                    {
                        moveToLootNeeded:Set[TRUE]
                        
                        if ${UIElement[${OBUI_checkbox_donotsave_dynamiccampspot}].Checked}
                        {
                            isOgreBotCampspotChecked:Set[TRUE]
                            previousCampspotLocation:Set[${Me.Loc}]
                        }
                        else
                        {
                            isOgreBotCampspotChecked:Set[FALSE]
                            previousCampspotLocation:Set[${Me.Loc}]
                            oc !c -CampSpot ${Me.Name} 
                        }
                        
                        oc !c -ChangeCampSpotWho ${Me.Name} ${Actor[id,${actorID}].X} ${Actor[id,${actorID}].Y} ${Actor[id,${actorID}].Z}
                        
                        wait 10
                        if ${Me.IsMoving}
                        {
                            while ${Me.IsMoving}
                                waitframe
                        }

                        wait 20                                              
                    }
                    else
                    {
                        echo ${Time}: Can't move to [${chestName}] - ${actorID} because a collision has been detected.
                        failure:Set[TRUE]
                    } 

                    lastActorID:Set[${actorID}]                   
                }

                if !${failure} && ${Actor[id,${actorID}](exists)} && ${Math.Distance[${Me.Loc},${Actor[id,${actorID}].Loc}]} <= 2
                {
                    echo ${Time}: Opening [${chestName}] - ${actorID}.
                    Eq2Execute apply_verb ${actorID} Open

                    if ${moveToLootNeeded}
                    {
                        if ${isOgreBotCampspotChecked}
                        {
                            oc !c -ChangeCampSpotWho ${Me.Name} ${previousCampspotLocation.X} ${previousCampspotLocation.Y} ${previousCampspotLocation.Z}
                            wait 10
                            if ${Me.IsMoving}
                            {
                                while ${Me.IsMoving}
                                    waitframe
                            }
                        }
                        else
                        {
                            oc !c -ChangeCampSpotWho ${Me.Name} ${previousCampspotLocation.X} ${previousCampspotLocation.Y} ${previousCampspotLocation.Z}
                            wait 10
                            if ${Me.IsMoving}
                            {
                                while ${Me.IsMoving}
                                    waitframe                                
                            }

                            oc !c -LetsGo ${Me.Name}
                        } 
                    }                     
                }                
            }
            else
            {
                chestTypeCounter:Inc
            }

            wait 20
        }  

        wait 60     
    }

	function CheckASpecificZone(string _ZoneName)
	{
		; Use a reference to shorten the typing!
		variable persistentref ICARef
		ICARef:SetReference["Script[${OgreInstanceControllerAssisterScriptName}].VariableScope.Obj_OgreUtilities.Obj_ZoneReset"]

		if ${ICARef.Get_ZoneData_GV[gcsRetValue,"${_ZoneName}"]}
		{
			echo Same zone (${_ZoneName}): ${Zone.Name.Equal["${_ZoneName}"]}
			echo IsSet ${gcsRetValue.Element["IsSet"]}
			echo Resettable ${gcsRetValue.Element["Resettable"]}
			echo TimeLeft ${gcsRetValue.Element["TimeLeft"]}
			echo TextTimeLeft ${gcsRetValue.Element["TextTimeLeft"]}
		}
		else
			echo GetZoneData was false
	}
	}
