
//spawns one of the specified animal type
/obj/effect/landmark/animal_spawner
	icon_state = "x3"
	var/spawn_type
	var/mob/living/spawned_animal
	invisibility = 101
	var/spawn_time_high = 2400
	var/spawn_time_low = 1200
	var/crosstrigger = FALSE

/obj/effect/landmark/animal_spawner/New()
	if(!crosstrigger)
		if(!spawn_type)
			var/new_type = pick(typesof(/obj/effect/landmark/animal_spawner) - /obj/effect/landmark/animal_spawner)
			new new_type(get_turf(src))
			qdel(src)

		START_PROCESSING(SSobj, src)
		spawned_animal = new spawn_type(get_turf(src))
	..()

/obj/effect/landmark/animal_spawner/Process()
	//if any of our animals are killed, spawn new ones
	if(!spawned_animal || spawned_animal.stat == DEAD)
		spawned_animal = new spawn_type(src)
		//after a random timeout, and in a random position (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_animal.loc = locate(src.x + rand(-12,12), src.y + rand(-12,12), src.z)

/obj/effect/landmark/animal_spawner/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/landmark/animal_spawner/panther
	name = "panther spawner"
	spawn_type = /mob/living/simple_animal/hostile/huntable/panther

/obj/effect/landmark/animal_spawner/parrot
	name = "parrot spawner"
	spawn_type = /mob/living/simple_animal/hostile/retaliate/parrot/jungle

/obj/effect/landmark/animal_spawner/monkey
	name = "monkey spawner"
	spawn_type = /mob/living/simple_animal/huntable/monkey

/obj/effect/landmark/animal_spawner/snake
	name = "snake spawner"
	spawn_type = /mob/living/simple_animal/hostile/snake

/obj/effect/landmark/animal_spawner/random
	var/spawn_list
	var/x_offset = 0
	var/y_offset = 0

/obj/effect/landmark/animal_spawner/random/New()
	spawn_type = pick(spawn_list)
	..()

/obj/effect/landmark/animal_spawner/random/Process()
	//if any of our animals are killed, spawn new ones
	if(!spawned_animal || spawned_animal.stat == DEAD)
		if(!spawn_type)
			spawn_type = pick(spawn_list)
		spawned_animal = new spawn_type(src)
		//after a random timeout, and in a random position (6-30 seconds)
		spawn(rand(spawn_time_low,spawn_time_high))
			spawned_animal.loc = locate(src.x + x_offset, src.y + x_offset, src.z)

/obj/effect/landmark/animal_spawner/random/Crossed(mob/living/M)
	if(crosstrigger) //if an animal crosses this thing, they "leave" the map, and then this landmark starts spawning animals
		if (istype(M, /mob/living/simple_animal) || istype(M, /mob/living/carbon/human/monkey))
			qdel(M)
			START_PROCESSING(SSobj, src)
			return

	else
		..()

/obj/effect/landmark/animal_spawner/random/jungle
	name = "jungle animal spawner"
	x_offset = -8
	crosstrigger = 1
	spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/panther,
		/mob/living/simple_animal/huntable/monkey,
		/mob/living/simple_animal/hostile/retaliate/parrot/jungle,
		/mob/living/simple_animal/hostile/huntable/deer
		)

/obj/effect/landmark/animal_spawner/random/plains
	name = "plains animal spawner"
	y_offset = -2
	spawn_list = list(
		/mob/living/simple_animal/hostile/huntable/bear,
		/mob/living/simple_animal/hostile/snake/randvenom/green
		)

/obj/effect/landmark/animal_spawner/random/jungle/crosstrigger
	crosstrigger = 1
	icon_state = "x2"

/obj/effect/landmark/animal_spawner/random/plains/crosstrigger
	crosstrigger = 1
	icon_state = "x2"

//huntable animals

//to prevent spam from monkeys being half killed

/mob/living/simple_animal/huntable/monkey/New()
	..()
	faction = "hostile"

//to prevent lag from monkey's life()

/mob/living/simple_animal/huntable/monkey
	name = "monkey"
	desc = "It's a monkey. Seems quite content to lounge around all the time."
	icon = 'icons/uristmob/monkey.dmi'
	icon_state = "preview"
	icon_living = "preview"
	icon_dead = "preview_dead"
	faction = "hostile"
	mob_size = MOB_SMALL
	speak_emote = list("chirps")
	maxHealth = 30
	health = 30
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pokes"
	meat_amount = 2
	bone_amount = 2
	skin_amount = 2
	skin_material = MATERIAL_SKIN_FUR
	ai_holder = /datum/ai_holder/simple_animal/passive
	say_list_type = /datum/say_list/monkey

/datum/say_list/monkey
	emote_hear = list("chirps")

//to prevent spam from parrots, and deer killing parrots

/mob/living/simple_animal/hostile/retaliate/parrot/jungle
	faction = "hostile"

//*********//
// Panther //
//*********//

/mob/living/simple_animal/hostile/huntable/panther
	name = "panther"
	desc = "A long sleek, black cat with sharp teeth and claws."
	icon = 'icons/urist/jungle/mobs.dmi'
	icon_state = "panther"
	icon_living = "panther"
	icon_dead = "panther_dead"
	icon_gib = "panther_dead"
	turns_per_move = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 75
	health = 75
	meat_amount = 4
	bone_amount = 8
	skin_amount = 8
	skin_material = MATERIAL_SKIN_FUR_BLACK

	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/claws
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bite.ogg'

	ai_holder = /datum/ai_holder/simple_animal/melee/hit_and_run/panther //cloaking taken from spider lurkers. should cloak, attack, run, repeat basically
/// Lower = Harder to see.
	var/cloaked_alpha = 45
	/// This is added on top of the normal melee damage.
	var/cloaked_bonus_damage = 30
	/// How long to stun for.
	var/cloaked_weaken_amount = 3
	/// Amount of time needed to re-cloak after losing it.
	var/cloak_cooldown = 10 SECONDS
	/// world.time
	var/last_uncloak = 0
	var/cloaked = FALSE
//	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
/datum/ai_holder/simple_animal/melee/hit_and_run/panther
	var/stalk_tick_delay = 3

/*/datum/ai_holder/simple_animal/melee/hit_and_run/panther/list_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, 10))
		targets += H
	return targets*/

/datum/ai_holder/simple_animal/melee/hit_and_run/panther/find_target(list/possible_targets, has_targets_list)
	. = ..()
	if(.)
		holder.custom_emote(1,"nashes at [.]")

/mob/living/simple_animal/hostile/huntable/panther/proc/cloak()
	if (is_cloaked())
		return
	animate(src, alpha = cloaked_alpha, time = 1 SECOND)
	cloaked = TRUE


/mob/living/simple_animal/hostile/huntable/panther/proc/uncloak()
	last_uncloak = world.time // This is assigned even if it isn't cloaked already, to 'reset' the timer if the panther is continously getting attacked.
	if (!is_cloaked())
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	cloaked = FALSE

/// Check if cloaking is possible.
/mob/living/simple_animal/hostile/huntable/panther/proc/can_cloak()
	if (stat)
		return FALSE
	if (last_uncloak + cloak_cooldown > world.time)
		return FALSE

	return TRUE

/// Called by things that break cloaks.
/mob/living/simple_animal/hostile/huntable/panther/proc/break_cloak()
	uncloak()


/mob/living/simple_animal/hostile/huntable/panther/is_cloaked()
	return cloaked


// Cloaks the panther automatically, if possible.
/mob/living/simple_animal/hostile/huntable/panther/handle_special()
	if (!is_cloaked() && can_cloak())
		cloak()


// Applies bonus base damage if cloaked.
/mob/living/simple_animal/hostile/huntable/panther/apply_bonus_melee_damage(atom/A, damage_amount)
	if (is_cloaked())
		return damage_amount + cloaked_bonus_damage
	return ..()

// Applies stun, then uncloaks.
/mob/living/simple_animal/hostile/huntable/panther/apply_melee_effects(atom/A)
	if (is_cloaked() && isliving(A))
		var/mob/living/L = A
		L.Weaken(cloaked_weaken_amount)
		to_chat(L, SPAN_DANGER("\The [src] ambushes you!"))
		playsound(src, 'sound/weapons/spiderlunge.ogg', 75, 1)
	uncloak()
	..() // For the poison.

// Force uncloaking if attacked.
/mob/living/simple_animal/hostile/huntable/panther/bullet_act(obj/item/projectile/P)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS
	. = ..()
	break_cloak()

/mob/living/simple_animal/hostile/huntable/panther/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()


/datum/ai_holder/simple_animal/melee/hit_and_run/panther/engage_target()
	..()
	if(stance == STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			holder.IMove(get_step_towards(holder, target))
			stalk_tick_delay = 3

//*******//
// Snake //
//*******//

/mob/living/simple_animal/hostile/snake
	name = "snake"
	desc = "A sinuously coiled, venomous looking reptile."
	icon = 'icons/urist/jungle/mobs.dmi'
	icon_state = "snake_green"
	icon_living = "snake_green"
	icon_dead = "snake_green_dead"
	icon_gib = null
	turns_per_move = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 25
	health = 25
	harm_intent_damage = 2
	natural_weapon = /obj/item/natural_weapon/bite/weak
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	ai_holder = /datum/ai_holder/simple_animal/melee/snek
	meat_amount = 2
	bone_amount = 1
	skin_amount = 2
	skin_material =	MATERIAL_SKIN_LIZARD

/datum/ai_holder/simple_animal/melee/snek
	vision_range = 5 //balancing snakes so they don't slither all the way across the plains to kill you.


//	layer = 3.1		//so they can stay hidde under the /obj/structure/bush
	var/stalk_tick_delay = 3

/datum/ai_holder/simple_animal/melee/snek/list_targets()
	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(src, 10))
		targets += H
	return targets

/datum/ai_holder/simple_animal/melee/snek/find_target()
	. = ..()
	if(.)
		holder.custom_emote(1,"hisses wickedly")

/mob/living/simple_animal/hostile/snake/UnarmedAttack(atom/A, var/proximity)
	. =..()
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/L = A
		bite(L)

/mob/living/simple_animal/hostile/snake/proc/bite(mob/living/L)
	L.apply_damage(rand(3,12), DAMAGE_TOXIN)

/datum/ai_holder/simple_animal/melee/snek/engage_target()
	..()
	if(stance == STANCE_ATTACKING && get_dist(src, target))
		stalk_tick_delay -= 1
		if(stalk_tick_delay <= 0)
			holder.IMove(get_step_towards(holder, target))
			stalk_tick_delay = 3

/mob/living/simple_animal/hostile/snake/randvenom
	icon_state = "snake_brown"
	icon_living = "snake_brown"
	icon_dead = "snake_brown_dead"
	desc = "A sinuously coiled, venomous looking reptile. This one looks rather exotic."
	natural_weapon = /obj/item/natural_weapon/bite/weak
	var/bite_vol = 5
	var/obj/item/venom_sac/venomsac

/mob/living/simple_animal/hostile/snake/randvenom/New()
	..()
	if(!venomsac)
		venomsac = new /obj/item/venom_sac(src)

/mob/living/simple_animal/hostile/snake/randvenom/Destroy()
	venomsac = null
	..()

/mob/living/simple_animal/hostile/snake/randvenom/harvest()
	if(venomsac)
		venomsac.forceMove(src.loc)
		venomsac = null
	..()

/mob/living/simple_animal/hostile/snake/randvenom/bite(mob/living/L)
	if((L && venomsac && venomsac) in src.contents)
		venomsac.reagents.trans_to_mob(L, bite_vol, CHEM_BLOOD, copy=1)

/mob/living/simple_animal/hostile/snake/randvenom/green //so they blend into the plain's turf
	icon_state = "snake_green"
	icon_living = "snake_green"
	icon_dead = "snake_green_dead"

//******//
// Deer //
//******//

/mob/living/simple_animal/hostile/huntable/deer
	name = "deer"
	desc = "It's a deer. It has antlers, so it's a buck."
	icon = 'icons/urist/jungle/mobs.dmi'
	icon_state = "deer"
	icon_living = "deer"
	icon_dead = "deer_dead"
	icon_gib = "deer_dead"
	turns_per_move = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 40
	health = 40
	move_to_delay = 3
	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/bite
	attacktext = "gored" //antlers
	attack_sound = 'sound/weapons/bite.ogg'
//	var/chase_time = 100
	meat_amount = 4
	bone_amount = 10
	skin_amount = 8
	skin_material = MATERIAL_SKIN_GENERIC
	ai_holder = /datum/ai_holder/simple_animal/passive/deer

/datum/ai_holder/simple_animal/passive/deer
	speak_chance = 0

/*/mob/living/simple_animal/hostile/huntable/deer/GiveTarget(new_target)
	target = new_target
	if(target != null)
		if(isliving(target))
			Aggro()
			stance = STANCE_ATTACK
			visible_message("<span class='danger'>The [src.name] tries to flee from [target.name]!</span>")
			retreat_distance = 10
			minimum_distance = 10
			spawn(chase_time)
				retreat_distance = 0
				minimum_distance = 0
				stance = STANCE_IDLE
				target = null
			return
	return*/

//******//
// Bear //
//******//

/mob/living/simple_animal/hostile/huntable/bear
	name = "bear"
	desc = "A big scary brown bear, probably best to stay away."
	icon = 'icons/uristmob/64x64_mobs.dmi'
	icon_state = "bigbear"
	icon_living = "bigbear"
	icon_dead = "bigbear_dead"
	icon_gib = "bigbear_dead"
	turns_per_move = 4
	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 150
	health = 150
	bound_width = 64
	ai_holder = /datum/ai_holder/simple_animal/destructive
	harm_intent_damage = 8
	natural_weapon = /obj/item/natural_weapon/giant
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bite.ogg'
	meat_amount = 10
	bone_amount = 10
	skin_amount = 15
	skin_material = MATERIAL_SKIN_FUR
	pixel_x = -32
	default_pixel_x = -32

//from civ13

/mob/living/simple_animal/hostile/huntable/panther/cougar
	name = "cougar"
	desc = "a large brown cat with a white belly and jaw."
	icon_state = "cougar"
	icon_living = "cougar"
	icon_dead = "cougar_dead"
	icon_gib = "cougar_dead"
	skin_material = MATERIAL_SKIN_FUR

/mob/living/simple_animal/hostile/huntable/bear/grey
	desc = "A big scary bear, probably best to stay away"
	icon_state = "greybear"
	icon_living = "greybear"
	icon_dead = "greybear_dead"
	icon_gib = "greybear_dead"
	skin_material = MATERIAL_SKIN_FUR_BLACK

/mob/living/simple_animal/hostile/huntable/bear/black
	desc = "A big scary black bear, probably best to stay away"
	icon_state = "blackbear"
	icon_living = "blackbear"
	icon_dead = "blackbear_dead"
	icon_gib = "blackbear_dead"
	skin_material = MATERIAL_SKIN_FUR_BLACK

/mob/living/simple_animal/hostile/huntable/bear/polar
	desc = "A big scary polar bear, probably best to stay away"
	icon_state = "polarbear"
	icon_living = "polarbear"
	icon_dead = "polarbear_dead"
	icon_gib = "polarbear_dead"
	skin_material = MATERIAL_SKIN_FUR_WHITE

/mob/living/simple_animal/hostile/huntable/bear/light
	desc = "A big scary bear, probably best to stay away"
	icon_state = "blondebear"
	icon_living = "blondebear"
	icon_dead = "blondebear_dead"
	icon_gib = "blondebear_dead"

/mob/living/simple_animal/hostile/huntable/bear/dark
	desc = "A big scary brown bear, probably best to stay away"
	icon_state = "darkbrownbear"
	icon_living = "darkbrownbear"
	icon_dead = "darkbrownbear_dead"
	icon_gib = "darkbrownbear_dead"

//wolf

/mob/living/simple_animal/hostile/huntable/wolf
	name = "wolf"
	desc = "A mean looking wolf"
	icon = 'icons/uristmob/simpleanimals.dmi'
	icon_state = "greywolf"
	icon_living = "greywolf_dead"
	icon_dead = "greywolf_dead"
	icon_gib = "greywolf_dead"
	turns_per_move = 6
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	maxHealth = 70
	health = 70
	natural_weapon = /obj/item/natural_weapon/bite
	meat_amount = 5
	bone_amount = 5
	skin_amount = 8
	skin_material = MATERIAL_SKIN_FUR_GRAY

/mob/living/simple_animal/hostile/huntable/wolf/white
	icon_state = "whitewolf"
	icon_living = "whitewolf_dead"
	icon_dead = "whitewolf_dead"
	icon_gib = "whitewolf_dead"
	skin_material = MATERIAL_SKIN_FUR_WHITE
