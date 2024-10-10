/obj/item/device/uplink_service/declumsifier
	service_label = "Declumsifier"

/obj/item/device/uplink_service/declumsifier/enable(mob/user = usr)
	usr.mutations.Remove(MUTATION_CLUMSY)
	. = ..()

/obj/item/device/uplink_service/declumsifier/attack_self(mob/user)
	if(state != AWAITING_ACTIVATION)
		to_chat(user, SPAN_WARNING("\The [src] won't activate again."))
		return
	if(!enable())
		return
	state = CURRENTLY_ACTIVE
	update_icon()
	user.visible_message(SPAN_NOTICE("\The [user] activates \the [src]."), SPAN_NOTICE("You activate \the [src]."))
	log_and_message_admins("has activated the service '[service_label]'", user)

	deactivate()
