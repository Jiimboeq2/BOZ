; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Zimara Breadth: Strungstone Ascent [Solo]"
variable string Heroic_1_Zone_Name="Zimara Breadth: Strungstone Ascent [Heroic I]"
variable string Heroic_2_Zone_Name="Zimara Breadth: Strungstone Ascent [Heroic II]"
variable int DefaultScanRadius="30"
variable int ShiniesLooted="0"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Support_Files_Common/Kordulek_ICFunctions.iss"

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
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_loot_lo_looteverything FALSE TRUE
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
			call This.Named1 "Rubblethrong"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Rubblethrong"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 2.
		if ${_StartingPoint} == 2
		{
			call This.Named2 "Bolagehera"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Bolagehera"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 3.				
		if ${_StartingPoint} == 3
		{
			call This.Named3 "Barlanka"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Barlanka"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 4.

		if ${_StartingPoint} == 4
		{
			call This.Named4 "Crisj'Jen the Bold"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Crisj'Jen the Bold"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}


		
		if ${_StartingPoint} == 5
		{
			call This.Named5 "Fuejenyrus"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: Fuejenyrus"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		

		if ${_StartingPoint} == 6
		{
			Ob_AutoTarget:Clear
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "-242.283844,432.106750,889.289368"
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
    Named 1 **********************    Move to, spawn and kill - Rubblethrong  ********************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-634.902527,205.867599,-526.909790"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "1"
	call move_to_next_waypoint "617.731567,201.674240,-766.535828"
	call move_to_next_waypoint "614.272583,195.113831,-684.101135"
	call move_to_next_waypoint "629.517395,206.511765,-560.547363"

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
 	Named 2 ********************    Move to, spawn and kill - Bolagehera ********************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="790.781494,189.071548,387.040802"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "2"
	call move_to_next_waypoint "790.781494,189.071548,387.040802"
	call move_to_next_waypoint "625.949341,206.747116,-569.715088"
	call move_to_next_waypoint "647.985779,207.478333,-464.141602"

	wait 5
	oc !ci -special igw:${Me.Name}
	wait 35

	call move_to_next_waypoint "714.309998,176.570007,273.679993"
	call move_to_next_waypoint "737.027161,184.310257,314.925293"

	call kill_trash

	call move_to_next_waypoint "747.340332,186.524689,347.649780"
	call move_to_next_waypoint "778.859497,188.151245,348.452209"
		
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
 	Named 3 *********************    Move to, spawn and kill - Barlanka ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="528.28 283.90 553.17"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "3"
	call move_to_next_waypoint "791.552490,189.010483,340.491241"
	call move_to_next_waypoint "710.981750,190.526535,357.606598"
	call move_to_next_waypoint "724.673828,206.152176,433.877930"
	call move_to_next_waypoint "760.713196,227.039993,478.397003"
	call move_to_next_waypoint "751.793701,252.232132,526.157349"
	call move_to_next_waypoint "707.069580,261.404266,532.166382"
	call move_to_next_waypoint "686.739563,269.870697,507.401886"
	call move_to_next_waypoint "722.174927,287.096527,485.689911"

	call move_to_next_waypoint "691.190247,292.675354,520.994080"
	call move_to_next_waypoint "692.309937,277.094482,487.822662"
	call move_to_next_waypoint "700.247437,284.064484,472.898254"
	call move_to_next_waypoint "717.447937,287.117676,497.626862"
	call move_to_next_waypoint "626.729126,281.829041,553.989624"
	call move_to_next_waypoint "583.938843,271.840851,543.145752"
	call move_to_next_waypoint "583.938843,271.840851,543.145752"
	call move_to_next_waypoint "542.834839,279.168427,534.507507"
	Ob_AutoTarget:AddActor["Barlanka",15,FALSE,TRUE]
	
	
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
 	Named 4 *********************    Move to, spawn and kill - Crisj'Jen the Bold ********************************
***********************************************************************************************************/
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="113.925377,373.424347,704.549866"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "4"
	call move_to_next_waypoint "543.17,275.20,602.56"
	call move_to_next_waypoint "509.40,281.13,660.10"
	call move_to_next_waypoint "532.92,277.50,620.83"
	call move_to_next_waypoint "554.84,275.13,566.50"
	call move_to_next_waypoint "526.70,284.40,554.95"
	call move_to_next_waypoint "473.71,308.70,607.87"
	call move_to_next_waypoint "423.02,327.75,627.47"
	call move_to_next_waypoint "388.84,344.09,613.56"
	call move_to_next_waypoint "371.13,360.66,568.47"
	call move_to_next_waypoint "399.95,370.91,544.34"
	call move_to_next_waypoint "430.61,380.89,556.50"
	call move_to_next_waypoint "427.30,382.40,576.35"
	call move_to_next_waypoint "409.69,384.76,579.94"
	call move_to_next_waypoint "343.71,402.33,597.42"
	wait 5
	oc !ci -special igw:${Me.Name}
	wait 35

	call move_to_next_waypoint "153.581924,362.173767,677.004272"
	call move_to_next_waypoint "113.925377,373.424347,704.549866"
	call move_to_next_waypoint "100.453194,379.593384,712.673706"

	wait 5
	oc !ci -special igw:${Me.Name}
	wait 15
	
	
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
 	Named 5 *********************    Move to, spawn and kill - Fuejenyrus ********************************
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-216.564896,432.164246,878.978027"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "5"
	call move_to_next_waypoint "101.88, 378.80, 661.03"
	call move_to_next_waypoint "94.13,382.59,717.34"
	call move_to_next_waypoint "56.99,397.51,733.71"
	call move_to_next_waypoint "39.32,400.98,738.67"
	call move_to_next_waypoint "15.74,402.28,738.02"
	call move_to_next_waypoint "-2.75,399.69,736.93"
	call move_to_next_waypoint "-31.40,387.93,722.42"
	call move_to_next_waypoint "-49.24,386.26,709.85"
	call move_to_next_waypoint "-70.23,394.22,719.01"
	call move_to_next_waypoint "-84.30,401.01,726.87"
	call move_to_next_waypoint "-100.17, 407.37,753.35"
	call move_to_next_waypoint "-135.71, 416.33,784.87"
	call move_to_next_waypoint "-173.11, 405.92,813.93"
	call move_to_next_waypoint "-180.15, 407.23,865.69"
	call move_to_next_waypoint "-201.76, 423.60,900.33"
	call move_to_next_waypoint "-214.91, 430.43,899.87"
	
	
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
