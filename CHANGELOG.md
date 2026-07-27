## 🔄 Update V6

### Every AddOns:
- Updated API changes.
- Updated TOC.
- Added a Category (As they are all within my pack I've taken the liberty of giving them all the same category as "Mâk's AddOns Pack").
- Added Icons.
- Removed the fancy colors as there is categories and icons now.

### DynamicUILayout:
- Newly created AddOn!
- Dynamically change the UI layout depending on the size of your group using the new layout system within the Edit Mode.
- Create as much layout as you want and go to the options to configure which layout has to change depending on the size of your party/raid.

### CPArmor:
- Added a check to avoid the rotation arrows on the character pannel if they are present.
- Updated the logic for checking the adding/removal of armor while the character pannel is open.

### DCAlert: 
- Now unlocked by default on a fresh install.
- No longer require to keep pressing alt to move it when unlocked.
- Added a tooltip when unlocked to make things clearer.

### RDH:
- Fixed an issue caused by the new API that made the nameplates behave as if they were party members.
- Despite a similar feature being present within the new Raid UI update, I've still updated this addOn as I prefer this way of showing debuff glows rather than Blizzard's one.

### TheoryCraftClassic:
- Fixed the "Vitals" tab not displaying informations correctly in the TC pannel when playing a Druid (Display depends on the form).
- Fixed an lua error appearing sometimes on login when the addon loaded before the tooltips were populated.

### Talented Classic:
- Simple API update, nothing has been fixed or added.

### Account Wide Raid Profiles:
- Removed the addOn, the new API introduced the Layout system (Escape > Edit Mode) and do not uses Raid Profiles anymore making this addOn useless now, DynamicUILayout is its enhanced replacement.

### Sigma Profession Filter (Classic):
- Fixed the "Craft Reagent: X" not multiplicating by the amount of item you plan to craft.

(Closes #1 )

---------

## 🔄 Update V5

### Sigma Profession Filter (Classic): Fixes and Addition of the Addon to the pack.
- Fixed UI&Checkboxes positioning.
- Fixed errors when recipes don't have a header.
- Fixed random refreshes when the window was opened for the first time after a login/reload.
- Fixed an arithmetic crash when opening professions (like First Aid) caused by uncached items returning a missing item level.
- Fixed Lua errors and crashes caused by querying invalid or removed spell IDs from the client database.
- Fixed crashes in the Search Box and "Toggle Unlearned Recipes" filters when encountering missing spell names.
- Fixed a missing table initialization (OriginalHeaders) that was completely breaking the Crafting window.
- Fixed frame initialization issues by safely hooking into Blizzard's native UI lifecycle.
- Fixed caching logic to safely load missing reagents, tools, and created items without throwing exceptions.
- Fixed the "Training Points" label anchor offset resetting when collapsing headers with Leatrix Plus enabled.
- Fixed 23rd line not being able to render when Leatrix Plus was enabled.

---------

## 🔄 Update V4

### BNFriendsToggle: Fix+Rewrite+Cleaning
- Won't randomly crash and do nothing.
- The tooltips now always show the actual friends being hovered.
- Online friends and Offline friends are now correctly moved above and below the divider.
- The list won't desync when a friend logon/logoff/is added/deleted while the friendspanel is opened.
- Rewrote and cleaned the whole thing, too many bandaids fixes has been done on this poor guy.

### VanillaDruidManaBar: Update&Fix
- Adding a spark indicator (To the likeness of five-second-rule (FSR) but homemade and specific to this bar).
- Made it so the layer of the manabar is behind the texture of the bordure and the spark is in front of everything for it to be easily seen.
- Added an option for the "FSR" like spark.
- Fix the layer of the bar when it is unlocked (Shouldn't stay stuck behind other frames while trying to position it).

---------

## 🔄 Update V3

### Fixed VanillaDruidManaBar to init only if you're a druid.

---------

## 🔄 Update V2

### Fixed major issue in the categoryID check.

---------

## 🔄 Update 1.1

### Fixing .toc interface versions.
### Removing TBC .toc files as they are not and will never be supported on this repo until we get a HC version of TBC.

----------

## 🔄 Update 1.0

### Adding WowUp auto-update compatibility.
