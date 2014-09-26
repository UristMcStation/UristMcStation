/var/global/BNews = null

/hook/startup/proc/updateBNews()
	Get_BNews()
	return 1

/proc/Get_BNews()
	if(!BNews)	return

	BNews = null

	var/MM	=	text2num(time2text(world.timeofday, "MM"))
	var/DD	=	text2num(time2text(world.timeofday, "DD"))

	switch(MM) //Seven tabs
		if(1) //January
			switch(DD)
				if(1)							BNews = "Blarg"
		if(2) //February
			switch(DD)
				if(1)							BNews = "Blarg"

		if(3) //March
			switch(DD)
				if(1)							BNews = "Blarg"

		if(4) //April
			switch(DD)
				if(1)							BNews = "Blarg"

		if(5) //May
			switch(DD)
				if(1)							BNews = "Blarg"

		if(6) //June
			switch(DD)
				if(1)							BNews = "Blarg"

		if(7) //July
			switch(DD)
				if(1)							BNews = "Blarg"

		if(8) //August
			switch(DD)
				if(1)							BNews = "Blarg"

		if(9) //September
			switch(DD)
				if(1)							BNews = "Blarg"
				if(25)							BNews = "Testing!"

		if(10) //October
			switch(DD)
				if(1)							BNews = "Blarg"

		if(11) //November
			switch(DD)
				if(1)							BNews = "Blarg"

		if(12) //December
			switch(DD)
				if(1)							BNews = "Blarg"

/client/proc/Set_BNews(B as text|null)
	set name = ".Set BNews"
	set category = "Fun"
	set desc = "Force-set the BNews variable to make the game think it's a certain day."
	if(!check_rights(R_SERVER))	return

	BNews = B
	//get a new station name
	station_name = null
	station_name()
	//update our hub status
	world.update_status()
	BNews_Game_Start()

	message_admins("\blue ADMIN: Event: [key_name(src)] force-set BNews to \"[BNews]\"")
	log_admin("[key_name(src)] force-set BNews to \"[BNews]\"")

/proc/BNews_Game_Start()
	if(BNews)
		world << "<font color='blue'>and...</font>"
		world << "<h4>Breaking News! [BNews]</h4>"

	return

/proc/BNews_Random_Event()
	switch(BNews)

		if(" ",null)
			return

