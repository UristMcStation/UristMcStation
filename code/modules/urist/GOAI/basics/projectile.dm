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


/obj/item/gun
	name = "Gun"
	icon = 'icons/obj/gun.dmi'
	icon_state = "laser"

	var/cooling = FALSE
	var/cooldown_time_deterministic = 17
	var/cooldown_time_random = 3

	var/dispersion = GUN_DISPERSION
	var/ammo_sprite = null

	var/projectile_raycast_flags = RAYTYPE_BEAM


/obj/item/gun/New(var/atom/location)
	..()

	loc = location
	ammo_sprite = pick(
		1; "laser",
		1; "bluelaser",
		1; "xray",
	)


/obj/item/gun/proc/cool()
	cooling = TRUE

	spawn(cooldown_time_deterministic + rand(-cooldown_time_random, cooldown_time_random))
		cooling = FALSE

	return


/obj/item/gun/proc/shoot(var/atom/At, var/atom/From)
	if(cooling)
		return

	cool()

	var/atom/source = (isnull(From) ? src : From)

	var/atom/Hit = AtomDensityRaytrace(source, At, list(source), src.projectile_raycast_flags, dispersion, TRUE)

	if(!istype(Hit))
		// this generally shouldn't happen
		return

	var/dx = null
	var/dy = null

	dx = (Hit.x - source.x)
	dy = (Hit.y - source.y)

	var/vec_length = sqrt(SQR(dx) + SQR(dy))
	var/angle = arctan(dx, dy)

	var/obj/projectile/newbeam = new(source.loc, vec_length, vec_length, angle, ammo_sprite)

	Hit.RangedHitBy(angle, From)

	if(Hit?.attachments)
		var/datum/event_queue/hit/hitqueue = Hit.attachments.Get(ATTACHMENT_EVTQUEUE_HIT)

		if(istype(hitqueue))
			var/datum/event/hit/hit_evt = new("Hit @ [world.time]", angle, From)
			hitqueue.Add(hit_evt)

	return newbeam


/obj/item/gun/proc/Fire(var/atom/At, var/atom/From)
	src.Shoot(At, From)
	return


/obj/item/gun/verb/Shoot(var/atom/At as mob in view())
	set src in view(0)

	if(cooling)
		to_chat(usr, "[src] is cooling down, please wait.")

	else
		shoot(At, usr)


/obj/item/test_grenade
	name = "Grenade???"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade_active"


/obj/item/test_grenade/proc/Boom()
	spawn(10)
		flick("explosion", src)
		sleep(9)
		qdel(src)


/proc/grenade_yeet(var/obj/item/test_grenade/grenade, var/atom/To, var/atom/From)
	if(isnull(grenade))
		return

	if(isnull(To))
		return

	if(isnull(From))
		return

	var/atom/impactee = AtomDensityRaytrace(From, To, list(From), RAYTYPE_PROJECTILE_NOCOVER, FALSE)

	var/expected_dist = get_dist(From, To)
	var/impact_dist = isnull(impactee) ? null : get_dist(From, impactee)

	var/true_impactee = impactee

	if(isnull(impact_dist) || impact_dist > expected_dist)
		true_impactee = To

	var/turf/endturf = get_turf(true_impactee)

	grenade.Boom()

	walk_to(grenade, endturf, ((isturf(true_impactee) && endturf.density) ? 1 : 0))
	return



/proc/grenade_spawnyeet(var/atom/To, var/atom/From)
	if(isnull(To))
		return

	if(isnull(From))
		return

	var/turf/startturf = get_turf(From)

	if(isnull(startturf))
		return

	var/obj/item/test_grenade/grenade = new(startturf)
	grenade_yeet(grenade, To, From)
	return


# endif
