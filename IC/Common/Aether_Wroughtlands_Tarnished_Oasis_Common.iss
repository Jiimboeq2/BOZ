
;	variable bool CheckState=
;	CheckState:Set[${TabConfig.Settings.checkbox_settings_npc_cast_monitoring}]
;	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_npc_cast_monitoring ${CheckState} TRUE


; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Aether Wroughtlands: Tarnished Oasis [Solo]"
variable string Heroic_1_Zone_Name="Aether Wroughtlands: Tarnished Oasis [Heroic I]"
variable string Heroic_2_Zone_Name="Aether Wroughtlands: Tarnished Oasis [Heroic II]"
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
	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_autotarget_outofcombatscanning FALSE
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
    Named 1 **********************    Move to, spawn and kill - Farzun the Forerunner  ********************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f PullSpot="-600.790710,35.022583,-673.571289"
	variable point3f KillSpot="-625.263123,35.796368,-698.473145b"
	variable point3f OrbKillSpot1="-558.750977,49.863567,-603.987061"
	variable point3f OrbKillSpot2="-542.140625,45.647732,-651.164734"
	variable point3f OrbKillSpot3="-523.534607,43.257080,-694.541443"
	variable point3f OrbKillSpot4="-588.248901,45.559025,-634.930969"
	variable point3f OrbKillSpot5="-625.767212,42.549217,-611.617676"
	variable point3f OrbKillSpot6="-638.446167,34.658066,-645.734253"
	
	Ob_AutoTarget:AddActor["an ill-invoked idea",0,FALSE,FALSE]
	Ob_AutoTarget:AddActor["Forerunner's Blink Buoy",0,FALSE,FALSE]
	Ob_AutoTarget:AddActor["${_NamedNPC}",0,FALSE,FALSE]
	oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_autotarget_outofcombatscanning TRUE

; 	Move to named and spawn
	call Obj_Kord.HO "Scout"
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "1"
	call Obj_Kord.Move_to_next_waypoint "-353.484741,61.921059,-219.339050"
	call Obj_Kord.Move_to_next_waypoint "-398.647949,57.534576,-266.323975"
	call Obj_Kord.Move_to_next_waypoint "-421.242981,54.004288,-313.577545"
	call Obj_Kord.Move_to_next_waypoint "-388.095032,56.676113,-382.240662"
	call Obj_Kord.Move_to_next_waypoint "-397.676453,52.853859,-442.100647  "
	call Obj_Kord.Move_to_next_waypoint "-412.755157,55.318192,-510.127899"
	call Obj_Kord.Move_to_next_waypoint "-457.571075,57.882290,-562.004822"
	call Obj_Kord.Move_to_next_waypoint "-500.442627,51.456875,-587.875854"
	call Kill_Orb "${OrbKillSpot1}"
	call Kill_Orb "${OrbKillSpot2}"
	Obj_OgreIH:ChangeCampSpot["-538.093933,43.148399,-673.418152"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	call Kill_Orb "${OrbKillSpot3}"
	Obj_OgreIH:ChangeCampSpot["-577.822754,37.024632,-665.722168"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	call Kill_Orb "${OrbKillSpot4}"
	Obj_OgreIH:ChangeCampSpot["-616.503784,40.452366,-632.232605"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	call Kill_Orb "${OrbKillSpot5}"
	Obj_OgreIH:ChangeCampSpot["-616.088928,40.443218,-634.683716"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	call Kill_Orb "${OrbKillSpot6}"
	Obj_OgreIH:ChangeCampSpot["${PullSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -PetOff igw:${Me.Name}
;	Check if already killed
	if !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}
;	Kill named
	oc !ci -SetUpFor igw:${Me.Name}
	oc ${Me.Name} is pulling ${_NamedNPC}
	Actor["${_NamedNPC}"]:DoTarget
	wait 50
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -PetAssist igw:${Me.Name}
	Actor["${_NamedNPC}"]:DoTarget
	call Obj_OgreUtilities.HandleWaitForCombat
	call Obj_OgreUtilities.WaitWhileGroupMembersDead
	wait 50
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}

/**********************************************************************************************************
 	Named 2 ********************    Move to, spawn and kill - Tarsisk the Tainted *************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-558.407959,52.748043,-431.931244"
	Ob_AutoTarget:AddActor["corrupted roots",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "2"
	call Obj_Kord.Move_to_next_waypoint "-600.790710,35.022583,-673.571289"
	call Obj_Kord.Move_to_next_waypoint "-588.308594,45.236431,-586.467896"
	call Obj_Kord.Move_to_next_waypoint "-563.363464,50.944668,-504.484528"

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
 	Named 3 *************************    Move to, spawn and kill - Cragnok ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-558.610535,52.812187,-181.143875"
;	Ob_AutoTarget:AddActor["",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "3"
	call Obj_Kord.HO "Disable"
	call Obj_Kord.Move_to_next_waypoint "-558.407959,52.748043,-431.931244"
	call Obj_Kord.Move_to_next_waypoint "-574.754517,53.819729,-353.123688"
	call Obj_Kord.Move_to_next_waypoint "-561.527893,56.944759,-303.724213"
	call Obj_Kord.Move_to_next_waypoint "-527.369446,54.248150,-234.312744"
	call Obj_Kord.Move_to_next_waypoint "-543.699829,53.866604,-207.416992"

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
 	Named 4 ***********************    Move to, spawn and kill - Derussah the Deceptive *******************
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-725.166504,58.574047,-351.647858"
	Ob_AutoTarget:AddActor["a violent vortex",0,FALSE,FALSE]


; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "4"
	call Obj_Kord.Move_to_next_waypoint "-561.170410,53.473160,-175.265839"
	call Obj_Kord.Move_to_next_waypoint "-628.469604,54.586197,-220.981659"
	call Obj_Kord.Move_to_next_waypoint "-697.018860,54.580528,-276.472443"
	call Obj_Kord.Move_to_next_waypoint "-751.669739,54.345325,-302.581665"
	call Obj_Kord.Move_to_next_waypoint "-775.931824,54.551044,-344.077972"
	call Obj_Kord.Move_to_next_waypoint "-765.776672,53.977970,-368.875488"

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
	variable point3f PullSpot="-820.606628,53.940506,-434.559326"
	variable point3f KillSpot="-789.898926,55.005562,-403.997314"
	Ob_AutoTarget:AddActor["Hasira's Marker",0,FALSE,FALSE]

; 	Move to named and spawn
	call Obj_Kord.Initialise_move_to_next_boss "${_NamedNPC}" "5"
	call Obj_Kord.Move_to_next_waypoint "-728.745911,58.574154,-353.300629" 12
	call Obj_Kord.Move_to_next_waypoint "-760.178345,54.047398,-372.736816"
	call Obj_Kord.Move_to_next_waypoint "-771.956238,54.326454,-397.312225"
	call Obj_Kord.Move_to_next_waypoint "-816.109741,53.926617,-432.535187"

;	Check if already killed
	if !${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	oc !ci -SetUpFor igw:${Me.Name}
	oc ${Me.Name} is pulling ${_NamedNPC}
	Obj_OgreIH:SetCampSpot
	Obj_OgreIH:ChangeCampSpot["${PullSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -PetOff igw:${Me.Name}
	wait 10
	Actor["${_NamedNPC}"]:DoTarget
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	wait 50
	oc !ci -PetAssist igw:${Me.Name}
	call Obj_OgreUtilities.HandleWaitForCombat
	call Obj_OgreUtilities.WaitWhileGroupMembersDead
	wait 50
	
;	Check named is dead
	if ${Actor[Query,Name=="${_NamedNPC}" && Type=="NamedNPC"].ID(exists)}
	{
		Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
		return FALSE
	}
	return TRUE
}
}

function Kill_Orb(point3f KillSpot)
{
	oc !ci -PetOff igw:${Me.Name}
	Obj_OgreIH:ChangeCampSpot["${KillSpot}"]
	call Obj_OgreUtilities.HandleWaitForCampSpot 10
	oc !ci -PetAssist igw:${Me.Name}
	while ${Actor[Query,Name=="Forerunner's Blink Buoy" && Distance < 15].ID(exists)}
	{
		waitframe
	}
	call Obj_OgreUtilities.HandleWaitForCombat
	call Obj_OgreUtilities.WaitWhileGroupMembersDead
}