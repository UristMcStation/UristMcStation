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
				if(1)							BNews = "The universe did not end last night, Unathi extremists not available for comment."
				if(20)							BNews = "Skrell passenger vessel, The Janarus, collided with a space station today while attempting to dock. All passengers aboard are believed to have been killed."
				if(30)							BNews = "The captain of the Janarus has been posthumously found guilty of gross misconduct and has been faulted with the destruction of the vessel and the death of all 154 passengers."

		if(2) //February
			switch(DD)
				if(6)							BNews = "A Nanotrasen phoron tanker has collided with an asteroid today, spilling thousands of gallons of the valuable substance into space."
				if(15)							BNews = "The leader of the Unathi Empire, Syvianus the Great, has been killed in a duel of succession. The victor, Yvalius the Lesser has assumed the role of Emperor of the Unathi Empire."

		if(3) //March
			switch(DD)
				if(8)							BNews = "Skrellian scientists have discovered a new kind of hyperdrive. This so called phoron drive is twice as fast as any previous model."
				if(19)							BNews = "Actor John Wills dies at the age of 78. Wills was best know for his work as the lead character in Space Invaders 2: Invading the Invaders."

		if(4) //April
			switch(DD)
				if(6)							BNews = "Unidentified hackers have gained access to several million bank accounts and have stolen well over 5 billion credits."
				if(20)							BNews = "Earlier today, salvage teams found an escape pod. The escape pod's occuptant appears to have gone mad, claiming to be a space wizard among other things. The survivors has been committed to Saint Mary's Mental Ward on Mars."

		if(5) //May
			switch(DD)
				if(1)							BNews = "Labour protests erupt accross dozens of Nanotrasen colonies."
				if(2)							BNews = "Labour protests enter the second day."
				if(5)							BNews = "After a response by Nanotrasen that protesters are calling heavy-handed and Nanotrasen is calling just, the majority of labour protests have ended."
				if(11)							BNews = "All labour protests across Nanotrasen controlled areas have come to an end. Speculation is abound over wethter they were influenced by rival corporations."

		if(6) //June
			switch(DD)
				if(3)							BNews = "The eco-terrorist group, Trees First, has targeted the mega-corporation Nanotrasen today, the group threatens to bomb the Nanotrasen headquarters if phoron drilling on Aeges 5 is not stopped."
				if(5)							BNews = "Nanotrasen has released a public statement today. We here at Nanotrasen will not be threatened by slime like the Trees First group, and we will not stop drilling on Aeges 5."
				if(15)							BNews = "The eco-terrorist group, Trees First, has been destroyed today by Nanotrasen special forces. Nanotrasen reports no survivors."

		if(7) //July
			switch(DD)
				if(13)							BNews = "The recently released blockbuster, Space Invaders 3: The Return of the Invaders, becomes the highest grossing movie of all time."
				if(20)							BNews = "Anti-government anarchists have been caught today attempting to bomb the Terran Grand Council building on Mars."

		if(8) //August
			switch(DD)
				if(9)							BNews = "Beer company Blue Moon has been shut down by Terran health officals after finding traces of mercury in their drinks."
				if(16)							BNews = "The infamous pirate captain Black-Eyed John has been killed by Terran Navy ships today after 15 years of terrorizing Terran Space."

		if(9) //September
			switch(DD)
				if(1)							BNews = "Attention loyal viewers. Due to recent budget cuts, Nanotrasen News Network will be off the air for the month of September."

		if(10) //October
			switch(DD)
				if(17)							BNews = "Hello citizens of Nanotrasen! I'm Chet Jonaheus! I'm the nightly news anchor for the newly founded Nanotrasen News Network! Turn in every night for the latest in breaking news and events!"
				if(18)							BNews = "The Skrellian Federation becomes the first galatic civilization to legalize inter-species marriage. Mass protests break out outside various Skrell embassies on many worlds!"
				if(19)							BNews = "The Skrellian Embassy on Earth has been bombed today by terrorists protesting the recent legalization of inter-species marriage! The captain of the Lotus Tree was not available for comment."
				if(30)							BNews = "Local police forces on Mars have released information today about a group of narcotic traffickers who were attempting to smuggle drugs past customs disguised as halloween candy."

		if(11) //November
			switch(DD)
				if(10)							BNews = "The Terran election season has begun! Voters all over the Terran Confederacy are flocking to the nearest voting station to cast their vote! The two biggest candidates are President Garret Harris running for his second term, and newcomer Tam Wycker."
				if(17)							BNews = "The polls are closed and the results are in! President Garret Harris has beaten Tam Wycker in the polls and will now be beginning his second term in office!"
				if(29)							BNews = "A new law has been passed that disallows non-humans from practicing medicine in the Terran Confederacy."

		if(12) //December
			switch(DD)
				if(3)							BNews = "CEO of Nanotrasen Markus Vylain was injured last night after his shuttle craft's engines failed mid-flight. Vylain is expected to make a full recovery. The CEO's security team would not comment on the possibility that this was an attempt on his life."
				if(25)							BNews = "Hundreds of break-ins occured last night, witnesses describe the perpetrators as large and dressed in red."
				if(31)							BNews = "Unathi religious extremists claim the the Universe will end tommorrow night at 4 am Moghes time."

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
		world << "<h4>Breaking News! I'm Chet Jonaheus here with today's top story! [BNews] And now, Annie with the weather, and later Todd with Sports News!</h4>"

	return

/proc/BNews_Random_Event()
	switch(BNews)

		if(" ",null)
			return

