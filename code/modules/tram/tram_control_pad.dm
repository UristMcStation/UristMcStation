/obj/tram/controlpad
	name = "tram controller interface"
	desc = "Controls a tram."
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	anchored = TRUE
	var/obj/tram/tram_controller/tram_linked

/obj/tram/controlpad/attack_hand(mob/user)
	usr.set_machine(src)
	if(!tram_linked)	return
	var/dat = "Tram Controller"
	dat += "<br>Tram engine: <a href=?src=\ref[src];engine_toggle=1>[tram_linked.automode ? "<font color='green'>On</font>" : "<font color='red'>Off</font>"]</a>"
	dat += "<br><A href='byond://?src=\ref[src];close=1'>Close console</A>"
	show_browser(user, dat, "window=trampad")
	onclose(user,"trampad")

/obj/tram/controlpad/Topic(href, href_list)
	if(..())
		show_browser(usr, null, "window=publiclibrary")
		onclose(usr, "publiclibrary")
		return

	if(href_list["engine_toggle"])
		tram_linked.automode = !tram_linked.automode
		if(tram_linked.automode)	tram_linked.startLoop()
		else	tram_linked.killLoop()
	else if(href_list["close"])
		usr.unset_machine()
		show_browser(usr, null, "window=trampad")

	src.add_fingerprint(usr)
	src.updateUsrDialog()
