; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Vaashkaani: Golden Rule [Solo]"
variable string Heroic_1_Zone_Name="Vaashkaani: Golden Rule [Heroic I]"  
; i think that's an H1 it has , will circle back
variable string Heroic_2_Zone_Name="x"
variable int DefaultScanRadius="30"
variable int ShiniesLooted="0"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(int _StartingPoint=0, ... Args)
{
call function_Handle_Startup_Process ${_StartingPoint} "-NoAutoLoadMapOnZone" ${Args.Expand}
}
atom atexit()
{
	echo ${Time}: ${Script.Filename} done
}
objectdef Object_Instance
{
	function:bool RunInstance(int _StartingPoint=0)
	{
		oc !ci -LetsGo igw:${Me.Name}
		Obj_OgreIH:SetCampSpot
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_movetoarea TRUE TRUE
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name} textentry_setup_moveintomeleerangemaxdistance 20 TRUE
		if ${Zone.Name.Equals["${Solo_Zone_Name}"]}
		{
			Obj_InstanceControllerXML:Set_ICFileOption[1,"Graceless on Boss Only"]
			Obj_InstanceControllerXML:ChangeUIOptionViaCode["ic_file_option_1",TRUE]
		}
		
		if ${_StartingPoint} == 0
		{
	call Obj_OgreIH.ZoneNavigation.GetIntoZone "${sZoneName}"
		
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone
				return FALSE
			}
			Ogre_Instance_Controller:ZoneSet
			call Obj_OgreIH.Set_VariousOptions
			call Obj_OgreIH.Set_PriestAscension FALSE
			Obj_OgreIH:Set_NoMove
			Obj_OgreIH:SetCampSpot
			call Obj_OgreUtilities.PreCombatBuff 5
			_StartingPoint:Inc

;	Change starting point below to start script after a certain named. (for debugging only)		
			_StartingPoint:Set[0]
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 1.

		if ${_StartingPoint} == 1
		{
			call This.Named1 "Nezri En'Sallef"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Nezri En'Sallef"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 2.				
		if ${_StartingPoint} == 2
		{
			call This.Named3 "Isos"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Isos"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		

		; 	Enter name and shinies nav point for Named 3.
		if ${_StartingPoint} == 3
		{
			call This.Named2 "The Storm Mistress"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: The Storm Mistress"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

; 	Enter name and shinies nav point for Named 4.				
		if ${_StartingPoint} == 4
		{
			call This.Named3 "Hezodhan"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Hezodhan"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}


		; 	Enter name and shinies nav point for Named 6.				
		if ${_StartingPoint} == 5
		{
			call This.Named3 "Ashnu"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: Ashnu"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		
; 	Enter /loc for the zone out	and change _StartingPoint == 

		if ${_StartingPoint} == 6
		{
			Ob_AutoTarget:Clear
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "592.834717,71.106186,-54.819336"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 5
			oc ${Me.Name} looted ${ShiniesLooted} shinies
			call Obj_OgreIH.ZoneNavigation.ZoneOut
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZoneOut
				return FALSE
			}
			_StartingPoint:Inc
		}
		return TRUE
	}



/**********************************************************************************************************
    Named 1 **********************    Move to, spawn and kill - Nezri En'Sallef  ********************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="145.784149,20.303329,-0.008304"
	Ob_AutoTarget:AddActor["Nezri En'Sallef",10,FALSE,TRUE]

; 	Move to named and spawn
	echo ${Me.Equipment[primary].ToItemInfo.Condition}
	wait 5
	if ${Me.Equipment[primary].ToItemInfo.Condition} < 50
	{
		call mend_and_rune_swap "stun"
	}
	call HO "All"

	call move_to_next_waypoint "-63.853203,3.085319,0.848909"
	call move_to_next_waypoint "-32.192711,3.252077,-30.456238"
	call move_to_next_waypoint "-15.910347,10.125579,-36.401478"
    call move_to_next_waypoint "-7.987914,13.233233,-35.427891"
    call move_to_next_waypoint "-0.990818,16.244753,-32.399117"
    call move_to_next_waypoint "5.867332,19.375635,-27.625574"
    call move_to_next_waypoint "7.898909,19.871166,-17.817272"
    call move_to_next_waypoint "9.470225,19.917973,-0.266956"
    call move_to_next_waypoint "120.931931,20.296247,0.382850"

	call initialise_move_to_next_boss "${_NamedNPC}" "1"

	call move_to_next_waypoint "11.864040,19.921078,0.348867"



	

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}
	
;	Check named is dead
	if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}

/**********************************************************************************************************
 	Named 2 ********************    Move to, spawn and kill - Isos  ********************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="262.198151,31.245022,58.916054"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "2"
	call move_to_next_waypoint "209.316299,31.504650,-0.151778"
	call move_to_next_waypoint "210.761063,31.596615,-9.813629"
    call move_to_next_waypoint "213.432541,31.245022,52.049480" 
	wait 50
	 call move_to_next_waypoint "224.365341,32.562355,45.469532"
	oc !ci -special igw:${Me.Name}
	wait 50

	call move_to_next_waypoint "224.365341,32.562355,45.469532"
	wait 50
	oc !ci -special igw:${Me.Name}
	wait 50

	call move_to_next_waypoint "212.496948,31.245022,42.624424" 
    call move_to_next_waypoint "213.071732,31.777447,10.870465" 
	call move_to_next_waypoint "222.739456,31.504650,1.152017"
	call move_to_next_waypoint "211.412064,31.438419,-26.274744"
	call move_to_next_waypoint "214.244415,31.245022,-44.421112"
	call move_to_next_waypoint "223.009338,32.181305,-44.738777"
	oc !ci -special igw:${Me.Name}
	wait 50
	call move_to_next_waypoint "203.683121,32.214455,-44.644077"
	oc !ci -special igw:${Me.Name}
	wait 50
    call move_to_next_waypoint "203.492325,32.222984,-44.860386"
    call move_to_next_waypoint "218.625458,31.504650,-6.464325"
	call move_to_next_waypoint "223.949478,31.504650,0.332479"
	call move_to_next_waypoint "261.783325,31.504650,-1.642059"
	call move_to_next_waypoint "261.654205,31.421638,-61.202709"
    call move_to_next_waypoint "261.486786,31.797768,9.345303"
	call move_to_next_waypoint "261.155304,31.449314,22.364616"
 
	
	Ob_AutoTarget:AddActor["Isos",20,FALSE,TRUE]
;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}
	
;	Check named is dead
	if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
	call move_to_next_waypoint "261.314362,31.816750,62.314568"
	oc !ci -special igw:${Me.Name}
	wait 50
}


/**********************************************************************************************************
 	Named 3 *********************    Move to, spawn and kill -The Storm Mistress  ********************************
	 

***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="261.988464,31.245022,-48.247028"
;	TODO ADD CAMPSPOT TO MOST RECENT LIGHTNING BOI
	call HO "All"

; 	Move to named and spawn
    call move_to_next_waypoint "260.585815,31.982433,62.767784"
    oc !ci -special igw:${Me.Name}
	call initialise_move_to_next_boss "${_NamedNPC}" "3"

	call mend_and_rune_swap "stifle"

	call move_to_next_waypoint "261.636658,31.786743,-18.954660"
	oc !ci -special igw:${Me.Name}

	call HO "All"

    Ob_AutoTarget:AddActor["Lightning Anchor",10,FALSE,TRUE]
	Ob_AutoTarget:AddActor["The Storm Mistress",10,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}
	
;	Check named is dead
	if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
	call move_to_next_waypoint "263.070831,31.612640,-61.744865"
	oc !c -special igw:${Me.Name}
	wait 50
}


/**********************************************************************************************************
 	Named 4 *********************    Move to, spawn and kill - Hezodhan ********************************
***********************************************************************************************************/

function:bool Named4(string _NamedNPC="Doesnotexist")
{


	call HO "All"

    call move_to_next_waypoint "265.614044,31.245022,-61.440887"

  	oc !ci -special igw:${Me.Name}

	variable point3f KillSpot="438.740540,6.816512,-0.284076"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "4"

	call move_to_next_waypoint "261.123199,31.504650,0.623502"
	call move_to_next_waypoint "280.255615,31.613644,-0.273382"
      	oc !ci -special igw:${Me.Name}
        wait 35

	call move_to_next_waypoint "380.126831,3.510479,-12.840424"
    call move_to_next_waypoint "401.180450,3.516983,0.296043"
    call move_to_next_waypoint "401.180450,3.516983,0.296043"


	Ob_AutoTarget:AddActor["Hezodhan",10,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}
	
;	Check named is dead
	if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}

 /**********************************************************************************************************
 	Named 5 *********************    Move to, spawn and kill - Ashnu + Sovereign dude ********************************
	 
	 			 ;kill adds or wipe
				
***********************************************************************************************************/

	
function:bool Named5(string _NamedNPC="Doesnotexist")
{

	call mend_and_rune_swap "fear"
	wait 95
	call HO "All"

    call move_to_next_waypoint "612.219299,71.106140,-45.708889"
  	oc !ci -special igw:${Me.Name}
    wait 40

	variable point3f KillSpot="438.740540,6.816512,-0.284076"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "5"

	call move_to_next_waypoint "367.322815,31.608864,-0.063050"
	call move_to_next_waypoint "338.425751,31.492619,-0.661140"
	call move_to_next_waypoint "331.130646,31.491600,-9.379161"
    call move_to_next_waypoint "304.570740,31.491615,-7.727015"
    call move_to_next_waypoint "397.374725,71.326294,-0.377002"

    call move_to_next_waypoint "411.318085,71.326294,17.277493"
    oc !ci -special igw:${Me.Name}
    wait 15
    call move_to_next_waypoint "506.010010,71.370003,17.629999"
    call move_to_next_waypoint "522.697876,71.370186,16.471838"
    call move_to_next_waypoint "602.011841,71.343628,0.576221"
    call move_to_next_waypoint "601.322021,71.120644,-42.030811"
     oc !ci -special igw:${Me.Name}
    wait 150

    call move_to_next_waypoint "602.447998,71.106018,-45.514637"

	Ob_AutoTarget:AddActor["Zakir-Sar-Ussur",10,FALSE,TRUE]
	Ob_AutoTarget:AddActor["Ashnu",10,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}
	
;	Check named is dead
	if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
    
}

/**********************************************************************************************************
 	 **********************    Jobs done! ***********************************
***********************************************************************************************************/


/***********************************************************************************************************
***********************************************  FUNCTIONS  ************************************************    
************************************************************************************************************/

function mend_and_rune_swap(string adorn)
{
	if (!${Obj_OgreIH.DuoMode} && !${Obj_OgreIH.SoloMode})
	{
		oc Using your tank's repair bot.
		oc !ci -UseItem igw:${Me.Name}+fighter "Mechanized Platinum Repository of Reconstruction"
		wait 70
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Tank's repair bot not available, trying your bard.
			oc !ci -UseItem igw:${Me.Name}+bard "Mechanized Platinum Repository of Reconstruction"
		wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Bard's repair bot not available, trying your chanter.
			oc !ci -UseItem igw:${Me.Name}+enchanter "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Chanter's repair bot not available, trying your priests.
			oc !ci -UseItem igw:${Me.Name}+shaman "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Chanter's repair bot not available, trying your priests.
			oc !ci -UseItem igw:${Me.Name}+cleric "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Chanter's repair bot not available, trying your priests.
			oc !ci -UseItem igw:${Me.Name}+druid "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Priest's repair bot not available, trying your scouts.
			oc !ci -UseItem igw:${Me.Name}+scout "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		if !${Actor[Query,Name=="Mechanized Platinum Repository of Reconstruction"](exists)}
		{
			oc Scout's repair bot not available, trying your mages.
			oc !ci -UseItem igw:${Me.Name}+mage "Mechanized Platinum Repository of Reconstruction"
			wait 50
		}
		oc !ci -repair igw:${Me.Name}
		wait 40
		oc !ci -ChangeBeltAdorn igw:${Me.Name} "${adorn}"
		wait 80
	}
}

function initialise_move_to_next_boss(string _NamedNPC, int startpoint)
{
	oc ${Me.Name} is moving to ${_NamedNPC} [${startpoint}].
	oc !ci -OgreFollow igw:${Me.Name} ${Me.Name} 2
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nostuns FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nodazes FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nostifles FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nointerrupts FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nofears FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_nodispels FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_npc_cast_monitoring TRUE TRUE
	eq2execute summon
	wait 5
	Obj_OgreIH:SetCampSpot
	call Obj_OgreUtilities.PreCombatBuff 5
	wait 30
	if ${Obj_OgreIH.SoloMode}
	{
		eq2execute merc resume
		wait 30
		eq2execute merc ranged
		eq2execute merc backoff
	}
}

function move_to_next_waypoint(point3f waypoint, int ScanRadius)
{
	oc !ci -resume igw:${Me.Name}
	oc !ci -letsgo igw:${Me.Name}
	variable float Return_X="0"
    variable float Return_Y="0"
    variable float Return_Z="0"
    if ${ScanRadius}==0
    {
        ScanRadius:Set[${DefaultScanRadius}]
    }
	Obj_OgreIH:SetCampSpot
	oc !ci -target ${Me.Name} ${Me.Name}
	Obj_OgreIH:ChangeCampSpot["${waypoint}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -notarget ${Me.Name}
	wait 10 
	if ${Me.InCombat}
	{
		call kill_trash
	}
	if ${Actor[Query,Name=="?" && Distance < ${ScanRadius}](exists)} && !${Ogre_Instance_Controller.bSkipShinies}
	{
		Return_X:Set[${Me.X}]
		Return_Y:Set[${Me.Y}]
		Return_Z:Set[${Me.Z}]
		Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="?"].ID}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		call Obj_OgreUtilities.HandleWaitForCombat
		while ${Actor[Query,Name=="?" && Distance < 20](exists)}
		{
			Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="?"].ID}"]
			call Obj_OgreUtilities.HandleWaitForCampSpot 5
			Actor[Query,Name=="?"]:DoTarget
			wait 1
			Actor[Query,Name=="?"]:DoubleClick
			wait 20
		}
		ShiniesLooted:Inc
		oc ${Me.Name} ninjas a shiny [${ShiniesLooted} so far]
		Obj_OgreIH:ChangeCampSpot["${Return_X},${Return_Y},${Return_Z}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
	}
	if ${Me.InCombat}
	{
		call kill_trash
	}
	call Obj_OgreUtilities.HandleWaitForGroupDistance 5
}

function kill_trash()
{
	oc !ci -PetOff igw:${Me.Name}
	call Obj_OgreUtilities.HandleWaitForCampSpot 5
	relay all eq2execute pet autoassist
	if (!${Obj_OgreIH.DuoMode} && !${Obj_OgreIH.SoloMode})
	{
		oc !ci -LetsGo igw:${Me.Name}+scout
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+scout checkbox_settings_movemelee TRUE TRUE
	}
	call Obj_OgreUtilities.HandleWaitForCombat
	oc !ci -campspot igw:${Me.Name}
	oc !ci -ChangeCampSpotWho igw:${Me.Name} ${Me.X} ${Me.Y} ${Me.Z}
	call Obj_OgreUtilities.WaitWhileGroupMembersDead
	call Obj_OgreUtilities.HandleWaitForGroupDistance 5
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+scout checkbox_settings_movemelee FALSE TRUE
	wait 10
}

function prepull(point3f PrePullSpot)
{
	Obj_OgreIH:SetCampSpot
	Obj_OgreIH:ChangeCampSpot["${PrePullSpot}"]
	call Obj_OgreUtilities.PreCombatBuff 5
	wait 40
}

function Tank_n_Spank(string _NamedNPC, point3f KillSpot)
{
	variable int iCount="0"
	oc ${Me.Name} is pulling ${_NamedNPC}
	Obj_OgreIH:SetCampSpot
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -PetOff igw:${Me.Name}
	wait 10
	relay all eq2execute pet autoassist
	Actor["${_NamedNPC}"]:DoTarget
	wait 50
	while ${Actor[Query,Name=="${_NamedNPC}" && Type != "Corpse"].ID(exists)}
	{
		if ${Actor[Query,Name=="${_NamedNPC}" && Distance > 7](exists)}
		{
			while ${Actor[Query,Name=="${_NamedNPC}" && Distance > 5](exists)} && ${iCount} < 15
			{
				iCount:Inc
				wait 10
			}
		}
		if (!${Obj_OgreIH.DuoMode} && !${Obj_OgreIH.SoloMode})
		{
			Obj_OgreIH:CCS_Actor_Position["${Actor[Query,Name=="${_NamedNPC}"].ID}"]
			wait 100
		}
	}
	call Obj_OgreUtilities.HandleWaitForCombat
	call Obj_OgreUtilities.WaitWhileGroupMembersDead
	wait 50
}


function HO(string Mode)
{
	switch ${Mode}

	{
		case Disable
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_start FALSE TRUE
			break
		case All
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_start TRUE TRUE
			break
		case Scout
			oc Scout HO set.
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+scout checkbox_settings_ho_start TRUE TRUE
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+notscout checkbox_settings_ho_start FALSE TRUE
			break
		case Priest	
			oc Priest HO set.
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+priest checkbox_settings_ho_start TRUE TRUE
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+notpriest checkbox_settings_ho_start FALSE TRUE
			break
		case Mage
			oc Mage HO set.
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+mage checkbox_settings_ho_start TRUE TRUE
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+notmage checkbox_settings_ho_start FALSE TRUE
			break
		case Fighter
			oc Fighter HO set.
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+fighter checkbox_settings_ho_start TRUE TRUE
			oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+notfighter checkbox_settings_ho_start FALSE TRUE
			break
		default
			wait 1
	}

	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_starter TRUE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_ho_wheel TRUE TRUE
	wait 1
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+@healer1 checkbox_settings_ho_starter FALSE TRUE
	oc !ci -ChangeOgreBotUIOption igw:${Me.Name}+@healer1 checkbox_settings_ho_wheel FALSE TRUE
}
}
