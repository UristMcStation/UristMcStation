var/global/list/GPS_list = list()
/obj/item/device/gps/goof
	name = "global positioning system"
	desc = "Helping lost spacemen find their way through the planets since 2016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2.0
	slot_flags = SLOT_BELT
	origin_tech = "programming=2;engineering=2"
	var/gpstag = "COM0"
	emped = 0

/obj/item/device/gps/goof/New()
	..()
	GPS_list.Add(src)
	name = "global positioning system ([gpstag])"
	AddOverlays("working")

/obj/item/device/gps/goof/Destroy()
	GPS_list.Remove(src)
	..()
/obj/item/device/gps/goof/emp_act(severity)
	emped = 1
	CutOverlays("working")
	AddOverlays("emp")
	spawn(300)
		emped = 0
		CutOverlays("emp")
		AddOverlays("working")

/obj/item/device/gps/goof/attack_self(mob/user as mob)

	var/obj/item/device/gps/goof/t = ""
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"

		for(var/obj/item/device/gps/goof/G in GPS_list)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
				t += "<BR>[tracked_gpstag]: [replacetext(replacetext(gps_area.name,"\proper ",""),"\improper ","")] ([pos.x], [pos.y], [pos.z])"

	var/datum/browser/popup = new(user, "GPS", name, 600, 450)
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/gps/goof/Topic(href, href_list)
	..()
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = uppertext(copytext(sanitize(a), 1, 5))
		if(src.loc == usr)
			gpstag = a
			name = "global positioning system ([gpstag])"
			attack_self(usr)

/obj/item/device/gps/goof/science
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-s"
	gpstag = "SCI0"

/obj/item/device/gps/goof/engineering
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-e"
	gpstag = "ENG0"
