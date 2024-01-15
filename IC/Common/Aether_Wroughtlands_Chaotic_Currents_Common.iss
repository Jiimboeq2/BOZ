
;	variable bool CheckState=
;	CheckState:Set[${TabConfig.Settings.checkbox_settings_npc_cast_monitoring}]
;	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_npc_cast_monitoring ${CheckState} TRUE


; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Aether Wroughtlands: Chaotic Currents [Solo]"
variable string Heroic_1_Zone_Name="Aether Wroughtlands: Chaotic Currents [Event Heroic I]"
variable string Named1="Satashi the Staggering"
variable string Named2="Vashtu the Volatile"
variable string Named3="Etosh the Electrifying"
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
	Ob_AutoTarget:Clear
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["ic_file_option_1",FALSE]
	Obj_OgreIH:ChangeCastStackListBoxItem["Open Wounds", TRUE]
	oc !ci -LetsGo igw:${Me.Name}
	call Obj_Kord.HO "Disable" TRUE
	echo ${Time}: ${Script.Filename} done
}
objectdef Object_Instance
{
	function:bool RunInstance(int _StartingPoint=0)
	{
		oc !ci -LetsGo igw:${Me.Name}
		Obj_OgreIH:SetCampSpot
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_movetoarea TRUE TRUE
		oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_loot_lo_looteverything FALSE TRUE
		
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
		}
		
;	Change IC File Option Buttons
/*
		Obj_InstanceControllerXML:Set_ICFileOption[1,"Button Description"]
;		${Ogre_Instance_Controller.bICFileOption_1}
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["ic_file_option_1",TRUE]
*/	
		
;	Graceless on Last Boss
/*
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]}
	{
		Obj_InstanceControllerXML:Set_ICFileOption[1,"Graceless on Boss Only"]
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["ic_file_option_1",TRUE]
	}
*/

; 	Enter name of Named 1.
		if ${_StartingPoint} == 1
		{
			call This.Named1 "${Named1}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: ${Named1}"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name of Named 2.
		if ${_StartingPoint} == 2
		{
			call This.Named2 "${Named2}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: ${Named2}"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name of Named 3.				
		if ${_StartingPoint} == 3
		{
			call This.Named3 "${Named3}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: ${Named3}"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
; 	Enter /loc for the zone out	and change _StartingPoint == 4 for Event Heroic	
		if ${_StartingPoint} == 4
		{
			Ob_AutoTarget:Clear
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc ""
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
    Named 1 *******************    Move to, spawn and kill - Satashi the Staggering  **********************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-457.456177,277.410370,611.056030"

; 	Move to named and spawn
	
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	
;	Check if already killed
	if ${Actor[Query,Name=="portal_from_1_to_2" && Interactable=TRUE].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}
;	call Obj_Kord.Mend_and_rune_swap "stun"
	call Obj_Kord.Move_to_next_waypoint "-451.296906,253.363602,612.929871"
	if !${Actor[Query,Name=="portal_to_top_01" && Interactable=TRUE].ID(exists)}
	{
		Obj_OgreIH:ChangeCampSpot["-461.540466,253.187531,641.629639"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-456.213013,253.566162,610.438049"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-435.914215,252.230072,638.530273"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-441.100494,253.286774,609.291809"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-456.996704,253.570557,610.676453"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-476.618805,252.499191,620.667358"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-450.102356,253.545731,610.736328"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
	}
	wait 50
	if !${Actor[Query,Name=="portal_to_top_01" && Interactable=TRUE].ID(exists)}
	{
		oc !ci -LetsGo igw:${Me.Name}
		Messagebox "Something went wrong, manually activate the portal."
	}
	call Obj_Kord.Move_to_next_waypoint "-470.067657,252.949631,602.256165"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "portal_to_top_01" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-468.640015,277.670013,604.950012"
	oc !ci -resume igw:${Me.Name}

;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		oc ${Me.Name} is pulling ${_NamedNPC}
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Actor["${_NamedNPC}"]:DoTarget
		wait 50
		oc !ci -SetCS_InFrontNPC "igw:${Me.Name}+fighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		oc !ci -SetCS_BehindNPC "igw:${Me.Name}+notfighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 50
	}
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}

/**********************************************************************************************************
 	Named 2 ****************    Move to, spawn and kill - Vashtu the Volatile *****************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-614.048584,279.654541,754.318848"

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-416.150848,252.733017,603.571106"
	call Obj_Kord.Move_to_next_waypoint "-448.069092,253.560822,612.366577"
	call Obj_Kord.Move_to_next_waypoint "-452.355499,252.949539,636.353149"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "portal_from_1_to_2" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-468.640015,277.670013,604.950012"
	oc !ci -resume igw:${Me.Name}
	call Obj_Kord.Move_to_next_waypoint "-613.409973,255.610001,763.309998"
;	Check if already killed
	if ${Actor[Query,Name=="portal_from_2_to_3" && Interactable=TRUE].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}
;	call Obj_Kord.Mend_and_rune_swap "fear"
	if !${Actor[Query,Name=="portal_to_top_02" && Interactable=TRUE].ID(exists)}
	{
		Obj_OgreIH:ChangeCampSpot["-627.661682,254.869659,787.176880"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-610.553955,255.607758,762.362976"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-603.001953,254.893021,807.482788"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-611.281494,255.607758,762.666687"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-584.992737,255.647064,783.116577"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-616.473633,255.607330,761.453308"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
	}
	wait 50
	if !${Actor[Query,Name=="portal_to_top_02" && Interactable=TRUE].ID(exists)}
	{
		oc !ci -LetsGo igw:${Me.Name}
		Messagebox "Something went wrong, manually activate the portal."
	}
	call Obj_Kord.Move_to_next_waypoint "-613.933838,255.204285,741.772278"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "portal_to_top_02" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-616.460022,279.920013,745.000000"
	oc !ci -resume igw:${Me.Name}

;	Check if already killed
	if !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		oc ${Me.Name} is pulling ${_NamedNPC}
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Actor["${_NamedNPC}"]:DoTarget
		wait 50
		oc !ci -SetCS_InFrontNPC "igw:${Me.Name}+fighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		oc !ci -SetCS_BehindNPC "igw:${Me.Name}+notfighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 50
	}
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}

/**********************************************************************************************************
 	Named 3 *********************    Move to, spawn and kill - Etosh the Electrifying *********************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-747.374817,279.206146,670.438904"
	Ob_AutoTarget:AddActor["a shocking left",0,FALSE,FALSE]
	Ob_AutoTarget:AddActor["a stunning right",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.Move_to_next_waypoint "-583.589966,255.025146,772.689636"
	call Obj_Kord.Move_to_next_waypoint "-613.454773,255.607758,763.441040"
	call Obj_Kord.Move_to_next_waypoint "-630.874390,255.215103,777.728516"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "portal_from_2_to_3" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-754.739990,255.160004,673.190002"
	oc !ci -resume igw:${Me.Name}
	if !${Actor[Query,Name=="portal_to_top_03" && Interactable=TRUE].ID(exists)}
	{
		Obj_OgreIH:ChangeCampSpot["-748.462280,255.628052,722.381775"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-753.412903,255.159042,670.303284"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-777.008240,253.735382,697.921753"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-751.426697,255.341492,671.823608"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
		Obj_OgreIH:ChangeCampSpot["-782.793945,254.451080,661.957397"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Spawn_Ick
		Obj_OgreIH:ChangeCampSpot["-751.076172,255.158997,674.366943"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Kill_Ick
	}
	wait 50
	if !${Actor[Query,Name=="portal_to_top_03" && Interactable=TRUE].ID(exists)}
	{
		oc !ci -LetsGo igw:${Me.Name}
		Messagebox "Something went wrong, manually activate the portal."
	}
	call Obj_Kord.Move_to_next_waypoint "-733.932800,254.745499,667.806030"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "portal_to_top_03" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-737.429993,279.470001,667.409973"
	oc !ci -resume igw:${Me.Name}

;	Check if already killed
	if !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.HO "All"
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		call Obj_Kord.HO "Scout"
		oc ${Me.Name} is pulling ${_NamedNPC}
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Actor["${_NamedNPC}"]:DoTarget
		wait 50
		oc !ci -SetCS_InFrontNPC "igw:${Me.Name}+fighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		oc !ci -SetCS_BehindNPC "igw:${Me.Name}+notfighter" "${Actor[Query,Name=="${_NamedNPC}"].ID}" 4
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 50
	}
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}
}

function Spawn_Ick()
{
	if ${Actor[Query,Name=="a silver ick" && Distance < 6].ID(exists)}
	{
		relay all eq2execute pet backoff
		wait 10
		Actor[Query,Name=="a volatile current" && Type=="NPC"]:DoTarget
		while !${Actor[Query,Name=="a volatile current" && Distance < 9].ID(exists)} && !${Actor[Query,Name=="an overcharged silver ick" && Distance < 9].ID(exists)}
		{
			Actor[Query,Name=="a volatile current" && Type=="NPC"]:DoTarget
			wait 20
		}
		relay all eq2execute pet autoassist
		while !${Actor[Query,Name=="an overcharged silver ick" && Distance < 9].ID(exists)}
		{
			wait 20
		}
		wait 30
		oc !ci -target ${Me.Name} ${Me.Name}
	}
}

function Kill_Ick()
{
	Actor[Query,Name=="an overcharged silver ick"]:DoTarget
	relay all eq2execute pet backoff
	while ${Actor[Query,Name=="an overcharged silver ick" && Distance > 9 && Type=="NPC"].ID(exists)}
	{
		wait 20
	}
	wait 5
	relay all eq2execute pet autoassist
	while ${Actor[Query,Name=="an overcharged silver ick" && Type=="NPC"].ID(exists)}
	{
		wait 20
	}
	oc !ci -target ${Me.Name} ${Me.Name}
}