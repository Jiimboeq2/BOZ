#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"
variable string MobName="Queen Era'selka"

function main()
{
    ;Name: Auriac Toxin BackDropIconID: 315 MainIconID: 909
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

atom atexit()
{
    oc ${Me.Name}: Ending the ${MobName} helper script.
}