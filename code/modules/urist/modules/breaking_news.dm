var/global/BNews = null

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
				if(5)							BNews = "ALERT: NNN interrupts our normal breaking news section to bring you an unprecedented alert. As you likely know, two weeks ago, a number of mining outposts in the Outer Rim went silent. Today, we have recieved confirmation of our worst fears from a representative of the Nanotrasen Navy: the outposts fell to a hostile force. We can't confirm any more details at this time, but rest assured that we will keep you updated. This is Chet Jonaheus signing off."
				if(6)							BNews = "ALERT: Following up on yesterday's special broadcast, we bring you more important information about the recent attacks. Indeed, attacks may be too week a word, for we have recieved confirmation that this is an unknown threat, something that we have never seen before. Early reports that the attacks were from the Unathi Empire have proved to be unfounded, but the origin of the force itself are unknown. As always, we will do our best to keep you updated. This is Chet Jonaheus, signing off."
				if(7)							BNews = "Unidentified hackers have gained access to several million bank accounts and have stolen well over 5 billion credits. The source of this incident is unknown. "
				if(8)							BNews = "ALERT: The attacks in the Outer Rim are quickly becoming a galactic crisis, as similar incursions have been reported in the Tau Ceti, Alderamin and Capella Systems. Nanotrasen citizens in those systems are to remain on high alert, and listen to local authorities for relevant information."
				if(9)							BNews = "ALERT: Attacks have been reported in the Zosma and Pegasi systems. Nanotrasen Naval forces in nearby systems are placed on high alert."
				if(11)							BNews = "A Nanotrasen trading vessel has been shot down in the Tau Ceti system today, casualties are currently unconfirmed, but it is assumed that there are no survivors."
				if(14)							BNews = "ALERT: Reade III, the capital of the Outer Rim Miners Alliance, has been confirmed to have fallen to the recent alien threat. Vigils are being held across the galaxy to mourn the loss of so many innocents."
				if(15)							BNews = "ALERT: Nanotrasen Naval officials are confirming that the recent threat has not eased in its intensity over the last two weeks, and are encouraging Nanotrasen citizens to enlist in the Nanotrasen Navy in support oof their fellow citizens."
				if(17)							BNews = "A civilian space station in the Denebola system has gone silent. It is not confirmed that this was due to the recent alien threat, but Nanotrasen citizens in that system are to remain vigilent."
				if(19)							BNews = "ALERT: Alien ships have been confirmed to be operating in the Denebola system. Nanotrasen colonies in the system have been placed under martial law, and citizens are urged to report any unusual sightings."
				if(20)							BNews = "Earlier today, salvage teams found an escape pod. The escape pod's occuptant appears to have gone mad, claiming to be a space wizard among other things. The survivors has been committed to Saint Mary's Mental Ward on Mars."
				if(22)							BNews = "ALERT: The Alderamin system has been confirmed to have fallen to the recent alien threat. Vigils are being held across the galaxy, and talks have begun between the Terran Confederacy and Nanotrasen about a joint effort to defend against the recent threat."
				if(23)							BNews = "A number of refugees from affected systems have fled to Sol. Martian authorities are struggling to deal with the massive influx of new arrivals."
				if(25)							BNews = "The number of refugees across the galaxy continues to rise, and today we have recieved reports that authorities in Ryclies I have diverted over 30,000 refugees to a temporary holding camp on Ryclies II. This is in addition to the 25,000 that arrived last week. Questions are being raised about how these refugees will be cared for, and who will care for them."
				if(27)							BNews = "ALERT: Colonies in the Pegasi and Zosma systems are no longer responding to attempts to communicate them, and Nanotrasen Naval authorities are confirming that they have pulled out of those systems. Those in neighbouring systems are encouraged to keep an eye on scanners in search of refugees. Full lists of missing and dead will be published soon."
				if(28)							BNews = "Citizens of the Milky Way. I speak with you today, not as a newscaster, not as a representative of Nanotrasen, but as a fellow sapient. It can no longer be said that these attacks over the last Earth month have been isolated, and I cannot in good conscience say that the attacks will be over soon. What began as a series of isolated attacks in the Outer Rim has become a galactic crisis. We've lost contact with a number of important systems, and not solely Nanotrasen ones. All citizens of the Milky Way galaxy have been affected by this crisis. In times like this, we need to put petty differences aside, and band together to halt this crisis. This is Chet Jonaheus, NNN, signing off."
		if(5) //May
			switch(DD)
				if(1)							BNews = "Labour protests erupt accross dozens of Nanotrasen colonies as concerns about losing jobs to refugees from the current galactic crisis rises."
				if(3)							BNews = "Labour protests enter the second day, and conflict between refugees and protestors has been reported."
				if(4)							BNews = "As what is now being called the Galactic Crisis enters its second month, questions are abound as to how the refugees from affected systems will be dealt with. As the recent labour protests show, the current lassaiz faire attitudes need to change."
				if(5)							BNews = "After a response by Nanotrasen that protesters are calling heavy-handed and Nanotrasen is calling just, the majority of labour protests have ended."
				if(7)							BNews = "Sporadic fighting has been reported in the Ryclies system. It appears that a small alien contingent has attacked Terran Confederacy forces operating in the area. Death tolls are as yet unknown."
				if(11)							BNews = "All labour protests across Nanotrasen controlled areas have come to an end after a series of conflicts between Nanotrasen forces and protestors. This, coupled with the Galactic Crisis has led some to speculate that we are entering a Second Age of Discord."

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
				if(26)							BNews = "ALERT: After a lull in alien attacks spanning three Earth months, there has been a massive resurgence in attacks on human colonies across the Milky Way, proving that the Galactic Crisis is still a massive concern for humans everywhere. We will provide continuing coverage over the coming days."
				if(27)							BNews = "HIGH ALERT: This is an emergency broadcast for all living in the Ryclies sector. An alien fleet of unprecedented size has been spotted entering the Ryclies system. Ryclies defence forces and Terran naval units are moving to respond."
				if(28)							BNews = "SYSTEM WIDE HIGH ALERT: The Ryclies system is on high alert today as alien forces have crushed Ryclies defence forces and Terran Naval units in the sector. We have recieved confirmed reports of alien forces landing in large numbers on Ryclies II. A spokesman for the joint Terran/Nanotrasen naval force ANFOR (created in response to the Galactic Crisis) has stated that they will do everything they can to protect the Ryclies system."
				if(29)							BNews = "SYSTEM WIDE HIGH ALERT: We have confirmed reports that fighting continues on the surface of Ryclies II. ANFOR units have been reported arriving in the sector along with units from an unknown force called SCOM. It has been suggested that they will be engaging the growing alien forces above Ryclies II. Citizens on Ryclies I are advised to follow local evacuation orders as closely as possible."

		if(9) //September //remind Knox to update this
			switch(DD)
				if(1)							BNews = "Attention loyal viewers. Due to recent budget cuts, Nanotrasen News Network will be off the air for the month of September."

		if(10) //October
			switch(DD)
				if(16)							BNews = "Hello citizens of Nanotrasen! I'm Chet Jonaheus! I'm the nightly news anchor for the newly founded Nanotrasen News Network! Turn in every night for the latest in breaking news and events!"
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
	//var/station_name = station_name()
	//update our hub status
	world.update_status()
	BNews_Game_Start()

	message_admins("<span class='notice'> ADMIN: Event: [key_name(src)] force-set BNews to \"[BNews]\"</span>")
	log_admin("[key_name(src)] force-set BNews to \"[BNews]\"")

/proc/BNews_Game_Start()
	if(BNews)
		to_world("<font color='blue'>and...</font>")
		to_world("<h4>Breaking News from NNN! [BNews]</h4>")

	return

/proc/BNews_Random_Event()
	switch(BNews)

		if(" ",null)
			return
