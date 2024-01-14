
;	variable bool CheckState=
;	CheckState:Set[${TabConfig.Settings.checkbox_settings_npc_cast_monitoring}]
;	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_npc_cast_monitoring ${CheckState} TRUE


; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Aether Wroughtlands: Tarnished Oasis [Solo]"
variable string Heroic_1_Zone_Name="Aether Wroughtlands: Tarnished Oasis [Event Heroic I]"
variable string Named1="Farzun the Forerunner"
variable string Named2="Tarsisk the Tainted"
variable string Named3="Cragnok"
variable string Named4="Derussah the Deceptive"
variable string Named5="Hasira the Hawk"
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
    Named 1 **********************    Move to, spawn and kill - Farzun the Forerunner    *******************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-549.99, 38.77, -651.47"

; 	Move to named and spawn
;	call Obj_Kord.Mend_and_rune_swap "stun"
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	call Obj_Kord.Move_to_next_waypoint "-327.56, 58.41, -194.52"
	call Obj_Kord.Move_to_next_waypoint "-378.35, 59.04, -245.34"
	call Obj_Kord.Move_to_next_waypoint "-425.01, 55.57, -292.01"
	call Obj_Kord.Move_to_next_waypoint "-428.18, 54.19, -315.43"
	call Obj_Kord.Move_to_next_waypoint "-408.79, 56.97, -339.01"
	call Obj_Kord.Move_to_next_waypoint "-389.35, 55.05, -360.42"
	call Obj_Kord.Move_to_next_waypoint "-378.57, 54.54, -375.26"
	call Obj_Kord.Move_to_next_waypoint "-388.70, 52.31, -404.95"
	call Obj_Kord.Move_to_next_waypoint "-402.59, 54.99, -437.57"
	call Obj_Kord.Move_to_next_waypoint "-418.56, 52.81, -487.28"
	call Obj_Kord.Move_to_next_waypoint "-425.45, 56.06, -519.62"
	call Obj_Kord.Move_to_next_waypoint "-442.16, 57.88, -538.55"
	call Obj_Kord.Move_to_next_waypoint "-464.75, 57.78, -565.04"
	call Obj_Kord.Move_to_next_waypoint "-480.09, 52.85, -578.77"
	call Obj_Kord.Move_to_next_waypoint "-497.69, 52.04, -594.66"
	call Obj_Kord.Move_to_next_waypoint "-514.20, 47.33, -605.28"
	call Obj_Kord.Move_to_next_waypoint "-534.16, 46.33, -621.04"
	call Obj_Kord.Move_to_next_waypoint "-550.94, 42.80, -636.09"
	call Obj_Kord.Move_to_next_waypoint "-597.16, 35.02, -676.41"
	call Obj_Kord.Move_to_next_waypoint "-549.99, 38.77, -651.47"

	Ob_AutoTarget:AddActor["Forerunner's Blink Buoy",0,FALSE,FALSE]


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
 	Named 2 *****************    Move to, spawn and kill - Tarsisk the Tainted  ************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-557.80, 52.66, -466.08"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-619.30, 35.80, -691.01"
	call Obj_Kord.Move_to_next_waypoint "-597.78, 35.02, -675.16"
	call Obj_Kord.Move_to_next_waypoint "-586.88, 45.07, -630.51"
	call Obj_Kord.Move_to_next_waypoint "-583.61, 46.82, -587.42"
	call Obj_Kord.Move_to_next_waypoint "-578.58, 47.73, -547.40"
	call Obj_Kord.Move_to_next_waypoint "-568.25, 50.94, -512.05"
	call Obj_Kord.Move_to_next_waypoint "-557.80, 52.66, -466.08"

	Ob_AutoTarget:AddActor["corrupted roots",0,FALSE,FALSE]

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
 	Named 3 *********************    Move to, spawn and kill - Cragnok  ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-525.31, 53.82, -198.59"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.Move_to_next_waypoint "-557.35, 52.50, -466.88"
	call Obj_Kord.Move_to_next_waypoint "-557.13, 52.70, -425.15"
	call Obj_Kord.Move_to_next_waypoint "-557.13, 52.70, -425.15"
	call Obj_Kord.Move_to_next_waypoint "-543.19, 54.04, -412.80"
	call Obj_Kord.Move_to_next_waypoint "-498.23, 56.28, -368.38"
	call Obj_Kord.Move_to_next_waypoint "-477.47, 56.29, -340.78"
	call Obj_Kord.Move_to_next_waypoint "-508.20, 59.77, -308.79"
	call Obj_Kord.Move_to_next_waypoint "-544.24, 55.57, -278.59"
	call Obj_Kord.Move_to_next_waypoint "-532.62, 53.84, -243.94"
	call Obj_Kord.Move_to_next_waypoint "-525.31, 53.82, -198.59"

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
 	Named 4 ***********************    Move to, spawn and kill - Derussah the Deceptive  *****************************
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-763.01, 53.98, -374.56"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "4"
	call Obj_Kord.Move_to_next_waypoint "-521.64, 53.95, -182.85"
	call Obj_Kord.Move_to_next_waypoint "-508.64, -5.46, -134.00"
	call Obj_Kord.Move_to_next_waypoint "-541.93, -4.96, -148.98"
	
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "pick_sign" "Teleport"
	wait 50
	
	call Obj_Kord.Move_to_next_waypoint "-536.87, 53.07, -170.75"
	call Obj_Kord.Move_to_next_waypoint "-588.33, 52.32, -184.61"
	call Obj_Kord.Move_to_next_waypoint "-615.89, 55.36, -205.61"
	call Obj_Kord.Move_to_next_waypoint "-638.86, 52.25, -229.83"
	call Obj_Kord.Move_to_next_waypoint "-663.97, 53.12, -252.16"
	call Obj_Kord.Move_to_next_waypoint "-708.90, 54.58, -281.36"
	call Obj_Kord.Move_to_next_waypoint "-736.04, 53.70, -297.54"
	call Obj_Kord.Move_to_next_waypoint "-762.68, 54.44, -322.82"
	call Obj_Kord.Move_to_next_waypoint "-776.57, 54.37, -326.90"
	call Obj_Kord.Move_to_next_waypoint "-763.01, 53.98, -374.56"

	Ob_AutoTarget:AddActor["a violent vortex",0,FALSE,FALSE]

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
 	Named 5 **********************    Move to, spawn and kill - Hasira the Hawk ***************************
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-802.35, 55.01, -391.60"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "5"
	
	call Obj_Kord.Move_to_next_waypoint "-761.25, 54.05, -370.52"
	call Obj_Kord.Move_to_next_waypoint "-758.56, 53.99, -369.01"
	call Obj_Kord.Move_to_next_waypoint "-731.64, 58.57, -353.93"
	call Obj_Kord.Move_to_next_waypoint "-766.65, 54.00, -373.98"
	call Obj_Kord.Move_to_next_waypoint "-766.99, 54.32, -402.55"
	call Obj_Kord.Move_to_next_waypoint "-765.41, 54.16, -448.92"
	call Obj_Kord.Move_to_next_waypoint "-792.53, 54.57, -471.02"
	call Obj_Kord.Move_to_next_waypoint "-759.94, 53.79, -445.42"
	call Obj_Kord.Move_to_next_waypoint "-765.05, 54.25, -406.00"
	call Obj_Kord.Move_to_next_waypoint "-790.81, 55.01, -403.02"
	call Obj_Kord.Move_to_next_waypoint "-802.35, 55.01, -391.60"

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
