/datum/persistent/account
	var/amount = 0

/datum/persistent/account/set_filename()
	filename = "data/persistent/[lowertext(GLOB.using_map.name)]-account.txt"