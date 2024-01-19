function main()
{
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Thishan's Zimaran Rune: Blinding Gleam [Tier 0]"]:Use
    wait 10
    Me.Inventory[Query, Location =- "Inventory" && Name =- "Thishan's Zimaran Rune: Blinding Gleam [Tier 0]"]:EnchantItem[${Me.Equipment[19].ID}]
    wait 40
    press esc
    wait 5
    variable int iCounter
    while !${Me.Equipment[19].IsItemInfoAvailable}
    {
        waitframe
    }
        press esc
    for (iCounter:Set[1] ; ${iCounter}<=${Me.Equipment[19].ToItemInfo.NumAdornmentsAttached} ; iCounter:Inc)
    {
oc ${Me.Name} ${Me.Equipment[19].ToItemInfo.Adornment[${iCounter}].Name}
    }
}