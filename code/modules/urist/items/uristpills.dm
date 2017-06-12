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
			M << "<span class='warning'> You lose focus..</span>"
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "<span class='notice'> Your mind feels focused and undivided.</span>"
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
			M << "<span class='warning'> Your mind feels a little less stable..</span>"
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				M << "<span class='notice'> Your mind feels stable.. a little stable.</span>"
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
			M << "<span class='warning'> Your mind feels much less stable..</span>"
		else
			if(world.time > data + ANTIDEPRESSANT_MESSAGE_DELAY)
				data = world.time
				if(prob(90))
					M << "<span class='notice'> Your mind feels much more stable.</span>"
				else
					M << "<span class='warning'> Your mind breaks apart..</span>"
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

//Tactical medicine from some skrellian pharmaceutical company

/obj/item/weapon/reagent_containers/pill/bloodloss
	name = "Blood recovery pill"
	desc = "Extremely strong blood restoration."
	icon_state = "pill12"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("iron", 15)
		reagents.add_reagent("sugar", 15)

/obj/item/weapon/reagent_containers/pill/peridaxon
	name = "Peridaxon pill"
	desc = "Rapidly regenerates internal organs."
	icon_state = "pill8"
	New()
		..()
		reagents.add_reagent("peridaxon", 10)

/obj/item/weapon/reagent_containers/pill/rezadone
	name = "Emergency recovery pill"
	desc = "Only to be used in absolute emergencies."
	icon_state = "pill18"
	New()
		..()
		reagents.add_reagent("rezadone", 15)

/obj/item/weapon/reagent_containers/pill/exspaceacillin
	name = "Extreme spaceacillin pill"
	desc = "WARNING: Overdose level of spaceacillin for extreme cases of infections."
	icon_state = "pill9"
	New()
		..()
		reagents.add_reagent("spaceacillin", 45)

/obj/item/weapon/reagent_containers/pill/exbicaridine
	name = "Extreme bicaridine pill"
	desc = "For arterial bleeding cases only."
	icon_state = "pill10"
	New()
		..()
		reagents.add_reagent("bicaridine", 45)

/obj/item/weapon/reagent_containers/pill/clonefix
	name = "Clone fix pill"
	desc = "Repairs possible cloning faults."
	icon_state = "pill7"
	New()
		..()
		reagents.add_reagent("alkysine", 10)
		reagents.add_reagent("ryetalyn", 1)

//Now pill bottle time

/obj/item/weapon/storage/pill_bottle/citalopram
	name = "bottle of citalopram pills"
	desc = "Contains pills used to stabilize a patient's mind."
	startswith = list(/obj/item/weapon/reagent_containers/pill/citalopram = 7)

/obj/item/weapon/storage/pill_bottle/methylphenidate
	name = "bottle of methylphenidate pills"
	desc = "Contains pills used to enhance a patient's concentration."
	startswith = list(/obj/item/weapon/reagent_containers/pill/methylphenidate = 7)

/obj/item/weapon/storage/pill_bottle/bloodloss
	name = "bottle of blood restoration pills"
	desc = "Contains pills to rapidly restore blood."
	startswith = list(/obj/item/weapon/reagent_containers/pill/bloodloss = 7)

/obj/item/weapon/storage/pill_bottle/peridaxon
	name = "bottle of peridaxon pills"
	desc = "Contains pills to regenerate organs."
	startswith = list(/obj/item/weapon/reagent_containers/pill/peridaxon = 7)

/obj/item/weapon/storage/pill_bottle/emergency
	name = "bottle of emergency medication"
	desc = "<span class='notice'>Not to be used by unqualified personnel!</span>"
	startswith = list(
		/obj/item/weapon/reagent_containers/pill/rezadone = 1,
		/obj/item/weapon/reagent_containers/pill/exspaceacillin = 3,
		/obj/item/weapon/reagent_containers/pill/exbicaridine = 3
		)

/obj/item/weapon/storage/pill_bottle/clonefix
	name = "bottle of clonefix pills"
	desc = "Contains pills to repair cloning defaults."
	startswith = list(/obj/item/weapon/reagent_containers/pill/clonefix = 7)