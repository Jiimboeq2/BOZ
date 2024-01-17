; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Zimara Breadth: Razing the Razelands [Solo]"
variable string Heroic_1_Zone_Name="Zimara Breadth: Razing the Razelands [Heroic I]"
variable string Heroic_2_Zone_Name="Zimara Breadth: Razing the Razelands [Heroic II]"
variable string Named1="Eaglovok"
variable string Named2="Gilded Back Demolisher"
variable string Named3="Sina A'rak"
variable string Named4="Doda K'Bael"
variable string Named5="Queen Era'selka"
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
    Named 1 **********************    Move to, spawn and kill - Eaglovok    *******************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-385.756561,124.275314,-652.157837"
	Ob_AutoTarget:AddActor["Zakir Rish controller",0,FALSE,FALSE]

; 	Move to named and spawn
;	call Obj_Kord.Mend_and_rune_swap "stun"
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	call Obj_Kord.Move_to_next_waypoint "-541.203857,165.337372,-607.941711"
	call Obj_Kord.Move_to_next_waypoint "-569.227905,168.517715,-586.563477"
	call Obj_Kord.Move_to_next_waypoint "-617.411804,181.929855,-581.026855"
	call Obj_Kord.Move_to_next_waypoint "-679.780090,172.698563,-543.038818"
	call Obj_Kord.Move_to_next_waypoint "-673.556396,156.090408,-510.072876"
	call Obj_Kord.Move_to_next_waypoint "-627.583618,124.927818,-429.735809"
	call Obj_Kord.Move_to_next_waypoint "-583.134216,114.763535,-445.363251"
	call Obj_Kord.Move_to_next_waypoint "-517.911682,94.434601,-487.168396"
	call Obj_Kord.Move_to_next_waypoint "-466.417816,96.066574,-524.654907"
	call Obj_Kord.Move_to_next_waypoint "-427.174286,101.789001,-560.290710"
	call Obj_Kord.Move_to_next_waypoint "-392.559418,121.401138,-606.650085"


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
 	Named 2 *****************    Move to, spawn and kill - Gilded Back Demolisher  ************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-297.823669,95.219391,-275.186432"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-383.912109,124.105209,-643.296204"
	call Obj_Kord.Move_to_next_waypoint "-354.910797,124.750145,-657.045776"
	call Obj_Kord.Move_to_next_waypoint "-334.618347,124.546104,-648.273132"
	oc !ci -pause igw:${Me.Name}
	oc !ci -ApplyVerbForWho igw:${Me.Name} "telelport crystal" "Teleport"
	wait 50
	call Obj_Kord.Move_to_next_waypoint "-227.350006,106.720001,-455.450012"
	oc !ci -resume igw:${Me.Name}
	call Obj_Kord.Move_to_next_waypoint "-226.425339,104.317589,-418.218079"
	call Obj_Kord.Move_to_next_waypoint "-219.063690,96.577530,-319.594482"
	call Obj_Kord.Move_to_next_waypoint "-226.796127,94.583755,-268.853546"

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
 	Named 3 *********************    Move to, spawn and kill - Sina A'rak  ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="75.772331,149.739685,-321.367035"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.Move_to_next_waypoint "-253.303726,92.095345,-356.560883"
	call Obj_Kord.Move_to_next_waypoint "-228.091049,95.385490,-292.250885"
	call Obj_Kord.Move_to_next_waypoint "-202.911041,100.882027,-221.621994"
	call Obj_Kord.Move_to_next_waypoint "-151.608063,123.888786,-167.713394"
	call Obj_Kord.Move_to_next_waypoint "-78.466698,139.030975,-148.268906"
	call Obj_Kord.Move_to_next_waypoint "-19.300608,138.983826,-188.882324"
	call Obj_Kord.Move_to_next_waypoint "42.526745,144.166702,-270.536255"
	call Obj_Kord.Move_to_next_waypoint "37.532730,144.804901,-305.182220"

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
 	Named 4 ***********************    Move to, spawn and kill - Doda K'Bael  *****************************
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-30.090937,156.701447,5.356103"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "4"
	call Obj_Kord.Move_to_next_waypoint "78.251183,149.739700,-322.036743"
	call Obj_Kord.Move_to_next_waypoint "11.977727,142.218582,-230.160675"
	call Obj_Kord.Move_to_next_waypoint "2.853228,140.604446,-100.493942"
	call Obj_Kord.Move_to_next_waypoint "8.703356,145.579498,-56.024300"
	call Obj_Kord.Move_to_next_waypoint "-7.486578,154.447556,-10.516138"

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
 	Named 5 **********************    Move to, spawn and kill - Queen Era'selka ***************************
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="146.225540,161.614914,38.905281"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "5"
	call Obj_Kord.Move_to_next_waypoint "-35.308868,156.797729,9.121156"
	call Obj_Kord.Move_to_next_waypoint "6.081822,146.938400,-49.378952"
	call Obj_Kord.Move_to_next_waypoint "56.901451,146.339783,-34.703312"
	call Obj_Kord.Move_to_next_waypoint "110.595711,155.579453,-10.009255"
	call Obj_Kord.Move_to_next_waypoint "152.194580,157.846298,-8.227892"

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
