
//Bartender
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"

//Captain
/obj/item/clothing/head/caphat
	name = "captain's hat"
	icon_state = "captain"
	desc = "It's good being the king."
	item_state_slots = list(
		slot_l_hand_str = "caphat",
		slot_r_hand_str = "caphat",
		)
	body_parts_covered = 0

/obj/item/clothing/head/caphat/cap
	name = "captain's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon_state = "capcap"

/obj/item/clothing/head/caphat/formal
	name = "parade hat"
	desc = "No one in a commanding position should be without a perfect, white hat of ultimate authority."
	icon_state = "officercap"

//HOP
/obj/item/clothing/head/caphat/hop
	name = "crew resource's hat"
	desc = "A stylish hat that both protects you from enraged former-crewmembers and gives you a false sense of authority."
	icon_state = "hopcap"

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

//Chaplain
/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "Maximum piety in this star system."
	icon_state = "nun_hood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD

//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap"
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/surgery/purple
	name = "purple surgical cap"
	color = "#7a1b3f"

/obj/item/clothing/head/surgery/blue
	name = "blue surgical cap"
	color = "#4891e1"

/obj/item/clothing/head/surgery/green
	name = "green surgical cap"
	color = "#255a3e"

/obj/item/clothing/head/surgery/black
	name = "black surgical cap"
	color = "#242424"

/obj/item/clothing/head/surgery/navyblue
	name = "navy blue surgical cap"
	color = "#1f3a69"

/obj/item/clothing/head/surgery/lilac
	name = "lilac surgical cap"
	color = "#c8a2c8"

/obj/item/clothing/head/surgery/teal
	name = "teal surgical cap"
	color = "#008080"

/obj/item/clothing/head/surgery/heliodor
	name = "heliodor surgical cap"
	color = "#aad539"

/obj/item/clothing/head/surgery/lavender
	name = "lavender surgical cap"
	color = "#bebbee"

//Berets
/obj/item/clothing/head/beret
	name = "beret"
	desc = "A beret, an artists favorite headwear."
	icon_state = "beret"
	slot_flags = SLOT_HEAD | SLOT_BELT
	body_parts_covered = 0

/obj/item/clothing/head/beret/equipped(mob/user, slot)
	switch(slot)
		if(slot_belt)
			sprite_sheets = list()
		if(slot_head)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi',
				SPECIES_NABBER = 'icons/mob/species/nabber/onmob_head_gas.dmi',
				SPECIES_RESOMI = 'icons/mob/species/resomi/head.dmi'
				)
	return ..()

/obj/item/clothing/head/beret/sec
	name = "corporate security beret"
	desc = "A beret with the security insignia emblazoned on it. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_red"

/obj/item/clothing/head/beret/sec/navy/officer
	name = "corporate security officer beret"
	desc = "A navy blue beret with an officer's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_navy_officer"

/obj/item/clothing/head/beret/sec/navy/hos
	name = "corporate security commander beret"
	desc = "A navy blue beret with a commander's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_navy_hos"

/obj/item/clothing/head/beret/sec/navy/warden
	name = "corporate security warden beret"
	desc = "A navy blue beret with a warden's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_navy_warden"

/obj/item/clothing/head/beret/sec/corporate/officer
	name = "corporate security officer beret"
	desc = "A corporate black beret with an officer's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_officer"

/obj/item/clothing/head/beret/sec/corporate/hos
	name = "corporate security commander beret"
	desc = "A corporate black beret with a commander's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_hos"

/obj/item/clothing/head/beret/sec/corporate/warden
	name = "corporate security warden beret"
	desc = "A corporate black beret with a warden's rank emblem. For officers that are more inclined towards style than safety."
	icon_state = "beret_corporate_warden"

/obj/item/clothing/head/beret/engineering
	name = "corporate engineering beret"
	desc = "A beret with the engineering insignia emblazoned on it. For engineers that are more inclined towards style than safety."
	icon = 'icons/urist/restored/hats.dmi'
	icon_state = "beret_orange"
	item_icons = URIST_ALL_ONMOBS

/obj/item/clothing/head/beret/purple
	name = "purple beret"
	desc = "A stylish, if purple, beret. For personnel that are more inclined towards style than safety."
	icon_state = "beret_purple"

/obj/item/clothing/head/beret/centcom/officer
	name = "asset protection beret"
	desc = "A navy blue beret adorned with the crest of corporate asset protection. For asset protection agents that are more inclined towards style than safety."
	icon_state = "beret_corporate_navy"
	armor = list(melee = 20, bullet = 20, laser = 20,energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/beret/centcom/captain
	name = "asset protection command beret"
	desc = "A white beret adorned with the crest of corporate asset protection. For asset protection leaders that are more inclined towards style than safety."
	icon_state = "beret_corporate_white"

/obj/item/clothing/head/beret/deathsquad
	name = "heavy asset protection beret"
	desc = "An armored red beret adorned with the crest of corporate asset protection. Doesn't sacrifice style or safety."
	icon_state = "beret_corporate_red"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_RESISTANT,
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.9

/obj/item/clothing/head/beret/guard
	name = "corporate security beret"
	desc = "A white beret adorned with a corporate logo. For security guards that are more inclined towards style than safety."
	icon_state = "corpsec_beret"

/obj/item/clothing/head/beret/plaincolor
	name = "beret"
	desc = "A simple, solid color beret. This one has no emblems or insignia on it."
	icon_state = "beret_white"
