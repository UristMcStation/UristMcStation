 /*										*****New space to put all UristMcStation Clothing*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/uristclothes.dmi'
All UMcS clothing will now go here, to prevent unecessary .dm's. I mean, how much clothes do we need anyways... -Glloyd

Update 23/03/2014 - removed all the ports of BS12 clothing. So, naval stuff, swimsuits, detective gear, cap's jacket, HoP whimsy and storage webbing stuff.*/

//this is important to save me time with all these dresses

/obj/item/clothing/under/urist
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'

/obj/item/clothing/head/urist
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'


//SciRIG. It's hip, it's happening and it protects against space and some other shit. You fuckers said you wanted more EVA.
//It's totally not just a reskin of the medrig...

/obj/item/clothing/head/helmet/space/rig/science
	name = "science hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	item_color = "medical"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 60, bio = 100, rad = 30)

/obj/item/clothing/suit/space/rig/science
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "Scirig"
	name = "science hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Built with lightweight materials for easier movement. Looks like it could hold up against an explosion."
	item_state = "Scirig"
	slowdown = 2
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/weapon/storage/box/monkeycubes,/obj/item/device/aicard,/obj/item/device/paicard,/obj/item/weapon/hand_tele)
	armor = list(melee = 10, bullet = 5, laser = 10,energy = 5, bomb = 60, bio = 100, rad = 30)

//Emergency Suit. It's really shitty, but better than a firesuit when it comes to space or biological hazards. Will need a special "emergency locker" for this.
//One of the lockers will go in each of the emergency storages, and have one of these fuckers in them. Prepare to feel the suck as it slowly kills you.

/obj/item/clothing/suit/emergencysuit
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "emergency suit"
	desc = "A bulky suit meant to be used in emergencies only. It doesn't look too safe... Wait, is that blood?" //PREPARE FOR YOUR DOOM
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "emergency"
	item_state = "emergency"
	w_class = 4
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen)
	slowdown = 1.5
	armor = list(melee = 5, bullet = 0, laser = 5,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	flags = STOPSPRESSUREDMAGE
	heat_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	species_restricted = list("exclude","Vox")

/obj/item/clothing/head/emergencyhood
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	name = "emergency hood"
	desc = "A bulky hood meant to be used in emergencies only. It doesn't look too safe, and has some strange gray stains inside..."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "emergency_hood"
	item_state = "emergency_hood"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 50, rad = 25)
	flags = STOPSPRESSUREDMAGE
	cold_protection = HEAD
	species_restricted = list("exclude","Vox")

//Armoured biosuit for sec

/obj/item/clothing/head/bio_hood/asec
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	name = "armoured bio hood"
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "Armouredbiohood"
	desc = "An armoured hood that protects the head and face from biological comtaminants and minor damage."
	permeability_coefficient = 0.01
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES

/obj/item/clothing/suit/bio_suit/asec
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "armoured bio suit"
	desc = "An armoured suit that protects against biological contamination and minor damage."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "Armouredbiosuit"
	item_state = "bio_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown = 3.0 //disgusting slowdown to compensate.
	allowed = list(/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/pen,/obj/item/device/flashlight/pen)
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

//Welder apron done by ShoesandHats and added by Cozarctan. Moved from welder. Welder machete goes into the new uristweapons.dm

/obj/item/clothing/suit/welderapron
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "welder's apron"
	desc = "A leather work apron."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "welderapron"
	item_state = "welderapron"
	blood_overlay_type = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

//Naval Space suit. Or something like that. I don't fucking know.

/obj/item/clothing/head/helmet/space/naval
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	name = "naval space helmet"
	desc = "A high quality space helmet used by the Nanotrasen Navy."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "navyspacehelm"
	armor = list(melee = 55, bullet = 45, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

/obj/item/clothing/suit/space/naval
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "naval space suit"
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "navyspace"
	desc = "A high quality space suit used by the Nanotrasen Navy. Smells like oppression."
	w_class = 3
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/flashlight)
	slowdown = 1
	armor = list(melee = 60, bullet = 50, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

//Naval Commando Helmet and Suit

/obj/item/clothing/head/helmet/space/rig/commando
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	name = "naval commando helmet"
	desc = "An extremely intimidating helmet worn by the Nanotrasen Naval Commandos"
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "rig0-commando"
	item_color = "commando"
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 30, rad = 30)

/obj/item/clothing/suit/space/rig/commando
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "naval commando suit"
	desc = "A heavily armored suit that protects against moderate damage. Worn by the Nanotrasen Naval Commandos. It reeks of oppression."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "commando"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/tank/emergency_oxygen,/obj/item/weapon/melee/energy/sword)
	slowdown = 1
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 30, rad = 30)

//Meido outfit, Pretty much Japanese for Maid outfit. I will most likely be doing more costumes. -Nien

/obj/item/clothing/suit/meido
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "meido costume"
	desc = "A black maid costume."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "meido"
	item_state = "meido"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//psychologist clothing -- God I got lazy here.

/obj/item/clothing/under/rank/psychologist
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "psychologist's suit"
	desc = "A slightly weathered suit worn by the station's psychologist. Are those Cheesy Honker stains?" //you fukken slob
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "psychologist"
	item_state = "blacksuit"
	item_color = "psychologist"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/suit/psychologist
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "tweed jacket"
	desc = "A tweed jacket worn by the station's psychologist. It looks a tad worn at the elbows."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "tweedjacket"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/dnainjector,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)

	verb/toggle()
		set name = "Toggle Coat Buttons"
		set category = "Object"
		set src in usr

		if(!usr.canmove || usr.stat || usr.restrained())
			return 0

		switch(icon_state)
			if("tweedjacket_open")
				src.icon_state = "tweedjacket"
				usr << "You button up the jacket."
			if("tweedjacket")
				src.icon_state = "tweedjacket_open"
				usr << "You unbutton the jacket."
			else
				usr << "You attempt to button-up the velcro on your [src], before promptly realising how retarded you are."
				return
		usr.update_inv_wear_suit()	//so our overlays update

//Terran Confederacy Trader outfit

/obj/item/clothing/under/terran
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'

/obj/item/clothing/suit/terran
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'

/obj/item/clothing/head/terran
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'

/obj/item/clothing/under/terran/trader
	name = "Terran Confederacy trader's outfit"
	desc = "An opulent outfit worn by a Terran Confederacy trader"
	icon_state = "TCToutfit"
	item_state = "TCToutfit"
	item_color = "TCToutfit"

/obj/item/clothing/suit/terran/trader
	name = "Terran Confederacy trader's cloak"
	desc = "An opulent cloak worn by a Terran Confederacy trader"
	icon_state = "TCTRobes"
	item_state = "TCTRobes"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/head/terran/trader
	name = "Terran Confederacy trader's hat"
	desc = "An opulent hat worn by a Terran Confederacy trader"
	icon_state = "TCTHat"
	item_state = "TCTHat"

//Alternate space wizard outfits. I hope to see more than just the necromancer's robes here one day.

/obj/item/clothing/suit/wizrobe/urist
	urist_only = 1
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_override = 'icons/uristmob/clothes.dmi'

/obj/item/clothing/head/wizard/urist
	urist_only = 1
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_override = 'icons/uristmob/head.dmi'

/obj/item/clothing/suit/wizrobe/urist/necro
	name = "necromancer's robes"
	desc = "A set of charcoal-black robes worn only by those practicing the darkest of arts. A variety of bones hang from it."
	icon_state = "necro"
	item_state = "necro"

/obj/item/clothing/head/wizard/urist/necro
	name = "necromancer's hood"
	desc = "A charcoal-black hood worn by the masters of life and death. Simply putting it on sharpens your senses."
	icon_state = "necrohood"
	item_state = "necrohood"

//NT Outfits

/obj/item/clothing/under/urist/nanotrasen/blue
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "blue nanotrasen outfit"
	desc = "A standard blue Nanotrasen outfit with a white NT on back."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "NTsuit"
	item_state = "NTsuit"
	item_color = "NTsuit"


/obj/item/clothing/under/urist/nanotrasen/white
	urist_only = 1
	icon_override = 'icons/uristmob/clothes.dmi'
	name = "white nanotrasen outfit"
	desc = "A standard white Nanotrasen outfit with a blue NT on back."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "NTWsuit"
	item_state = "NTWsuit"
	item_color = "NTWsuit"

//matching hats

/obj/item/clothing/head/soft/nanotrasen/blue
	icon_override = 'icons/uristmob/head.dmi'
	name = "blue nanotrasen cap"
	desc = "It's a baseball hat in the glorious colours of Nanotrasen. There is a white N on the front."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "ntbluesoft"
	item_color = "ntblue"

/obj/item/clothing/head/soft/nanotrasen/white
	icon_override = 'icons/uristmob/head.dmi'
	name = "white nanotrasen cap"
	desc = "It's a baseball hat in the glorious colours of Nanotrasen. There is a blue N on the front."
	icon = 'icons/urist/items/uristclothes.dmi'
	icon_state = "ntwhitesoft"
	item_color = "ntwhite"

//SO MANY FUCKING DRESSES

/obj/item/clothing/under/urist/dress/teal
	name = "teal dress"
	desc = "A pretty teal dress, for pretty ladies."
	icon_state = "tealdress"
	item_color = "tealdress"
	item_state = "tealdress"

/obj/item/clothing/under/urist/dress/yellow
	name = "floral yellow dress"
	desc = "A pretty yellow dress with some cute designs on it."
	icon_state = "yellowdress"
	item_color = "yellowdress"
	item_state = "yellowdress"

/obj/item/clothing/under/urist/dress/white1
	name = "short white dress"
	desc = "A pretty white dress. Short and sweet!"
	icon_state = "wd1"
	item_color = "wd1"
	item_state = "wd1"

/obj/item/clothing/under/urist/dress/white2
	name = "long white dress"
	desc = "A beautiful long white dress. Looks more formal than most dresses."
	icon_state = "wd2"
	item_color = "wd2"
	item_state = "wd2"

/obj/item/clothing/under/urist/dress/princess
	name = "princess dress"
	desc = "A cute dress fit for a princess!"
	icon_state = "princess"
	item_color = "princess"
	item_state = "princess"

obj/item/clothing/head/princessbow
	urist_only = 1
	icon_override = 'icons/uristmob/head.dmi'
	icon = 'icons/urist/items/uristclothes.dmi'
	name = "princess bow"
	desc = "A cute bow fit for a princess."
	icon_state = "princess_bow"
	item_color = "princess_bow"
	item_state = "princess_bow"

//nurse joy

obj/item/clothing/under/urist/rank/nurse
	name = "white nurse outfit"
	desc = "A pretty nurse outfit. It brings a sense of joy to you."
	icon_state = "nursejoy"
	item_color = "nursejoy"
	item_state = "nursejoy"

//alt alt RD

obj/item/clothing/under/urist/rank/rdgreen
	name = "green RD's outfit"
	desc = "A cute green outfit sometimes worn by the Research Director."
	icon_state = "emaRD"
	item_color = "emaRD"
	item_state = "emaRD"

//fixing hats

/obj/item/clothing/head/urist/beaverhat
	name = "beaver hat"
	icon_state = "beaver_hat"
	item_state = "beaver_hat"
	desc = "Like a top hat, but made of beavers."
	flags = FPRINT|TABLEPASS

/obj/item/clothing/head/urist/boaterhat
	name = "boater hat"
	icon_state = "boater_hat"
	item_state = "boater_hat"
	desc = "Goes well with celery."
	flags = FPRINT|TABLEPASS

/obj/item/clothing/head/urist/fedora
	name = "\improper fedora"
	icon_state = "fedora"
	item_state = "fedora"
	desc = "A great hat ruined by being within fifty yards of you."
	flags = FPRINT|TABLEPASS

//TIPS FEDORA
/obj/item/clothing/head/urist/fedora/verb/tip_fedora()
	set name = "Tip Fedora"
	set category = "Object"
	set desc = "Show those scum who's boss."

	usr << "You tip your fedora."
	usr.visible_message("[usr] tips his fedora.")

/obj/item/clothing/head/urist/fez
	name = "\improper fez"
	icon_state = "fez"
	item_state = "fez"
	desc = "Put it on your monkey, make lots of cash money."
	flags = FPRINT|TABLEPASS

//trolololo

/obj/item/clothing/under/sakura_hokkaido_kimono
	name = "Kimono"
	desc = "A pale-pink, nearly white, kimono with a red and gold obi. There is a embroidered design of cherry blossom flowers covering the kimono."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "sakura_hokkaido_kimono"
	item_state = "sakura_hokkaido_kimono"
	item_color = "sakura_hokkaido_kimono"
