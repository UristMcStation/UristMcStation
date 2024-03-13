/turf/verb/GetCardinal()
	set src in view(1)
	var/list/neighbors = CardinalTurfs(TRUE, TRUE, TRUE)
	var/idx = 0

	to_chat(usr, "==================")
	for(var/atom/neighT in neighbors)
		idx++
		to_chat(usr, "Neighbor [idx] @ [neighT]")

	to_chat(usr, "==================")

	return


/turf/verb/CheckTurfBlockage()
	set src in view(1)

	var/turf/src_turf = get_turf(usr)
	var/turf/trg_turf = get_turf(src)

	var/dir2caller = get_dir(src, usr)
	var/dir2turf = get_dir(usr, src)

	var/result = DirBlocked(trg_turf, dir2caller, TRUE)
	var/result_rev = DirBlocked(src_turf, dir2turf, TRUE)

	to_chat(usr, "==================")
	to_chat(usr, "[src_turf] -> [trg_turf] is blocked in DIR: [dir2caller] = [result ? "TRUE" : "FALSE"]")
	to_chat(usr, "[trg_turf] -> [src_turf] is blocked in DIR: [dir2turf] = [result_rev ? "TRUE" : "FALSE"]")
	to_chat(usr, "==================")

	return


/turf/verb/CheckTurfLinkBlockage()
	set src in view(1)

	var/turf/src_turf = get_turf(src)
	var/turf/usr_turf = get_turf(usr)

	var/result = LinkBlocked(src_turf, usr_turf)

	to_chat(usr, "==================")
	to_chat(usr, "[src] <-> [usr] LINK is blocked = [result ? "TRUE" : "FALSE"]")
	to_chat(usr, "==================")

	return
