/obj/item/reagent_containers/food/drinks/shaker
	name = "shaker"
	desc = "A three piece Cobbler-style shaker. Used to mix, cool, and strain drinks."
	icon_state = "shaker"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = "5;10;15;25;30;60" //Professional bartender should be able to transfer as much as needed
	volume = 120
	center_of_mass = "x=17;y=10"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_REACT

/obj/item/reagent_containers/food/drinks/shaker/attack_self(mob/user as mob)
	if(user.mind.assigned_role == "Bartender")
		user.visible_message(SPAN_CLASS("rose", "\The [user] shakes \the [src] briskly in one hand, with supreme confidence and competence."), SPAN_CLASS("rose", "You shake \the [src] briskly with one hand."))
		mix()
		return
	else
		user.visible_message(SPAN_NOTICE("\The [user] shakes \the [src] gingerly."), SPAN_NOTICE("You shake \the [src] gingerly."))
		if(prob(1) && (reagents && reagents.total_volume))
			user.visible_message(SPAN_WARNING("\The [user] spills the contents of \the [src] over themselves!"), SPAN_WARNING("You spill the contents of \the [src] over yourself!"))
			reagents.splash(user, reagents.total_volume)
		else
			mix()

/obj/item/reagent_containers/food/drinks/shaker/proc/mix()
	if(reagents && reagents.total_volume)
		atom_flags &= ~ATOM_FLAG_NO_REACT
		HANDLE_REACTIONS(reagents)
		addtimer(new Callback(src, PROC_REF(stop_react)), SSchemistry.wait)

/obj/item/reagent_containers/food/drinks/shaker/proc/stop_react()
	atom_flags |= ATOM_FLAG_NO_REACT
