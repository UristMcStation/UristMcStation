//quality code theft
#include "blueriver_areas.dm"
/obj/overmap/visitable/sector/planetoid/arcticplanet
	name = "arctic planetoid"
	desc = "Sensor array detects an arctic planet with a small vessel on the planet's surface. Scans further indicate strange energy emissions from below the planet's surface."
	sector_flags = EMPTY_BITFIELD
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_blueriv_1",
		"nav_blueriv_2",
		"nav_blueriv_3",
		"nav_blueriv_antag"
	)

///obj/overmap/visitable/sector/arcticplanet/New(nloc, max_x, max_y)
//	name = "[generate_planet_name()], \a [name]"
//	..()

/datum/map_template/ruin/away_site/blueriver
	name = "Bluespace River"
	id = "awaysite_blue"
	spawn_cost = 2
	description = "An arctic planet and an alien underground surface"
	suffixes = list("blueriver/blueriver-1.dmm", "blueriver/blueriver-2.dmm")
	generate_mining_by_z = 2
	area_usage_test_exempted_root_areas = list(/area/bluespaceriver)
	apc_test_exempt_areas = list(
		/area/bluespaceriver/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/bluespaceriver/ground = NO_SCRUBBER|NO_VENT|NO_APC
	)

//This is ported from /vg/ and isn't entirely functional. If it sees a threat, it moves towards it, and then activates it's animation.
//At that point while it sees threats, it will remain in it's attack stage. It's a bug, but I figured it nerfs it enough to not be impossible to deal with
/mob/living/simple_animal/hostile/hive_alien/defender
	name = "hive defender"
	desc = "A terrifying monster resembling a massive, bloated tick in shape. Hundreds of blades are hidden underneath its rough shell."
	icon = 'maps/away/blueriver/blueriver.dmi'
	icon_state = "hive_executioner_move"
	icon_living = "hive_executioner_move"
	icon_dead = "hive_executioner_dead"
	move_to_delay = 5
	speed = -1
	health = 280
	maxHealth = 280
	can_escape = TRUE

	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/defender_blades
	ai_holder = /datum/ai_holder/simple_animal/melee/defender
	var/attack_mode = FALSE

	var/transformation_delay_min = 4
	var/transformation_delay_max = 8

/datum/ai_holder/simple_animal/melee/defender/lose_target()
	. = ..()
	var/mob/living/simple_animal/hostile/hive_alien/defender/D = holder
	if(D.attack_mode && !find_target()) //If we don't immediately find another target, switch to movement mode
		D.mode_movement()

	return ..()

/datum/ai_holder/simple_animal/melee/defender/lose_target()
	. = ..()
	var/mob/living/simple_animal/hostile/hive_alien/defender/D = holder
	if(D.attack_mode && !find_target()) //If we don't immediately find another target, switch to movement mode
		D.mode_movement()

	return ..()

/datum/ai_holder/simple_animal/melee/defender/engage_target()
	. = ..()
	var/mob/living/simple_animal/hostile/hive_alien/defender/D = holder
	if(!D.attack_mode)
		return D.mode_attack()

	flick("hive_executioner_attacking", src)

	return ..()
/obj/item/natural_weapon/defender_blades
	name = "blades"
	attack_verb = list("eviscerated")
	force = 30
	edge = TRUE
	hitsound = 'sound/weapons/slash.ogg'

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_movement() //Slightly broken, but it's alien and unpredictable so w/e
	set waitfor = 0
	icon_state = "hive_executioner_move"
	flick("hive_executioner_movemode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = FALSE
	speed = -1
	move_to_delay = 8
	. = FALSE

	//Immediately find a target so that we're not useless for 1 Life() tick!
	ai_holder.find_target()

/mob/living/simple_animal/hostile/hive_alien/defender/proc/mode_attack()
	set waitfor = 0
	icon_state = "hive_executioner_attack"
	flick("hive_executioner_attackmode", src)
	sleep(rand(transformation_delay_min, transformation_delay_max))
	anchored = TRUE
	speed = 0
	attack_mode = TRUE
	walk(src, 0)

/mob/living/simple_animal/hostile/hive_alien/defender/wounded
	name = "wounded hive defender"
	health = 80
	can_escape = FALSE

/obj/shuttle_landmark/nav_blueriv/nav1
	name = "Arctic Planet Landing Point #1"
	landmark_tag = "nav_blueriv_1"
	base_area = /area/bluespaceriver/ground

/obj/shuttle_landmark/nav_blueriv/nav2
	name = "Arctic Planet Landing Point #2"
	landmark_tag = "nav_blueriv_2"
	base_area = /area/bluespaceriver/ground

/obj/shuttle_landmark/nav_blueriv/nav3
	name = "Arctic Planet Landing Point #3"
	landmark_tag = "nav_blueriv_3"
	base_area = /area/bluespaceriver/ground

/obj/shuttle_landmark/nav_blueriv/nav4
	name = "Arctic Planet Navpoint #4"
	landmark_tag = "nav_blueriv_antag"
	base_area = /area/bluespaceriver/ground

/turf/simulated/floor/away/blueriver/alienfloor
	name = "glowing floor"
	desc = "The floor glows without any apparent reason."
	icon = 'riverturfs.dmi'
	icon_state = "floor"
	temperature = 233

/turf/simulated/floor/away/blueriver/alienfloor/Initialize()
	.=..()

	set_light(5, 0.7, l_color = "#0066ff")

/turf/unsimulated/wall/away/blueriver/livingwall
	name = "alien wall"
	desc = "You feel a sense of dread from just looking at this wall. Its surface seems to be constantly moving, as if it were breathing."
	icon = 'riverturfs.dmi'
	icon_state = "evilwall_1"
	opacity = 1
	density = TRUE
	temperature = 233

/turf/unsimulated/wall/away/blueriver/livingwall/Initialize()
	.=..()

	if(prob(80))
		icon_state = "evilwall_[rand(1,8)]"

/turf/unsimulated/wall/supermatter/no_spread
	name = "weird liquid"
	desc = "The viscous liquid glows and moves as if it were alive."
	icon='blueriver.dmi'
	icon_state = "bluespacecrystal1"
	layer = SUPERMATTER_WALL_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	opacity = 0
	dynamic_lighting = 0

/turf/unsimulated/wall/supermatter/no_spread/Initialize()
	.=..()

	icon_state = "bluespacecrystal[rand(1,3)]"
	set_light(5, 1, l_color = "#0066ff")

/turf/unsimulated/wall/supermatter/no_spread/Process()
	return PROCESS_KILL

/turf/unsimulated/wall/supermatter/no_spread/attack_ghost(mob/user as mob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/no_spread/attack_ai(mob/user as mob)
	return user.examinate(src)

/turf/unsimulated/wall/supermatter/no_spread/attack_hand(mob/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src]... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything immediately goes quiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/unsimulated/wall/supermatter/no_spread/use_tool(obj/item/W, mob/living/user, list/click_params)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W)
	Consume(W)

/turf/unsimulated/wall/supermatter/no_spread/Bumped(atom/AM as mob|obj)
	if(istype(AM, /mob/living))
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
	else
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)

/turf/unsimulated/wall/supermatter/no_spread/proc/Consume(var/atom/A)
	if(isobserver(A))
		return
	if(!A.simulated)
		return
	qdel(A)


/obj/structure/deity
	icon = 'icons/obj/cult.dmi'
	icon_state = "tomealtar"
	health_max = 10
	density = TRUE
	anchored = TRUE


/obj/structure/deity/on_death()
	visible_message(SPAN_DANGER("\The [src] crumbles!"))
	qdel(src)

/obj/structure/deity/bullet_act(obj/item/projectile/P)
	damage_health(P.get_structure_damage(), P.damage_type)
