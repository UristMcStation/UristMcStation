/datum/seed_pile
	var/name
	var/amount
	var/datum/seed/seed_type // Keeps track of what our seed is
	var/list/obj/item/seeds/seeds = list() // Tracks actual objects contained in the pile
	var/ID

/datum/seed_pile/New(obj/item/seeds/O, ID)
	name = O.name
	amount = 1
	seed_type = O.seed
	seeds += O
	src.ID = ID

/datum/seed_pile/proc/matches(obj/item/seeds/O)
	if (O.seed == seed_type)
		return 1
	return 0

/obj/machinery/seed_storage
	name = "Seed storage"
	desc = "It stores, sorts, and dispenses seeds."
	icon = 'icons/obj/machines/vending.dmi'
	icon_state = "seeds"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 100
	obj_flags = OBJ_FLAG_ANCHORABLE

	var/list/datum/seed_pile/piles = list()
	var/list/starting_seeds = list(
		/obj/item/seeds/affelerin = 15,
		/obj/item/seeds/aghrassh = 15,
		/obj/item/seeds/algaeseed = 15,
		/obj/item/seeds/almondseed = 15,
		/obj/item/seeds/ambrosiavulgarisseed = 15,
		/obj/item/seeds/appleseed = 15,
		/obj/item/seeds/bamboo = 15,
		/obj/item/seeds/bananaseed = 15,
		/obj/item/seeds/berryseed = 15,
		/obj/item/seeds/blueberryseed = 15,
		/obj/item/seeds/cabbageseed = 15,
		/obj/item/seeds/cocoapodseed = 15,
		/obj/item/seeds/carrotseed = 15,
		/obj/item/seeds/chantermycelium = 15,
		/obj/item/seeds/cherryseed = 15,
		/obj/item/seeds/chiliseed = 15,
		/obj/item/seeds/cinnamon = 15,
		/obj/item/seeds/clam = 5,
		/obj/item/seeds/coconutseed = 15,
		/obj/item/seeds/coffeeseed = 15,
		/obj/item/seeds/cornseed = 15,
		/obj/item/seeds/cotton = 15,
		/obj/item/seeds/crab = 5,
		/obj/item/seeds/replicapod = 15,
		/obj/item/seeds/eggplantseed = 15,
		/obj/item/seeds/amanitamycelium = 15,
		/obj/item/seeds/garlicseed = 15,
		/obj/item/seeds/glowshroom = 15,
		/obj/item/seeds/grapeseed = 15,
		/obj/item/seeds/grassseed = 15,
		/obj/item/seeds/greengrapeseed = 15,
		/obj/item/seeds/gukhe = 15,
		/obj/item/seeds/gummen = 15,
		/obj/item/seeds/harebell = 15,
		/obj/item/seeds/hrukhza = 15,
		/obj/item/seeds/iridast = 15,
		/obj/item/seeds/kudzuseed = 15,
		/obj/item/seeds/lavenderseed = 15,
		/obj/item/seeds/lemonseed = 15,
		/obj/item/seeds/lettuceseed = 15,
		/obj/item/seeds/libertymycelium = 15,
		/obj/item/seeds/limeseed = 15,
		/obj/item/seeds/melonseed = 15,
		/obj/item/seeds/mtearseed = 15,
		/obj/item/seeds/mussel = 5,
		/obj/item/seeds/nettleseed = 15,
		/obj/item/seeds/okrri = 15,
		/obj/item/seeds/olives = 15,
		/obj/item/seeds/onionseed = 15,
		/obj/item/seeds/orangeseed = 15,
		/obj/item/seeds/oyster = 5,
		/obj/item/seeds/peanutseed = 15,
		/obj/item/seeds/pearseed = 15,
		/obj/item/seeds/peppercornseed = 15,
		/obj/item/seeds/pineappleseed = 15,
		/obj/item/seeds/plastiseed = 15,
		/obj/item/seeds/plumpmycelium = 15,
		/obj/item/seeds/poppyseed = 15,
		/obj/item/seeds/potatoseed = 15,
		/obj/item/seeds/pumpkinseed = 15,
		/obj/item/seeds/qokkloa = 15,
		/obj/item/seeds/reishimycelium = 15,
		/obj/item/seeds/riceseed = 15,
		/obj/item/seeds/shandseed = 15,
		/obj/item/seeds/shrimp = 5,
		/obj/item/seeds/soyaseed = 15,
		/obj/item/seeds/sugarcaneseed = 15,
		/obj/item/seeds/sunflowerseed = 15,
		/obj/item/seeds/tobaccoseed = 15,
		/obj/item/seeds/tomatoseed = 15,
		/obj/item/seeds/towermycelium = 15,
		/obj/item/seeds/vanillaseed = 15,
		/obj/item/seeds/watermelonseed = 15,
		/obj/item/seeds/wheatseed = 15,
		/obj/item/seeds/whitebeetseed = 15,
		/obj/item/seeds/whitegrapeseed = 15,
		/obj/item/seeds/ximikoa = 15
	)
	var/list/scanner = list() // What properties we can view

/obj/machinery/seed_storage/Initialize(mapload)
	. = ..()
	if (LAZYLEN(starting_seeds))
		for(var/typepath in starting_seeds)
			var/amount = starting_seeds[typepath]
			if(isnull(amount))
				amount = 1
			for (var/i = 1 to amount)
				var/O = new typepath
				add(O)
		sort_piles()

/obj/machinery/seed_storage/random // This is mostly for testing, but I guess admins could spawn it
	name = "Random seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list(/obj/item/seeds/random = 50)

/obj/machinery/seed_storage/garden
	name = "Garden seed storage"
	scanner = list("stats")
	icon_state = "seeds_generic"

/obj/machinery/seed_storage/xenobotany
	name = "Xenobotany seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")

/obj/machinery/seed_storage/xenobotany/Initialize()
	starting_seeds += list(/obj/item/seeds/random = 5)
	. = ..()

/obj/machinery/seed_storage/all
	name = "Debug seed storage"
	scanner = list("stats", "produce", "soil", "temperature", "light")
	starting_seeds = list()

/obj/machinery/seed_storage/all/Initialize(mapload)
	for (var/typepath in subtypesof(/obj/item/seeds))
		if (typepath == /obj/item/seeds/random || typepath == /obj/item/seeds/cutting)
			continue
		starting_seeds[typepath] = 5
	. = ..()

/obj/machinery/seed_storage/interface_interact(mob/user)
	interact(user)
	return TRUE

/obj/machinery/seed_storage/interact(mob/user as mob)
	user.set_machine(src)

	var/dat = ""
	if (length(piles) == 0)
		dat += SPAN_COLOR("red", "No seeds")
	else
		dat += "<table style='text-align:center;border-style:solid;border-width:1px;padding:4px'><tr><td>Name</td>"
		dat += "<td>Variety</td>"
		if ("stats" in scanner)
			dat += "<td>E</td><td>Y</td><td>M</td><td>Pr</td><td>Pt</td><td>Harvest</td>"
		if ("temperature" in scanner)
			dat += "<td>Temp</td>"
		if ("light" in scanner)
			dat += "<td>Light</td>"
		if ("soil" in scanner)
			dat += "<td>Nutri</td><td>Water</td>"
		dat += "<td>Notes</td><td>Amount</td><td></td></tr>"
		for (var/datum/seed_pile/S in piles)
			var/datum/seed/seed = S.seed_type
			if(!seed)
				continue
			dat += "<tr>"
			dat += "<td>[seed.seed_name]</td>"
			dat += "<td>#[seed.uid]</td>"
			if ("stats" in scanner)
				dat += "<td>[seed.get_trait(TRAIT_ENDURANCE)]</td><td>[seed.get_trait(TRAIT_YIELD)]</td><td>[seed.get_trait(TRAIT_MATURATION)]</td><td>[seed.get_trait(TRAIT_PRODUCTION)]</td><td>[seed.get_trait(TRAIT_POTENCY)]</td>"
				if(seed.get_trait(TRAIT_HARVEST_REPEAT))
					dat += "<td>Multiple</td>"
				else
					dat += "<td>Single</td>"
			if ("temperature" in scanner)
				dat += "<td>[seed.get_trait(TRAIT_IDEAL_HEAT)] K</td>"
			if ("light" in scanner)
				dat += "<td>[seed.get_trait(TRAIT_IDEAL_LIGHT)] L</td>"
			if ("soil" in scanner)
				if(seed.get_trait(TRAIT_REQUIRES_NUTRIENTS))
					if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
						dat += "<td>Low</td>"
					else if(seed.get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
						dat += "<td>High</td>"
					else
						dat += "<td>Norm</td>"
				else
					dat += "<td>No</td>"
				if(seed.get_trait(TRAIT_REQUIRES_WATER))
					if(seed.get_trait(TRAIT_WATER_CONSUMPTION) < 1)
						dat += "<td>Low</td>"
					else if(seed.get_trait(TRAIT_WATER_CONSUMPTION) > 5)
						dat += "<td>High</td>"
					else
						dat += "<td>Norm</td>"
				else
					dat += "<td>No</td>"

			dat += "<td>"
			switch(seed.get_trait(TRAIT_CARNIVOROUS))
				if(1)
					dat += "CARN "
				if(2)
					dat	+= SPAN_COLOR("red", "CARN ")
			switch(seed.get_trait(TRAIT_SPREAD))
				if(1)
					dat += "VINE "
				if(2)
					dat	+= SPAN_COLOR("red", "VINE ")
			if ("pressure" in scanner)
				if(seed.get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
					dat += "LP "
				if(seed.get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
					dat += "HP "
			if ("temperature" in scanner)
				if(seed.get_trait(TRAIT_HEAT_TOLERANCE) > 30)
					dat += "TEMRES "
				else if(seed.get_trait(TRAIT_HEAT_TOLERANCE) < 10)
					dat += "TEMSEN "
			if ("light" in scanner)
				if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
					dat += "LIGRES "
				else if(seed.get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
					dat += "LIGSEN "
			if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
				dat += "TOXSEN "
			else if(seed.get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
				dat += "TOXRES "
			if(seed.get_trait(TRAIT_PEST_TOLERANCE) < 3)
				dat += "PESTSEN "
			else if(seed.get_trait(TRAIT_PEST_TOLERANCE) > 6)
				dat += "PESTRES "
			if(seed.get_trait(TRAIT_WEED_TOLERANCE) < 3)
				dat += "WEEDSEN "
			else if(seed.get_trait(TRAIT_WEED_TOLERANCE) > 6)
				dat += "WEEDRES "
			if(seed.get_trait(TRAIT_PARASITE))
				dat += "PAR "
			if ("temperature" in scanner)
				if(seed.get_trait(TRAIT_ALTER_TEMP) > 0)
					dat += "TEMP+ "
				if(seed.get_trait(TRAIT_ALTER_TEMP) < 0)
					dat += "TEMP- "
			if(seed.get_trait(TRAIT_BIOLUM))
				dat += "LUM "
			dat += "</td>"
			dat += "<td>[S.amount]</td>"
			dat += "<td><a href='byond://?src=\ref[src];task=vend;id=[S.ID]'>Vend</a> <a href='byond://?src=\ref[src];task=purge;id=[S.ID]'>Purge</a></td>"
			dat += "</tr>"
		dat += "</table>"

	var/datum/browser/popup = new(user, "seedstorage", "Seed Storage", 500, 800)
	popup.set_content(dat)
	popup.open()

/obj/machinery/seed_storage/Topic(href, list/href_list)
	if (..())
		return
	var/task = href_list["task"]
	var/ID = text2num(href_list["id"])

	for (var/datum/seed_pile/N in piles)
		if (N.ID == ID)
			if (task == "vend")
				var/obj/O = pick(N.seeds)
				if (O)
					--N.amount
					N.seeds -= O
					if (N.amount <= 0 || length(N.seeds) <= 0)
						piles -= N
						qdel(N)
					flick("[initial(icon_state)]-vend", src)
					O.dropInto(loc)
				else
					piles -= N
					qdel(N)
			else if (task == "purge")
				for (var/obj/O in N.seeds)
					qdel(O)
					piles -= N
					qdel(N)
			break
	updateUsrDialog()

/obj/machinery/seed_storage/use_tool(obj/item/O, mob/living/user, list/click_params)
	if (istype(O, /obj/item/seeds))
		add(O)
		sort_piles()
		user.visible_message("[user] puts \the [O.name] into \the [src].", "You put \the [O] into \the [src].")
		return TRUE

	if (istype(O, /obj/item/storage/plants))
		var/obj/item/storage/P = O
		var/loaded = 0
		for(var/obj/item/seeds/G in P.contents)
			++loaded
			P.remove_from_storage(G, src, 1)
			add(G, 1)
		P.finish_bulk_removal()
		if (loaded)
			sort_piles()
			user.visible_message("[user] puts the seeds from \the [O.name] into \the [src].", "You put the seeds from \the [O.name] into \the [src].")
		else
			to_chat(user, SPAN_NOTICE("There are no seeds in \the [O.name]."))
		return TRUE
	return ..()

/obj/machinery/seed_storage/proc/add(obj/item/seeds/O, bypass_removal = 0)
	if(!bypass_removal)
		if (ismob(O.loc))
			var/mob/user = O.loc
			if(!user.unEquip(O, src))
				return
		else if(istype(O.loc,/obj/item/storage))
			var/obj/item/storage/S = O.loc
			S.remove_from_storage(O, src)

	O.forceMove(src)
	var/newID = 0

	for (var/datum/seed_pile/N in piles)
		if (N.matches(O))
			++N.amount
			N.seeds += (O)
			return
		else if(N.ID >= newID)
			newID = N.ID + 1

	piles += new /datum/seed_pile(O, newID)
	flick("[initial(icon_state)]-vend", src)
	return


/// Handles sorting of the `piles` list.
/obj/machinery/seed_storage/proc/sort_piles()
	piles = sortAtom(piles)
