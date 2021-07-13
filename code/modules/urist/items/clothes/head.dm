/*										*****New space to put all UristMcStation On-Head Clothing*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/items/clothes/head.dmi'
and on_mob icon_override sprites go to 'icons/uristmob/head.dmi' Put anything that isn't a child of clothing/head/helmet under clothing/head/urist
to avoid worrying about the sprites -Glloyd*/

//urist head id

/obj/item/clothing/head/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/head.dmi'
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')

//sci rig helmet

/obj/item/clothing/head/helmet/space/void/science
	name = "science hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low pressure environment. Built with lightweight materials for extra comfort."
	icon_state = "rig0-medical"
	item_state = "medical_helm"
	//item_color = "medical"
	armor = list(melee = 10, bullet = 5, laser = 5,energy = 5, bomb = 60, bio = 100, rad = 30)
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')

//emergency suit hood

/obj/item/clothing/head/urist/emergencyhood
	name = "emergency hood"
	desc = "A bulky hood meant to be used in emergencies only. It doesn't look too safe, and has some strange gray stains inside..."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "emergency_hood"
	item_state = "emergency_hood"
	armor = list(melee = 5, bullet = 0, laser = 0,energy = 0, bomb = 5, bio = 50, rad = 25)
	obj_flags = ITEM_FLAG_STOPPRESSUREDAMAGE
	cold_protection = HEAD
	species_restricted = list("exclude","Vox",SPECIES_RESOMI)

//armored biosuit hood

/obj/item/clothing/head/bio_hood/asec
	item_icons = URIST_ALL_ONMOBS
	name = "armoured bio hood"
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "Armouredbiohood"
	desc = "An armoured hood that protects the head and face from biological contaminants and minor damage."
	permeability_coefficient = 0.01
	armor = list(melee = 20, bullet = 10, laser = 25, energy = 10, bomb = 25, bio = 100, rad = 20)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')


//naval space suit helmet

/obj/item/clothing/head/helmet/space/naval
	item_icons = URIST_ALL_ONMOBS
	name = "naval space helmet"
	desc = "A high quality space helmet used by the NanoTrasen Navy."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "navyspacehelm"
	armor = list(melee = 55, bullet = 45, laser = 30,energy = 15, bomb = 30, bio = 30, rad = 30)

//naval commando helmet

/obj/item/clothing/head/helmet/space/void/commando
	item_icons = URIST_ALL_ONMOBS
	name = "naval commando helmet"
	desc = "An extremely intimidating helmet worn by the NanoTrasen Naval Commandos"
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "rig0-commando"
	//item_color = "commando"
	armor = list(melee = 65, bullet = 55, laser = 35,energy = 20, bomb = 30, bio = 30, rad = 30)

//TC trader hat

/obj/item/clothing/head/urist/terran
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')

/obj/item/clothing/head/urist/terran/trader
	name = "Terran Confederacy trader's hat"
	desc = "An opulent hat worn by a Terran Confederacy trader"
	icon_state = "TCTHat"
	item_state = "TCTHat"

//alt space wizard outfit

/obj/item/clothing/head/wizard/urist
	item_icons = URIST_ALL_ONMOBS
	icon_override = 'icons/uristmob/head.dmi'

/obj/item/clothing/head/wizard/urist/necro
	name = "necromancer's hood"
	icon = 'icons/urist/items/clothes/head.dmi'
	desc = "A charcoal-black hood worn by the masters of life and death. Simply putting it on sharpens your senses."
	icon_state = "necrohood"
	item_state = "necrohood"

/obj/item/clothing/head/wizard/urist/dresdendora
	name = "urban wizard's hat"
	desc = "A black, wide-brimmed fedora, radiating with an unearthly power of not looking dumb on your ugly mug. Very urban fantasy."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "dresdendora"

//matching NT hats

/obj/item/clothing/head/soft/nanotrasen/blue
	icon_override = 'icons/uristmob/head.dmi'
	name = "blue nanotrasen cap"
	desc = "It's a baseball hat in the glorious colours of Nanotrasen. There is a white N on the front."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "ntbluesoft"
	//item_color = "ntblue"

/obj/item/clothing/head/soft/nanotrasen/white
	icon_override = 'icons/uristmob/head.dmi'
	name = "white nanotrasen cap"
	desc = "It's a baseball hat in the glorious colours of Nanotrasen. There is a blue N on the front."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "ntwhitesoft"
	//item_color = "ntwhite"

//princess bow

/obj/item/clothing/head/princessbow
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/head.dmi'
	name = "princess bow"
	desc = "A cute bow fit for a princess."
	icon_state = "princess_bow"
	//item_color = "princess_bow"
	item_state = "princess_bow"
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')

//fixing hats

/obj/item/clothing/head/urist/beaverhat
	name = "beaver hat"
	icon_state = "beaver_hat"
	item_state = "beaver_hat"
	desc = "Like a top hat, but made of beavers."
	cold_protection = HEAD
	min_cold_protection_temperature = 263.15

/obj/item/clothing/head/urist/boaterhat
	name = "boater hat"
	icon_state = "boater_hat"
	item_state = "boater_hat"
	desc = "Goes well with celery."

/obj/item/clothing/head/urist/fedora
	name = "\improper fedora"
	icon_state = "fedora"
	item_state = "fedora"
	desc = "A great hat ruined by being within fifty yards of you."

//TIPS FEDORA
/obj/item/clothing/head/urist/fedora/verb/tip_fedora()
	set name = "Tip Fedora"
	set category = "Object"
	set desc = "Show those scum who's boss."

	usr << "You tip your fedora."
	usr.visible_message("[usr] tips \his fedora.")

/obj/item/clothing/head/urist/fez
	name = "\improper fez"
	icon_state = "fez"
	item_state = "fez"
	desc = "Put it on your monkey, make lots of cash money."

//Villian and hero stuff

/obj/item/clothing/head/urist/trickster
	name = "Trickster's Hat"
	desc = "The Trickster's hat."
	armor = list(melee = 0, bullet = 15, laser = 0, energy = 0, bomb = 10, bio = 0, rad = 0)
	icon_state = "tricksterhat"
	item_state = "tricksterhat"

/obj/item/clothing/head/urist/penguin
	name = "Penguin's Hat"
	desc = "The Penguin's hat."
	icon_state = "penguinhat"
	item_state = "penguinhat"

//alt CMO hat

/obj/item/clothing/head/urist/altcmo
	name = "CMO's formal cap"
	desc = "A peaked cap worn by the CMO on formal occasions."
	icon_state = "cmo"
	item_state = "cmo"

/obj/item/clothing/head/urist/motorhelm
	name = "Black Motorcycle Helmet"
	desc = "A Black Motorcycle Helmet. Useful to prevent head injuries."
	icon_state = "blackmotor"
	item_state = "blackmotor"
	armor = list(melee = 20, bullet = 5, laser = 0,energy = 0, bomb = 5, bio = 2, rad = 0)

//Paper Crown
/obj/item/clothing/head/urist/papercrown
	name = "Paper Crown"
	desc = "A Paper Crown. Long Live The King!"
	icon_state = "papercrown"
	item_state = "papercrown"

//Paper flower hat thingy stuff
/obj/item/clothing/head/urist/paperflower
	name = "paper flower"
	desc = "A Paper Flower. To put in your hair."
	icon_state = "paperFlower_H"
	item_state = "paperFlower_H"

//alt jani

/obj/item/clothing/head/urist/janihat
	name = "grubby hat"
	desc = "A grubby red hat worn by a janitor."
	icon_state = "janihat"
	item_state = "janihat"

//Barber

/obj/item/clothing/head/urist/barber
	name = "boater"
	desc = "A flat-topped hardened straw hat with a red and blue brim."
	icon_state = "boater"
	item_state = "boater"

//Earplugs. Earmuffs, but more discrete, for the discerning traitor.
/obj/item/clothing/ears/earmuffs/earplugs
	name = "earplugs"
	desc = "Protects your hearing from loud noises, but a little bit more discretely."
	icon = 'icons/urist/items/clothes/ears.dmi'
	icon_state = "earplugs"
	item_state = "earplugs"

//hazardvest bandanda

/obj/item/clothing/head/urist/hazardbandana
	name = "orange bandana"
	desc = "Hey, I think we're missing a hazard vest..."
	icon = 'icons/urist/items/old_bay_custom_items.dmi'
	icon_state = "taryn_kifer_1"

/obj/item/clothing/head/urist/hazardbandana/verb/toggle_bandana()
	set name = "Unfold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0

	var/obj/item/clothing/suit/storage/hazardvest/H = new /obj/item/clothing/suit/storage/hazardvest

	user.remove_from_mob(src)

	user.put_in_hands(H)
	user << "<span class='notice'>You unfold the bandana into a hazardvest.</span>"
	qdel(src)

/obj/item/clothing/suit/storage/hazardvest/verb/toggle_bandana()
	set name = "Fold Bandana"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(user.incapacitated())
		return 0

	for(var/obj/item/O in contents)
		O.loc = (get_turf(src))
	var/obj/item/clothing/head/urist/hazardbandana/H = new /obj/item/clothing/head/urist/hazardbandana

	user.remove_from_mob(src)
	user.put_in_hands(H)
	user << "<span class='notice'>You fold the hazardvest into a bandana.</span>"
	qdel(src)

//Fallout hats

/obj/item/clothing/head/urist/enclave
	icon_override = 'icons/uristmob/head.dmi'
	name = "enclave officer cap"
	desc = "An Enclave Officer cap, has a silver E on the front"
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "enclavesoft"
	//item_color = "enclavesoft"

//blackwarden

/obj/item/clothing/head/helmet/urist
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/head.dmi'

/obj/item/clothing/head/helmet/urist/blackwarden
	item_icons = URIST_ALL_ONMOBS
	name = "warden's black hat"
	desc = "It's a special black helmet issued to the Warden of a security force. Protects the head from impacts."
	icon_state = "policehelm"
	flags_inv = 0
	body_parts_covered = 0
	item_state = "policehelm"
	sprite_sheets = list("Unathi" = 'icons/uristmob/species/unathi/head.dmi')

//First Order

/obj/item/clothing/head/helmet/space/fo
	item_icons = URIST_ALL_ONMOBS
	name = "first order helmet"
	desc = "A very clean white and black helmet."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "fohelm"
	armor = list(melee = 20, laser = 35)

//toque/beanie
/obj/item/clothing/head/urist/toque
	icon_override = 'icons/uristmob/head.dmi'
	name = "toque"
	desc = "A nice warm toque, known by some fucking heathens as a beanie."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "toque"
	cold_protection = HEAD
	min_cold_protection_temperature = 243.15



//Civil War hats
/obj/item/clothing/head/urist/civilwar/usltgenhat
	name = "US Army Lieutenant General Hat"
	desc = "A hat worn by the commander of an army."
	icon_state = "Lieut_General_US_hat"
	item_state = "Lieut_General_US_hat"

/obj/item/clothing/head/urist/civilwar/usbrighat
	name = "US Army Brigadier General Hat"
	desc = "A hat worn by the commander of an army."
	icon_state = "Brig_General_US_hat"
	item_state = "Brig_General_US_hat"

/obj/item/clothing/head/urist/civilwar/uscolhat
	name = "US Army Colonel Hat"
	desc = "A hat worn by an infantry officer."
	icon_state = "Colonel_of_Infantry_US_hat"
	item_state = "Colonel_of_Infantry_US_hat"

/obj/item/clothing/head/urist/civilwar/uspvthat
	name = "US Army Private Hat"
	desc = "A blue hat worn by an infantryman."
	icon_state = "Private_Infantry_US_hat"
	item_state = "Private_Infantry_US_hat"

/obj/item/clothing/head/urist/civilwar/csapvthat
	name = "CS Army Private Hat"
	desc = "A grey hat worn by an infantryman."
	icon_state = "Private_Infantry_CS_hat"
	item_state = "Private_Infantry_CS_hat"

/obj/item/clothing/head/urist/civilwar/csaartycpthat
	name = "Artillery Captain Hat"
	desc = "A hat worn by an artillery officer."
	icon_state = "Captain_Artillery_CS_hat"
	item_state = "Captain_Artillery_CS_hat"

/obj/item/clothing/head/urist/civilwar/csagenhat
	name = "CS Army General Hat"
	desc = "A hat worn by an army commander."
	icon_state = "General_CS_hat"
	item_state = "General_CS_hat"

/obj/item/clothing/head/urist/civilwar/fancyheaddress
	name = "Fancy Headdress"
	desc = "Geronimo!"
	icon_state = "headpiece"
	item_state = "headpiece"

/obj/item/clothing/head/urist/civilwar/featherband
	name = "Feather Headband"
	desc = "A headband with a single feather on it."
	icon_state = "single_fether"
	item_state = "single_fether"

/obj/item/clothing/head/urist/civilwar/tricorn
	name = "Tricorn"
	desc = "A plain tricorn hat."
	icon_state = "tricorn_hat"
	item_state = "tricorn_hat"

/obj/item/clothing/head/urist/civilwar/csalthat
	name = "CS Army Lieutenant Hat"
	desc = "A hat worn by an infantry officer."
	icon_state = "Lieutenant_CS_hat"
	item_state = "Lieutenant_CS_hat"


// RS Helms

/obj/item/clothing/head/urist/armor/bronzehelm
	name = "Bronze Full Helm"
	desc = "A full face helm."
	icon_state = "helmet_bronze"
	item_state = "helmet_bronze"
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 15, bullet = 6.6, laser = 10, energy = 2, bomb = 5, bio = 0, rad = 0)
	flags_inv = HIDEEARS|BLOCKHEADHAIR

/obj/item/clothing/head/urist/armor/addyhelm
	name = "Adamantite Full Helm"
	desc = "Provides modest protection."
	icon_state = "helmet_green"
	item_state = "helmet_green"
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 25, bullet = 16, laser = 20, energy = 12, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|BLOCKHEADHAIR


/obj/item/clothing/head/urist/armor/runehelm
	name = "Runeite Full Helm"
	desc = "Provides excelent protection."
	icon_state = "helmet_blue"
	item_state = "helmet_blue"
	item_flags = ITEM_FLAG_THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 75, bullet = 40, laser = 50, energy = 25, bomb = 40, bio = 0, rad = 0)
	flags_inv = HIDEEARS|BLOCKHEADHAIR

//cowboy hat
/obj/item/clothing/head/urist/cowboy
	name = "cowboy hat"
	desc = "Giddy up pardner, yee haw cowpoke. Et cetera."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "cowboyhat"

/obj/item/clothing/head/urist/cowboy2
	name = "brown cowboy hat"
	desc = "It's a brown cowboy hat with a flat top. Perfect for rounding out the gunslinger aesthetic."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "cowboyhat2"

//hood

/obj/item/clothing/head/winterhood/sandsuit
	item_icons = URIST_ALL_ONMOBS
	icon = 'icons/urist/items/clothes/head.dmi'
	name = "leather hood"
	desc = "A hood attached to a heavy leather protective suit."
	icon_state = "sandsuit"
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR
	min_cold_protection_temperature = 243.15
	armor = list(melee = 15, bullet = 5, laser = 10, energy = 5, bomb = 0, bio = 0, rad = 0)
	sprite_sheets = list(SPECIES_RESOMI = 'icons/mob/species/resomi/uristHead.dmi')

//terran stuff

/obj/item/clothing/head/urist/terran/officercap
	name = "Terran Confederacy Marine officer cap"
	desc = "A grey cap bearing the crest of the Terran Confederacy Marines."
	icon_state = "greyutility"

/obj/item/clothing/head/helmet/space/void/terran_marine
	item_icons = URIST_ALL_ONMOBS
	name = "Terran Confederacy Marine voidsuit"
	desc = "A reinforced helmet worn by Terran Confederacy Marines."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_state = "terran_void_helm"
	armor = list(melee = 65, bullet = 60, laser = 35,energy = 20, bomb = 35, bio = 100, rad = 30)

/obj/item/clothing/head/helmet/urist/terran_marine
	name = "Terram Confederacy Marine helmet"
	desc = "A grey protective helmet, standard issue for all Terran Confederacy Marines."
	icon_state = "terran_helm"
	armor = list(melee = 50, bullet = 55, laser = 30, energy = 25, bomb = 30, bio = 0, rad = 0)
	var/obj/item/weapon/storage/fancy/cigarettes/cigs

// Headbands

/obj/item/clothing/head/urist/headbanddragon
	name = "ancient headband"
	desc = "An ancient cloth headband, with a red circle in the middle."
	icon = 'icons/urist/items/clothes/head.dmi'
	icon_override = 'icons/uristmob/head.dmi'
	icon_state = "risingsun"
	item_state = "risingsun"
	armor = list (melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
