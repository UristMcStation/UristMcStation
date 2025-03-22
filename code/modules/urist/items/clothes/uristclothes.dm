/*										*****New space to put all UristMcStation Clothing (clothing/suit and clothing/under. I may split them up anyways)*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/clothes.dmi'
All UMcS clothing will now go here, to prevent unecessary .dm's. I mean, how much clothes do we need anyways... -Glloyd //haha, i got that one right.

Update 23/03/2014 - removed all the ports of BS12 clothing. So, naval stuff, swimsuits, detective gear, cap's jacket, HoP whimsy and storage webbing stuff.

Update 26/07/2014 - All generic clothing goes under obj/item/clothing/under/urist. All generic suits go under /obj/item/clothing/suit/urist*/

//this is important to save me time with all these dresses

/obj/item/clothing/under/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uniform.dmi')

//this is important EXPLICITLY for all the dresses -Vakothu
/obj/item/clothing/under/urist/dress
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
	icon_state = "blackdress" //for travis purposes
	name = "dress" //likewise

//backtracking and putting this here to clean things up

/obj/item/clothing/suit/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	species_restricted = list("exclude","Lactera") //no more lactera wearing armour
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/armor/species_restricted = list("exclude","Lactera") //no more lactera wearing armour

//SciRIG. It's hip, it's happening and it protects against space and some other shit. You fuckers said you wanted more EVA.
//It's totally not just a reskin of the medrig...

/obj/item/clothing/suit/space/void/science
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "Scirig"
	name = "science hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement. Looks like it could hold up against an explosion."
	item_state = "Scirig"
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/storage/box/monkeycubes,/obj/item/aicard,/obj/item/device/paicard)
	armor = list(melee = 10, bullet = 5, laser = 10,energy = 5, bomb = 60, bio = 100, rad = 30)
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_IPC, SPECIES_RESOMI)

/obj/item/clothing/suit/space/void/science/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

//Emergency Suit. It's really shitty, but better than a firesuit when it comes to space or biological hazards. Will need a special "emergency locker" for this.
//One of the lockers will go in each of the emergency storages, and have one of these fuckers in them. Prepare to feel the suck as it slowly kills you.

/*/obj/item/clothing/suit/urist/emergencysuit
	name = "emergency suit"
	desc = "A bulky suit meant to be used in emergencies only. It doesn't look too safe... Wait, is that blood?" //PREPARE FOR YOUR DOOM
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "emergency"
	item_state = "emergency"
	w_class = 4
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/tank)
	armor = list(melee = 5, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	item_flags = ITEM_FLAG_STOPPRESSUREDAMAGE
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	species_restricted = list("exclude","Vox",SPECIES_RESOMI)

/obj/item/clothing/suit/urist/emergencysuit/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1.5
*/
//Armoured biosuit for sec

/obj/item/clothing/suit/bio_suit/asec
	item_icons = URIST_ALL_ONMOBS
	name = "armoured bio suit"
	desc = "An armoured suit that protects against biological contamination and minor damage."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "Armouredbiosuit"
	item_state = "bio_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	allowed = list(/obj/item/tank,/obj/item/pen,/obj/item/device/flashlight/pen)
	armor = list(melee = 20, bullet = 15, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/bio_suit/asec/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 3

//Welder apron done by ShoesandHats and added by Cozarctan. Moved from welder. Welder machete goes into the new uristweapons.dm

/obj/item/clothing/suit/urist/welderapron
	item_icons = URIST_ALL_ONMOBS
	name = "welder's apron"
	desc = "A leather work apron."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "welderapron"
	item_state = "welderapron"
	blood_overlay_type = "armorblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//Naval Space suit. Or something like that. I don't fucking know.

/obj/item/clothing/suit/space/naval
	item_icons = URIST_ALL_ONMOBS
	name = "naval space suit"
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "navyspace"
	desc = "A high quality space suit used by the NanoTrasen Navy. Smells like oppression."
	w_class = 3
	allowed = list(/obj/item/gun,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs,/obj/item/tank,/obj/item/device/flashlight)
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

/obj/item/clothing/suit/space/naval/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

//Naval Commando Suit

/obj/item/clothing/suit/space/void/commando
	item_icons = URIST_ALL_ONMOBS
	name = "naval commando suit"
	desc = "A heavily armored suit that protects against moderate damage. Worn by the NanoTrasen Naval Commandos. It reeks of oppression."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "commando"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	allowed = list(/obj/item/gun,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/melee/energy/sword)
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 30, rad = 30)
	can_breach = 0

/obj/item/clothing/suit/space/void/commando/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

//Meido outfit, Pretty much Japanese for Maid outfit. I will most likely be doing more costumes. -Nien

/obj/item/clothing/suit/urist/meido
	item_icons = URIST_ALL_ONMOBS
	name = "meido costume"
	desc = "A black maid costume."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "meido"
	item_state = "meido"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//psychologist clothing -- God I got lazy here.

/obj/item/clothing/under/rank/psychologist
	item_icons = URIST_ALL_ONMOBS
	name = "psychologist's suit"
	desc = "A slightly weathered suit worn by the station's psychologist. Are those Cheesy Honker stains?" //you fukken slob
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "psychologist"
	item_state = "blacksuit"
	//item_color = "psychologist"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/suit/psychologist
	item_icons = URIST_ALL_ONMOBS
	name = "tweed jacket"
	desc = "A tweed jacket worn by the station's psychologist. It looks a tad worn at the elbows."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "tweedjacket"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/device/scanner/gas,/obj/item/stack/medical,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/device/scanner/health,/obj/item/device/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)

/obj/item/clothing/suit/psychologist/verb/toggle()
	set name = "Toggle Coat Buttons"
	set category = "Object"
	set src in usr

	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0

	switch(icon_state)
		if("tweedjacket_open")
			src.icon_state = "tweedjacket"
			to_chat(usr, "You button up the jacket.")
		if("tweedjacket")
			src.icon_state = "tweedjacket_open"
			to_chat(usr, "You unbutton the jacket.")
		else
			to_chat(usr, "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are.")
			return
	usr.update_inv_wear_suit()	//so our overlays update

//Terran Confederacy Trader outfit

/obj/item/clothing/under/urist/terran //why was this a weirdass path
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uniform.dmi')

/obj/item/clothing/suit/urist/terran
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/under/urist/terran/trader
	name = "Terran Confederacy trader's outfit"
	desc = "An opulent outfit worn by a Terran Confederacy trader"
	icon_state = "TCToutfit"
	item_state = "TCToutfit"
	//item_color = "TCToutfit"

/obj/item/clothing/suit/urist/terran/trader
	name = "Terran Confederacy trader's cloak"
	desc = "An opulent cloak worn by a Terran Confederacy trader"
	icon_state = "TCTRobes"
	item_state = "TCTRobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//Alternate space wizard outfits. I hope to see more than just the necromancer's robes here one day.

/obj/item/clothing/suit/wizrobe/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/wizrobe/urist/necro
	name = "necromancer's robes"
	desc = "A set of charcoal-black robes worn only by those practicing the darkest of arts. A variety of bones hang from it."
	icon_state = "necro"
	item_state = "necro"

/obj/item/clothing/suit/wizrobe/urist/dresden
	name = "urban wizard's coat"
	desc = "A black duster that seems to radiate power. It billows slightly in a nonexistent wind. Very urban fantasy."
	icon_state = "dresdencoat"
	item_state = "suitjacket_black"

//NT Outfits

/obj/item/clothing/under/urist/nanotrasen/blue
	item_icons = URIST_ALL_ONMOBS
	name = "blue nanotrasen outfit"
	desc = "A standard blue Nanotrasen outfit with a white NT on back."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "NTsuit"
	item_state = "NTsuit"
	//item_color = "NTsuit"


/obj/item/clothing/under/urist/nanotrasen/white
	item_icons = URIST_ALL_ONMOBS
	name = "white nanotrasen outfit"
	desc = "A standard white Nanotrasen outfit with a blue NT on back."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "NTWsuit"
	item_state = "NTWsuit"
	//item_color = "NTWsuit"

//SO MANY FUCKING DRESSES

/obj/item/clothing/under/urist/dress/teal
	name = "teal dress"
	desc = "A pretty teal dress, for pretty ladies."
	icon_state = "tealdress"
	//item_color = "tealdress"
	item_state = "tealdress"

/obj/item/clothing/under/urist/dress/yellow
	name = "floral yellow dress"
	desc = "A pretty yellow dress with some cute designs on it."
	icon_state = "yellowdress"
	//item_color = "yellowdress"
	item_state = "yellowdress"

/obj/item/clothing/under/urist/dress/white1
	name = "short white dress"
	desc = "A pretty white dress. Short and sweet!"
	icon_state = "wd1"
	//item_color = "wd1"
	item_state = "wd1"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/urist/dress/white2
	name = "long white dress"
	desc = "A beautiful long white dress. Looks more formal than most dresses."
	icon_state = "wd2"
	//item_color = "wd2"
	item_state = "wd2"

/obj/item/clothing/under/urist/dress/princess
	name = "princess dress"
	desc = "A cute dress fit for a princess!"
	icon_state = "princess"
	//item_color = "princess"
	item_state = "princess"

/obj/item/clothing/under/urist/dress/red
	name = "red cocktail dress"
	desc = "A very pretty red cocktail dress."
	icon_state = "reddress"
	//item_color = "reddress"
	item_state = "reddress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//nurse joy

/obj/item/clothing/under/urist/rank/nurse
	name = "white nurse outfit"
	desc = "A pretty nurse outfit. It brings a sense of joy to you."
	icon_state = "nursejoy"
	//item_color = "nursejoy"
	item_state = "nursejoy"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

//alt alt RD

/obj/item/clothing/under/urist/rank/rdgreen
	name = "green RD's outfit"
	desc = "A cute green outfit sometimes worn by the Research Director."
	icon_state = "emaRD"
	//item_color = "emaRD"
	item_state = "emaRD"

//trolololo

/obj/item/clothing/under/sakura_hokkaido_kimono
	item_icons = URIST_ALL_ONMOBS
	name = "Kimono"
	desc = "A pale-pink, nearly white, kimono with a red and gold obi. There is a embroidered design of cherry blossom flowers covering the kimono."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "sakura_hokkaido_kimono"
	item_state = "sakura_hokkaido_kimono"
	//item_color = "sakura_hokkaido_kimono"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uniform.dmi')

//Super hero/villain stuff

/obj/item/clothing/under/urist/trickster
	name = "The Trickster suit"
	desc = "Go pull some tricks."
	icon_state = "trickster"
	//item_color = "trickster"
	item_state = "trickster"

/obj/item/clothing/suit/urist/trickster
	name = "The Trickster coat"
	desc = "Go pull some tricks."
	icon_state = "trickstercoat"
	item_state = "trickstercoat"

/obj/item/clothing/under/urist/darveyflint
	name = "Darvey Flint work suit"
	desc = "Suit on one side, party on the other."
	icon_state = "harvey_flint"
	//item_color = "harvey_flint"
	item_state = "harvey_flint"

/obj/item/clothing/under/urist/darvetflint_skin
	name = "Darvey Flint work suit"
	desc = "Suit on one side, party on the other with fake skin?"
	icon_state = "harvey_flint"
	//item_color = "harvey_flint_skin"
	item_state = "harvey_flint_skin"

/obj/item/clothing/under/urist/jester
	name = "The Jester"
	desc = "A 'Happy' jester outfit."
	icon_state = "the_jester"
	//item_color = "the_jester"
	item_state = "the_jester"

/obj/item/clothing/suit/urist/jester
	name = "The Jester coat"
	desc = "A 'Happy' jester coat."
	icon_state = "the_jester_coat"
	item_state = "the_jester_coat"

/obj/item/clothing/under/urist/penguin
	name = "Penguin's suit"
	desc = "The Penguin's suit."
	icon_state = "penguin"
	//item_color = "penguin"
	item_state = "penguin"

//fancy cmo shit

/obj/item/clothing/under/urist/rank/cmoalt
	name = "CMO's formal outfit"
	desc = "A fancy outfit sometimes worn by the CMO."
	icon_state = "cmo"
	//item_color = "cmo"
	item_state = "cmo"

/obj/item/clothing/suit/storage/toggle/labcoat/cmo/alt
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/clothes.dmi'
//	icon_override = 'icons/uristmob/clothes.dmi'
	desc = "A slightly fancier labcoat sometimes worn by the CMO."
	icon_state = "cmo_lab"
	//icon_open = "cmo_lab_open"
	//icon_closed = "cmo_lab"

//sexy captain's outfit by imblyings from tg

/obj/item/clothing/under/urist/rank/capdressalt
	name = "captain's formal outfit"
	desc = "A formal outfit for female captains. Or really flamboyant male captains."
	icon_state = "captainfemaleformal"
	//item_color = "captainfemaleformal"
	item_state = "captainfemaleformal"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uniform.dmi')

//hooonk bs12

/obj/item/clothing/suit/storage/toggle/labcoat/robotics
	item_icons = URIST_ALL_ONMOBS
	name = "Robotics labcoat"
	desc = "A labcoat with a few markings denoting it as the labcoat of a roboticist."
//	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "aeneasrinil"
	//icon_open = "aeneasrinil_open"
	//icon_closed = "aeneasrinil"
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

//for the carpenter

/obj/item/clothing/under/urist/rank/carpenter
	name = "carpenter's overalls"
	desc = "A pair of well used overalls with a plaid shirt underneath."
	icon_state = "overalls"
	//item_color = "overalls"
	item_state = "overalls"

//scrdest's coats
/obj/item/clothing/suit/storage/toggle/urist
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/storage/toggle/urist/coat
	name = "coat"
	desc = "A long, warm garment. Perfect for looking nice in Space Winter."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "blackcoat"
	//icon_open = "blackcoat_open"
	//icon_closed = "blackcoat_closed"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 253.15
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/storage/urist
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')

/obj/item/clothing/suit/storage/urist/coat
	name = "nontogglecoat"
	desc = "A long, warm garment. Perfect for looking nice in Space Winter. It seems to be missing its buttons."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "blackcoat"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/suit/storage/toggle/urist/coat/navycoat
	name = "navy coat"
	desc = "A warm wool coat in navy blue. Perfect for looking nice in Space Winter."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "navycoat"

/obj/item/clothing/suit/storage/toggle/urist/coat/charcoat
	name = "charcoal coat"
	desc = "A warm wool coat in dark grey. Perfect for looking nice in Space Winter."
	icon_state = "charcoat"

/obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat
	name = "black coat"
	desc = "A warm wool coat in black. Perfect for looking nice in Space Winter."
	icon_state = "blackcoat"

/obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit
	name = "black coat with suit jacket"
	desc = "A warm wool coat in black with a black suit jacket. Because you're feeling dressy."
	icon_state = "blackcoat_suit"

/obj/item/clothing/suit/storage/toggle/urist/coat/burgcoat
	name = "burgundy coat"
	desc = "A warm wool coat in burgundy. Perfect for looking nice in Space Winter."
	icon_state = "burgcoat"

/obj/item/clothing/suit/storage/urist/coat/tajcoat
	name = "tajaran fur coat"
	desc = "A very heavy, very warm belted fur coat made out of furs of an extinct race. Production of these coats is highly regulated to a small number of companies allowed to do so. NanoTrasen isn't one, but who cares?"
	icon_state = "tajcoat"

/obj/item/clothing/suit/storage/urist/coat/journocoat
	name = "Journalist's coat"
	desc = "A durable brown double-breasted coat. Keeps you warm while you expose corporate corruption."
	icon_state = "browncoat" //non-togglable

/obj/item/clothing/under/urist/dresden
	name = "black pullover"
	desc = "A black jumper and a pair of jeans, basic and inconspicuous."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "dresdenunder"
	item_state = "dresdenunder"
	//item_color = "dresdenunder"

//alt janitor shit

/obj/item/clothing/under/urist/rank/janialt
	name = "work clothes"
	desc = "A grubby shirt and work pants worn by a janitor."
	icon_state = "jani"
	//item_color = "jani"
	item_state = "jani"

/obj/item/clothing/suit/urist/janicoat
	name = "work shirt"
	desc = "A grubby work shirt worn by a janitor."
	icon_state = "janicoat"

//Kawaii as fuck maid outfit

/obj/item/clothing/suit/urist/maid
	name = "maid uniform"
	desc = "A tidy maid unform for cleaning."
	icon_state = "janimaid"

//Barber

/obj/item/clothing/under/urist/barber
	name = "barber outfit"
	desc = "A white, red and blue striped shirt with black pants and bowtie."
	icon_state = "barber"
	//item_color = "barber"
	item_state = "barber"

//More Dresses!

/obj/item/clothing/under/urist/dress/white3
	name = "frilly white dress"
	desc = "A white dress."
	icon_state = "whitedress"
	item_state = "whitedress"
	//item_color = "whitedress"

/obj/item/clothing/under/urist/dress/pink
	name = "pink dress"
	desc = "A pink dress."
	icon_state = "pinkdress"
	item_state = "pinkdress"
	//item_color = "pinkdress"

/obj/item/clothing/under/urist/dress/gold
	name = "gold dress"
	desc = "A gold dress."
	icon_state = "golddress"
	item_state = "golddress"
	//item_color = "golddress"

/obj/item/clothing/under/urist/dress/green
	name = "green dress"
	desc = "A green dress."
	icon_state = "greendress"
	item_state = "greendress"
	//item_color = "greendress"

/obj/item/clothing/under/urist/dress/purple
	name = "purple dress"
	desc = "A purple dress."
	icon_state = "purpledress"
	item_state = "purpledress"
	//item_color = "purpledress"

/obj/item/clothing/under/urist/dress/black
	name = "black dress"
	desc = "A black dress."
	icon_state = "blackdress"
	item_state = "blackdress"
	//item_color = "blackdress"

//Even MORE dresses! -Dresses are sprited by Deer (2018) -Teshari sprites by Vakothu

/obj/item/clothing/under/urist/dress/pinksun
	name = "pink sundress"
	desc = "A cute pink sundress."
	icon_state = "pinksun"
	item_state = "pinksun"

/obj/item/clothing/under/urist/dress/whitesun
	name = "short white sundress"
	desc = "A white sundress, it's short."
	icon_state = "whitesun"
	item_state = "whitesun"

/obj/item/clothing/under/urist/dress/bowsun
	name = "bowed pink sundress"
	desc = "A cute pink sundress with a bow."
	icon_state = "bowsun"
	item_state = "bowsun"

/obj/item/clothing/under/urist/dress/bluesun
	name = "long blue sundress"
	desc = "A long blue sun dress with white frills towards the bottom."
	icon_state = "bluesun"
	item_state = "bluesun"

/obj/item/clothing/under/urist/dress/shortpink
	name = "short pink sundress"
	desc = "A very short pink sundress, it's more like a chemise."
	icon_state = "shortpink"
	item_state = "shortpink"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/urist/dress/twopiece
	name = "two-piece dress"
	desc = "A fancy two-piece dress, the pieces are sewn together."
	icon_state = "twopiece"
	item_state = "twopiece"

/obj/item/clothing/under/urist/dress/gothic
	name = "gothic dress"
	desc = "An elegant gothic dress with lace decorations."
	icon_state = "gothic"
	item_state = "gothic"

//pinstripe suit

/obj/item/clothing/under/urist/pinstripesuit
	name = "pinstripe suit"
	desc = "A classy pinstripe suit. Lookin' good champ!"
	icon_state = "pinstripe"
	item_state = "pinstripe"
	//item_color = "pinstripe"

//IAA Dress

/obj/item/clothing/under/urist/rank/iaadress
	name = "Internal Affairs dress"
	desc = "The plain, professional dress of an Internal Affairs Agent"
	icon_state = "dress_IAA"
	item_state = "dress_IAA"
	//item_color = "dress_IAA"

//polka dot dress

/obj/item/clothing/under/urist/dress/polkadot
	name = "polka dot dress"
	desc = "A cute little dress in a polka dot pattern."
	icon_state = "polkaskirt"
	item_state = "polkaskirt"
	//item_color = "polkaskirt"

//dress blouse

/obj/item/clothing/under/urist/dress/dress_blouse
	name = "blue formal dress"
	desc = "A crisp blue dress with a matching blouse."
	icon_state = "dress_blouse"
	item_state = "dress_blouse"
	//item_color = "dress_blouse"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

//Fallout event clothing

/obj/item/clothing/under/urist/springm
	name = "pre-War male spring outfit"
	desc = "It's a long-sleeve beige shirt with a red sweater-vest and brown trousers."
	icon_state = "springm"
	item_state = "springm"
	//item_color = "springm"

/obj/item/clothing/under/urist/relaxedwearm
	name = "pre-War male relaxedwear"
	desc = "It's along-sleeve blue shirt with a greenish brown sweater-vest and slacks."
	icon_state = "relaxedwearm"
	item_state = "relaxedwearm"
	//item_color = "relaxedwearm"

/obj/item/clothing/under/urist/enclaveo
	name = "Enclave officer uniform"
	desc = "It's a standard Enclave officer uniform.<br>The outer layer is made of a sturdy material designed to withstand the harsh conditions of the wasteland."
	icon_state = "enclaveo"
	item_state = "enclaveo"
	//item_color = "enclaveo"

/obj/item/clothing/suit/urist/autumn //Based of Colonel Autumn's uniform.
	name = "tan trenchcoat"
	desc = "A resistant, tan trenchcoat, typically worn by pre-War generals."
	icon_state = "autumn"
	item_state = "autumn"
	blood_overlay_type = "armorblood"
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 5, bomb = 5, bio = 0, rad = 10)
	allowed = list(/obj/item/material/knife, /obj/item/material/knife/kitchen/cleaver, /obj/item/stamp, /obj/item/reagent_containers/food/drinks/flask, /obj/item/melee, /obj/item/device/flash, /obj/item/storage/box/matches, /obj/item/clothing/mask/smokable/cigarette, /obj/item/storage/fancy/smokable, /obj/item/tank, /obj/item/device/flashlight, /obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/scalpel, /obj/item/cautery, /obj/item/hemostat, /obj/item/retractor)
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	min_cold_protection_temperature = 263.15

//Blueshield
/obj/item/clothing/suit/storage/urist/coat/blueshield //no toggle yet
	name = "blueshield coat"
	desc = "NT deluxe ripoff. You finally have your own coat."
	icon_state = "blueshieldcoat"
	item_state = "blueshieldcoat"
	blood_overlay_type = "coatblood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	allowed = list(/obj/item/gun/energy,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/device/flashlight,/obj/item/melee/telebaton)
	armor = list(melee = 50, bullet = 10, laser = 25, energy = 10, bomb = 0, bio = 0, rad = 0)
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = 263.15
	//flags =

/obj/item/clothing/suit/armor/pcarrier/deus_blueshield
	name = "blue shield security armor"
	desc = "A plate carrier with the badge of a Blue Shield Security lieutenant. It can be equipped with armor plates, but provides no protection of its own."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	item_icons = list("slot_suit" = 'icons/mob/onmob/onmob_suit.dmi')
	icon_state = "deus_blueshield"
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_C)

//more pants

/obj/item/clothing/under/pants/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/nt-tgclothing.dmi'

/obj/item/clothing/under/pants/urist/jeans
	name = "jeans"
	desc = "A pair of tough blue jeans."
	icon_state = "jeans"
	item_state = "jeans"

/obj/item/clothing/under/pants/urist/jeans_b
	name = "black jeans"
	desc = "A pair of tough blue jeans."
	icon_state = "jeans_b"
	item_state = "jeans_b"

/obj/item/clothing/under/pants/urist/jeans_m
	name = "mustang jeans"
	desc = "A pair of washed out jeans."
	icon_state = "jeans_m"
	item_state = "jeans_m"

/obj/item/clothing/under/pants/urist/jeans_d
	name = "distressed jeans"
	desc = "A pair of distressed blue jeans. You cool cat."
	icon_state = "jeans_d"
	item_state = "jeans_d"

/obj/item/clothing/under/pants/urist/whitepants
	name = "white pants"
	desc = "A pair of crisp white pants. They're clean, for now."
	icon_state = "whitepants"
	item_state = "whitepants"

/obj/item/clothing/under/pants/urist/redpants
	name = "red pants"
	desc = "A pair of crisp red pants. Good for hiding your blood."
	icon_state = "redpants"
	item_state = "redpants"

/obj/item/clothing/under/pants/urist/militarypants
	name = "military pants"
	desc = "A pair of military style pants. Why are you wearing these again?"
	icon_state = "militarypants"
	item_state = "militarypants"

/obj/item/clothing/under/pants/urist/leatherpants
	icon = 'icons/urist/items/clothes/clothes.dmi'
	name = "leather pants"
	desc = "A pair of leather pants. Look at you, wearing the skin of vanquished creatures."
	icon_state = "leatherpants"
	item_state = "leatherpants"

//blackwarden

/obj/item/clothing/suit/urist/armor/warden
	urist_only = 0
	name = "Warden's black jacket"
	desc = "A black armoured jacket worn by a Warden of a security force."
	icon_state = "warden_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	blood_overlay_type = "armorblood"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_C)
	accessories = list(/obj/item/clothing/accessory/armor_plate/medium)

/obj/item/clothing/under/urist/blackwarden
	name = "black Warden's jumpsuit"
	desc = "A black jumpsuit worn by the Warden of a security force."
	icon_state = "warden_black"
	item_state = "warden_black"

//New jackets

/obj/item/clothing/suit/storage/toggle/urist/coat/brown
	name = "brown coat"
	desc = "A warm wool jacket in brown. Perfect for looking nice in Space Winter."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "brownjacket"

/obj/item/clothing/suit/storage/toggle/urist/coat/black
	name = "black coat"
	desc = "A warm wool jacket in black. Perfect for looking nice in Space Winter."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_state = "blackjacket"

//Some casual clothing.

/obj/item/clothing/under/urist/casual/olive
	name = "olive outfit"
	desc = "A olive button up shirt sporting jeans."
	icon_state = "oliveoutfit"
	item_state = "oliveoutfit"

/obj/item/clothing/under/urist/casual/plaid
	name = "plaid outfit"
	desc = "A plaid green button up shirt sporting brown slacks."
	icon_state = "plaidoutfit"
	item_state = "plaidoutfit"

/obj/item/clothing/under/urist/casual/suspenders
	name = "red outfit with suspenders"
	desc = "A red button up shirt sporting tan slacks and suspenders."
	icon_state = "moutfit"
	item_state = "moutfit"

/obj/item/clothing/suit/urist/sweater/pink
	name = "pink sweater"
	desc = "A pink sweater that makes you feel prettier and manlier."
	icon_state = "pinksweater"
	item_state = "pinksweater"

/obj/item/clothing/suit/urist/sweater/blue
	name = "blue sweater"
	desc = "A blue sweater that makes you feel prettier and happier."
	icon_state = "bluesweater"
	item_state = "bluesweater"

/obj/item/clothing/suit/urist/sweater/blue/heart
	name = "blue heart sweater"
	desc = "A blue sweater with a heart that makes you feel prettier and in love."
	icon_state = "blueheart"
	item_state = "blueheart"

/obj/item/clothing/suit/urist/sweater/mint
	name = "mint sweater"
	desc = "A mint sweater that makes you feel prettier and yummier."
	icon_state = "mintsweater"
	item_state = "mintsweater"

/obj/item/clothing/suit/urist/sweater/nanotrasen
	name = "Nanotrasen sweater"
	desc = "A blue sweater with the letters 'NT' on it that displays your loyalty to the company."
	icon_state = "ntsweater"
	item_state = "ntsweater"

//Luna's Men

/obj/item/clothing/under/urist/luna
	name = "luna's men"
	desc = "An outfit of those who support Luna."
	icon_state = "luna"
	item_state = "luna"

/obj/item/clothing/suit/urist/armor
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	item_flags = ITEM_FLAG_THICKMATERIAL
	cold_protection = UPPER_TORSO|LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO|LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6

//First Order

/obj/item/clothing/suit/urist/armor/fo
	name = "first order suit"
	desc = "A very clean white and black suit."
	icon_state = "fo"
	item_state = "fo"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	blood_overlay_type = "armorblood"
	item_flags = ITEM_FLAG_THICKMATERIAL
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

//Actual armour

/obj/item/clothing/suit/urist/armor/trash //Isn't actually good
	name = "heavy metal armour"
	desc = "A heavy set of armour"
	icon_state = "trash"
	item_state = "trash"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	blood_overlay_type = "armorblood"
	item_flags = ITEM_FLAG_THICKMATERIAL

/obj/item/clothing/suit/urist/armor/trash/blue //Isn't actually good
	name = "heavy metal blue armour"
	desc = "A heavy set of blue armour"
	icon_state = "bluetrash"
	item_state = "bluetrash"

/obj/item/clothing/suit/urist/armor/trash/heavy //Isn't actually good
	name = "spooky dragon armour"
	desc = "A heavy set of armour"
	icon_state = "heavytrash"
	item_state = "heavytrash"

/obj/item/clothing/suit/urist/armor/trash/hunt //Isn't actually good
	name = "witch hunt armour"
	desc = "A heavy set of armour"
	icon_state = "witchhunt"
	item_state = "witchhunt"

/obj/item/clothing/suit/urist/armor/trash/spacemarine //Isn't actually good
	name = "heavy armour"
	desc = "A set of large overly bulky armour."
	icon_state = "spacemarine"
	item_state = "spacemarine"

/obj/item/clothing/suit/urist/armor/trash/doom //Isn't actually good
	name = "heavy armour"
	desc = "A set of large overly bulky armour."
	icon_state = "doomguy"
	item_state = "doomguy"

//altshield

/obj/item/clothing/under/urist/altshield
	name = "blueshield's outfit"
	desc = "A more practical outfit often worn by Nanotrasen blueshields."
	icon_state = "altshield"
	item_state = "altshield"

//Halloween

/obj/item/clothing/under/urist/halloween/princess
	name = "princess"
	desc = "A very pretty dress."
	icon_state = "princesszeld"
	item_state = "princesszeld"

/obj/item/clothing/under/urist/halloween/beaker
	name = "beaker"
	desc = "An over sized beaker."
	icon_state = "beaker"
	item_state = "beaker"

/obj/item/clothing/under/urist/halloween/facebook
	name = "facebook"
	desc = "Did someone really tape a book to their face?"
	icon_state = "facebook"
	item_state = "facebook"



//Civil War and other uniforms//

/obj/item/clothing/under/urist/civilwar/usltgen
	name = "US Army Lieutenant General Uniform"
	desc = "A uniform worn by an army commander."
	icon_state = "Lieut_General_US"
	item_state = "Lieut_General_US"

/obj/item/clothing/under/urist/civilwar/usbriggen
	name = "US Army Brigadier General Uniform"
	desc = "A uniform worn by an army commander."
	icon_state = "Brig_General_US"
	item_state = "Brig_General_US"

/obj/item/clothing/under/urist/civilwar/uscol
	name = "US Army Colonel Uniform"
	desc = "A uniform worn by an infantry commander."
	icon_state = "Colonel_of_Infantry_US"
	item_state = "Colonel_of_Infantry_US"

/obj/item/clothing/under/urist/civilwar/uspvt
	name = "US Army Private Uniform"
	desc = "A uniform worn by an infantryman."
	icon_state = "Private_Infantry_US"
	item_state = "Private_Infantry_US"

/obj/item/clothing/under/urist/civilwar/csapvt
	name = "CS Army Private Uniform"
	desc = "A uniform worn by an infantryman."
	icon_state = "Private_Infantry_CS"
	item_state = "Private_Infantry_CS"

/obj/item/clothing/under/urist/civilwar/csalt
	name = "CS Army Lieutenant Uniform"
	desc = "A uniform worn by an infantry commander."
	icon_state = "Lieutenant_CS"
	item_state = "Lieutenant_CS"

/obj/item/clothing/under/urist/civilwar/csacpt
	name = "CS Army Artilery Captain Uniform"
	desc = "A uniform worn by an artillery commander."
	icon_state = "Captain_Artillery_CS"
	item_state = "Captain_Artillery_CS"

/obj/item/clothing/under/urist/civilwar/csagen
	name = "CS Army General Uniform"
	desc = "A uniform worn by an army commander."
	icon_state = "General_CS"
	item_state = "General_CS"

/obj/item/clothing/under/urist/civilwar/bluecoatuni
	name = "Blue Coat Infantry Uniform"
	desc = "A simple uniform worn by infantrymen."
	icon_state = "blue_coat_uniform"
	item_state = "blue_coat_uniform"

/obj/item/clothing/under/urist/civilwar/redcoatuni
	name = "Red Coat Infantry Uniform"
	desc = "A simple uniform worn by infantrymen."
	icon_state = "red_coat_uniform"
	item_state = "red_coat_uniform"

/obj/item/clothing/under/urist/civilwar/hamiltonclothes
	name = "Hamilton Clothes"
	desc = "White slacks paired with a suitable tan button up."
	icon_state = "hamilton_uniform"
	item_state = "hamilton_uniform"

/obj/item/clothing/suit/urist/civilwar/bluecoatjacket
	name = "Blue Infantry Coat"
	desc = "A blue coat worn by soldiers."
	icon_state = "blue_coat_coat"
	item_state = "blue_coat_coat"

/obj/item/clothing/suit/urist/civilwar/redcoatjacket
	name = "Red Infantry Coat"
	desc = "A red coat worn by soldiers."
	icon_state = "red_coat_coat"
	item_state = "red_coat_coat"

/obj/item/clothing/suit/urist/civilwar/hamiltoncoat
	name = "Hamilton Coat"
	desc = "A blue coat sporting gold buttons."
	icon_state = "hamiltoncoat"
	item_state = "hamiltoncoat"

//RS Armor Suits

/obj/item/clothing/suit/urist/armor/bronzearmor
	name = "Bronze Armor"
	desc = "Provides protection."
	icon_state = "suit_bronze"
	item_state = "suit_bronze"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	w_class = 4
	item_flags = ITEM_FLAG_THICKMATERIAL
	armor = list(melee = 15, bullet = 6.6, laser = 10, energy = 2, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/addyarmor
	name = "Adamantite Armor"
	desc = "Provides modest protection."
	icon_state = "suit_green"
	item_state = "suit_green"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	w_class = 4
	armor = list(melee = 25, bullet = 16, laser = 20, energy = 12, bomb = 25, bio = 0, rad = 0)
	item_flags = ITEM_FLAG_THICKMATERIAL


/obj/item/clothing/suit/urist/armor/runearmor
	name = "Runeite Armor"
	desc = "Provides excelent protection."
	icon_state = "suit_blue"
	item_state = "suit_blue"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	w_class = 4
	armor = list(melee = 75, bullet = 40, laser = 50, energy = 25, bomb = 40, bio = 0, rad = 0)
	item_flags = ITEM_FLAG_THICKMATERIAL

//why is this not storage? Duplicate item, but it makes way more sense as a storage item.

/obj/item/clothing/suit/storage/capjacket
	name = "captain's uniform jacket"
	desc = "A less formal jacket for everyday captain use."
	icon_state = "capjacket"
	item_state = "capjacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv = 0

//leather stuff

/obj/item/clothing/suit/storage/urist/coat/duster
	name = "duster"
	desc = "A floor length duster. Perfect for looking like you just rolled into a one-horse town."
	icon_state = "duster"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 15, bullet = 5, laser = 5, energy = 5, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/urist/coat/leather
	name = "leather coat"
	desc = "A thick leather coat."
	icon_state = "autumn"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 15, bullet = 5, laser = 5, energy = 5, bomb = 0, bio = 0, rad = 0)

//overalls/apron

/obj/item/clothing/suit/storage/urist/overalls
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/storage/urist/overalls/leather
	name = "leather overalls"
	desc = "A sturdy pair of leather work overalls with a ton of pockets for storing all sorts of stuff."
	icon_state = "overalls_acc"
	item_state = "overalls_acc"

/obj/item/clothing/suit/storage/urist/overalls/electricians
	name = "electrician's overalls"
	desc = "A sturdy pair of electrician's work overalls with a ton of pockets for storing all your tools."
	icon_state = "electrician-overalls"
	item_state = "electrician-overalls"

/obj/item/clothing/suit/storage/urist/overalls/standard
	name = "work overalls"
	desc = "A sturdy pair of work overalls with a ton of pockets for storing all sorts of stuff."
	icon_state = "emergency-overalls"
	item_state = "emergency-overalls"

/obj/item/clothing/suit/storage/urist/apron
	name = "factory worker's apron"
	desc = "A sturdy leather work apron, with pockets for storing tools."
	icon_state = "factoryworker-apron"
	item_state = "factoryworker-apron"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/suit/storage/hooded/sandsuit
	action_button_name = "Toggle Hood"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS|HEAD
	min_cold_protection_temperature = 243.15
	armor = list(melee = 20, bullet = 5, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/winterhood/sandsuit
	icon = 'icons/urist/items/clothes/clothes.dmi'
	item_icons = URIST_ALL_ONMOBS
	icon_state = "sandsuit"
	item_state = "sandsuit"
	name = "leather protective suit"
	desc = "A full-body suit meant to protect against the elements."
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/suit.dmi')
	allowed = list(/obj/item/gun,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/tank,/obj/item/melee/energy/sword,/obj/item/device/flashlight,/obj/item/device/radio)

/obj/item/clothing/under/urist/cowboy
	name = "cowboy's outfit"
	desc = "A simple buttoned shirt paired with a leather vest and pants. A classic cowboy's outfit."
	icon_state = "cowboy"
	item_state = "cowboy"

/obj/item/clothing/suit/urist/poncho
	name = "poncho"
	desc = "A simple poncho, the kind that could've been worn by a gunslinger in the Wild West."
	icon_state = "poncho"
	item_state = "poncho"

/* Bay restores */
/obj/item/clothing/accessory/armband/science
	name = "science armband"
	desc = "An armband, worn by the crew to display which department they're assigned to. This one is purple."
	icon_state = "rnd"

// Biohazard Stuff, and Big Bulky Dumb Suits.

// Grey Version of the biosuit.
/obj/item/clothing/head/biohazardhoodgrey
	name = "custodial bio hood"
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "bulky_grey_hood"
	item_state = "bulky_grey_hood"
	desc = "A bulky grey hood that protects the user from biohazardous materials."
	w_class = 3.0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/suit/biohazardgrey
	name = "custodial bio suit"
	desc = "A bulky grey suit that protects against biological contamination."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "bulky_grey"
	item_state = "bulky_grey"
	item_state_slots = list(
		slot_l_hand_str = "bio_suit",
		slot_r_hand_str = "bio_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank,/obj/item/pen,/obj/item/device/flashlight/pen,/obj/item/device/scanner/health,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.3

// Radiation Suit.
/obj/item/clothing/head/biohazardradiationhood
	name = "bulky radiation hood"
	desc = "A bulky yellow hood designed to protect the user from radiation."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "bulky_yellow_hood"
	item_state = "bulky_yellow_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)

/obj/item/clothing/suit/biohazardradiation
	name = "bulky radiation suit"
	desc = "A bulky yellow radiation suit, designed to protect the user from radiation exposure."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "bulky_yellow"
	item_state = "bulky_yellow"
	item_state_slots = list(
		slot_l_hand_str = "rad_suit",
		slot_r_hand_str = "rad_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS|HANDS|FEET
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/clothing/head/radiation,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 60, rad = 100)
	flags_inv = HIDEJUMPSUIT|HIDETAIL|HIDEGLOVES|HIDESHOES
	siemens_coefficient = 0.3

/obj/item/clothing/suit/biohazardradiation/New()
	..()
	slowdown_per_slot[slot_shoes] = 1.5

// Blue Biohazard Suit.
/obj/item/clothing/head/biohazardbluehood
	name = "blue medical hood"
	desc = "A bulky grey hood that protects the user from biohazardous materials."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "bulky_blue_hood"
	item_state = "bulky_blue_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)

/obj/item/clothing/suit/biohazardblue
	name = "blue medical biosuit"
	desc = "A bulky blue suit that protects against biological contamination. This suit appears to have a medical cross on it."
	icon = 'icons/urist/items/clothes/clothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'
	icon_state = "bulky_blue"
	item_state = "bulky_blue"
	item_state_slots = list(
		slot_l_hand_str = "bio_suit",
		slot_r_hand_str = "bio_suit",
	)
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0
	permeability_coefficient = 0
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/tank,/obj/item/pen,/obj/item/device/flashlight/pen,/obj/item/device/scanner/health,/obj/item/device/ano_scanner,/obj/item/clothing/head/bio_hood,/obj/item/clothing/mask/gas)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	item_flags = ITEM_FLAG_THICKMATERIAL
	siemens_coefficient = 0.3

//moving this here from noctis_jobs.dm for pirate use
/obj/item/clothing/suit/armor/pcarrier/light/hijacker
	color = "#ff0000"

/obj/item/clothing/under/syndicate/pirate
	accessories = list(/obj/item/clothing/accessory/armband, /obj/item/clothing/accessory/kneepads, /obj/item/clothing/accessory/storage/bandolier)

//moving this here from nerva_clothes.dm to not break other maps

/obj/item/clothing/suit/urist/armor/nerva/sec
	name = "armour vest"
	desc = "A bulky armoured vest assigned to the ICS Nerva's security officers. Has space to attach additional pouches for storage."
	icon_state = "nervasecarmour"
	item_state = "nervasecarmour"
	blood_overlay_type = "armorblood"
	armor = list(melee = 50, bullet = 45, laser = 40, energy = 25, bomb = 30, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_L, ACCESSORY_SLOT_ARMOR_S)
	accessories = list(/obj/item/clothing/accessory/storage/pouches/large)

//rescued colored spacesuits from bay. too nice to let go
/obj/item/clothing/suit/urist/space/syndicate

//Green syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/green
	name = "green space suit"
	icon_state = "syndicate-green"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-green",
		slot_r_hand_str = "syndicate-green",
	)
	item_icons = URIST_ALL_ONMOBS

//Dark green syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/green/dark
	name = "dark green space suit"
	icon_state = "syndicate-green-dark"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-green-dark",
		slot_r_hand_str = "syndicate-green-dark",
	)
	item_icons = URIST_ALL_ONMOBS

//Orange syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/orange
	name = "orange space suit"
	icon_state = "syndicate-orange"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-orange",
		slot_r_hand_str = "syndicate-orange",
	)
	item_icons = URIST_ALL_ONMOBS

//Blue syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/blue
	name = "blue space suit"
	icon_state = "syndicate-blue"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-blue",
		slot_r_hand_str = "syndicate-blue",
	)
	item_icons = URIST_ALL_ONMOBS

//Black-green syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/green
	name = "black and green space suit"
	icon_state = "syndicate-black-green"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-green",
		slot_r_hand_str = "syndicate-black-green",
	)
	item_icons = URIST_ALL_ONMOBS

//Black-blue syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/blue
	name = "black and blue space suit"
	icon_state = "syndicate-black-blue"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-blue",
		slot_r_hand_str = "syndicate-black-blue",
	)
	item_icons = URIST_ALL_ONMOBS

//Black medical syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/med
	name = "black medical space suit"
	icon_state = "syndicate-black-med"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)
	item_icons = URIST_ALL_ONMOBS

//Black-orange syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/orange
	name = "black and orange space suit"
	icon_state = "syndicate-black-orange"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)
	item_icons = URIST_ALL_ONMOBS

//Black-red syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/red
	name = "black and red space suit"
	icon_state = "syndicate-black-red"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black-red",
		slot_r_hand_str = "syndicate-black-red",
	)
	item_icons = URIST_ALL_ONMOBS

//Black with yellow/red engineering syndicate space suit

/obj/item/clothing/suit/urist/space/syndicate/black/engie
	name = "black engineering space suit"
	icon_state = "syndicate-black-engie"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-black",
		slot_r_hand_str = "syndicate-black",
	)
	item_icons = URIST_ALL_ONMOBS

//rescued asset protection rig
/obj/item/rig/ert/assetprotection
	name = "heavy emergency response suit control module"
	desc = "A heavy, modified version of a common emergency response hardsuit. Has blood red highlights.  Armoured and space ready."
	suit_type = "heavy emergency response"
	icon_state = "asset_protection_rig"

// rescued resomi coat
/obj/item/clothing/suit/storage/toggle/urist/resomicoat
	name = "small coat"
	desc = "A coat that seems too small to fit a human."
	icon_state = "resomicoat"
	body_parts_covered = UPPER_TORSO|ARMS|LOWER_TORSO|LEGS
	species_restricted = list(SPECIES_RESOMI)

//fuck them lizards

/obj/item/clothing/shoes/urist/unathiboots
	name = "unathi skin boots"
	desc = "A fancy pair of boots made from very large reptile."
	icon_state = "unathiboots"
	item_state = "unathiboots"

/obj/item/clothing/shoes/urist/unathiboots/green
	icon_state = "unathiboots_green"
	item_state = "unathiboots_green"

//civ13 clothing

/obj/item/clothing/under/urist/historic
	name = "yellow tunic"
	desc = "A simple yellow tunic."
	icon_state = "yellow_tunic"
	item_state = "yellow_tunic"

/obj/item/clothing/under/urist/historic/blue_tunic
	name = "blue tunic"
	desc = "A simple blue tunic."
	icon_state = "blue_tunic"
	item_state = "blue_tunic"

/obj/item/clothing/under/urist/historic/red_tunic
	name = "red tunic"
	desc = "A simple red tunic."
	icon_state = "red_tunic"
	item_state = "red_tunic"

/obj/item/clothing/under/urist/historic/green_tunic
	name = "green tunic"
	desc = "A simple green tunic."
	icon_state = "green_tunic"
	item_state = "green_tunic"

/obj/item/clothing/under/urist/historic/white_tunic
	name = "white tunic"
	desc = "A simple white tunic."
	icon_state = "white_tunic"
	item_state = "white_tunic"

/obj/item/clothing/under/urist/historic/leather_tunic
	name = "leather tunic"
	desc = "A plain leather tunic."
	icon_state = "leather_tunic"
	item_state = "leather_tunic"
	armor = list(melee = 10, bullet = 0, laser = 5, energy = 5, bomb = 0, bio = 0, rad = 0)//halved from sandsuit, removed bullet armor. made of leather

/obj/item/clothing/under/urist/historic/red_tunic2
	name = "red and yellow tunic"
	desc = "A simple red and yellow tunic."
	icon_state = "red_tunic2"
	item_state = "red_tunic2"

/obj/item/clothing/under/urist/historic/blue_tunic2
	name = "blue and white tunic"
	desc = "A simple blue and white tunic."
	icon_state = "blue_tunic2"
	item_state = "blue_tunic2"

/obj/item/clothing/under/urist/historic/pirate1
	name = "common clothes"
	desc = "A pair of trousers and a black striped shirt."
	icon_state = "pirate1"
	item_state = "pirate1"

/obj/item/clothing/under/urist/historic/pirate2
	name = "common clothes"
	desc = "A pair of trousers and a red striped shirt."
	icon_state = "pirate2"
	item_state = "pirate2"

/obj/item/clothing/under/urist/historic/pirate3
	name = "common clothes"
	desc = "A pair of trousers and a blue striped shirt."
	icon_state = "pirate3"
	item_state = "pirate3"

/obj/item/clothing/under/urist/historic/pirate4
	name = "common clothes"
	desc = "A pair of trousers and a shirt."
	icon_state = "pirate4"
	item_state = "pirate4"

/obj/item/clothing/under/urist/historic/pirate5
	name = "common clothes"
	desc = "A pair of trousers and a shirt."
	icon_state = "pirate5"
	item_state = "pirate5"

/obj/item/clothing/under/urist/historic/roman
	name = "roman tunic"
	desc = "A short red tunic with a rope belt."
	icon_state = "roman"
	item_state = "roman"

/obj/item/clothing/under/urist/historic/steppe_wool
	name = "wool clothes"
	desc = "A wool shirt and pair oftrousers."
	icon_state = "steppe_wool_tunic"
	item_state = "steppe_wool_tunic"

/obj/item/clothing/under/urist/historic/dressg
	name = "dress"
	desc = "A green dress with an apron."
	icon_state = "dressg"
	item_state = "dressg"

/obj/item/clothing/under/urist/historic/dressr
	name = "dress"
	desc = "A red dress with an apron."
	icon_state = "dressr"
	item_state = "dressr"

/obj/item/clothing/under/urist/historic/dressbl
	name = "dress"
	desc = "A blue dress with an apron."
	icon_state = "dressbl"
	item_state = "dressbl"

/obj/item/clothing/under/urist/historic/dressbr
	name = "dress"
	desc = "A brown dress with an apron."
	icon_state = "dressbr"
	item_state = "dressbr"

/obj/item/clothing/under/urist/historic/merchant_suit
	name = "merchant_suit"
	desc = "A fancy set of clothes for a fancy person."
	icon_state = "merchant_suit"
	item_state = "merchant_suit"

/obj/item/clothing/under/urist/historic/mummy
	name = "mummy wraps"
	desc = "linen wraps for a burial"
	icon_state = "mummy"
	item_state = "mummy"
	flags_inv = HIDEEARS|BLOCKHEADHAIR

/obj/item/clothing/under/urist/historic/sheriff
	name = "sheriff uniform"
	desc = "A small town copper."
	icon_state = "sd_sheriff"
	item_state = "sd_sheriff"

//civ13 top layer, coats and armor

/obj/item/clothing/suit/urist/armor/historic/full
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	w_class = 4
	item_flags = ITEM_FLAG_THICKMATERIAL
	armor = list(melee = 55, bullet = 20, laser = 20, energy = 10, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/historic/chestplate
	body_parts_covered = UPPER_TORSO
	w_class = 3
	item_flags = ITEM_FLAG_THICKMATERIAL
	armor = list(melee = 45, bullet = 15, laser = 15, energy = 2, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/suit/urist/armor/historic/chain
	name = "bronze armor"
	desc = "Provides protection."
	icon_state = "suit_bronze"
	item_state = "suit_bronze"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	w_class = 3
	item_flags = ITEM_FLAG_THICKMATERIAL
	armor = list(melee = 35, bullet = -10, laser = 10, energy = 2, bomb = 5, bio = 0, rad = 0) //-10, its old chainmail, its giving you extra shrapnel

/obj/item/clothing/suit/urist/historic/piratejacket1
	name = "black jacket"
	desc = "An open black jacket."
	icon_state = "piratejacket1"
	item_state = "piratejacket1"

/obj/item/clothing/suit/urist/historic/piratejacket2
	name = "brown jacket"
	desc = "An open brown jacket."
	icon_state = "piratejacket2"
	item_state = "piratejacket2"

/obj/item/clothing/suit/urist/historic/piratejacket3
	name = "blue vest"
	desc = "A blue vest that can no longer be buttoned up."
	icon_state = "piratejacket3"
	item_state = "piratejacket3"

/obj/item/clothing/suit/urist/historic/piratejacket4
	name = "brown vest"
	desc = "A brown vest that can no longer be buttoned up."
	icon_state = "piratejacket4"
	item_state = "piratejacket4"

/obj/item/clothing/suit/urist/historic/piratejacket5
	name = "red jacket"
	desc = "An open red jacket."
	icon_state = "piratejacket5"
	item_state = "piratejacket5"

/obj/item/clothing/suit/urist/historic/bluevest
	name = "blue vest"
	desc = "A closed blue vest."
	icon_state = "bluevest"
	item_state = "bluevest"

/obj/item/clothing/suit/urist/historic/blackvest
	name = "black vest"
	desc = "A closed black."
	icon_state = "blackvest"
	item_state = "blackvest"

/obj/item/clothing/suit/urist/historic/olivevest
	name = "olive vest"
	desc = "A closed olive vest."
	icon_state = "olivevest"
	item_state = "olivevest"

/obj/item/clothing/suit/urist/armor/historic/full/knight_yellow
	name = "yellow armor suit"
	desc = "A set of armor painted yellow."
	icon_state = "knight_yellow"
	item_state = "knight_yellow"

/obj/item/clothing/suit/urist/armor/historic/full/knight_green
	name = "green armor suit"
	desc = "A set of armor painted green."
	icon_state = "knight_green"
	item_state = "knight_green"

/obj/item/clothing/suit/urist/armor/historic/full/knight_red
	name = "red armor suit"
	desc = "A set of armor painted red."
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/suit/urist/armor/historic/full/knight_blue
	name = "blue armor suit"
	desc = "A set of armor painted blue."
	icon_state = "knight_blue"
//	item_state = "knight_blue"

/obj/item/clothing/suit/urist/armor/historic/full/knight_blue2
	name = "blue armor suit"
	desc = "A set of armor painted blue."
	icon_state = "knight_blue2"
	item_state = "knight_blue2"

/obj/item/clothing/suit/urist/armor/historic/full/knight_simple
	name = "plain armor suit"
	desc = "simple unadorned knights armor."
	icon_state = "knight_simple"
	item_state = "knight_simple"

/obj/item/clothing/suit/urist/armor/historic/full/knight_templar
	name = "templar armor"
	desc = "Non nobis, Domine, non nobis, sed Nomini tuo da gloriam."
	icon_state = "knight_templar"
	item_state = "knight_templar"

/obj/item/clothing/suit/urist/armor/historic/chestplate/bronze_chestplate
	name = "bronze chestplate"
	desc = "A simple bronze chestplate."
	icon_state = "bronze_chestplate"
	item_state = "bronze_chestplate"

/obj/item/clothing/suit/urist/armor/historic/chestplate/iron_chestplate
	name = "iron chestplate"
	desc = "A simple iron chestplate."
	icon_state = "iron_chestplate"
	item_state = "iron_chestplate"

/obj/item/clothing/suit/urist/armor/historic/chestplate/scale_plate
	name = "scaled plate"
	desc = "A chestplate made from strips of iron."
	icon_state = "scale_plate"
	item_state = "scale_plate"

/obj/item/clothing/suit/urist/armor/historic/chestplate/egyptian_lamellar
	name = "lamellar armor"
	desc = "A chestplate made from strips of old iron."
	icon_state = "egyptian_lamellar"
	item_state = "egyptian_lamellar"

/obj/item/clothing/suit/urist/armor/historic/chestplate/iron_chestplater
	name = "iron chestplate"
	desc = "A chestplate with a red cape."
	icon_state = "iron_chestplater"
	item_state = "iron_chestplater"

/obj/item/clothing/suit/urist/armor/historic/chestplate/iron_chestplateb
	name = "iron chestplate"
	desc = "A chestplate with a blue cape."
	icon_state = "iron_chestplateb"
	item_state = "iron_chestplateb"

/obj/item/clothing/suit/urist/armor/historic/chain/scaled_armor
	name = "scale armor"
	desc = "A chainmail tunic made from bronze scales."
	icon_state = "scaled_armor"
	item_state = "scaled_armor"

/obj/item/clothing/suit/urist/armor/historic/chain/early_chainmail
	name = "early chainmail"
	desc = "An ancient set of chainmail."
	icon_state = "early_chainmail"
	item_state = "early_chainmail"

/obj/item/clothing/suit/urist/armor/historic/chain/chainmail
	name = "chainmail tunic"
	desc = "A set of armor made from interlocked chains."
	icon_state = "chainmail"
	item_state = "chainmail"

//rescued bandanas
/obj/item/clothing/head/urist/bandana/green
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "greenbandana"
	item_state = "greenbandana"

/obj/item/clothing/head/urist/bandana/orange
	name = "orange bandana"
	desc = "An orange piece of cloth, worn on the head."
	icon_state = "orange_bandana"
	item_state = "orange_bandana"

/obj/item/clothing/suit/urist/raincoat
	name = "tan raincoat"
	desc = "A tan scuffy raincoat, often worn by disheveled detectives trying to solve another homicide case."
	icon_state = "raincoat"
	item_state = "raincoat"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency,
		/obj/item/device/flashlight,
		/obj/item/gun/energy,
		/obj/item/gun/projectile,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/storage/fancy/smokable,
		/obj/item/flame/lighter,
		/obj/item/device/taperecorder
	)
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR
		)

//pirate spacesuit variant
//Black syndicate space suit
/obj/item/clothing/head/helmet/space/syndicate/black/pirate
	name = "salvaged black space helmet"
	desc = "A black helmet sporting clean lines and durable plating. It's seen better days."
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/suit/space/syndicate/black/pirate
	name = "salvaged black space suit"
	desc = "A black spacesuit sporting clean lines and durable plating. It's seen better days."
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SMALL,
		rad = ARMOR_RAD_MINOR
		)

/obj/item/clothing/under/contortionist
	name = "contortionist's jumpsuit"
	desc = "A light jumpsuit useful for squeezing through narrow vents."
	icon_state = "robotics2"
	item_state = "robotics2"

/obj/item/clothing/under/contortionist/proc/check_clothing(mob/user as mob)
	//Allowed to wear: glasses, shoes, gloves, pockets, mask, and jumpsuit (obviously)
	var/list/slot_must_be_empty = list(slot_back,slot_handcuffed,slot_legcuffed,slot_l_hand,slot_r_hand,slot_belt,slot_head,slot_wear_suit)
	for(var/slot_id in slot_must_be_empty)
		user << "<span class='warning'>You can't fit inside while wearing those bulky clothes.</span>"
		return 0
