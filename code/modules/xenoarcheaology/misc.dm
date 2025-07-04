/obj/structure/bookcase/manuals/xenoarchaeology
	name = "Xenoarchaeology Manuals bookcase"

/obj/structure/bookcase/manuals/xenoarchaeology/New()
	..()
	new /obj/item/book/manual/excavation(src)
	new /obj/item/book/manual/mass_spectrometry(src)
	new /obj/item/book/manual/materials_chemistry_analysis(src)
	new /obj/item/book/manual/anomaly_testing(src)
	new /obj/item/book/manual/anomaly_spectroscopy(src)
	new /obj/item/book/manual/stasis(src)
	update_icon()

/obj/structure/closet/secure_closet/xenoarchaeologist
	name = "Xenoarchaeologist Locker"
	icon = 'icons/urist/restored/closet.dmi'
	req_access = list(access_xenoarch)
	closet_appearance = /singleton/closet_appearance/secure_closet/expedition/science

/obj/structure/closet/secure_closet/xenoarchaeologist/New()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/corpsci(src)
	else
		new /obj/item/storage/backpack/satchel/corpsci(src)
	if(prob(50))
		new /obj/item/storage/backpack/dufflebag(src)
	new /obj/item/clothing/under/rank/scientist(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/glasses/science(src)
	new /obj/item/device/radio/headset/headset_sci(src)
	new /obj/item/clothing/mask/gas(src)
	new /obj/item/material/folder/clipboard(src)
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/excavation(src)
	new /obj/item/taperoll/research(src)

/obj/structure/closet/excavation
	name = "excavation tools"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering/tools

/obj/structure/closet/excavation/New()
	..()
	new /obj/item/storage/belt/archaeology(src)
	new /obj/item/storage/excavation(src)
	new /obj/item/device/flashlight/lantern(src)
	new /obj/item/device/ano_scanner(src)
	new /obj/item/device/depth_scanner(src)
	new /obj/item/device/core_sampler(src)
	new /obj/item/device/gps(src)
	new /obj/item/pinpointer/radio(src)
	new /obj/item/clothing/glasses/meson(src)
	new /obj/item/pickaxe(src)
	new /obj/item/device/measuring_tape(src)
	new /obj/item/pickaxe/xeno/hand(src)
	new /obj/item/storage/bag/fossils(src)
	new /obj/item/hand_labeler(src)
	new /obj/item/taperoll/research(src)

/obj/machinery/alarm/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))

/obj/machinery/alarm/monitor/isolation
	req_access = list(list(access_research, access_atmospherics, access_engine_equip))
