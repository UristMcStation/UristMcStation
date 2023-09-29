#define NETWORK_SUBWYRM "Sub Deck"
#define NETWORK_PRIMWYRM "Primary Deck"
#define NETWORK_COMMAND "Command"
#define NETWORK_HATCHLING "Hatchling"

/datum/map/wyrm/get_network_access(network)
	switch(network)
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_SUBWYRM)
			return access_engine_equip
		if(NETWORK_PRIMWYRM)
			return access_security
	return ..()

/*
/datum/map/wyrm
	station_networks = list(
		NETWORK_SUBWYRM,
		NETWORK_PRIMWYRM,
		NETWORK_COMMAND,
		NETWORK_ENGINEERING,
		NETWORK_MEDICAL,
		NETWORK_RESEARCH,
		NETWORK_MINE,
		NETWORK_ROBOTS,
		NETWORK_SECURITY,
		NETWORK_ALARM_ATMOS,
		NETWORK_ALARM_CAMERA,
		NETWORK_ALARM_FIRE,
		NETWORK_ALARM_MOTION,
		NETWORK_ALARM_POWER,
		NETWORK_HATCHLING,
		NETWORK_THUNDER
	)
*/
//
// Cameras
//

// Networks

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/primdeck
	network = list(NETWORK_PRIMWYRM)

/obj/machinery/camera/network/subdeck
	network = list(NETWORK_SUBWYRM)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/hatchling
	network = list(NETWORK_HATCHLING)

// Motion
/obj/machinery/camera/motion/command
	network = list(NETWORK_COMMAND)

// X-ray
/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

//Special explorer camera
/obj/machinery/camera/network/exploration
	network = list(NETWORK_HATCHLING)

/obj/machinery/telecomms/hub/preset/wyrm
	network = "wyrm"
	autolinkers = list("busWyrm", "serverWyrm", "receiverWyrm", "broadcasterWyrm", "prim_relay", "sub_relay")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/machinery/telecomms/bus/preset_wyrm
	id = "Main Bus"
	network = "wyrm"
	freq_listening = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, PUB_FREQ, SCI_FREQ, SUP_FREQ)
	autolinkers = list("processorWyrm", "busWyrm")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/machinery/telecomms/processor/preset_wyrm
	id = "Main Processor"
	network = "wyrm"
	autolinkers = list("processorWyrm")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/machinery/telecomms/server/presets/wyrm
	id = "Wyrm NAS"
	network = "wyrm"
	freq_listening = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, PUB_FREQ, SCI_FREQ, SUP_FREQ)
	channel_tags = list(
		list(AI_FREQ, "AI Private", "#ff00ff"),
		list(COMM_FREQ, "Command", "#395a9a"),
		list(ENG_FREQ, "Engineering", "#a66300"),
		list(ENT_FREQ, "Entertainment", "#6eaa2c"),
		list(MED_FREQ, "Medical", "#008160"),
		list(PUB_FREQ, "Common", "#008000"),
		list(SCI_FREQ, "Science", "#993399"),
		list(SUP_FREQ, "Supply", "#7f6539")
	)
	autolinkers = list("serverWyrm", "busWyrm")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/machinery/telecomms/broadcaster/preset_wyrm
	id = "Wyrm Broadcaster"
	network = "wyrm"
	autolinkers = list("broadcasterWyrm")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/machinery/telecomms/receiver/preset_wyrm
	id = "Wyrm Receiver"
	network = "wyrm"
	freq_listening = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, PUB_FREQ, SCI_FREQ, SUP_FREQ)
	autolinkers = list("receiverWyrm")
	light_color = "#4b734b"
	light_max_bright = 0.6
	light_outer_range = 4

/obj/structure/closet/secure_closet/engineering_tools
	name = "high-performance tools locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/engineering_tools
	req_access = list(access_engine_equip)

/obj/structure/closet/secure_closet/engineering_tools/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/rcd_ammo = 80, /obj/item/rcd_ammo/large = 20)),
		new/datum/atom_creator/weighted(list(/obj/item/rcd_ammo = 70, /obj/item/rcd_ammo/large = 30)),
		/obj/item/rcd_ammo = 2,
		/obj/item/rcd,
		/obj/item/rpd,
		/obj/item/device/paint_sprayer
	)

/singleton/closet_appearance/secure_closet/engineering_tools
	color = COLOR_TITANIUM
	decals = list(
		"lower_half_solid"
	)
	extra_decals = list(
		"tool" = COLOR_BEASTY_BROWN,
	)

/obj/structure/closet/secure_closet/wyrmresearcher
	name = "researchers' locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/wyrmresearcher
	req_access = list(access_engine_equip)

/obj/structure/closet/secure_closet/wyrmresearcher/WillContain()
	return list(
		/obj/item/clothing/under/rank/scientist/zeng/wyrm,
		/obj/item/clothing/under/rank/research_director/rdalt,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
		/obj/item/clothing/suit/storage/toggle/labcoat/biologist,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/shoes/dress,
		/obj/item/device/scanner/spectrometer,
		/obj/item/device/scanner/plant,
		/obj/item/disk // what was this
	)

/singleton/closet_appearance/secure_closet/wyrmresearcher
	color = COLOR_OFF_WHITE
	decals = list()
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"research" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/wyrmcaptain
	name = "captain's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/command
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/wyrmcaptain/WillContain()
	return list(
		/obj/random/plushie,
		/obj/item/disk/secret_project,
		// /obj/item/gun/energy/capacitor,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/suit/storage/toggle/bomber,
		/obj/item/device/radio/headset/heads/captain,
		// /obj/item/storage/fancy/cigar,
		/obj/item/flame/lighter/zippo/bronze
	)

/obj/structure/closet/secure_closet/wyrmmate
	name = "first mate's locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/command
	req_access = list(access_hop)

/obj/structure/closet/secure_closet/wyrmmate/WillContain()
	return list(
		/obj/item/gun/projectile/revolver,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/accessory/yellow,
		/obj/item/clothing/accessory/blue_clip,
		/obj/item/clothing/accessory/brown,
		/obj/item/clothing/accessory/red,
		/obj/item/clothing/suit/storage/det_trench,
		/obj/item/radio/headset/heads/hop/wyrm,
		/obj/item/modular_computer/tablet/preset/custom_loadout/advanced,
		/obj/random/clipboard
	)

/obj/structure/closet/secure_closet/militia
	name = "militia supplies locker"
	closet_appearance = /singleton/closet_appearance/secure_closet/militia
	req_access = list(access_security)

/obj/structure/closet/secure_closet/militia/WillContain()
	return list(
		/obj/item/gun/energy/gun/secure,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/accessory/armband/bluegold,
		/obj/item/clothing/suit/armor/pcarrier/blue,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/accessory/storage/holster/hip,
		/obj/item/clothing/gloves/thick/duty,
		/obj/item/melee/baton/loaded,
		/obj/item/storage/belt/holster/security
	)

/singleton/closet_appearance/secure_closet/militia
	color = COLOR_GUNMETAL
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BABY_BLUE,
		"security" = COLOR_BABY_BLUE
	)

/obj/structure/closet/secure_closet/wyrmsec
	name = "security officer's locker"
	req_access = list(access_hos)
	closet_appearance = /singleton/closet_appearance/secure_closet/wyrmsec

/obj/structure/closet/secure_closet/wyrmsec/WillContain()
	return list(
		/obj/item/clothing/under/guard/wyrm,
		/obj/item/clothing/suit/armor/pcarrier/blue,
		/obj/item/clothing/accessory/armor_plate/medium,
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/accessory/helmet_cover/blue,
		/obj/item/clothing/accessory/armband/bluegold,
		/obj/item/device/radio/headset/headset_com,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/taperoll/police,
		/obj/item/shield/riot,
		/obj/item/storage/box/flashbangs,
		/obj/item/storage/belt/security,
		/obj/item/device/flash,
		/obj/item/melee/baton/loaded,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/accessory/storage/holster/waist,
		/obj/item/melee/telebaton
	)

/singleton/closet_appearance/secure_closet/wyrmsec
	color = COLOR_GUNMETAL
	decals = list(
		"lower_holes"
	)
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_right_full" = COLOR_GOLD,
		"security" = COLOR_BABY_BLUE
	)

/obj/effect/floor_decal/corner/gold
	name = "gold corner"
	color = COLOR_GOLD

/obj/effect/floor_decal/corner/gold/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/gold/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/gold/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/gold/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/gold/half
	icon_state = "bordercolorhalf"

/obj/effect/floor_decal/corner/gold/mono
	icon_state = "bordercolormonofull"

/obj/effect/floor_decal/corner/gold/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/gold/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/gold/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/gold/bordercee
	icon_state = "bordercolorcee"
