/*										*****New space to put all UristMcStation Pills and Reagents*****
													(This is mainly for the psychologist)
Please keep it tidy, by which I mean put comments describing the item before the entry. Just use regular /tg/ icons -Glloyd */

//Space drugs pill. LET'S PARTY!

/obj/item/weapon/reagent_containers/pill/spacedrugs
	name = "happy pill"
	desc = "Ready to party?"
	icon_state = "pill20"
	New()
		..()
		reagents.add_reagent("space_drugs", 50)

//A whole fuckton of fluffy psychologist shit, this is the reagents and reactions here

#define ANTIDEPRESSANT_MESSAGE_DELAY 5*60*10

/datum/reagent/antidepressant/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Improves the ability to concentrate."
	reagent_state = LIQUID
	color = "#C8A5DC"
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red You lose focus.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "\blue Your mind feels focused and undivided."
		..()
		return

/datum/chemical_reaction/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	result = "methylphenidate"
	required_reagents = list("mindbreaker" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/reagent/antidepressant/citalopram
	name = "Citalopram"
	id = "citalopram"
	description = "Stabilizes the mind a little."
	reagent_state = LIQUID
	color = "#C8A5DC"
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red Your mind feels a little less stable.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "\blue Your mind feels stable.. a little stable."
		..()
		return

/datum/chemical_reaction/citalopram
	name = "Citalopram"
	id = "citalopram"
	result = "citalopram"
	required_reagents = list("mindbreaker" = 1, "carbon" = 1)
	result_amount = 3


/datum/reagent/antidepressant/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Stabilizes the mind greatly, but has a chance of adverse effects."
	reagent_state = LIQUID
	color = "#C8A5DC"
	data = 0

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		if(src.volume <= 0.1) if(data != -1)
			data = -1
			M << "\red Your mind feels much less stable.."
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				if(prob(90))
					M << "\blue Your mind feels much more stable."
				else
					M << "\red Your mind breaks apart.."
					M.hallucination += 200
		..()
		return

/datum/chemical_reaction/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	result = "paroxetine"
	required_reagents = list("mindbreaker" = 1, "oxygen" = 1, "inaprovaline" = 1)
	result_amount = 3

//now time to define the actual pills

/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("methylphenidate", 15)

/obj/item/weapon/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("citalopram", 15)

/obj/item/weapon/reagent_containers/pill/paroxetine
	name = "Paroxetine pill (DANGER)"
	desc = "Strong but unstable anti-depressant."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("paroxetine", 15)

//Now pill bottle time

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of citalopram pills"
	desc = "Contains pills used to stabilize a patient's mind."

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )
		new /obj/item/weapon/reagent_containers/pill/citalopram( src )

/obj/item/weapon/storage/pill_bottle/methylphenidate
	name = "bottle of methylphenidate pills"
	desc = "Contains pills used to enhance a patient's concentration"

	New()
		..()
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )
		new /obj/item/weapon/reagent_containers/pill/methylphenidate( src )

