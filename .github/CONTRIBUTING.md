All users are expected to review [/docs/CODE_OF_CONDUCT.md](/docs/CODE_OF_CONDUCT.md) before interacting with the repository or other users.

Baystation12 is licensed under the GNU Affero General Public License version 3, which can be found in full in LICENSE-AGPL3.txt.

Commits with a git authorship date prior to `1420675200 +0000` (2015/01/08 00:00 GMT) are licensed under the GNU General Public License version 3, which can be found in full in LICENSE-GPL3.txt.

All commits whose authorship dates are not prior to `1420675200 +0000` are assumed to be licensed under AGPL v3, if you wish to license under GPL v3 please make this clear in the commit message and any added files.


Guide To Contributing

Code: When adding code, follow the regular Urist guidelines and file structure. It makes things easier to keep track of. So, for adding anything self contained, go to code/modules/urist/40k and put it under the relevant subfolder. When adding items with in_hands, make sure to set urist_only = 1. When adding clothing, make sure to set the icon_override to the proper uristmob file. When adding clothing, make sure to make the path a child of the existing urist objs. This will take care of the above. Example: /obj/item/clothing/under/urist/itemgoeshere

Icons: We will also be following Urist guidelines. So, all icons go to the relevant subfolder under icons/urist/40k. All mob/in_hand icons go to the relevant .dmi under icons/uristmob as per usual.
