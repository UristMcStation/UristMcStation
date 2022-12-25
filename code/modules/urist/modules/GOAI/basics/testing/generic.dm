// Generic 'magic' logic that should be only enabled for dev

/client/DblClick(object, location, control, params)
	..(location, control, params)

	// Make double-clicking an atom jump the mob there
	var/atom/trg = object
	if(trg && src.mob)
		Move(trg, get_dir(src.mob, trg))

