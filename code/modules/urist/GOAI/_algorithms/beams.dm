// DEBUG ONLY!

# define DEFAULT_BEAM_VANISH_TIME 20

/obj/vectorbeam
	name = "Beam"
	icon = 'icons/effects/beam.dmi'
	icon_state = "r_beam"

	var/atom/source = null
	var/scale = 1
	var/dist = 1
	var/angle = 0


/obj/vectorbeam/proc/UpdateVector(var/atom/new_source = null, var/new_scale = null, var/new_dist = null, var/new_angle = null)
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


/obj/vectorbeam/proc/PostNewHook()
	return


/obj/vectorbeam/New(var/atom/new_source = null, var/new_scale = null, var/new_dist = null, var/new_angle = null, var/beam_icon_state = null)
	..()

	if(beam_icon_state)
		src.icon_state = beam_icon_state

	source = (isnull(new_source) ? loc : new_source)
	src.UpdateVector(new_source, new_scale, new_dist, new_angle)
	name = "Beam @ [source]"

	src.PostNewHook()


/obj/vectorbeam/verb/Delete()
	set src in view()
	qdel(src)


/obj/vectorbeam/vanishing


/obj/vectorbeam/vanishing/PostNewHook()
	. = ..()

	spawn(DEFAULT_BEAM_VANISH_TIME)
		qdel(src)


/atom/proc/pDrawVectorbeam(var/atom/start, var/atom/end = null, var/beam_icon_state = null)
	var/atom/true_end = end
	true_end = (isnull(end) ? src : end)

	var/dist = EuclidDistance(start, true_end)

	var/dx = (true_end.x - start.x)
	var/dy = (true_end.y - start.y)
	var/angle = arctan(dx, dy)

	var/Vector2d/vec_length = dist

	var/obj/vectorbeam/vanishing/new_beam = new(get_turf(start), vec_length, vec_length, angle, beam_icon_state)
	return new_beam


// Debug verbs (defined as procs, so you need to grant them via another verb/proc to the desired user)

/atom/proc/DrawVectorbeam(var/atom/A in view())
	var/obj/vectorbeam/vanishing/new_beam = A.pDrawVectorbeam(usr)
	to_chat(usr, "Spawned new beam [new_beam]")


/atom/proc/DeleteBeams()
	for(var/obj/vectorbeam/VB in view())
		qdel(VB)

