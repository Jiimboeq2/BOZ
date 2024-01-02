; DO NOT MESS WITH THE FOLLOWING CODE.

variable string Solo_Zone_Name="Zimara Breadth: Razing the Razelands [Solo]"
variable string Heroic_1_Zone_Name="Zimara Breadth: Razing the Razelands [Heroic I]"
variable string Heroic_2_Zone_Name="Zimara Breadth: Razing the Razelands [Heroic II]"
variable int DefaultScanRadius="35"
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
;		if ${Zone.Name.Equals["${Solo_Zone_Name}"]}
;		{
;			Obj_InstanceControllerXML:Set_ICFileOption[1,"Graceless on Boss Only"]
;			Obj_InstanceControllerXML:ChangeUIOptionViaCode["ic_file_option_1",TRUE]
;		}
		
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
			;call Obj_OgreIH.Set_PriestAscension FALSE
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
			call This.Named1 "Eaglovok"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Eaglovok"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 2.
		if ${_StartingPoint} == 2
		{
			call This.Named2 "Gilded Back Demolisher"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Gilded Back Demolisher"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
; 	Enter name and shinies nav point for Named 3.				
		if ${_StartingPoint} == 3
		{
			call This.Named3 "Sina A’Rak"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Sina A’Rak"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
; 	Enter name and shinies nav point for Named 4.
		if ${_StartingPoint} == 4
		{
			call This.Named4 "Doda K’Bael"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Doda K’Bael"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}		
; 	Enter name and shinies nav point for Named 5.
		if ${_StartingPoint} == 5
		{
			call This.Named5 "Queen Era'selka"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: Queen Era'selka"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}		
		
; 	Enter /loc for the zone out	and change _StartingPoint == X
		if ${_StartingPoint} == 6
		{
			Ob_AutoTarget:Clear
			Obj_OgreIH:LetsGo
			oc ${Me.Name} Double checking shinies
			oc ${Me.Name} looted ${ShiniesLooted} shinies
			wait 55
			oc ${Me.Name} is zoning out
			call Obj_OgreUtilities.HandleWaitForGroupDistance 5
			call Obj_OgreUtilities.NavToLoc "145.165054,160.950012,54.135956"
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
    Named 1 **********************    Move to, spawn and kill - Eaglovok  ********************************
***********************************************************************************************************/

function:bool Named1(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-374.663666,124.653801,-649.473267"

; 	Move to named and spawn

	call initialise_move_to_next_boss "${_NamedNPC}" "1"
	call move_to_next_waypoint "-606.980957,180.004944,-570.428406"
	call move_to_next_waypoint "-651.058289,181.113403,-561.681030"
	call move_to_next_waypoint "-676.384644,156.140823,-508.842133"
	call move_to_next_waypoint "-621.152466,124.467979,-425.483154"
	call move_to_next_waypoint "-515.456848,94.523468,-490.304688"
	call move_to_next_waypoint "-438.670258,101.360344,-555.439697"
	call move_to_next_waypoint "-392.697632,122.300201,-612.710083"


;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_2_Zone_Name}"]}
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
 	Named 2 ********************    Move to, spawn and kill - Guildedback Demolisher  ********************************
***********************************************************************************************************/
	
function:bool Named2(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-283.798553,96.159622,-273.710022"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "2"
	call move_to_next_waypoint "-337.142822,124.072754,-647.553406"
	oc !ci -special igw:${Me.Name}
	wait 15
	call move_to_next_waypoint "-227.350006,106.720001,-455.450012"
	call move_to_next_waypoint "-189.173050,99.535095,-253.994293"
	call move_to_next_waypoint "-219.544861,96.765625,-308.768555"
	call move_to_next_waypoint "-271.311798,92.332634,-268.471191"

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_2_Zone_Name}"]}
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
 	Named 3 *********************    Move to, spawn and kill -Sina A'Rak ********************************
***********************************************************************************************************/
	
function:bool Named3(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="77.831650,149.739700,-322.345154"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "3"
	call move_to_next_waypoint "-208.406143,98.186638,-234.852844"
	call move_to_next_waypoint "-108.194267,136.019135,-154.987015"
	call move_to_next_waypoint "-66.224007,139.073166,-152.454025"
	call move_to_next_waypoint "0.028605,139.719040,-211.453903"
	call move_to_next_waypoint "47.598545,144.789001,-272.262054"
	call move_to_next_waypoint "91.890930,145.275620,-299.213867"
	call move_to_next_waypoint "88.179649,148.760986,-305.407745"
	call move_to_next_waypoint "79.823105,149.739700,-320.016785"
	Ob_AutoTarget:AddActor["Sina A'rak",50,FALSE,TRUE]

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

;	Kill named
	if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_2_Zone_Name}"]}
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
 	Named 4 *********************    Move to, spawn and kill - Doda K'Bael ********************************
***********************************************************************************************************/
	
function:bool Named4(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="-37.266163,156.773453,9.066074"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "4"
	call move_to_next_waypoint "95.273376,145.061508,-286.061523"
	call move_to_next_waypoint "62.190891,142.203186,-226.830246"
	call move_to_next_waypoint "-64.044342,138.616852,-159.997665"
	call move_to_next_waypoint "-58.264938,143.641312,-124.003914"
	call move_to_next_waypoint "16.904150,139.838852,-92.498856"
	call move_to_next_waypoint "4.319942,145.992584,-58.870403"
	call move_to_next_waypoint "-11.311839,154.361435,-12.076102"
	call move_to_next_waypoint "-33.205685,156.778595,7.207820"
	Ob_AutoTarget:AddActor["Doda K'Bael",50,FALSE,TRUE]
	wait 15
; Check if already killed
if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
{
    Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
    return TRUE
}

; Kill named
if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_2_Zone_Name}"]}
{
    call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	while ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
{
call CheckIntercept
}
}

; Check if named is dead
if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
{
    Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
    return FALSE
}
}


/**********************************************************************************************************
 	Named 5 *********************    Move to, spawn and kill - Queen Era'Selka ********************************
***********************************************************************************************************/
	
function:bool Named5(string _NamedNPC="Doesnotexist")
{
	variable point3f KillSpot="145.029266,161.614914,49.574821"

; 	Move to named and spawn
	call initialise_move_to_next_boss "${_NamedNPC}" "5"
	call move_to_next_waypoint "-9.760703,156.886185,5.662886"
	call move_to_next_waypoint "16.384985,155.466415,25.289717"
	call move_to_next_waypoint "27.090868,143.684326,-38.723091"
	call move_to_next_waypoint "44.080605,145.798798,-38.023281"
	call move_to_next_waypoint "70.251511,146.612457,-27.978701"
	call move_to_next_waypoint "105.498749,154.733871,-9.561902"
	call move_to_next_waypoint "112.976990,155.896698,-7.732466"
	call move_to_next_waypoint "130.250488,157.551956,-11.106156"
	call move_to_next_waypoint "152.744217,157.894379,-12.996835"
	call move_to_next_waypoint "148.046310,159.105774,21.339634"

;	Check if already killed
	if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
	{
		Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
		return TRUE
	}

if ${Zone.Name.Equals["${Solo_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_1_Zone_Name}"]} || ${Zone.Name.Equals["${Heroic_2_Zone_Name}"]}
{
    call Tank_n_Spank "${_NamedNPC}" "${KillSpot}"
	while ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
{
call CheckIntercept
}
}


; Check if named is dead
if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
{
    Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
    return FALSE
}
}
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

function CheckIntercept()
{
    ;Name: Test of Magic BackDropIconID: 315 MainIconID: 839
    while ${Actor[exactname,${MobName}].ID(exists)}
    {
        if ${OgreBotAPI.DetrimentalInfo[909, 315]}
        {
            eq2ex p I need intercept.
            oc !c -CastAbilityOnPlayer igw:${Me.Name} "Intercept" "${Me.Name}"
            wait 20
        }
    wait 5
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
	;might change out for precasttag in personal files
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
