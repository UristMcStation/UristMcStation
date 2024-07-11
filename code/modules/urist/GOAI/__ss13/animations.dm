
# ifdef GOAI_LIBRARY_FEATURES

#define ABOVE_PROJECTILE_LAYER 4.18

/*
stolen from ss13 code to make melee visualization easier
*/

/proc/get_all_clients()
	// dirty dev replacement for GLOB.clients
	var/objcount = 0
	var/batchsize = 20
	var/list/allclients = list()

	for(var/worldobj in world.contents)
		if(!(++objcount % batchsize))
			sleep(-1)

		var/mob/M = worldobj
		if(!istype(M))
			continue

		if(M.client)
			allclients.Add(M.client)

	return allclients

/proc/flick_overlay(image/I, list/show_to, duration)
	for(var/client/C in show_to)
		C.images += I
	spawn(duration)
		for(var/client/C in show_to)
			C.images -= I

/mob
	var/default_pixel_x = 0
	var/default_pixel_y = 0
	var/default_pixel_z = 0

	var/dizziness = 0
	var/is_dizzy = 0

/mob/proc/make_dizzy(amount)
	if(!istype(src, /mob/living/carbon/human)) // for the moment, only humans get dizzy
		return

	dizziness = min(1000, dizziness + amount)	// store what will be new value
													// clamped to max 1000
	if(dizziness > 100 && !is_dizzy)
		spawn(0)
			dizzy_process()


/*
dizzy process - wiggles the client's pixel offset over time
spawned from make_dizzy(), will terminate automatically when dizziness gets <100
note dizziness decrements automatically in the mob's Life() proc.
*/
/mob/proc/dizzy_process()
	is_dizzy = 1
	while(dizziness > 100)
		if(client)
			var/amplitude = dizziness*(sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = 0
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0



/atom/movable/proc/do_windup_animation(atom/A, windup_time)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = -8
	else if(direction & SOUTH)
		pixel_y_diff = 8

	if(direction & EAST)
		pixel_x_diff = -8
	else if(direction & WEST)
		pixel_x_diff = 8

	var/default_pixel_x = initial(pixel_x)
	var/default_pixel_y = initial(pixel_y)
	var/mob/mob = src
	if(istype(mob))
		default_pixel_x = mob.default_pixel_x
		default_pixel_y = mob.default_pixel_y

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = windup_time - 2)
	animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y, time = 2)

/atom/movable/proc/do_attack_animation(atom/A)

	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/turn_dir = 1

	var/direction = get_dir(src, A)

	if(direction & NORTH)
		pixel_y_diff = 8
		turn_dir = rand(50) ? -1 : 1
	else if(direction & SOUTH)
		pixel_y_diff = -8
		turn_dir = rand(50) ? -1 : 1

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8
		turn_dir = -1

	var/default_pixel_x = initial(pixel_x)
	var/default_pixel_y = initial(pixel_y)
	var/mob/mob = src
	if(istype(mob))
		default_pixel_x = mob.default_pixel_x
		default_pixel_y = mob.default_pixel_y

	var/matrix/initial_transform = matrix(transform)
	var/matrix/rotated_transform = transform.Turn(15 * turn_dir)

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, transform = rotated_transform, time = 2, easing = BACK_EASING | EASE_IN)
	animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y, transform = initial_transform, time = 2, easing = SINE_EASING)

/atom/movable/proc/do_attack_effect(atom/A, effect) //Simple effects for telegraphing or marking attack locations
	if (effect)
		var/image/I = image('icons/effects/effects.dmi', A, effect, ABOVE_PROJECTILE_LAYER)

		if (!I)
			return

		var/list/all_clients = get_all_clients()
		if(istype(all_clients) && length(all_clients))
			flick_overlay(I, all_clients, 10)

		// And animate the attack!
		animate(
			I,
			alpha = 175,
			transform = matrix().Update(scale_x = 0.75, scale_y = 0.75),
			pixel_x = 0,
			pixel_y = 0,
			pixel_z = 0,
			time = 3
		)
		animate(time = 1)
		animate(alpha = 0, time = 3, easing = CIRCULAR_EASING|EASE_OUT)

/mob/do_attack_animation(atom/A)
	..()

	// What icon do we use for the attack?
	var/image/I
	/*
	var/obj/item/active_hand = get_active_hand()
	if (active_hand)
		I = image(active_hand.icon, A, active_hand.icon_state, A.layer + 1)
	else // Attacked with a fist?
		return
	*/
	return // temporary replacement, since I don't have active_hand here rn

	// Who can see the attack?
	var/list/viewing = list()
	for (var/mob/M in viewers(A))
		if (M.client)
			viewing |= M.client
	flick_overlay(I, viewing, 5) // 5 ticks/half a second

	// Scale the icon.
	I.SetTransform(scale = 0.75)
	// Set the direction of the icon animation.
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		I.pixel_y = -16
	else if(direction & SOUTH)
		I.pixel_y = 16

	if(direction & EAST)
		I.pixel_x = -16
	else if(direction & WEST)
		I.pixel_x = 16

	if(!direction) // Attacked self?!
		I.pixel_z = 16

	// And animate the attack!
	animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)

/mob/proc/spin(spintime, speed)
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			src.dir = D
			spintime -= speed
	return

#endif
