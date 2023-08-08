/*
** This module represents Urist's atom-based mob spawners for more convenient spawning
** (because trying to go through buildmode is painful).
** Called 'uspawner' - spawner for obvious reasons, u for Urist - name needs to be terse for adminbus purposes.
*/

/atom/movable/uspawner
	// UI - only for the mapper, since they are invisible in-game.
	icon = 'icons/urist/uristicons.dmi'
	icon_state = "scomop" // because 'S' for 'Spawner'

	// Location stuff
	var/turf/center //center turf, used when selecting a turf and radius > 0
	var/area/area //area where mobs will spawn

	// Timing
	var/interval = 5 //interval to spawn mobs on (in seconds)
	var/variation = 25 //random variation added to the interval (in seconds)
	var/paused = TRUE
	var/next_spawn_time = 0 //internal

	var/sleep_time = 3  // ticker clock resolution

	// Spawn params
	var/spawn_count = 0 //how many mobs to spawn (0 is infinite)
	var/radius = 2 //radius from around the selected origin to spawn mobs (0 is no radius, -1 is anywhere in the area)

	// Special effects!
	var/obj/effect/spawn_effect = null

	// Spawn messaging
	var/list/messages = null //messages spawner will pick from to display alongside spawning mobs
	var/message_class = "none" //the span class applied to the chosen message

	// Spawned mob params
	var/list/mob/living/mobs = null // list of mobs to spawn; repeats boost probability of getting picked
	var/atmos_immune = FALSE //if the mobs are immune to all atmospheric conditions
	var/faction = null //faction of the mob, null = default faction

	// Tracking the associated spawner datum
	//var/datum/mob_spawner/associated_spawner = null


/*/atom/movable/uspawner/proc/Sync()
	// Synchronize the spawner variables to the atom's equivalents
	var/spawner_area = get_area(src)
	var/spawner_loc = get_turf(src)

	var/datum/mob_spawner/spawner = GLOB.mob_spawners[spawner_loc]

	if (!spawner)
		spawner = new /datum/mob_spawner
		GLOB.mob_spawners[spawner_loc] = spawner

	src.associated_spawner = spawner

	// Copy over the variables nearly verbatim.
	spawner.center = spawner_loc
	spawner.area = spawner_area
	spawner.interval = src.interval
	spawner.variation = src.variation
	spawner.paused = src.paused
	spawner.interval = src.interval
	spawner.variation = src.variation
	spawner.spawn_count = src.spawn_count
	spawner.radius = src.radius
	spawner.message_class = src.message_class
	spawner.atmos_immune = src.atmos_immune
	spawner.faction = src.faction

	if(!isnull(src.mobs))
		spawner.mobs = src.mobs

	if(!isnull(src.messages))
		spawner.messages = src.messages
	return
*/


/atom/movable/uspawner/proc/PickSpawnLoc()
	var/turf/T

	for (var/i = 1; i <= 10; i++)
		sleep(-1)

		if (radius == -1)
			T = pick_area_turf(area, list(/proc/not_turf_contains_dense_objects))

			if (!T) //no open spaces to spawn on
				T = pick_area_turf(area)
		else
			var/list/turfs = trange(radius, center)
			T = pick(turfs)

		if (!isnull(T) && !T.is_wall() && !T.density)
			break

	return T


/atom/movable/uspawner/proc/SpawnMob(turf/T)
	if(isnull(T) || T.is_wall() || T.density)
		return

	var/mob/living/simple_animal/M = pick(mobs)
	M = new M(T)
	return M


/atom/movable/uspawner/proc/FinalizeMob(mob/living/simple_animal/target)
	var/mob/living/simple_animal/M = target

	if(isnull(M))
		return

	if (faction)
		M.faction = faction

	if(atmos_immune)
		M.min_gas = null
		M.max_gas = null
		M.minbodytemp = 0
		M.maxbodytemp = 5000

	if (length(messages) > 0)
		if (message_class != "none")
			M.visible_message(SPAN_CLASS("[message_class]", "[pick(messages)]"))
		else
			M.visible_message(pick(messages))

	return M


/atom/movable/uspawner/proc/ApplySpawnEffects(turf/T)
	if(isnull(T))
		return

	var/obj/effect/fx = src.spawn_effect
	if(isnull(fx))
		return

	fx = new(T)
	return fx


/atom/movable/uspawner/proc/SpawnerLoop()
	set waitfor = FALSE

	if (interval == 0 && spawn_count >= 0)
		interval = 10

	var/initial_spawn_count = src.spawn_count

	var/sleep_time = min((src.sleep_time || 1), 1)

	while(TRUE)
		sleep(sleep_time)

		if ((mobs?.len || 0) > 0 && next_spawn_time < world.time)
			var/turf/T = src.PickSpawnLoc()

			if(isnull(T) || T.is_wall() || T.density)
				continue

			var/mob/living/simple_animal/spawned_mob = SpawnMob(T)
			var/mob/living/simple_animal/finalized_mob = FinalizeMob(spawned_mob)
			ApplySpawnEffects(T)

			if(finalized_mob)
				if(initial_spawn_count > 0 && --spawn_count <= 0)
					log_debug(append_admin_tools("Mob spawner at ([center.x], [center.y], [center.z]) finished spawning.", null, center))
					qdel(src) //delete spawner once we're done spawning mobs
					break

			next_spawn_time = world.time + interval + rand(0, variation)

	return

/atom/movable/uspawner/Initialize(mapload)
	// Hide this from most users; has  to be done at runtime or the mappers won't see it
	src.alpha = 150
	src.invisibility = INVISIBILITY_EYE

	src.center = get_turf(src)
	src.area = get_area(src)

	//src.Sync() // busted Bayspawners
	src.SpawnerLoop() // handrolled ticker

	. = ..()
	return .


/atom/movable/uspawner/squad
	// Basically a semi-randomized bundle of mobs; a convenience for mappers/adminbus.
	paused = FALSE
	spawn_count = 4  // fireteam
	interval = 2
	variation = 4
	spawn_effect = /obj/effect/effect/smoke // fake-smokenade; also covers up the occasional dodgy spawn locations


/atom/movable/uspawner/endless
	// What you might expect a spawner to be - endless stream of spawned mobs.
	// It can emulate squad if you put down a couple together with radius > 0.
	paused = FALSE
	spawn_count = 0  // endless
	radius = -1 // area-based by default, less predictable
	spawn_effect = /obj/effect/sparks

	// bigger delay to avoid mobspam
	interval = 30
	variation = 60


/* Prefab variants
** As a convention, set a faction.
** This way we can add mobs not designed for this faction for variety
*/

// NT deathsquads sent to clean up embarrassing messes
/atom/movable/uspawner/squad/ntis_hit
	faction = "NTIS"
	spawn_effect = /obj/effect/sparks

	mobs = list(
		/mob/living/simple_animal/hostile/urist/commando,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/recon/ntagent,
		/mob/living/simple_animal/hostile/urist/recon/ntagent
	)

/atom/movable/uspawner/endless/ntis_interdiction
	faction = "NTIS"
	spawn_effect = /obj/effect/sparks

	mobs = list(
		/mob/living/simple_animal/hostile/urist/commando,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/ntis_merc,
		/mob/living/simple_animal/hostile/urist/recon/ntagent,
		/mob/living/simple_animal/hostile/urist/recon/ntagent
	)


// NT spess cops pacifying the crew; mostly riot response, some gunmen for variety (detective-type guys)
/atom/movable/uspawner/squad/riot_response
	faction = "NTIS"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/ntis_merc
	)

/atom/movable/uspawner/endless/riot_cops
	faction = "NTIS"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/riotcop,
		/mob/living/simple_animal/hostile/urist/ntis_merc
	)


// ANTAG strike team
/atom/movable/uspawner/squad/antag_crew
	faction = "alien"
	spawn_effect = /obj/effect/effect/smoke

	mobs = list(
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/recon/quisling,
		/mob/living/simple_animal/hostile/urist/recon/quisling,
		/mob/living/simple_animal/hostile/urist/recon/merc
	)


/atom/movable/uspawner/endless/antag_operation
	faction = "alien"
	spawn_effect = /obj/effect/effect/smoke

	mobs = list(
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/ANTAG,
		/mob/living/simple_animal/hostile/urist/recon/quisling,
		/mob/living/simple_animal/hostile/urist/recon/quisling,
		/mob/living/simple_animal/hostile/urist/recon/merc
	)


// mostly cultists, small chance of monsters mixed in
/atom/movable/uspawner/squad/cult_coven
	faction = "cult"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/faithless/cult/strong,
		/mob/living/simple_animal/hostile/creature/cult
	)


/atom/movable/uspawner/endless/cult_portal
	faction = "cult"
	spawn_effect = /obj/effect/gibspawner/human

	mobs = list(
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/faithless/cult/strong,
		/mob/living/simple_animal/hostile/creature/cult
	)


// similar to cult_coven, except it's vamp + thralls
/atom/movable/uspawner/squad/vamp_cult
	faction = "undead"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/cultist,
		/mob/living/simple_animal/hostile/urist/vampire
	)


// Skrellorist terror cell, mostly grunts with a rare recon specialist
/atom/movable/uspawner/squad/skrell_cell
	faction = "skrellt"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/recon/skrell
	)


/atom/movable/uspawner/endless/skrell_insurgency
	faction = "skrellt"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/skrellterrorist,
		/mob/living/simple_animal/hostile/urist/recon/skrell
	)


// Generic baddies - mercs, raiders, gangsters, misc terrorists, etc.
/atom/movable/uspawner/squad/spacegang
	faction = "gunman"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/recon/merc,
		/mob/living/simple_animal/hostile/urist/recon/merc,
		/mob/living/simple_animal/hostile/urist/recon/unathi
	)

/atom/movable/uspawner/endless/spacemob
	faction = "gunman"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/gunman,
		/mob/living/simple_animal/hostile/urist/recon/merc,
		/mob/living/simple_animal/hostile/urist/recon/merc,
		/mob/living/simple_animal/hostile/urist/recon/unathi
	)


// SOYUUUUUUZ NYEEEERUSHIIIIMYYY
/atom/movable/uspawner/squad/soviet
	faction = "russian"

	mobs = list(
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/urist/recon/merc
	)

/atom/movable/uspawner/endless/soviet_meatwave
	faction = "russian"

	mobs = list(
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/urist/recon/merc
	)


// RIP AND TEAR
/atom/movable/uspawner/squad/doom
	faction = "cult"
	spawn_effect = /obj/effect/gibspawner/human

	mobs = list(
		/mob/living/simple_animal/hostile/urist/mutant/ranged,
		/mob/living/simple_animal/hostile/urist/mutant/melee,
		/mob/living/simple_animal/hostile/urist/mutant/melee,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/urist/imp,
		/mob/living/simple_animal/hostile/urist/imp
	)

/atom/movable/uspawner/endless/doom_eternal
	faction = "cult"
	spawn_effect = /obj/effect/gibspawner/human

	mobs = list(
		/mob/living/simple_animal/hostile/urist/mutant/ranged,
		/mob/living/simple_animal/hostile/urist/mutant/melee,
		/mob/living/simple_animal/hostile/urist/mutant/melee,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/urist/imp,
		/mob/living/simple_animal/hostile/urist/imp
	)


// 2spoopy4me
/atom/movable/uspawner/squad/spoopy
	faction = "cult"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/imp,
		/mob/living/simple_animal/hostile/urist/zombie,
		/mob/living/simple_animal/hostile/urist/vampire,
		/mob/living/simple_animal/hostile/urist/skeleton,
		/mob/living/simple_animal/hostile/skeleton,
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/meat/strippedhuman,
		/mob/living/simple_animal/hostile/meat/horrorminer
	)

/atom/movable/uspawner/endless/toospoopy
	faction = "cult"
	spawn_effect = /obj/effect/effect/smoke

	mobs = list(
		/mob/living/simple_animal/hostile/urist/imp,
		/mob/living/simple_animal/hostile/urist/zombie,
		/mob/living/simple_animal/hostile/urist/vampire,
		/mob/living/simple_animal/hostile/urist/skeleton,
		/mob/living/simple_animal/hostile/skeleton,
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/faithless/cult,
		/mob/living/simple_animal/hostile/meat/strippedhuman,
		/mob/living/simple_animal/hostile/meat/horrorminer
	)


// YARRRRRRR
/atom/movable/uspawner/squad/pirate_crew
	faction = "pirate"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/newpirate/laser,
		/mob/living/simple_animal/hostile/urist/newpirate/laser,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate,
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/urist/recon/unathi
	)


/atom/movable/uspawner/endless/pirate_raid
	faction = "pirate"

	mobs = list(
		/mob/living/simple_animal/hostile/urist/newpirate/laser,
		/mob/living/simple_animal/hostile/urist/newpirate/laser,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate/ballistic,
		/mob/living/simple_animal/hostile/urist/newpirate,
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/urist/recon/unathi
	)


// Weird-spooky, not Halloween-spooky
/atom/movable/uspawner/squad/surreal
	faction = "undead"
	spawn_effect = /obj/effect/gibspawner/human

	mobs = list(
		/mob/living/simple_animal/hostile/urist/hololab/holonautgrunt,
		/mob/living/simple_animal/hostile/urist/hololab/holonautsuit,
		/mob/living/simple_animal/hostile/urist/devourer,
		/mob/living/simple_animal/hostile/urist/mutant/hybrid,
		/mob/living/simple_animal/hostile/bluespace,
		/mob/living/simple_animal/hostile/meat/abomination,
		/mob/living/simple_animal/hostile/meat/strippedhuman
	)

/atom/movable/uspawner/endless/reality_rift
	faction = "undead"
	spawn_effect = /obj/effect/gibspawner/human

	mobs = list(
		/mob/living/simple_animal/hostile/urist/hololab/holonautgrunt,
		/mob/living/simple_animal/hostile/urist/hololab/holonautsuit,
		/mob/living/simple_animal/hostile/urist/devourer,
		/mob/living/simple_animal/hostile/urist/mutant/hybrid,
		/mob/living/simple_animal/hostile/bluespace,
		/mob/living/simple_animal/hostile/meat/abomination,
		/mob/living/simple_animal/hostile/meat/strippedhuman
	)
