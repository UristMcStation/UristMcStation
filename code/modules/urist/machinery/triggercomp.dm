//i'm fucking sick of having 100 buttons bunched up on one tile. This shit takes care of that for blast doors, it's meant for the brig and the ce. TODO: make it for all button things.

/obj/machinery/computer/trigger/blast
	name = "Blast Door Computer" //let's just do blast doors for now all this does is condense buttons down so the warden/CE isn't shitting himself.
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "trig"
	density = 0

	var/id = null
	var/id1 = null
	var/id2 = null
	var/id3 = null
	var/id4 = null
	var/id5 = null
	var/id6 = null
	var/id7 = null

/*	circuit = "/obj/item/weapon/circuitboard/merch"

/obj/item/weapon/circuitboard/trigger/blast
	name = "\improper Blast Door Computer Circuitboard"
	build_path = /obj/machinery/computer/trigger/blast*/

/obj/machinery/computer/trigger/attackby(obj/O, mob/user)
	return

/obj/machinery/computer/trigger/blast/proc/trigger()
	for(var/obj/machinery/door/blast/M in machines)
		if(M.id == src.id)
			if(M.density)
				spawn(0)
					M.open()
					return
			else
				spawn(0)
					M.close()
					return

//	circuit = "/obj/item/weapon/circuitboard"

/*	var/dat = {"
<html>
	<head>
		<title>[command_name()] Merchandise</title>
		<style type="text/css">
* {
	font-family:sans-serif;
	font-size:x-small;
}
html {
	background:#333;
	color:#999;
}

a {
	color:#cfcfcf;
	text-decoration:none;
	font-weight:bold;
}

a:hover {
	color:#ffffff;
}
tr {
	background:#303030;
	border-radius:6px;
	margin-bottom:0.5em;
	border-bottom:1px solid black;
}
tr:nth-child(even) {
	background:#3f3f3f;
}

td.cost {
	font-size:20pt;
	font-weight:bold;
}

		</style>
	</head>*/

/obj/machinery/computer/trigger/blast/attack_hand(mob/user as mob)
	..()

	if(!id1)
		return

	else

		var/t = "<B>Blast Door Controller</B><br><br>"
		t += "<A href='?src=\ref[src];on1=[id1]'>[id1]</A><br>"
		t += "<A href='?src=\ref[src];on2=[id2]'>[id2]</A><br>"
		t += "<A href='?src=\ref[src];on3=[id3]'>[id3]</A><br>"
		t += "<A href='?src=\ref[src];on4=[id4]'>[id4]</A><br>"
		if(id5)
			t += "<A href='?src=\ref[src];on5=[id5]'>[id5]</A><br>"
			t += "<A href='?src=\ref[src];on6=[id6]'>[id6]</A><br>"
			t += "<A href='?src=\ref[src];on7=[id7]'>[id7]</A><br>"

		user << browse(t, "window=computer;size=420x700")


/obj/machinery/computer/trigger/blast/Topic(href, href_list) //come back to this
	..()
	if( href_list["on1"] )
		id = id1
		trigger()

	if( href_list["on2"] )
		id = id2
		trigger()

	if( href_list["on3"] )
		id = id3
		trigger()

	if( href_list["on4"] )
		id = id4
		trigger()

	if( href_list["on5"] )
		id = id5
		trigger()

	if( href_list["on6"] )
		id = id6
		trigger()

	if( href_list["on7"] )
		id = id7
		trigger()
