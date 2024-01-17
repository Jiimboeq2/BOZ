
;	variable bool CheckState=
;	CheckState:Set[${TabConfig.Settings.checkbox_settings_npc_cast_monitoring}]
;	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_npc_cast_monitoring ${CheckState} TRUE


; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Splendor Sky Aerie: Vale Invasion [Solo]"
variable string Heroic_1_Zone_Name="Splendor Sky Aerie: Vale Invasion [Event Heroic I]"
variable string Named1="Magmalatorr"
variable string Named2="Tkesh'Tura"
variable string Named3="Kusala'Din"
variable int DefaultScanRadius="30"
variable int ShiniesLooted="0"
variable int iCount="0"

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
			call Obj_OgreUtilities.NavToLoc "-1097.067139,181.800201,738.052368"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 5
;			oc ${Me.Name} looted ${ShiniesLooted} shinies
			call Obj_OgreIH.ZoneNavigation.ZoneOut "Exit"
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
    Named 1 **********************    Move to, spawn and kill - Magmalatorr  ******************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-740.229065,63.003349,408.959839"

;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
;	call Obj_Kord.Mend_and_rune_swap "stun"
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	call Obj_Kord.Move_to_next_waypoint "-777.547485,77.342346,291.248962"
	call Obj_Kord.Move_to_next_waypoint "-747.702820,67.840446,362.541046"
	call Obj_Kord.Move_to_next_waypoint "-747.709839,63.834572,381.734589"

;	Check if already killed
	if !${Actor[Query,Name=="Kusala'Din" && Distance < 40].ID(exists)} && !${Actor[Query,Name=="${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

	if ${Actor[Query,Name=="Kusala'Din" && Distance < 40].ID(exists)}
	{
		iCount:Set[0]
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		while !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)} && ${iCount} < 25
		{
			iCount:Inc
			wait 10
		}
	}

;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_2_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_3_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
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
 	Named 2 ********************    Move to, spawn and kill - Tkesh'Tura   ********************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-556.702881,79.751762,677.742371"
	iCount:Set[0]

;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-740.229065,63.003349,408.959839"
	call Obj_Kord.Move_to_next_waypoint "-713.243774,63.580147,518.958740"
	call Obj_Kord.Move_to_next_waypoint "-637.818237,58.338142,600.922119"
	call Obj_Kord.Move_to_next_waypoint "-589.243591,75.365746,659.217163"
	call Obj_Kord.Move_to_next_waypoint "-585.829834,76.220200,663.073120"

;	Check if already killed
	if !${Actor[Query,Name=="Kusala'Din" && Distance < 40].ID(exists)} && !${Actor[Query,Name=="${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

	if ${Actor[Query,Name=="Kusala'Din" && Distance < 40].ID(exists)}
	{
		iCount:Set[0]
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		while !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)} && ${iCount} < 25
		{
			iCount:Inc
			wait 10
		}
	}
	
;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_2_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_3_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
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
 	Named 3 *********************    Move to, spawn and kill - Kusala'Din *********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-1017.306946,178.293900,728.347412"
	Ob_AutoTarget:AddActor["a conjured enforcer",0,FALSE,FALSE]
	iCount:Set[0]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.Move_to_next_waypoint "-556.702881,79.751762,677.742371"
	call Obj_Kord.Move_to_next_waypoint "-644.785583,60.337650,617.090942"
	call Obj_Kord.Move_to_next_waypoint "-717.477234,76.603081,613.695740"
	call Obj_Kord.Move_to_next_waypoint "-790.272583,84.761589,618.452698"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "telelport crystal" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-987.140015,170.550003,635.390015"
	oc !ci -resume igw:${Me.Name}
	call Obj_Kord.Move_to_next_waypoint "-1054.996094,179.173294,702.519958"


	;	Check if already killed
	if !${Actor[Query,Name=="Kusala'Din"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

	if ${Actor[Query,Name=="Kusala'Din" && Distance < 40].ID(exists)}
	{
		iCount:Set[0]
		Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		while !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)} && ${iCount} < 25
		{
			iCount:Inc
			wait 10
		}
	}

;	Kill named
	if ${OgreBotAPI.ZoneName.Equal["${Solo_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_1_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_2_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	if ${OgreBotAPI.ZoneName.Equal["${Heroic_3_Zone_Name}"]}
	{
		call Obj_Kord.Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	}

	call Obj_Kord.Move_to_next_waypoint "778.112732,44.772240,-13.035841"
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}
}
