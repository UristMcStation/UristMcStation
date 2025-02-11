// ### Preset machines  ###

//HUB

/obj/machinery/telecomms/hub/map_preset
	var/preset_name

/obj/machinery/telecomms/hub/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Hub"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_broadcaster",
			"[name_lower]_hub",
			"[name_lower]_receiver",
			"[name_lower]_relay",
			"[name_lower]_server"
		)
	. = ..()

/obj/machinery/telecomms/hub/preset
	id = "Hub"
	network = "tcommsat"
	autolinkers = list("hub", "relay", "c_relay", "s_relay", "m_relay", "r_relay", "b_relay", "1_relay", "2_relay", "3_relay", "4_relay", "5_relay", "s_relay", "science", "medical",
	"supply", "service", "common", "command", "engineering", "security", "receiverA", "broadcasterA")

/obj/machinery/telecomms/hub/preset_cent
	id = "CentComm Hub"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("hub_cent", "c_relay", "s_relay", "m_relay", "r_relay", "s1_relay", "s2_relay",
	 "centcomm", "receiverCent", "broadcasterCent")

/obj/machinery/telecomms/hub/preset/wyrm
	autolinkers = list("busWyrm", "serverWyrm", "receiverWyrm", "broadcasterWyrm", "prim_relay", "sub_relay")

/obj/machinery/telecomms/hub/preset/nerva
	autolinkers = list("busNerva", "serverNerva", "receiverNerva", "broadcasterNerva", "1_relay", "2_relay", "3_relay","4_relay", "Relay-PSR")

//Receivers

/obj/machinery/telecomms/receiver/map_preset
	var/preset_name
	var/use_common = FALSE

/obj/machinery/telecomms/receiver/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Receiver"
		network = "tcomm_[name_lower]"
		freq_listening += list(assign_away_freq(preset_name), HAIL_FREQ)
		if (use_common)
			freq_listening += PUB_FREQ
		autolinkers = list(
			"[name_lower]_receiver"
		)
	. = ..()

/obj/machinery/telecomms/receiver/preset_right
	id = "Receiver A"
	network = "tcommsat"
	autolinkers = list("receiverA") // link to relay
	freq_listening = list(AI_FREQ, SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, COMM_FREQ, ENG_FREQ, SEC_FREQ, ENT_FREQ, HAIL_FREQ)

	//Common and other radio frequencies for people to freely use
/obj/machinery/telecomms/receiver/preset_right/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		freq_listening |= i
	..()

/obj/machinery/telecomms/receiver/preset_cent
	id = "CentComm Receiver"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("receiverCent")
	freq_listening = list(ERT_FREQ, DTH_FREQ)

/obj/machinery/telecomms/receiver/preset_wyrm
	id = "Wyrm Receiver"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, SEC_FREQ, COMM_FREQ, ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ)
	autolinkers = list("receiverWyrm")

/obj/machinery/telecomms/receiver/preset_nerva
	id = "Nerva Receiver"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, SEC_FREQ, COMM_FREQ, ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ, COMB_FREQ)
	autolinkers = list("receiverNerva")

//Buses

/obj/machinery/telecomms/bus/map_preset
	var/preset_name
	var/use_common = FALSE

/obj/machinery/telecomms/bus/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Bus"
		network = "tcomm_[name_lower]"
		freq_listening += list(assign_away_freq(preset_name), HAIL_FREQ)
		if (use_common)
			freq_listening += PUB_FREQ
		autolinkers = list(
			"[name_lower]_processor",
			"[name_lower]_server"
		)
	. = ..()

/obj/machinery/telecomms/bus/preset_one
	id = "Bus 1"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ)
	autolinkers = list("processor1", "science", "medical")

/obj/machinery/telecomms/bus/preset_two
	id = "Bus 2"
	network = "tcommsat"
	freq_listening = list(SUP_FREQ, SRV_FREQ)
	autolinkers = list("processor2", "supply", "service")

/obj/machinery/telecomms/bus/preset_three
	id = "Bus 3"
	network = "tcommsat"
	freq_listening = list(SEC_FREQ, COMM_FREQ)
	autolinkers = list("processor3", "security", "command")

/obj/machinery/telecomms/bus/preset_four
	id = "Bus 4"
	network = "tcommsat"
	freq_listening = list(ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ, HAIL_FREQ)
	autolinkers = list("processor4", "engineering", "common")

/obj/machinery/telecomms/bus/preset_four/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ || i == MED_I_FREQ || i == SEC_I_FREQ || i == HAIL_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/bus/preset_cent
	id = "CentComm Bus"
	network = "tcommsat"
	freq_listening = list(ERT_FREQ, DTH_FREQ, ENT_FREQ)
	produces_heat = 0
	autolinkers = list("processorCent", "centcomm")

/obj/machinery/telecomms/bus/preset_wyrm
	id = "Main Bus"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, SEC_FREQ, COMM_FREQ, ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ)
	autolinkers = list("processorWyrm", "busWyrm")

/obj/machinery/telecomms/bus/preset_nerva
	id = "Main Bus"
	network = "tcommsat"
	freq_listening = list(SCI_FREQ, MED_FREQ, SUP_FREQ, SRV_FREQ, SEC_FREQ, COMM_FREQ, ENG_FREQ, AI_FREQ, PUB_FREQ, ENT_FREQ, COMB_FREQ)
	autolinkers = list("processorNerva", "busNerva")

//Processors

/obj/machinery/telecomms/processor/map_preset
	var/preset_name

/obj/machinery/telecomms/processor/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Processor"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_processor"
		)
	. = ..()

/obj/machinery/telecomms/processor/preset_one
	id = "Processor 1"
	network = "tcommsat"
	autolinkers = list("processor1") // processors are sort of isolated; they don't need backward links

/obj/machinery/telecomms/processor/preset_two
	id = "Processor 2"
	network = "tcommsat"
	autolinkers = list("processor2")

/obj/machinery/telecomms/processor/preset_three
	id = "Processor 3"
	network = "tcommsat"
	autolinkers = list("processor3")

/obj/machinery/telecomms/processor/preset_four
	id = "Processor 4"
	network = "tcommsat"
	autolinkers = list("processor4")

/obj/machinery/telecomms/processor/preset_cent
	id = "CentComm Processor"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("processorCent")

/obj/machinery/telecomms/processor/preset_wyrm
	id = "Main Processor"
	network = "tcommsat"
	autolinkers = list("processorWyrm")

/obj/machinery/telecomms/processor/preset_nerva
	id = "Main Processor"
	network = "tcommsat"
	autolinkers = list("processorNerva")

//Servers

/obj/machinery/telecomms/server/map_preset
	var/preset_name
	var/preset_color = COMMS_COLOR_DEFAULT
	var/use_common = FALSE

/obj/machinery/telecomms/server/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Server"
		network = "tcomm_[name_lower]"
		freq_listening += list(
			assign_away_freq(preset_name),
			HAIL_FREQ
		)
		channel_tags += list(
			list(assign_away_freq(preset_name), preset_name, preset_color),
			list(HAIL_FREQ, "Hailing", COMMS_COLOR_HAILING)
		)
		if (use_common)
			freq_listening += PUB_FREQ
			channel_tags += list(list(PUB_FREQ, "Common", COMMS_COLOR_COMMON))
		autolinkers = list(
			"[name_lower]_server"
		)
	. = ..()

/obj/machinery/telecomms/server/presets

	network = "tcommsat"

/obj/machinery/telecomms/server/presets/science
	id = "Science Server"
	freq_listening = list(SCI_FREQ)
	channel_tags = list(list(SCI_FREQ, "Science", COMMS_COLOR_SCIENCE))
	autolinkers = list("science")

/obj/machinery/telecomms/server/presets/medical
	id = "Medical Server"
	freq_listening = list(MED_FREQ)
	channel_tags = list(list(MED_FREQ, "Medical", COMMS_COLOR_MEDICAL))
	autolinkers = list("medical")

/obj/machinery/telecomms/server/presets/supply
	id = "Supply Server"
	freq_listening = list(SUP_FREQ)
	channel_tags = list(list(SUP_FREQ, "Supply", COMMS_COLOR_SUPPLY))
	autolinkers = list("supply")

/obj/machinery/telecomms/server/presets/service
	id = "Service Server"
	freq_listening = list(SRV_FREQ)
	channel_tags = list(list(SRV_FREQ, "Service", COMMS_COLOR_SERVICE))
	autolinkers = list("service")

/obj/machinery/telecomms/server/presets/common
	id = "Common Server"
	freq_listening = list(PUB_FREQ, AI_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ, HAIL_FREQ) // AI Private, Common, and Departmental Intercomms
	channel_tags = list(
		list(PUB_FREQ, "Common", COMMS_COLOR_COMMON),
		list(AI_FREQ, "AI Private", COMMS_COLOR_AI),
		list(ENT_FREQ, "Entertainment", COMMS_COLOR_ENTERTAIN),
		list(MED_I_FREQ, "Medical (I)", COMMS_COLOR_MEDICAL_I),
		list(SEC_I_FREQ, "Security (I)", COMMS_COLOR_SECURITY_I),
		list(HAIL_FREQ, "Hailing", COMMS_COLOR_HAILING)
	)
	autolinkers = list("common")

// "Unused" channels, AKA all others.
/obj/machinery/telecomms/server/presets/common/New()
	for(var/i = PUBLIC_LOW_FREQ, i < PUBLIC_HIGH_FREQ, i += 2)
		if(i == AI_FREQ || i == PUB_FREQ || i == MED_I_FREQ || i == SEC_I_FREQ || i == HAIL_FREQ)
			continue
		freq_listening |= i
	..()

/obj/machinery/telecomms/server/presets/command
	id = "Command Server"
	freq_listening = list(COMM_FREQ)
	channel_tags = list(list(COMM_FREQ, "Command", COMMS_COLOR_COMMAND))
	autolinkers = list("command")

/obj/machinery/telecomms/server/presets/engineering
	id = "Engineering Server"
	freq_listening = list(ENG_FREQ)
	channel_tags = list(list(ENG_FREQ, "Engineering", COMMS_COLOR_ENGINEER))
	autolinkers = list("engineering")

/obj/machinery/telecomms/server/presets/security
	id = "Security Server"
	freq_listening = list(SEC_FREQ)
	channel_tags = list(list(SEC_FREQ, "Security", COMMS_COLOR_SECURITY))
	autolinkers = list("security")

/obj/machinery/telecomms/server/presets/centcomm
	id = "CentComm Server"
	freq_listening = list(ERT_FREQ, DTH_FREQ)
	channel_tags = list(list(ERT_FREQ, "Response Team", COMMS_COLOR_CENTCOMM), list(DTH_FREQ, "Special Ops", COMMS_COLOR_SYNDICATE))
	produces_heat = 0
	autolinkers = list("centcomm")

/obj/machinery/telecomms/server/presets/wyrm
	id = "Wyrm NAS"
	freq_listening = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, PUB_FREQ, SCI_FREQ, SEC_FREQ, SRV_FREQ, SUP_FREQ)
	channel_tags = list(
		list(AI_FREQ, "AI Private", "#ff00ff"),
		list(COMM_FREQ, "Command", "#395a9a"),
		list(ENG_FREQ, "Engineering", "#a66300"),
		list(ENT_FREQ, "Entertainment", "#6eaa2c"),
		list(MED_FREQ, "Medical", "#008160"),
		list(PUB_FREQ, "Common", "#008000"),
		list(SCI_FREQ, "Science", "#993399"),
		list(SEC_FREQ, "Security", "#a30000"),
		list(SRV_FREQ, "Service", "#6eaa2c"),
		list(SUP_FREQ, "Supply", "#7f6539")
	)
	autolinkers = list("serverWyrm", "busWyrm")

/obj/machinery/telecomms/server/presets/nerva //the same, but with combat
	id = "Nerva Server"
	freq_listening = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, PUB_FREQ, SCI_FREQ, SEC_FREQ, SRV_FREQ, SUP_FREQ, COMB_FREQ)
	channel_tags = list(
		list(AI_FREQ, "AI Private", "#ff00ff"),
		list(COMM_FREQ, "Command", "#395a9a"),
		list(ENG_FREQ, "Engineering", "#a66300"),
		list(ENT_FREQ, "Entertainment", "#6eaa2c"),
		list(MED_FREQ, "Medical", "#008160"),
		list(PUB_FREQ, "Common", "#008000"),
		list(SCI_FREQ, "Science", "#993399"),
		list(SEC_FREQ, "Security", "#a30000"),
		list(SRV_FREQ, "Service", "#6eaa2c"),
		list(SUP_FREQ, "Supply", "#7f6539"),
		list(COMB_FREQ, "Combat", "#db135c"), //pank
	)
	autolinkers = list("serverNerva", "busNerva")

//Broadcasters

//--PRESET LEFT--//

/obj/machinery/telecomms/broadcaster/map_preset
	var/preset_name

/obj/machinery/telecomms/broadcaster/map_preset/Initialize()
	if (preset_name)
		var/name_lower = replacetext(lowertext(preset_name), " ", "_")
		id = "[preset_name] Broadcaster"
		network = "tcomm_[name_lower]"
		autolinkers = list(
			"[name_lower]_broadcaster"
		)
	. = ..()

/obj/machinery/telecomms/broadcaster/preset_right
	id = "Broadcaster A"
	network = "tcommsat"
	autolinkers = list("broadcasterA")

/obj/machinery/telecomms/broadcaster/preset_cent
	id = "CentComm Broadcaster"
	network = "tcommsat"
	produces_heat = 0
	autolinkers = list("broadcasterCent")

/obj/machinery/telecomms/broadcaster/preset_wyrm
	id = "Wyrm Broadcaster"
	network = "tcommsat"
	autolinkers = list("broadcasterWyrm")

/obj/machinery/telecomms/broadcaster/preset_nerva
	id = "Nerva Broadcaster"
	network = "tcommsat"
	autolinkers = list("broadcasterNerva")

	//Relay

/obj/machinery/telecomms/relay/preset
	network = "tcommsat"
//	circuitboard = /obj/item/stock_parts/circuitboard/tcomms_relay

/obj/machinery/telecomms/relay/preset/station
	id = "Primary Relay"
	autolinkers = list("s_relay")

/obj/machinery/telecomms/relay/preset/station/Initialize()
	listening_levels = GLOB.using_map.contact_levels
	return ..()

/obj/machinery/telecomms/relay/preset/telecomms
	id = "Telecomms Relay"
	autolinkers = list("relay")

/obj/machinery/telecomms/relay/preset/mining
	id = "Mining Relay"
	autolinkers = list("m_relay")

/obj/machinery/telecomms/relay/preset/bridge
	id = "Bridge Relay"
	autolinkers = list("b_relay")

/obj/machinery/telecomms/relay/preset/firstdeck
	id = "First Deck Relay"
	autolinkers = list("1_relay")

/obj/machinery/telecomms/relay/preset/seconddeck
	id = "Second Deck Relay"
	autolinkers = list("2_relay")

/obj/machinery/telecomms/relay/preset/thirddeck
	id = "Third Deck Relay"
	autolinkers = list("3_relay")

/obj/machinery/telecomms/relay/preset/fourthdeck
	id = "Fourth Deck Relay"
	autolinkers = list("4_relay")

/obj/machinery/telecomms/relay/preset/fifthdeck
	id = "Fifth Deck Relay"
	autolinkers = list("5_relay")

/obj/machinery/telecomms/relay/preset/ruskie
	id = "Ruskie Relay"
	hide = 1
	toggled = 0
	autolinkers = list("r_relay")

/obj/machinery/telecomms/relay/preset/centcom
	id = "Centcom Relay"
	hide = 1
	toggled = 1
	produces_heat = 0
	autolinkers = list("c_relay")

/obj/machinery/telecomms/relay/preset/wyrm_prim
	id = "Primary Deck Relay"
	autolinkers = list("prim_relay")

/obj/machinery/telecomms/relay/preset/wyrm_sub
	id = "Sub Deck Relay"
	autolinkers = list("sub_relay")

/obj/machinery/telecomms/relay/preset/department_level
	id = "Departmental Level Relay"
	autolinkers = list("dep_relay")

/obj/machinery/telecomms/relay/preset/construction_level
	id = "Construction Level Relay"
	autolinkers = list("con_relay")

/obj/machinery/telecomms/relay/preset/supply_level
	id = "Supply Level Relay"
	autolinkers = list("sup_relay")
