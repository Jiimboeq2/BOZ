Spell Queues are for crafting experts (down the line i'll add the GMs once books are actually out)

IC is for instance controller zones


other than that the main folder should be cast stacks/ AA's


Move the scripts to C:\Program Files (x86)\InnerSpace\Scripts.

Move the profiles to C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreBot\Save and rename it as your own toon name ( be sure to delete your old stack/ BACK IT UP if you'd like

OR

C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreBot\Save\ProfilesToImport   > check admin tab (refresh first) search for it in that tab and hit load , then should be in your drop down

For Temp Adorns, go to C:\Program Files (x86)\InnerSpace\Scripts\EQ2OgreCommon\OgreTempAdorns.



precast tag button

Obj_OgreMCP:PasteButton[RawCommand,Pre-Pull,oc,!c,-AbilityTag,AUTO,PreCastTag,20,Allow,AUTO]


For patcher ignore list simply add it to 
C:\Program Files (x86)\InnerSpace\Extensions , or where ever your extensions folder is , not x64.


---

## New OgreBot / new OgreCraft (Ogre's new native bot)

Every cast stack pack (.zip) also holds `New OgreBot/<name>.json`, and every spell queue `<name>.xml` has `<name>.json`
beside it. The `.xml` files are for the old OgreBot / OgreCraft, the `.json` files for the new.

- **Cast stack, new OgreBot:** copy the `.json` from the pack's `New OgreBot` folder into
  `C:\Program Files (x86)\InnerSpace\Scripts\OgreSave\EQ2\OgreBot\Profiles\Import`, then OgreBot's **Admin** tab:
  **Refresh List**, click it under **Profiles you can import**, **Import Profile**.
- **Spell queue, new OgreCraft:** copy the `.json` into `C:\Program Files (x86)\InnerSpace\Scripts\OgreSave\EQ2\Craft\queues`.
  It is listed on OgreCraft's **Queues** tab under **Save / load a queue**: click its name, then **Load Queue**.
- **With ISXJQB:** `jb csimport BOZ` in game imports your class's stack for you.
