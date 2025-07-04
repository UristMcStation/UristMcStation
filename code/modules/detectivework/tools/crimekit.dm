//crime scene kit
/obj/item/storage/briefcase/crimekit
	name = "crime scene kit"
	desc = "A stainless steel-plated carrycase for all your forensic needs. Feels heavy."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"
	item_state = "case"
	slot_flags = SLOT_BELT
	startswith = list(
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/fingerprints,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/device/uv_light,
		/obj/item/forensics/sample_kit,
		/obj/item/forensics/sample_kit/powder,
		/obj/item/storage/csi_markers
	)
	contents_allowed = list(
		/obj/item/storage/box/swabs,
		/obj/item/storage/box/fingerprints,
		/obj/item/storage/box/evidence,
		/obj/item/reagent_containers/spray/luminol,
		/obj/item/device/uv_light,
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/forensics/swab,
		/obj/item/sample/print,
		/obj/item/sample/fibers,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/clothing/gloves,
		/obj/item/material/folder,
		/obj/item/paper,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/forensics/sample_kit,
		/obj/item/device/camera,
		/obj/item/device/taperecorder,
		/obj/item/device/tape,
		/obj/item/storage/csi_markers,
		/obj/item/device/scanner,
		/obj/item/modular_computer/tablet,
		/obj/item/evidencebag,
		/obj/item/taperoll,
		/obj/item/device/camera_film,
		/datum/uplink_item/item/tools/ductape,
		/obj/item/reagent_containers/food/drinks/flask
	)
