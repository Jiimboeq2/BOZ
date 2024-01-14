
;	variable bool CheckState=
;	CheckState:Set[${TabConfig.Settings.checkbox_settings_npc_cast_monitoring}]
;	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_npc_cast_monitoring ${CheckState} TRUE


; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Aether Wroughtlands: Ferric Fields [Solo]"
variable string Heroic_1_Zone_Name="Aether Wroughtlands: Ferric Fields [Event Heroic I]"
variable string Named1="Katakir the Cruel"
variable string Named2="Metalloid"
variable string Named3="Theya Shen'Safa"
variable string Named4="Syadun"
variable string Named5="Shanrazzad the Spared"
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
; 	Enter name of Named 4.	
		if ${_StartingPoint} == 4
		{	
			call This.Named4 "${Named4}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: ${Named4}"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name of Named 5.
		if ${_StartingPoint} == 5
		{
			call This.Named5 "${Named5}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: ${Named5}"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
; 	Enter /loc for the zone out	and change _StartingPoint == 4 for Event Heroic	
		if ${_StartingPoint} == 6
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
    Named 1 **********************    Move to, spawn and kill - Katakir the Cruel    *******************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-96.30, 37.65, -656.38"

; 	Move to named and spawn
;	call Obj_Kord.Mend_and_rune_swap "stun"
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	call Obj_Kord.Move_to_next_waypoint "-207.78,42.49, -707.57"
	call Obj_Kord.Move_to_next_waypoint "-183.26,39.12, -692.29"
	call Obj_Kord.Move_to_next_waypoint "-174.72,36.57, -678.03"
	call Obj_Kord.Move_to_next_waypoint "-192.12,37.01, -630.43"
	call Obj_Kord.Move_to_next_waypoint "-172.63,37.02, -665.66"
	call Obj_Kord.Move_to_next_waypoint "-157.77,36.26, -692.51"
	call Obj_Kord.Move_to_next_waypoint "-105.85,36.51, -699.45"
	call Obj_Kord.Move_to_next_waypoint "-78.26,36.12, -697.10"
	call Obj_Kord.Move_to_next_waypoint "-85.43,36.97, -676.26"
	call Obj_Kord.Move_to_next_waypoint "-89.24,37.81, -665.21"
	call Obj_Kord.Move_to_next_waypoint "-95.36,37.65, -653.38"


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
 	Named 2 *****************    Move to, spawn and kill - Metalloid  ************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="280.03, 36.45, -692.19"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-80.47, 37.71, -644.34"
	call Obj_Kord.Move_to_next_waypoint "-76.94, 36.84, -674.45"
	call Obj_Kord.Move_to_next_waypoint "-52.71, 43.48, -713.79"
	call Obj_Kord.Move_to_next_waypoint "-34.70, 43.61, -732.52"
	call Obj_Kord.Move_to_next_waypoint "-22.68, 50.10, -749.38"
	call Obj_Kord.Move_to_next_waypoint "-1.34, 50.17, -781.24"
	call Obj_Kord.Move_to_next_waypoint "8.22, 49.87, -746.23"
	call Obj_Kord.Move_to_next_waypoint "19.47, 49.98, -728.62"
	call Obj_Kord.Move_to_next_waypoint "43.35, 37.98, -733.92"
	call Obj_Kord.Move_to_next_waypoint "67.35, 36.61, -716.48"
	call Obj_Kord.Move_to_next_waypoint "50.80, 38.27, -690.72"
	call Obj_Kord.Move_to_next_waypoint "64.55, 36.52, -713.03"
	call Obj_Kord.Move_to_next_waypoint "96.47, 38.13, -693.90"
	call Obj_Kord.Move_to_next_waypoint "152.50, 36.09, -672.20"
	call Obj_Kord.Move_to_next_waypoint "190.75, 36.36, -682.88"
	call Obj_Kord.Move_to_next_waypoint "220.69, 36.39, -710.07"
	call Obj_Kord.Move_to_next_waypoint "236.50, 36.40, -723.74"
	call Obj_Kord.Move_to_next_waypoint "264.31, 36.57, -727.58"
	call Obj_Kord.Move_to_next_waypoint "280.90, 35.57, -706.84"
	call Obj_Kord.Move_to_next_waypoint "293.48, 36.78, -683.28"
	call Obj_Kord.Move_to_next_waypoint "280.03, 36.45, -692.19"

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
 	Named 3 *********************    Move to, spawn and kill - Theya Shen'Safa  ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-21.00, 49.89, -749.85"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.Move_to_next_waypoint "35.98, 37.85, -739.35"
	call Obj_Kord.Move_to_next_waypoint "61.48, 36.68, -718.42"
	call Obj_Kord.Move_to_next_waypoint "75.12, 36.18, -699.07"
	call Obj_Kord.Move_to_next_waypoint "30.80, 36.31, -702.34"
	call Obj_Kord.Move_to_next_waypoint "-35.61, 43.52, -718.87"
	call Obj_Kord.Move_to_next_waypoint "-24.12, 48.87, -747.64"
	call Obj_Kord.Move_to_next_waypoint "-21.00, 49.89, -749.85"

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
 	Named 4 ***********************    Move to, spawn and kill - Syadun  *****************************
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="33.80, 38.13, -667.86"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "4"
	call Obj_Kord.Move_to_next_waypoint "-13.13, 49.91, -774.50"
	call Obj_Kord.Move_to_next_waypoint "-24.03, 50.12, -751.23"
	call Obj_Kord.Move_to_next_waypoint "-30.47, 43.50, -715.91"
	call Obj_Kord.Move_to_next_waypoint "6.94, 36.27, -696.72"
	call Obj_Kord.Move_to_next_waypoint "3.88, 38.17, -666.57"
	call Obj_Kord.Move_to_next_waypoint "20.96, 36.81, -675.33"
	call Obj_Kord.Move_to_next_waypoint "33.80, 38.13, -667.86"

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
 	Named 5 **********************    Move to, spawn and kill - Shanrazzad the Spared ***************************
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="95.36, 14.53, -550.89"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "5"
	; portal_cube_03
	
	wait 5
    oc !ci -special igw:${Me.Name}
    wait 15
	
	call Obj_Kord.Move_to_next_waypoint "53.02, 37.84, -659.52"
	call Obj_Kord.Move_to_next_waypoint "98.68, 14.48, -566.40"
	call Obj_Kord.Move_to_next_waypoint "95.36, 14.53, -550.89"

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
}
