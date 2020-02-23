// Urist Station Viruses, I'm sure we'll have some more down the line, that is if virology is ever decent. - Shippy
// Make sure you comment and keep it clean and all that jazz.

// E. Coli, commonly caused by eating raw food, causes upset stomach, vomiting, etc. Will eventually go away itself.

/datum/disease2/disease/ecoli
	infectionchance = 0
	speed = 1
	spreadtype = "Contact"
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_SKRELL) //Unathi eat raw meat, so this probably wouldn't affect them?

/datum/disease2/disease/ecoli/New()
	..()
	var/datum/disease/effect/stomachbad/E1 = new()	// Minor Upset Stomach, Stage 1.
	E1.stage = 1
	effects += E1
	var/datum/disease2/effect/stomach/E2 = new()	// Upset Stomach, Stage 2.
	E2.stage = 2
	effects += E2
	var/datum/disease2/effect/nausea/E3 = new()	// Nausea, Stage 3.
	E3.stage = 3
	effects += E3
	var/datum/disease2/effect/vomiting/E4 = new()	// Vomiting Stage 4.
	E4.stage = 4
	effects += E4

// Parasitic Infection caused by eating raw food. Needs anti-parasitics to cure, and causes hunger/nutrition loss.
/datum/disease2/disease/tapeworm
	infectionchance = 0 // Would be annoying if constantly contagious.
	speed = 1
	spreadtype = "Contact"
	var/max_stage = 3
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_TESHARI,SPECIES_SKRELL,SPECIES_VOX) //Unsure if Unathi should get this.

/datum/disease2/disease/tapeworm/New()
	..()
	var/datum/disease2/effect/parasitesgrowth/E1 = new()	// Parasite growth, Stage 1.
	E1.stage = 1
	effects += E1
	var/datum/disease2/effect/parasitepang/E2 = new()	// Parasite hunger pangs, Stage 2.
	E2.stage = 2
	effects += E2
	var/datum/disease/effect/parasiteharvest/E3 = new()	// Parasite eating your food, Stage 3.
	E3.stage = 3
	effects += E3

// Listeria: Caused by eating raw meat, will eventually go away itself. Causes upset stomach, vomitting and fever, random paralysis.
/datum/disease2/disease/listeria
	infectionchance = 0
	speed = 3
	spreadtype = "Contact"
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_TESHARI,SPECIES_SKRELL)

/datum/disease2/disease/listeria/New()
	..()
	var/datum/disease2/effect/stomach/E1 = new()	// Upset Stomach, Stage 1.
	E1.stage = 1
	effects += E1
	var/datum/disease2/effect/nausea/E2 = new()	// Nausea Stomach, Stage 2.
	E2.stage = 2
	effects += E2
	var/datum/disease2/effect/vomiting/E3 = new()	// Vomiting, Stage 3.
	E3.stage = 3
	effects += E3
	var//datum/disease/effect/stomachparalysis/E4 = new()	// Stomach Big Pain Stage 4.
	E4.stage = 4
	effects += E4

// Salmonella: Caused by eating raw meat, certain rotten food, etc. Causes upset stomach, vomitting, annoying messages.
/datum/disease2/disease/salmonella
	infectionchance = 0
	speed = 3
	spreadtype = "Contact"
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_TESHARI,SPECIES_SKRELL) // It'd be funny if Vox got Salmonella.

/datum/disease2/disease/salmonella/New()
	..()
	var/datum/disease2/effect/stomach/E1 = new()	// Minor Upset Stomach, Stage 1.
	E1.stage = 1
	effects += E1
	var/datum/disease/effect/dehydration/E2 = new()	// Dehydration, Stage 2.
	E2.stage = 2
	effects += E2
	var/datum/disease/effect/nausea/E3 = new()	// Nausea, Stage 3.
	E3.stage = 3
	effects += E3
	var/datum/disease2/effect/vomiting/E4 = new()	// Vomiting Stage 4.
	E4.stage = 4
	effects += E4

// Mycrosohyosi: (I made this up) Rarely caused by eating rotten food, Causes the person to cough rapidly, shortness of breath and oxygen deprivation.
/datum/disease2/disease/sporehurl
	infectionchance = 10 // Spores get coughed out in proximity.
	speed = 2
	spreadtype = "Proximity"
	var/max_stage = 3
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_DIONA) // Dionae are plant guys.

/datum/disease2/disease/sporehurl/New()
	..()
	var/datum/disease/effect/shortbreath/E1 = new()	// Shortness of Breath - Stage 1.
	E1.stage = 1
	effects += E1
	var/datum/disease/effect/moldtaste/E2 = new()	// Tasting Mushrooms Stage 2.
	E2.stage = 2
	effects += E2
	var/datum/disease/effect/choking/E3 = new()	// Choking Stage 3.
	E3.stage = 3
	effects += E3
	var/datum/disease/effect/sporehurl/E4 = new()	// Infectious Spores Stage 4.
	E4.stage = 4
	effects += E4

// Gut Burrowers: Rarely caused by eating rotten food, will slowly cause damage to your stomach, and inflict constant pain messages until cured.
/datum/disease2/disease/gutworm
	infectionchance = 0 // To avoid half the station smashing into Surgery
	speed = 3
	spreadtype = "Proximity"
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES_TESHARI,SPECIES_SKRELL,SPECIES_UNATHI)

/datum/disease2/disease/gutworm/New()
	..()
	var/datum/disease2/effect/parasitesgrowth/E1 = new()	// Parasite Growing.
	E1.stage = 1
	effects += E1
	var/datum/disease/effect/parasiteorgan/E2 = new()	// Parasite Small Pain
	E2.stage = 2
	effects += E2
	var/datum/disease/effect/parasitesevere/E3 = new()	// Parasite Severe Pain
	E3.stage = 3
	effects += E3
	var/datum/disease2/effect/organs/E4 = new()	// Infectious Spores Stage 4.	TODO Decide if I should keep organ loss from bad parasites, potentional for griffing.
	E4.stage = 4
	effects += E4

// Rotsprawl: Caused only by eating rotten food, this will slowly accumulate toxin damage in your body. Don't eat rotten food.
/datum/disease2/disease/rotsprawl
	infectionchance = 0
	speed = 5
	spreadtype = "Proximity"
	var/max_stage = 4
	var/list/affected_species = list(SPECIES_HUMAN,SPECIES,TESHARI,SPECIES_SKRELL,SPECIES_UNATHI) //Vox are scavengers, so they'd be fine, probably.

/datum/disease2/disease/rotsprawl/New()
	..()
	var/datum/disease2/effect/nausea/E1 = new()	// Nausea
	E1.stage = 1
	effects += E1
	var/datum/disease2/effect/vomiting/E2 = new()	// Vomiting
	E2.stage = 2
	effects += E2
	var/datum/disease/effect/stomachparalysis/E3 = new()	// Stomach Paralysis
	E3.stage = 3
	effects += E3
	var/datum/disease2/effect/toxins/E4 = new()	// Toxins...	// Bay handles toxins realisticly, so we have to be careful with this.
	E4.stage = 4
	effects += E4



// Virus Effects defined below.
// Make sure that they are neatly organized, I've seperated them into seperate commented areas, for my own sanity - Shippy
// TODO See about adding some of these effects into normal virus generation, if they aren't already...

													// Stomach Related Food Poisoning \\

// Stomach Gurgling
/datum/disease/effect/stomachbad	// Stomach unsettled.
	name = "Gastritis Syndrome"
	stage = 1
	badness = VIRUS_COMMON
	delay = 60
	chance_max = 25
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		mob.custom_pain("Your stomach hurts a little.", 5)

// Fluid Loss
/datum/disease/effect/dehydration
	name = "Fluid Loss Syndrome"
	stage = 1
	badness = VIRUS_MILD
	delay = 30
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You feel very thirsty.</span>")

// Nausea
/datum/disease2/effect/nausea	// Harmless.
	name = "Nauseous Syndrome"
	stage = 2
	badness = VIRUS_COMMON
	delay = 30
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>Your head is spinning and you feel nauseous.</span>")

// Vomiting
/datum/disease2/effect/vomiting	// Causes the person to vomit, gross.
	name = "Emesis Syndrome"
	stage = 3
	badness = VIRUS_MILD
	delay = 90
	chance_max = 25 // Or you'll be hungry forever.
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>You feel like you are going to puke...</span>")
		mob.emote("vomit")

// Stomach paralysis
/datum/disease/effect/stomachparalysis		// Causes person to fall to floor in pain.
	name = "Gastroparaesis Syndrome"
	stage = 4
	badness = VIRUS_ENGINEERED
	delay = 150 SECONDS
	chance_max = 40
	activate(var/mob/living/carbon/human/mob,var/multipler)
		mob.custom_pain("Your stomach locks up in intense pain!", 25)
		mob.emote("collapse")


											// Parasites/Parasitics & Food Poisoning: A match made in heaven.




// Parasite Growing.
/datum/disease2/effect/parasitesgrowth // You can feel something squirming in you, also gross.
	name = "Taeniasis Growth Syndrome"
	stage = 1
	badness = VIRUS_COMMON
	delay = 30
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>You feel a little off.</span>")

// Parasite Hunger Pangs.
/datum/disease2/effect/parasitepang
	name = "Taeniasis Polyphagia Syndrome"
	stage = 2
	badness = VIRUS_COMMON
	delay = 45
	chance_max = 50
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You feel a bit more hungrier than usual.</span>")

// Parasite Hurting Organs.
/datum/disease/effect/parasiteorgan   // Parasite starting to hurt you.
	name = "Ostertagia Dysfunction Syndrome"
	stage = 2
	badness = VIRUS_ENGINEERED
	delay = 60
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You really don't feel good.</span>")
		mob.custom_pain("Something deep inside of you starts to sting badly.", 10)


// Parasite Leeching Nutrition.
/datum/disease/effect/parasiteharvest // Parasite leaching your nutrition away.
	name = "Taeniasis Polyphagia Nutritional Syndrome"
	stage = 3
	badness = VIRUS_MILD
	delay = 90
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You feel very hungry.</span>")
		mob.nutrition = max(0, mob.nutrition - 200)
		mob.custom_pain("Your stomach sends out painful hunger pangs", 10)

// Parasite Organ Severe
/datum/disease/effect/parasitesevere
	name = "Severe Ostertagia Organ Dysfunction Syndrome"	// Parasites really start to hurt you.
	stage = 3
	badness = VIRUS_ENGINEERED
	delay = 60
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		to_chat(mob, "<span class='warning'You feel really awful.")
		mob.custom_pain("You feel a horrible burning sensation inside of you!", 20)


													// Spore/Fungi Related Food Poisoning \\

//Shortness of Breath
/datum/disease/effect/shortbreath			// Shortness of Breath
	name = "Dyspnea Syndrome"
	stage = 1
	badness = VIRUS_COMMON
	delay = 30
	chance_max = 25
	activate(var/mob/living/carbon/human/mob,var/multiplier)
		to_chat(mob, "<span class='warning'>Your struggle to breath.</span>")

// Mushroom Taste
/datum/disease/effect/moldtaste // An inflammatory response to fungal infection, causes you to taste fungi, not metal like usual.
	name = "Fungal Inflammatory Response Syndrome"
	stage = 2
	badness = VIRUS_MILD
	delay = 60
	chance_max = 25
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You can taste mold on your tongue.</span>")  // Cataclysm DDA Players be like

// Choking
/datum/disease/effect/choking
	name = "Asphyxiation Syndrome"
	stage = 2
	badness = VIRUS_ENGINEERED
	delay = 60
	chance = 20
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You really struggle to catch your breath!</span>")
		mob.custom_pain("Your lungs sting!", 10)
		mob.apply_damage(5, OXY)

// Spore Hurling
/datum/disease/effect/sporehurl //Coughing/Hurling up contagious spores.
	name = "Spore Tussis Syndrome"
	stage = 4
	badness = VIRUS_ENGINEERED
	delay = 60
	activate(var/mob/living/carbon/human/mob,var/multipler)
		to_chat(mob, "<span class='warning'>You cough up some sort of dust.</span>")
		mob.emote("cough")
		if (mob.wear_mask)
			return
		for(var/mob/living/carbon/human/M in oview(2,mob))
			mob.spread_disease_to(M)  // Can now infect other people with it.
