 /*										*****New space to put all UristMcStation Structures*****

Please keep it tidy, by which I mean put comments describing the item before the entry.I may or may not move couches and flora here. -Glloyd*/


//THA MAP

/obj/structure/sign/uristmap
	name = "station map"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "A framed picture of the station."

/obj/structure/sign/uristmap/left
	icon_state = "umap_left"

/obj/structure/sign/uristmap/right
	icon_state = "umap_right"

//Emergency suits locker, moved from Uristclothes.dm

/obj/structure/closet/emsuits //Tossing the closet here, because why the fuck not.
	name = "emergency suit closet"
	desc = "It's a closet for storing emergency equipment and suits. A small  sign on the bottom reads 'use only in extreme emergencies'"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	icon_state = "ecloset"
	icon_closed = "ecloset"
	icon_opened = "eclosetopen"

/obj/structure/closet/emsuits/New()
	..()

	new /obj/item/clothing/head/emergencyhood(src)
	new /obj/item/clothing/suit/emergencysuit(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/weapon/storage/toolbox/emergency(src)
	new /obj/item/weapon/tank/emergency_oxygen(src)

//Armored sec biosuit locker, moved from Uristclothes.dm

/obj/structure/closet/secure_closet/armoredbiosuit
	name = "armoured bio suit locker"
	req_access = list(access_armory)
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/armoredbiosuit/New()
	..()

	new /obj/item/clothing/head/bio_hood/asec(src)
	new /obj/item/clothing/suit/bio_suit/asec(src)

//Psychologists locker

/obj/structure/closet/secure_closet/psychologist
	name = "Psychologist's Locker"
	req_access = list(access_psychiatrist)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"

//Department signs, icons based off the ones from Para station

/obj/structure/sign/deptsigns
	name = "departmental sign"
	icon = 'icons/urist/structures&machinery/structures.dmi'

/obj/structure/sign/deptsigns/sec
	desc = "A sign leading to Security."
	icon_state = "sec"

/obj/structure/sign/deptsigns/sci
	desc = "A sign leading to Research."
	icon_state = "sci"

/obj/structure/sign/deptsigns/eng
	desc = "A sign leading to Engineering."
	icon_state = "eng"

/obj/structure/sign/deptsigns/med
	desc = "A sign leading to Medbay."
	icon_state = "med"

/obj/structure/sign/deptsigns/esc
	desc = "A sign leading to Escape."
	icon_state = "esc"

//hacky, but I don't give a fuck. nicer beds

/obj/structure/stool/bed/nice
	name = "bed"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "This is used to lie in, sleep in or strap on. Looks comfortable."
	icon_state = "bed"


//Pokertables

/obj/structure/table/woodentable/poker/update_icon()
	spawn(2) //So it properly updates when deleting
		var/dir_sum = 0
		for(var/direction in list(1,2,4,8,5,6,9,10))
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if(W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if(1)
					inv_direction = 2
				if(2)
					inv_direction = 1
				if(4)
					inv_direction = 8
				if(8)
					inv_direction = 4
				if(5)
					inv_direction = 10
				if(6)
					inv_direction = 9
				if(9)
					inv_direction = 6
				if(10)
					inv_direction = 5
			for(var/obj/structure/window/W in get_step(src,direction))
				if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if(!skip_sum) //means there is a window between the two tiles in this direction
				if(locate(/obj/structure/table,get_step(src,direction)))
					if(direction <5)
						dir_sum += direction
					else
						if(direction == 5)	//This permits the use of all table directions. (Set up so clockwise around the central table is a higher value, from north)
							dir_sum += 16
						if(direction == 6)
							dir_sum += 32
						if(direction == 8)	//Aherp and Aderp.  Jezes I am stupid.  -- SkyMarshal
							dir_sum += 8
						if(direction == 10)
							dir_sum += 64
						if(direction == 9)
							dir_sum += 128

		var/table_type = 0 //stand_alone table
		if(dir_sum%16 in cardinal)
			table_type = 1 //endtable
			dir_sum %= 16
		if(dir_sum%16 in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if(dir_sum%16 == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if(dir_sum%16 == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if(dir_sum%16 in list(5,6,9,10))
			if(locate(/obj/structure/table,get_step(src.loc,dir_sum%16)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			dir_sum %= 16
		if(dir_sum%16 in list(13,14,7,11)) //Three-way intersection
			table_type = 5 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations.  TOO BAD -- SkyMarshal
			switch(dir_sum%16)	//Begin computation of the special type tables.  --SkyMarshal
				if(7)
					if(dir_sum == 23)
						table_type = 6
						dir_sum = 8
					else if(dir_sum == 39)
						dir_sum = 4
						table_type = 6
					else if(dir_sum == 55 || dir_sum == 119 || dir_sum == 247 || dir_sum == 183)
						dir_sum = 4
						table_type = 3
					else
						dir_sum = 4
				if(11)
					if(dir_sum == 75)
						dir_sum = 5
						table_type = 6
					else if(dir_sum == 139)
						dir_sum = 9
						table_type = 6
					else if(dir_sum == 203 || dir_sum == 219 || dir_sum == 251 || dir_sum == 235)
						dir_sum = 8
						table_type = 3
					else
						dir_sum = 8
				if(13)
					if(dir_sum == 29)
						dir_sum = 10
						table_type = 6
					else if(dir_sum == 141)
						dir_sum = 6
						table_type = 6
					else if(dir_sum == 189 || dir_sum == 221 || dir_sum == 253 || dir_sum == 157)
						dir_sum = 1
						table_type = 3
					else
						dir_sum = 1
				if(14)
					if(dir_sum == 46)
						dir_sum = 1
						table_type = 6
					else if(dir_sum == 78)
						dir_sum = 2
						table_type = 6
					else if(dir_sum == 110 || dir_sum == 254 || dir_sum == 238 || dir_sum == 126)
						dir_sum = 2
						table_type = 3
					else
						dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
		if(dir_sum%16 == 15)
			table_type = 4 //4-way intersection, the 'middle' table sprites will be used.
		switch(table_type)
			if(0)
				icon_state = "pokertable"
			if(1)
				icon_state = "pokertable_1tileendtable"
			if(2)
				icon_state = "pokertable_1tilethick"
			if(3)
				icon_state = "pokertable_dir"
			if(4)
				icon_state = "pokertable_middle"
			if(5)
				icon_state = "pokertable_dir2"
			if(6)
				icon_state = "pokertable_dir3"
		if (dir_sum in list(1,2,4,8,5,6,9,10))
			dir = dir_sum
		else
			dir = 2

/obj/structure/table/woodentable/poker //No specialties, Just a mapping object.
	name = "gambling table"
	icon = 'icons/urist/structures&machinery/structures.dmi'
	desc = "A seedy table for seedy dealings in seedy places."
	icon_state = "pokertable"
	parts = /obj/item/weapon/table_parts/wood/poker