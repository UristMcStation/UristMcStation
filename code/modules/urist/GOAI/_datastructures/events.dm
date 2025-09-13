/datum/event
	var/name
	var/create_time


/datum/event/New(var/name)
	src.name = name
	src.create_time = world.time


/datum/event/hit
	var/angle
	var/atom/from


/datum/event/hit/New(var/new_name, var/new_angle, var/atom/new_from)
	. = ..(new_name)

	src.angle = new_angle
	src.from = new_from

