#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"
variable string MobName="Chromon, Titan of Colors"

function main()
{
    oc !ci -ChangeOgreBotUIOption ${Me.Name} checkbox_settings_disablecaststack_curecurse TRUE FALSE TRUE

;   while ${Actor[exactname,${MobName}].ID(exists)}
    while TRUE
    {
        ;Name: Curse of Restraint BackDropIconID: 509 MainIconID: 1129
        if ${OgreBotAPI.DetrimentalInfo[1129, 509]}
        {
            eq2ex p I need curse cure.
            oc !c -AutoCurse irw:${Me.Name} ${Me.Name}
            wait 100
        }
        ;Name: Emissary's Mental Instability BackDropIconID: 317 MainIconID: 603
        if ${OgreBotAPI.DetrimentalInfo[603, 317]}
        {
            eq2ex p I need curse cure.
            oc !c -AutoCurse irw:${Me.Name} ${Me.Name}
            wait 100
        }
    wait 5
    }
}

atom atexit()
{
    oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_disablecaststack_curecurse FALSE FALSE FALSE
    oc ${Me.Name}: Ending the ${MobName} helper script.
}