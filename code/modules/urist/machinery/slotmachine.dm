/******************************\
|		  Slot Machines		   |
\******************************/

/obj/machinery/slot_machine
	name = "Slot Machine"
	desc = "Gambling for the antisocial."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "slots-off"
	anchored = TRUE
	density = TRUE
//	mats = 10
	var/money = 25000
	var/plays = 0
	var/working = 0
	var/balance=0

/obj/machinery/slot_machine/attack_hand(mob/user as mob)
	if(user.mind)
		if(user.mind.initial_account)
			balance = user.mind.initial_account.money
	user.machine = src
	if (src.working)
		var/dat = {"<B>Slot Machine</B><BR>
		<HR><BR>
		<B>Please wait!</B><BR>"}
		show_browser(user, dat, "window=slotmachine;size=450x500")
		onclose(user, "slotmachine")
	else
		var/dat = {"<B>Slot Machine</B><BR>
		<HR><BR>
		Five credits to play!<BR>
		<B>Prize Money Available:</B> [src.money]<BR>
		<B>Credits Remaining:</B> [balance]<BR>
		[src.plays] players have tried their luck today!<BR>
		<HR><BR>
		<A href='byond://?src=\ref[src];ops=1'>Play!<BR>"}
		show_browser(user, dat, "window=slotmachine;size=400x500")
		onclose(user, "slotmachine")

/obj/machinery/slot_machine/Topic(href, href_list)
	if(href_list["ops"])
		var/operation = text2num(href_list["ops"])
		if(operation == 1) // Play
/*			if (src.working == 1)
				to_chat(usr, "<span class='warning'> You need to wait until the machine stops spinning!</span>")
				return */
			if (balance < 5)
				to_chat(usr, "<span class='warning'> Insufficient money to play!</span>")
				return
			usr.mind.initial_account.money -= 5
			src.money += 5
			src.plays += 1
			src.working = 1
			src.icon_state = "slots-on"
			to_chat(usr, "Let's roll!")
			var/roll = rand(1,10000)
			spawn(100)
				if (roll == 1)
					for(var/mob/O in hearers(src, null))
						O.show_message(text("<b>[]</b> says, 'JACKPOT! You win [src.money]!'", src), 1)
					command_announcement.Announce("Congratulations [usr.name] on winning the Jackpot!", "Jackpot Winner")
					usr.mind.initial_account.money += src.money
					src.money = 0
				else if (roll > 1 && roll <= 10)
					for(var/mob/O in hearers(src, null))
						O.show_message(text("<b>[]</b> says, 'Big Winner! You win five thousand credits!'", src), 1)
					usr.mind.initial_account.money += 5000
					src.money -= 5000
				else if (roll > 10 && roll <= 100)
					for(var/mob/O in hearers(src, null))
						O.show_message(text("<b>[]</b> says, 'Winner! You win five hundred credits!'", src), 1)
					usr.mind.initial_account.money += 500
					src.money -= 500
				else if (roll > 100 && roll <= 1000)
					to_chat(usr, "<span class='notice'> You win a free game!</span>")
					usr.mind.initial_account.money += 5
					src.money -= 5
				else
					to_chat(usr, "<span class='warning'> No luck!</span>")
				src.working = 0
				src.icon_state = "slots-off"
	src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
