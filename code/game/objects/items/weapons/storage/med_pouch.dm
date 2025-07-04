/*
Single Use Emergency Pouches
 */

/obj/item/storage/med_pouch
	name = "emergency medical pouch"
	desc = "For use in emergency situations only."
	icon = 'icons/obj/medical.dmi'
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	icon_state = "pack0"
	opened = FALSE
	open_sound = 'sound/effects/rip1.ogg'
	var/injury_type = "generic"
	var/static/image/cross_overlay

	var/instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/Initialize()
	. = ..()
	name = "emergency [injury_type] pouch"
	make_exact_fit()
	for(var/obj/item/reagent_containers/pill/P in contents)
		P.color = color
	for(var/obj/item/reagent_containers/hypospray/autoinjector/A in contents)
		A.band_color = color
		A.update_icon()

/obj/item/storage/med_pouch/on_update_icon()
	ClearOverlays()
	if(!cross_overlay)
		cross_overlay = image(icon, "cross")
		cross_overlay.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	AddOverlays(cross_overlay)
	icon_state = "pack[opened]"

/obj/item/storage/med_pouch/examine(mob/user)
	. = ..()
	to_chat(user, "<A href='byond://?src=\ref[src];show_info=1'>Please read instructions before use.</A>")

/obj/item/storage/med_pouch/CanUseTopic()
	return STATUS_INTERACTIVE

/obj/item/storage/med_pouch/OnTopic(user, list/href_list)
	if(href_list["show_info"])
		to_chat(user, instructions)
		return TOPIC_HANDLED

/obj/item/storage/med_pouch/attack_self(mob/user)
	open(user)

/obj/item/storage/med_pouch/open(mob/user)
	if(!opened)
		user.visible_message(SPAN_NOTICE("\The [user] tears open [src], breaking the vacuum seal!"), SPAN_NOTICE("You tear open [src], breaking the vacuum seal!"))
	. = ..()

/obj/item/storage/med_pouch/trauma
	name = "trauma pouch"
	injury_type = "trauma"
	color = COLOR_RED

	startswith = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/reagent_containers/pill/pouch_pill/paracetamol,
	/obj/item/stack/medical/bruise_pack = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Use bandages to stop bleeding if required.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Contact the medical team with your location.
	7) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/burn
	name = "burn pouch"
	injury_type = "burn"
	color = COLOR_SEDONA

	startswith = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/reagent_containers/pill/pouch_pill/paracetamol,
	/obj/item/stack/medical/ointment = 2,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply the emergency deletrathol autoinjector to the injured party.\n\
	\t4) Apply all remaining autoinjectors to the injured party.\n\
	\t5) Force the injured party to swallow all pills.\n\
	\t6) Use ointment on any burns if required\n\
	\t7) Contact the medical team with your location.
	8) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/oxyloss
	name = "low oxygen pouch"
	injury_type = "low oxygen"
	color = COLOR_BLUE

	startswith = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline,
	/obj/item/reagent_containers/pill/pouch_pill/inaprovaline,
	/obj/item/reagent_containers/pill/pouch_pill/dexalin,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.\n\
	\t6) Find a source of oxygen if possible.\n\
	\t7) Update the medical team with your new location.\n\
	8) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/toxin
	name = "toxin pouch"
	injury_type = "toxin"
	color = COLOR_GREEN

	startswith = list(
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/storage/med_pouch/radiation
	name = "radiation pouch"
	injury_type = "radiation"
	color = COLOR_AMBER

	startswith = list(
	/obj/item/reagent_containers/hypospray/autoinjector/antirad,
	/obj/item/reagent_containers/pill/pouch_pill/dylovene,
		)
	instructions = {"
	1) Tear open the emergency medical pack using the easy open tab at the top.\n\
	\t2) Carefully remove all items from the pouch and discard the pouch.\n\
	\t3) Apply all autoinjectors to the injured party.\n\
	\t4) Force the injured party to swallow all pills.\n\
	\t5) Contact the medical team with your location.
	6) Stay in place once they respond.\
		"}

/obj/item/reagent_containers/pill/pouch_pill
	name = "emergency pill"
	desc = "An emergency pill from an emergency medical pouch."
	icon_state = "pill2"
	var/datum/reagent/chem_type
	var/chem_amount = 15

/obj/item/reagent_containers/pill/pouch_pill/inaprovaline
	chem_type = /datum/reagent/inaprovaline

/obj/item/reagent_containers/pill/pouch_pill/dylovene
	chem_type = /datum/reagent/dylovene

/obj/item/reagent_containers/pill/pouch_pill/dexalin
	chem_type = /datum/reagent/dexalin

/obj/item/reagent_containers/pill/pouch_pill/paracetamol
	chem_type = /datum/reagent/paracetamol

/obj/item/reagent_containers/pill/pouch_pill/New()
	..()
	reagents.add_reagent(chem_type, chem_amount)
	name = "emergency [reagents.get_master_reagent_name()] pill ([reagents.total_volume]u)"
	color = reagents.get_color()

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto
	name = "emergency autoinjector"
	desc = "An emergency autoinjector from an emergency medical pouch."

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/inaprovaline
	name = "emergency inaprovaline autoinjector"
	starts_with = list(/datum/reagent/inaprovaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol
	name = "emergency deletrathol autoinjector"
	starts_with = list(/datum/reagent/deletrathol = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dylovene
	name = "emergency dylovene autoinjector"
	starts_with = list(/datum/reagent/dylovene = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin
	name = "emergency dexalin autoinjector"
	starts_with = list(/datum/reagent/dexalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/adrenaline
	name = "emergency adrenaline autoinjector"
	starts_with = list(/datum/reagent/adrenaline = 5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/allergy
	name = "emergency allergy autoinjector"
	desc = "The ingredient label reads 1.5 units of adrenaline and 3.5 units of inaprovaline."
	starts_with = list(/datum/reagent/adrenaline = 1.5, /datum/reagent/inaprovaline = 3.5)

/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/nanoblood
	name = "emergency nanoblood autoinjector"
	amount_per_transfer_from_this = 5
	starts_with = list(/datum/reagent/nanoblood = 5)

//TODO: Just bring back real medkits, these things are worthless.
/obj/item/stack/medical/bruise_pack/med_pouch
	w_class = ITEM_SIZE_TINY

/obj/item/stack/medical/ointment/med_pouch
	w_class = ITEM_SIZE_TINY
