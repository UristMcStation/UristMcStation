/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */

/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/structures/drawers.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/list/can_hold = list(
		/obj/item/paper,
		/obj/item/material/folder,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/sample)

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"

/obj/structure/filingcabinet/wallcabinet
	name = "wall-mounted filing cabinet"
	desc = "A filing cabinet installed into a cavity in the wall to save space. Wow!"
	icon_state = "wallcabinet"
	density = FALSE
	obj_flags = OBJ_FLAG_WALL_MOUNTED


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	for(var/obj/item/I in loc)
		if(is_type_in_list(I, can_hold))
			I.forceMove(src)
	. = ..()


/obj/structure/filingcabinet/use_tool(obj/item/tool, mob/user, list/click_params)
	// Any item - Attempt to put in cabinet
	if (is_type_in_list(tool, can_hold))
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(tool, user)
			return
		flick("[initial(icon_state)]-open", src)
		user.visible_message(
			SPAN_NOTICE("\The [user] puts \a [tool] in \the [src]."),
			SPAN_NOTICE("You put \the [tool] in \the [src].")
		)
		updateUsrDialog()
	else if(isScrewdriver(tool))
		if (anchored)
			to_chat(user, "<span class='warning'>You can't see anywhere to unscrew that!</span>")
			return
		else
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "<span class='notice'>You disassemble \the [src], and its contents spill out.</span>")
			var/obj/item/stack/material/steel/S =  new /obj/item/stack/material/steel(src.loc)
			S.amount = 2
			transfer_fingerprints_to(S)
			for(var/obj/item/b in contents)
				b.loc = (get_turf(src))
			qdel(src)
	else
		..()

	return ..()


/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(length(contents) <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return

	user.set_machine(src)
	var/dat = list("<center><table>")
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	show_browser(user, "<html><head><title>[name]</title></head><body>[jointext(dat,null)]</body></html>", "window=filingcabinet;size=350x300")

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		show_browser(usr, "", "window=filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			flick("[initial(icon_state)]-open",src)
