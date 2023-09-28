# ifdef GOAI_LIBRARY_FEATURES

/obj/projectile
	name = "Projectile"
	//icon = 'icons/effects/beam.dmi'
	icon = 'icons/obj/projectiles.dmi'
	//icon_state = "b_beam"
	icon_state = "laser"

	var/atom/source = null
	var/scale = 1
	var/dist = 1
	var/angle = 0
	var/lifetime = 5


/obj/projectile/New(var/atom/new_source = null, var/new_scale = null, var/new_dist = null, var/new_angle = null, var/custom_sprite = null)
	..()

	source = (isnull(new_source) ? loc : new_source)
	src.UpdateVector(new_source, new_scale, new_dist, new_angle)
	name = "Beam @ [source]"

	icon_state = (isnull(custom_sprite) ? icon_state : custom_sprite)

	src.PostNewHook()


/obj/projectile/proc/UpdateVector(var/atom/new_source = null, var/new_scale = null, var/new_dist = null, var/new_angle = null)
	source = (isnull(new_source) ? source : new_source)
	scale = (isnull(new_scale) ? scale : new_scale)
	dist = (isnull(new_dist) ? dist : new_dist)
	angle = (isnull(new_angle) ? angle : new_angle)

	var/matrix/beam_transform = new()
	var/turn_angle = -angle // normal Turn() is clockwise (y->x), we want (x->y).
	var/x_translate = dist * cos(angle)
	var/y_translate = dist * sin(angle)

	if((angle > 135 || angle <= -45))
		// some stupid nonsense with how matrix.Turn() works requires this
		turn_angle = 180 - angle

	beam_transform.Scale(1, scale)

	beam_transform.Turn(90) // the icon is vertical, so we reorient it to x-axis alignment
	beam_transform.Turn(turn_angle)

	beam_transform.Translate(0.5 * x_translate * world.icon_size, 0.5 * y_translate * world.icon_size)

	src.x = source.x
	src.y = source.y
	src.transform = beam_transform


/obj/projectile/proc/PostNewHook()
	var/true_lifetime = lifetime // placeholder for proper validation :^)

	spawn(true_lifetime)
		del(src)


/obj/item/weapon/gun
	name = "Gun"
	icon = 'icons/obj/gun.dmi'
	icon_state = "laser"

	var/cooling = FALSE
	var/cooldown_time_deterministic = 17
	var/cooldown_time_random = 3

	var/dispersion = GUN_DISPERSION
	var/ammo_sprite = null


/obj/item/weapon/gun/New(var/atom/location)
	..()

	loc = location
	ammo_sprite = pick(
		1; "laser",
		1; "bluelaser",
		1; "xray",
	)


/obj/item/weapon/gun/proc/cool()
	cooling = TRUE

	spawn(cooldown_time_deterministic + rand(-cooldown_time_random, cooldown_time_random))
		cooling = FALSE

	return


/obj/item/weapon/gun/proc/shoot(var/atom/At, var/atom/From)
	if(cooling)
		return

	cool()

	var/atom/source = (isnull(From) ? src : From)
	var/dist = EuclidDistance(source, At)
	var/shot_dispersion = rand(-dispersion, dispersion) % 180

	var/dx = (At.x - source.x)
	var/dy = (At.y - source.y)
	var/angle = arctan(dx, dy) + shot_dispersion

	var/vec_length = dist

	var/obj/projectile/newbeam = new(source.loc, vec_length, vec_length, angle, ammo_sprite)

	var/true_dy = vec_length * sin(angle)
	var/true_dx = vec_length * cos(angle)

	var/hit_x = (source.x + true_dx)
	var/hit_y = (source.y + true_dy)

	if ((FLOOR(hit_x) == At.x) && (FLOOR(hit_y) == At.y))
		At.Hit(angle, From)

		if(At.attachments)
			var/datum/event_queue/hit/hitqueue = At.attachments.Get(ATTACHMENT_EVTQUEUE_HIT)

			if(hitqueue)
				var/datum/event/hit/hit_evt = new("Hit @ [world.time]", angle, From)
				hitqueue.Add(hit_evt)

	return newbeam


/obj/item/weapon/gun/proc/Fire(var/atom/At, var/atom/From)
	src.Shoot(At, From)
	return


/obj/item/weapon/gun/verb/Shoot(var/atom/At as mob in view())
	set src in view(0)

	if(cooling)
		to_chat(usr, "[src] is cooling down, please wait.")

	else
		shoot(At, usr)


/mob/verb/GimmeGun()
	var/obj/item/weapon/gun/newgun = new(usr)

	to_chat(usr, "There ya go, one [newgun]!")

# endif
