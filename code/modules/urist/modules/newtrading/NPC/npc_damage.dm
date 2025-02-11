/mob/living/simple_animal/passive/npc/adjustBruteLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/passive/npc/adjustFireLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/passive/npc/adjustToxLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/passive/npc/adjustOxyLoss(damage)
	..()
	if(damage)
		last_afraid = world.time

/mob/living/simple_animal/passive/npc/hit_with_weapon(obj/item/O, mob/living/user, effective_force, var/hit_zone)
	. = ..()

	for(var/mob/living/simple_animal/hostile/H in viewers (src, null)) //any allied mobs nearby will attack you. //come back to this
		if(istype(H, /mob/living/simple_animal/passive/npc))
			var/mob/living/simple_animal/passive/npc/N = H
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
