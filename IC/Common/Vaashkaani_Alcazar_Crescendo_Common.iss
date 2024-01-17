; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Vaashkaani: Alcazar Crescendo [Solo]"
variable string Heroic_1_Zone_Name="Vaashkaani: Alcazar Crescendo [Heroic I]"
variable string Heroic_2_Zone_Name="X"
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
			call This.Named1 "Khazinehdar Zuhraasa"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Khazinehdar Zuhraasa"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 2.			
		if ${_StartingPoint} == 2
		{
			call This.Named2 "Zakir-Sar-Ussur"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Zakir-Sar-Ussur"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 3.

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Kapuji-bashi Haakhaz"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Kapuji-bashi Haakhaz"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 4.

		if ${_StartingPoint} == 4
		{
			call This.Named4 "General Ra'Zaal"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: General Ra'Zaal"]
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
			call Obj_OgreUtilities.NavToLoc "103.040222,7.944616,-316.740021"
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


		;is the chicken script even needed?  -- it didnt seem to do any thing.

/**********************************************************************************************************
    Named 1 ******************    Move to, spawn and kill - Khazinehdar Zuhraasa  *************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="600.30, 71.11, -47.85"

; 	Move to named and spawn
	echo ${Me.Equipment[primary].ToItemInfo.Condition}
	wait 5
	if ${Me.Equipment[primary].ToItemInfo.Condition} < 50
	{
		call mend_and_rune_swap "stun"
	}
	call initialise_move_to_next_boss "${_NamedNPC}" "1"
	call move_to_next_waypoint "522.19,71.37, 17.97"
	call move_to_next_waypoint "521.25,71.37, -1.33"
	call move_to_next_waypoint "552.55,71.39, 0.08"
	call move_to_next_waypoint "553.48,71.40, -25.52"
	call move_to_next_waypoint "553.42,71.83, -53.23"
	call move_to_next_waypoint "553.12,71.40, -18.95"
	call move_to_next_waypoint "553.52,71.40, 17.34"
	call move_to_next_waypoint "553.81,71.17, 43.69"
	call move_to_next_waypoint "554.17,71.36, 20.83"
	call move_to_next_waypoint "554.28,71.33, 1.57"
	call move_to_next_waypoint "571.25,71.32, -1.20"
	call move_to_next_waypoint "601.23,71.34, -1.50"
	call move_to_next_waypoint "600.30,71.11, -47.85"
	call move_to_next_waypoint "602.60,71.34, 0.38"
	call move_to_next_waypoint "602.60,71.36, 29.49"
	call move_to_next_waypoint "602.60,71.11, 38.81"

	Ob_AutoTarget:AddActor["Khazinehdar Zuhraasa",50,FALSE,TRUE]

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
 	Named 2 *************    Move to, spawn and kill - Zakir-Sar-Ussur  ************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="842.31, 70.20, -0.74"

; 	Move to named and spawn

	call initialise_move_to_next_boss "${_NamedNPC}" "2"
	call move_to_next_waypoint "600.30,71.11,-47.85"
	call move_to_next_waypoint "603.19,71.34,-0.33"
	call move_to_next_waypoint "622.58,71.32,-0.82"
	call move_to_next_waypoint "624.01,71.39,-0.85"

    wait 5
    oc !ci -special igw:${Me.Name}
    wait 15
	
	call move_to_next_waypoint "624.01,71.39,-0.85"
	call move_to_next_waypoint "683.16,71.32,-0.03"
	call move_to_next_waypoint "698.94,71.32,-0.03"
	call move_to_next_waypoint "701.71,71.39,-31.80"
	call move_to_next_waypoint "701.97,71.32,3.27"
	call move_to_next_waypoint "701.99,71.39,30.28"
	call move_to_next_waypoint "701.78,71.32,1.21"
	call move_to_next_waypoint "722.12,71.41,-0.06"
	call move_to_next_waypoint "756.83,70.75,-0.08"
	call move_to_next_waypoint "790.40,71.38,-0.53"
	call move_to_next_waypoint "802.13,70.41,28.45"
	call move_to_next_waypoint "822.40,71.32,47.47"
	call move_to_next_waypoint "855.04,70.41,46.30"
	call move_to_next_waypoint "880.06,71.37,31.24"
	call move_to_next_waypoint "889.37,70.41,-0.06"
	call move_to_next_waypoint "881.38,71.31,-28.10"
	call move_to_next_waypoint "855.84,70.41,-46.55"
	call move_to_next_waypoint "824.54,71.38,-49.15"
	call move_to_next_waypoint "853.78,70.41,-47.29"
	call move_to_next_waypoint "880.75,71.37,-31.49"
	call move_to_next_waypoint "888.82,70.41,-0.22"
	call move_to_next_waypoint "888.93,70.41,0.23"

    wait 5
    oc !ci -special igw:${Me.Name}
    wait 15
	call move_to_next_waypoint "828.69, 70.04, 0.14"

	Ob_AutoTarget:AddActor["Zakir-Sar-Ussur",20,FALSE,TRUE]
;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		wait 250
		while ${Me.InCombat}
			oc !c Useitem igw:${Me.Name} "Glorious Maestra's Cithara"
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
 	Named 3 **********    Move to, spawn and kill - Kapuji-bashi Haakhaz  ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="376.98,22.92,-356.55"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "3"
	
	call move_to_next_waypoint "847.87,70.11,-13.22"
	call move_to_next_waypoint "847.87,70.11,-13.22"
	
	wait 5
    oc !ci -special igw:${Me.Name}
    wait 15

	call move_to_next_waypoint "224.90,35.44,-320.77"
	call move_to_next_waypoint "224.90,35.44,-355.78"
	call move_to_next_waypoint "249.66,35.48,-355.85"
	call move_to_next_waypoint "295.90,24.29,-356.54"
	call move_to_next_waypoint "296.59,24.29,-372.31"
	call move_to_next_waypoint "310.99,24.29,-398.53"
	call move_to_next_waypoint "320.81,20.85,-373.48"
	call move_to_next_waypoint "328.06,20.85,-365.40"
	call move_to_next_waypoint "353.03,20.85,-353.17"
	call move_to_next_waypoint "376.98,22.92,-356.55"

	Actor[Query,Name=="Lyrissa Nostrolo"]:DoTarget
	while ${Actor[Query,Name=="Lyrissa Nostrolo"].Distance} > 5
	{
		Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="Lyrissa Nostrolo"].ID}"]
		wait 5
		Actor[Query,Name=="Lyrissa Nostrolo"]:DoubleClick
		Actor[Query, Name == "Lyrissa Nostrolo" && Type == "NoKill NPC"]:Hail
	}
	Actor[Query,Name=="Lyrissa Nostrolo"]:DoubleClick
	Actor[Query, Name == "Lyrissa Nostrolo" && Type == "NoKill NPC"]:Hail
	wait 50

	Ob_AutoTarget:AddActor["Kapuji-bashi Haakhaz",20,FALSE,TRUE]
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
 	Named 4 ******************    Move to, spawn and kill - General Ra'Zaal ********************************
	 
	 			 ;kill adds or wipe
				; TODO call HO's and use on adds other wise they repop
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="336.15, 20.87, -355.79"

	Actor[Query,Name=="Vahravi"]:DoubleClick
	Actor[Query, Name == "Vahravi" && Type == "NoKill NPC"]:Hail
	wait 50

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "5"
	call move_to_next_waypoint "367.44, 20.85, -337.61"
	call move_to_next_waypoint "343.45, 20.85, -354.23"
	call move_to_next_waypoint "336.15, 20.87, -355.79"

	wait 10
	Actor[Query,Name=="General Ra'Zaal"]:DoTarget
	while ${Actor[Query,Name=="General Ra'Zaal"].Distance} > 5
	{
		Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="General Ra'Zaal"].ID}"]
		wait 5
		Actor[Query,Name=="General Ra'Zaal"]:Hail
	}
	Actor[Query,Name=="General Ra'Zaal"]:DoubleClick
	Obj_OgreIH:ChangeCampSpot["${SoloKillSpot}"]
	while ${Actor[Query, Name=="${_NamedNPC}" && Type=="NoKill NPC"].ID(exists)}
	{
		wait 20
		
		Actor[Query, Name == "General Ra'Zaal" && Type == "NoKill NPC"]:Hail
		Actor[Query, Name == "General Ra'Zaal" && Type == "NoKill NPC"]:DoubleClick
	}
	
	call move_to_next_waypoint "82.233963,7.944616,-300.831512"
	Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="${_NamedNPC}"].ID}"]
	wait 50

	Ob_AutoTarget:AddActor["Ra'Zaal's ghul",20,FALSE,TRUE]
	Ob_AutoTarget:AddActor["General Ra'Zaal",20,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]}
	{
		call HO "All"
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
