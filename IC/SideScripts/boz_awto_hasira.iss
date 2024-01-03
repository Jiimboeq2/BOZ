/*

    Author:     Myzer
    Name:       Hasira the Hawk
    Notes:      Runs on everyone.  Handles Curse Cures.

*/
variable string MobName="Hasira the Hawk"
variable int MyMetal=7
variable int CureMetal=8

function main()
{
    oc ${Me.Name}: The ${MobName} helper script is active!
    
    Event[EQ2_onIncomingText]:AttachAtom[EQ2_onIncomingText]

    call DoSetup

    while ${Actor[exactname,${MobName}].ID(exists)}
    {
        wait 10
        if ${MyMetal}==${CureMetal} && ${OgreBotAPI.DetrimentalInfo[234, 413]}
        {
            oc Curing ${Me.Name}
            oc !c -AutoCurse igw:${Me.Name} ${Me.Name}
            CureMetal:Set[8]         
        }
    }
}

function DoSetup()
{
    oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_disablecaststack_curecurse TRUE FALSE TRUE
    oc !c -ChangeOgreBotUIOption igw:${Me.Name}+fighters checkbox_settings_movetoarea FALSE FALSE TRUE
    oc ${Me.Name}: ${MobName} setup is done. Ready to pull.
}

atom EQ2_onIncomingText(string Text)
{
    if ${Text.Find["cursed with Metal Mayhem: Copper"]}
    {
        MyMetal:Set[1]
        oc ${Me.Name}: Copper
    }
    elseif ${Text.Find["cursed with Metal Mayhem: Platinum"]}
    {
        MyMetal:Set[2]
        oc ${Me.Name}: Platinum
    }
    elseif ${Text.Find["cursed with Metal Mayhem: Gold"]}
    {
        MyMetal:Set[3]
        oc ${Me.Name}: Gold
    }
    elseif ${Text.Find["cursed with Metal Mayhem: Silver"]}
    {
        MyMetal:Set[4]
        oc ${Me.Name}: Silver
    }
    elseif ${Text.Find["cursed with Metal Mayhem: Iron"]}
    {
        MyMetal:Set[5]
        oc ${Me.Name}: Iron
    }
    if ${Text.Find["Fine! It's copper!"]}
    {
        CureMetal:Set[1]
    }
    elseif ${Text.Find["Fine! It's platinum!"]}
    {
        CureMetal:Set[2]
    }
    elseif ${Text.Find["Fine! It's gold!"]}
    {
        CureMetal:Set[3]
    }
    elseif ${Text.Find["Fine! It's silver!"]}
    {
        CureMetal:Set[4]
    }
    elseif ${Text.Find["Fine! It's iron!"]}
    {
        CureMetal:Set[5]
    }
    if ${Text.Find["Metal Mayhem, which cures all!"]}
    {
        MyMetal:Set[7]
        CureMetal:Set[8]         
    }
}

atom atexit()
{
    oc !ci -ChangeOgreBotUIOption igw:${Me.Name} checkbox_settings_disablecaststack_curecurse FALSE FALSE FALSE
    oc !ci -ChangeOgreBotUIOption fighter checkbox_settings_movetoarea TRUE FALSE FALSE
    oc ${Me.Name}: Ending the ${MobName} helper script.
}