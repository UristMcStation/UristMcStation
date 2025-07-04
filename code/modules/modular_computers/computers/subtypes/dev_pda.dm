/obj/item/modular_computer/pda
	name = "\improper PDA"
	desc = "A very compact computer, designed to keep its user always connected."
	icon = 'icons/obj/modular_pda.dmi'
	icon_state = "pda"
	icon_state_unpowered = "pda"
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	light_strength = 2
	slot_flags = SLOT_ID | SLOT_BELT
	stores_pen = TRUE
	stored_pen = /obj/item/pen/retractable
	interact_sounds = list('sound/machines/pda_click.ogg')
	interact_sound_volume = 20

/obj/item/modular_computer/pda/Initialize()
	. = ..()
	enable_computer()

/obj/item/modular_computer/pda/CtrlClick(mob/user)
	if(!isturf(loc)) ///If we are dragging the PDA across the ground we don't want to remove the pen
		remove_pen(user)
		return TRUE
	return ..()

/obj/item/modular_computer/pda/AltClick(mob/user)
	if (CanPhysicallyInteract(user) && card_slot && istype(card_slot.stored_card))
		card_slot.eject_id(user)
		return TRUE
	return ..()

/obj/item/modular_computer/pda/proc/receive_notification(message = null)
	if (!enabled || bsod)
		return
	var/display = "pings softly[message ? " and displays a message: '[message]'" : null]"
	var/mob/found_mob = get_container(/mob)
	if (found_mob)
		found_mob.visible_message(
			SPAN_NOTICE("\The [found_mob]'s [name] [display]."),
			SPAN_NOTICE("Your [name] [display]."),
			SPAN_NOTICE("You hear a soft ping."),
			1
		)
		return
	visible_message(
		SPAN_NOTICE("\The [src] [display]."),
		SPAN_NOTICE("You hear a soft ping."),
		1
	)

// PDA box
/obj/item/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/boxes.dmi'
	icon_state = "pda"
	startswith = list(/obj/item/modular_computer/pda = 5)

/obj/item/storage/box/PDAs/Initialize()
	. = ..()
	for(var/obj/item/modular_computer/pda/pda in contents)
		pda.shutdown_computer(0) //Because 5 PDAs all on in a box use SO much power

// PDA types
/obj/item/modular_computer/pda/medical
	icon_state = "pda-m"
	icon_state_unpowered = "pda-m"

/obj/item/modular_computer/pda/chemistry
	icon_state = "pda-m"
	icon_state_unpowered = "pda-m"

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"
	icon_state_unpowered = "pda-e"

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/forensics
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/science
	icon_state = "pda-nt"
	icon_state_unpowered = "pda-nt"

/obj/item/modular_computer/pda/heads
	name = "command PDA"
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/heads/paperpusher
	stored_pen = /obj/item/pen/fancy

/obj/item/modular_computer/pda/heads/hop
	icon_state = "pda-hop"
	icon_state_unpowered = "pda-hop"

/obj/item/modular_computer/pda/heads/hos
	icon_state = "pda-hos"
	icon_state_unpowered = "pda-hos"

/obj/item/modular_computer/pda/heads/ce
	icon_state = "pda-ce"
	icon_state_unpowered = "pda-ce"

/obj/item/modular_computer/pda/heads/cmo
	icon_state = "pda-cmo"
	icon_state_unpowered = "pda-cmo"

/obj/item/modular_computer/pda/heads/rd
	icon_state = "pda-rd"
	icon_state_unpowered = "pda-rd"

/obj/item/modular_computer/pda/captain
	icon_state = "pda-c"
	icon_state_unpowered = "pda-c"

/obj/item/modular_computer/pda/ert
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/cargo
	icon_state = "pda-sup"
	icon_state_unpowered = "pda-sup"

/obj/item/modular_computer/pda/mining
	icon_state = "pda-nt"
	icon_state_unpowered = "pda-nt"

/obj/item/modular_computer/pda/syndicate
	icon_state = "pda-syn"
	icon_state_unpowered = "pda-syn"

/obj/item/modular_computer/pda/roboticist
	icon_state = "pda-robot"
	icon_state_unpowered = "pda-robot"

/obj/item/modular_computer/pda/mime

/obj/item/modular_computer/pda/clown
