; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Vaashkaani: Argent Sanctuary [Solo]"
variable string Heroic_1_Zone_Name="Vaashkaani: Argent Sanctuary [Heroic I]"
variable string Heroic_2_Zone_Name="Vaashkaani: Argent Sanctuary [Heroic II]"
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
			call This.Named1 "Tazir Tanziri"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Tazir Tanziri"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 2.			
		if ${_StartingPoint} == 2
		{
			call This.Named2 "Akharys"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Akharys"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 3.

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Uah'Lu the Unhallowed"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Uah'Lu the Unhallowed"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		

		; 	Enter name and shinies nav point for Named 4.
		if ${_StartingPoint} == 4
		{
			call This.Named4 "Xuxuquaxul"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Xuxuquaxul"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

; 	Enter name and shinies nav point for Named 5.				
		if ${_StartingPoint} == 5
		{
			call This.Named5 "General Ra'Zaal"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: General Ra'Zaal"]
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
    Named 1 ******************    Move to, spawn and kill - Tazir Tanziri  ********************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="99.71,3.53,-0.06"

; 	Move to named and spawn
	echo ${Me.Equipment[primary].ToItemInfo.Condition}
	wait 5
	if ${Me.Equipment[primary].ToItemInfo.Condition} < 50
	{
		call mend_and_rune_swap "stun"
	}
	call initialise_move_to_next_boss "${_NamedNPC}" "1"
	call move_to_next_waypoint "-75.22,3.61,0.26"
	call move_to_next_waypoint "-46.65,3.03,-16.65"
	call move_to_next_waypoint "-27.89,3.13,-28.40"
	call move_to_next_waypoint "-10.72,3.01,-33.76"
	call move_to_next_waypoint "18.10,2.96,-28.93"
	call move_to_next_waypoint "28.23,3.49,-27.27"
	call move_to_next_waypoint "45.53,3.50,-14.37"
	call move_to_next_waypoint "54.11,3.53,-2.26"
	call move_to_next_waypoint "80.66,3.53,-0.31"

	Ob_AutoTarget:AddActor["a silver shard",100,FALSE,TRUE]
	Ob_AutoTarget:AddActor["Tazir Tanziri",50,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	Obj_OgreIH:AutoTarget_SetScanRadius[100]
	Actor[Query,Name=="Tazir Tanziri"]:DoTarget
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 1
	wait 10
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	oc ${Me.Name} is pulling ${_NamedNPC}
	wait 50
	while ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		while ${Actor[Query,Name=="a silver shard"].ID(exists)} 
		{
			Actor[Query,Name=="a silver shard"]:DoTarget
			Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="a silver shard" && Distance > 15].ID}"]
			call Obj_OgreUtilities.HandleWaitForCampSpot 1
			oc !ci -CS_Set_Formation_Circle igw:${Me.Name}+NotFighter 7 ${Me.X} ${Me.Y} ${Me.Z}
			wait 10
		}
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 1
		if ${Actor[Query,Name=="${_NamedNPC}" && Distance > 25](exists)}
		{
			Obj_OgreIH:CCS_Actor["${Actor[Query,Name=="${_NamedNPC}"].ID}"]
			call Obj_OgreUtilities.HandleWaitForCampSpot 1
		}
		wait 10
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
 	Named 2 *************    Move to, spawn and kill - Sansobog + Akharys  ********************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="213.794464,3.451207,57.732517"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "2"
	call move_to_next_waypoint "112.694412,3.533185,-1.904541"
	call move_to_next_waypoint "140.268066,3.533128,0.657942"
	call move_to_next_waypoint "164.962845,3.755733,0.256476"
	call move_to_next_waypoint "168.011673,3.755733,20.326904"
	call move_to_next_waypoint "176.874268,3.755733,20.621941"
	call move_to_next_waypoint "189.234619,3.750598,0.261821"
	call move_to_next_waypoint "214.373856,3.457151,0.076444"
	call move_to_next_waypoint "213.926468,3.451166,42.877728"

	Ob_AutoTarget:AddActor["Sansobog",20,FALSE,TRUE]
	Ob_AutoTarget:AddActor["Akharys",20,FALSE,TRUE]
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
 	Named 3 **********    Move to, spawn and kill - Uah'Lu the Unhallowed  ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="262.723999,3.451161,-44.062378"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "3"
	call move_to_next_waypoint "213.794464,3.451207,57.732517"
	call move_to_next_waypoint "214.363159,3.457150,-0.438490"
	call move_to_next_waypoint "255.721802,3.457150,-0.367512"
	call move_to_next_waypoint "263.713379,3.451005,-22.190277"

	Ob_AutoTarget:AddActor["a fallen",20,FALSE,TRUE]
	Ob_AutoTarget:AddActor["Uah'Lu the Unhallowed",20,FALSE,TRUE]
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
 	Named 4 *********************    Move to, spawn and kill - Xuxuquaxul  ********************************
	 
	 			 ;possibly have to swap runes to fear ? -- it's not terrible , but is annoying
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="88.594643,11.429982,-185.822891"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "4"
	call move_to_next_waypoint "262.789215,3.744644,-16.424225"
	call move_to_next_waypoint "276.530853,3.454931,-0.844003"
	call move_to_next_waypoint "295.983673,3.645917,0.096400"
	wait 5
	Actor["portal_to_aviary"]:DoubleClick
	wait 25

	call mend_and_rune_swap "stun"

	wait 95

	call move_to_next_waypoint "-56.669998,26.580000,-247.220001"
	call move_to_next_waypoint "-18.168152,11.883893,-247.220001"
	call move_to_next_waypoint "65.216095,11.784368,-199.326691"

	Ob_AutoTarget:AddActor["Xuxuquaxul",20,FALSE,TRUE]

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
 	Named 5 ******************    Move to, spawn and kill - General Ra'Zaal ********************************
	 
	 			 ;kill adds or wipe
				; TODO call HO's and use on adds other wise they repop
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="99.749557,7.944616,-305.060638"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "5"
	call move_to_next_waypoint "103.113686,7.944616,-255.433548"
	call move_to_next_waypoint "82.233963,7.944616,-300.831512"

	call move_to_next_waypoint "82.233963,7.944616,-300.831512"
	call move_to_next_waypoint "99.749557,7.944616,-305.060638"

	call HO "All"
	wait 20
	
	call move_to_next_waypoint "82.233963,7.944616,-300.831512"
	call move_to_next_waypoint "99.749557,7.944616,-305.060638"

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

;function chimken()
;	{
;    if ${Actor["an unwell wisher"].Distance} <= 5
	;	{
   ;         oc ${Me.Name} - saving the dude
    ;        Actor[${Actor["an unwell wisher"]}]:DoubleClick
;			wait 25
	;		ogre qh1
	;	}
 ;   }

function EnterPortal(string PortalName, string Command, ... Args)
{
	variable int iCounter
	variable bool bMoveToPortal=TRUE

	for ( iCounter:Set[1] ; ${iCounter} <= ${Args.Used} ; iCounter:Inc )
	{
		switch ${Args[${iCounter}]}
		{
			; Some "portals" front is not in a good spot, so move ahead of time, then use this function to click it.
			case -NoMove
				bMoveToPortal:Set[FALSE]
			break
		}
	}

	oc !ci -runwalk igw:${Me.Name}

	if ${bMoveToPortal}
	{
		Obj_OgreIH:SetCampSpot
		oc !ci -SetCS_InFrontNPC "igw:${Me.Name}" "${Actor[Query,Name=="${PortalName}"].ID}" 1
	}
	call Obj_OgreUtilities.HandleWaitForCampSpot 10

	; lets make sure everyone is near by (if this cases a problem because this is being used for a single person to do running, it can be removed or added as a -flag)
	call Obj_OgreUtilities.HandleWaitForGroupDistance 5
	wait 10
	; Apparently a lot of portals you can't use them if you're in combat
	call Obj_OgreUtilities.HandleWaitForCombat "-wait" 20

	; Clear campspot so after rwe get through the portal, we don't move.
	Obj_OgreIH:ClearCampSpot
	Obj_OgreIH:Set_NoMove
	; Because this command is queued into Ogrebot, we need to wait for people to finish their casting. We should be generious with how much time that could take.
	oc !ci -ApplyVerbQueuedForWho igw:${Me.Name} "${PortalName}" "${Command}"
	wait 50
	oc !ci -runwalk igw:${Me.Name}

	; I'm not sure where we should leave this, with campspot on? off?
	; In this file, the following call is always move_to_next and that issues a new campspot. Which is good. Leaving this for now (which, as it is above, has campspot cleared)
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
