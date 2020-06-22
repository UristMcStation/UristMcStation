/mob/living/simple_animal/hostile/npc/adjustBruteLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/hostile/npc/adjustFireLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/hostile/npc/adjustToxLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/hostile/npc/adjustOxyLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/hostile/npc/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()

	for(var/mob/living/simple_animal/hostile/H in viewers (src, null)) //any allied mobs nearby will attack you. //come back to this
		if(istype(H, /mob/living/simple_animal/hostile/npc))
			var/mob/living/simple_animal/hostile/npc/N = H
			N.last_afraid = world.time
			for(var/i=0,i<5,i++)
			dir = get_dir(user,N)
			Move(get_step_away(N,user))
			sleep(1)

		else
			if(H.hiddenfaction == src.hiddenfaction)
				H.faction = H.hiddenfaction.factionid
		return

	for(var/i=0,i<5,i++)
		dir = get_dir(user,src)
		Move(get_step_away(src,user))
		sleep(1)