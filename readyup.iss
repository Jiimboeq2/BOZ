/* Ready Up Checking
   (c) Trouble 2022
*/
variable string ScriptName="Ready Up Side-Script"
variable string ScriptVersion="v1.1"
variable int NoticeTime = 0
variable int Notice = 0

function main(int ReqNotice = 0)
{
    if ${ReqNotice}
    {
        Notice:Set[${ReqNotice}]
        NoticeTime:Set[800 - (${Notice} * 10)]
    }

    oc ${Me.Name}: Script '${ScriptName}' ${ScriptVersion} started.
    Event[EQ2_onIncomingText]:AttachAtom[ReadyUp_IncomingText]
    while TRUE
        wait 100
}

atom atexit()
{
	oc ${Me.Name}: Script '${ScriptName}' ended.
}

atom ReadyUp_IncomingText(string Text)
{
	if ${Text.Find["Readied Up!"]}
	{
        oc ${Me.Name}: Ready Up!
        if ${NoticeTime}
        {
            ; Trigger a notification
            TimedCommand ${NoticeTime} oc ${Me.Name}: Ready Up in ${Notice} seconds!
            TimedCommand ${NoticeTime} OgreBotAPI:AbilityTag_AddRotateTagTimer[${Me.Name}, "ReadyUpInc", ${Notice}, "Allow", ""]
        }
	}
}