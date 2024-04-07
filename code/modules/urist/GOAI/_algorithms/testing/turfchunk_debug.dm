/mob/verb/TestTperimeter(var/radius = 1 as num, var/exclude_centre=FALSE as null|anything in list(TRUE, FALSE))
	set category = "TurfChunk"

	var/list/result_turfs = tperimeter(
		radius = radius,
		centreX = usr.x,
		centreY = usr.y,
		centreZ = usr.z,
		dirs = ALL_CARDINAL_DIRS,
		exclude_centre_tile = exclude_centre
	)

	var/result_no = 0

	for(var/turf/T in result_turfs)
		result_no++
		to_chat(usr, "TestTperimeter result [result_no]: [T]")

	to_chat(usr, " ")
	return


/mob/verb/TestTperimeterDirectional(var/dirs as num, var/exclude_centre=FALSE as null|anything in list(TRUE, FALSE))
	set category = "TurfChunk"

	var/const/radius = 2

	var/list/result_turfs = tperimeter(
		radius = radius,
		centreX = usr.x,
		centreY = usr.y,
		centreZ = usr.z,
		dirs = dirs,
		exclude_centre_tile = exclude_centre
	)

	var/result_no = 0

	for(var/turf/T in result_turfs)
		result_no++
		to_chat(usr, "TestTperimeter result [result_no]: [T]")

	to_chat(usr, " ")
	return
