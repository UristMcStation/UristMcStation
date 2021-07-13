/datum/map/nerva
	allowed_jobs = list(/datum/job/captain, /datum/job/firstofficer, /datum/job/hop, /datum/job/seniorscientist, /datum/job/blueshield,
						/datum/job/chef, /datum/job/janitor, /datum/job/assistant,
						/datum/job/qm, /datum/job/cargo_tech,
						/datum/job/chief_engineer, /datum/job/engineer,
						/datum/job/hos, /datum/job/officer,
						/datum/job/cmo, /datum/job/doctor,
						/datum/job/scientist, /datum/job/chaplain,
						/datum/job/mime, /datum/job/clown,
						/datum/job/merchant, /datum/job/stowaway,
						/datum/job/ai, /datum/job/cyborg
						)

//general command

/datum/job/ai
	minimal_player_age = 7

/datum/job/ai/get_description_blurb()
	return "You are the Artifical Intelligence installed to the ICS Nerva. Ensure that you follow all directives specified to you as stated by the lawset you have been designated to follow. You answer to all of the crew, unless your lawset states otherwise. Failure to follow your lawset may result in removal."

/datum/job/cyborg
	minimal_player_age = 0

/datum/job/ai/get_description_blurb()
	return "You are a Cyborg, purposed for use on the ICS Nerva. Ensure that you follow all directives specified to you by your lawset, You answer directly to all crew and the AI, unless you are not slaved to them. Failure to follow your lawset may result in your removal."

/datum/job/blueshield
	title = "Bodyguard"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain, who hired you to protect them. If the captain is not present, follow the chain of command as to who you will be protecting."
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 3
	economic_power = 7
	outfit_type = /decl/hierarchy/outfit/job/bodyguard
	hud_icon = "hudbodyguard"
	access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_ai_upload, access_eva, access_heads, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield, access_teleporter
			            )
	minimal_access = list(access_security, access_sec_doors, access_court, access_forensics_lockers,
			            access_medical, access_engine, access_eva, access_heads, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_construction, access_morgue,
			            access_cargo, access_mailsorting, access_qm, access_lawyer,
			            access_theatre, access_research, access_mining, access_mining_station,
			            access_clown, access_mime, access_RC_announce, access_keycard_auth, access_blueshield, access_teleporter
			            )

// Bodyguard's Job Verb is basically already stated in his supervisor setup.

/datum/job/firstofficer
	title = "First Officer"
	supervisors = "the captain"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#004a7f"
	req_admin_notify = 1
	minimal_player_age = 5
	economic_power = 15
	outfit_type = /decl/hierarchy/outfit/job/nerva/firstofficer
	hud_icon = "hudheadofpersonnel"
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
			            access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
			            access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist, access_seniornt
						)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics, access_lawyer,
			            access_chapel_office, access_library, access_research, access_mining, access_heads_vault, access_mining_station,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition, access_fo, access_teleporter,
			            access_tcomsat, access_engine_equip, access_tech_storage, access_ce, access_external_airlocks, access_atmospherics, access_emergency_storage, access_construction,
			            access_medical, access_medical_equip, access_morgue, access_genetics,
						access_chemistry, access_virology, access_cmo, access_surgery,
						access_robotics, access_research, access_armory, access_hos,
						access_tox, access_tox_storage, access_xenobiology, access_xenoarch, access_psychiatrist, access_seniornt
						)

/datum/job/firstofficer/get_description_blurb()
	return "You are the First Officer, and second in command of the ICS Nerva. As the clear second in command of the ship, your job is to work with the captain to run the ship, and take charge of navigation according to the captain's orders. Moreover, if there is no second officer, your job is also to oversee personnel issues and organize away missions. In the event of combat, your job is to work with the Chief of Security to coordinate the ship's defence."

/datum/job/captain
	supervisors = "yourself, as you are the owner of this ship and the sole arbiter of its destiny. However, be careful not to anger NanoTrasen and the other factions that have set up outposts in this sector, or your own staff for that matter. It could lead to your undoing"
	minimal_player_age = 7
	outfit_type = /decl/hierarchy/outfit/job/nerva/captain
	economic_power = 24

/datum/job/captain/get_description_blurb()
	return "You are the Captain and owner of the ICS Nerva. You are the top dog. Your backstory and destiny is your own to decide, however, you are ultimately responsible for all that happens onboard. Your job is to make sure the that Nerva survives its time in this sector, and turns a profit for you. Delegate to your First Officer, the Second Officer, and your department heads to effectively manage the ship, and listen to and trust their expertise. It might be the difference between life and death. Oh, and watch out for pirates. The ICS Nerva only has a small complement of weapons at first, which can be upgraded at certain stations in the sector. Good luck."

/datum/job/hop
	minimal_player_age = 3
	title = "Second Officer"
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/nerva/secondofficer
	hud_icon = "hudheadofpersonnel"
	access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_cargo, access_hydroponics, access_lawyer, access_bar, access_kitchen,
			            access_chapel_office, access_library, access_research, access_heads_vault,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_sec_doors, access_brig, access_forensics_lockers, access_heads,
			            access_medical, access_engine, access_change_ids, access_ai_upload, access_eva, access_bridge,
			            access_all_personal_lockers, access_maint_tunnels, access_janitor, access_construction, access_morgue,
			            access_crematorium, access_cargo, access_hydroponics, access_lawyer, access_bar, access_kitchen,
			            access_chapel_office, access_library, access_research, access_heads_vault,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/hop/get_description_blurb()
	return "You are the Second Officer, third in command, after the First Officer and the Captain. As the Second Officer, it is your job to oversee personnel issues, which includes managing access, delegating crew grievances, and ensuring the proper upkeep and operation of the ship's recreational and mess facilities. Thus, you are the direct supervisor for the janitorial staff, as well as the culinary and hydroponics staff. As Second Officer, it is also your job to organize and lead awaymissions, and in cases where there is no First Officer present, to pilot the ICS Nerva."

/datum/job/seniorscientist
	minimal_player_age = 2
	department = "Science"
	total_positions = 1
	spawn_positions = 1
	department_flag = SCI
	selection_color = "#ad6bad"
	req_admin_notify = 1
	economic_power = 15
	title = "Senior Scientist"
	supervisors = "the captain and nanotrasen central command."
	hud_icon = "hudresearchdirector"
	outfit_type = /decl/hierarchy/outfit/job/nerva/seniorscientist
	access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_expedition, access_network, access_seniornt,
			 					access_maint_tunnels, access_heads, access_medical, access_ai_upload, access_eva, access_bridge, access_morgue, access_hydroponics,
								access_library, access_research, access_heads_vault, access_RC_announce, access_gateway, access_expedition_shuttle_helm, access_expedition, access_teleporter)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_expedition, access_network, access_seniornt,
			 					access_maint_tunnels, access_heads, access_medical, access_ai_upload, access_eva, access_bridge, access_morgue, access_hydroponics,
								access_library, access_research, access_heads_vault, access_RC_announce, access_gateway, access_expedition_shuttle_helm, access_expedition, access_teleporter)

/datum/job/seniorscientist/get_description_blurb()
	return "You are a well-respected Senior Scientist working for Nanotrasen's interests. It is your job to manage your science team to ensure that Nanotrasen's research advances. You answer directly to the Captain and Nanotrasen Central Command, which you can fax directly."

//eng

/datum/job/chief_engineer
	minimal_player_age = 1
	supervisors = "the captain and the first officer."
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_heads,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_bridge, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/chief_engineer/get_description_blurb()
	return	"You are the Chief Engineer, as the Chief Engineer, it is your job to oversee the Engineering Staff to ensure that all elements of engineering are being performed safely. This includes overseeing the supermatter's power generation, ensuring all atmospheric flown through the air are not contaminated, stopping possible fires from occuring and forwarding engineer supply requests to the Cargo Team. Thus, you are a direct supervivor for the Engineering Staff, ensure that all of your staff are well-organized and know what tasks to work on, as you may be held responsible for catastrophic damage from engine-failure and gas leaks. You answer directly to the Captain and the First Officer, remember that in the event of a Supermatter explosion, you can eject the crystal to space and that your suit is completley fire proof to assist in stopping fires."


/datum/job/engineer
	minimal_player_age = 0
	total_positions = 5
	spawn_positions = 3

/datum/job/engineer/get_description_blurb()
	return	"You are part of the Engineering Team aboard the ICS Nerva. As an Engineer, it is your job to ensure the ICS Nerva has fully operational power, thrust for flight and air to breathe. Ensure that the Supermatter Crystal is fully operational to generate power and that sufficent gas is used for thrust. You are directly responsible for the Ship's well-being, this includes fixing interior and exterior breaches caused by damage, firefighting from gas leaks and optimizing machines to function to their fullest. You answer directly to the Chief Engineer. Remember to always help your engineers."


//cargo

/datum/job/qm
	minimal_player_age = 1
	economic_power = 9
	total_positions = 1
	spawn_positions = 1
	department_flag = COM|SUP
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/nerva/qm
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research, access_teleporter,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research, access_teleporter,
	access_RC_announce, access_keycard_auth, access_heads, access_eva, access_bridge)

/datum/job/qm/get_description_blurb()
	return	"You are the Quartermaster. As the Quartermaster, it is your job to oversee and delegate your Supply Staff, which may include managing research & development, exporting and importing goods, sending teams to away-missions, salvaging and mining and arming the ICS Nerva if attacks occur. As Quartermaster, it is your job to discuss with the Second Officer organizing awaymissions and to prevent supply crew from manufactoring dangerous arms without direct permission."

/datum/job/cargo_tech
	minimal_player_age = 0
	economic_power = 4
	title = "Supply Technician"
	supervisors = "the quartermaster"
	alt_titles = list("Cargo Technician", "Resource Technician", "Fabrication Technician", "Salvage Technician",
	"Roboticist" = /decl/hierarchy/outfit/job/science/nervaroboticist)
	total_positions = 6 //because we're replacing science
	spawn_positions = 4
	hud_icon = "hudcargotechnician"
	outfit_type = /decl/hierarchy/outfit/job/nerva/supplytech
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station,
	access_expedition_shuttle_helm, access_expedition, access_robotics, access_research)

/datum/job/cargo_tech/get_description_blurb()
	return	"You are part of the Supply Department on the ICS Nerva. As part of the Supply Team, it is your job to obtain any shipped crates ordered from nearby stations by your Quartermaster, conduct away-missions with approval, salvage derelict stations and vessels for materials/artifacts to sell, conduct R&D work and mine for minerals at nearby Asteroid Belts. You answer directly to the Quartermaster, ensure that you do not use the R&D and Autolathes as a way to manufacture firearms for personal use, as this may lead to dismissal. Remember to pack radio equipment, suitable internals and EVA equipment when conducting salvage, mining and away-missions."

//medbay

/datum/job/cmo
	minimal_player_age = 1
	supervisors = "the captain and the first officer."
	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_bridge, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_maint_tunnels, access_external_airlocks,
			access_expedition_shuttle_helm, access_expedition)

/datum/job/cmo/get_description_blurb()
	return	"You are the Chief Medical Officer onboard the ICS Nerva. As Chief Medical Officer, it is your job to oversee your medical staff to ensuring they successfully treat all injured crew, provide surgery for injured crew, produce and mandate chemicals used for medicine and ensure all deceased crew are relaced. Thus, you are the direct supervisor for medical staff, and may be held responsible for their malpractice. As Chief Medical Officer, it is also your job to delegate the medical team to respond to injured crew in specific areas, send medical doctors to away missions to provide medical care and to cure any biological contaminant that may come onboard. You answer directly to the Captain and the First Officer."

/datum/job/doctor
	minimal_player_age = 0
	access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_maint_tunnels)
	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics, access_maint_tunnels)
	alt_titles = list("Chemist" = /decl/hierarchy/outfit/job/medical/doctor/chemist,
		"Surgeon" = /decl/hierarchy/outfit/job/medical/doctor/surgeon,
		"Emergency Physician" = /decl/hierarchy/outfit/job/medical/doctor/emergency_physician,
		)
/datum/job/doctor/get_description_blurb()
	return	"You are a doctor on board the ICS Nerva, as a Doctor, it is within job to ensure all crew remain healthy, this may involve scanning paitents in the bodyscanners to find internal injuries, perform medical surgery to fix ailemtns, produce beneficial medicine to assist the crew and provide and seek out critically injured crew. As a Medical Doctor, ensure that you follow surgical procedures correctly to avoid malpractice, and to remind crew to set their lifesign sensors to maximum. You may be requested to accompany Away Missions, or other expeditions to ensure away-team safety. You answer directly to the Chief Medical Officer. If any paitent dies, remember to always remove the neural lace of the deceased crewmember and replace their body using the cloner and attach the new lace to revive them."
//sec

/datum/job/hos
	minimal_player_age = 5
	title = "Chief of Security"
	supervisors = "the captain and the first officer."
	outfit_type = /decl/hierarchy/outfit/job/security/nervacos
	hud_icon = "hudheadofsecurity"
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
			            access_expedition_shuttle_helm, access_expedition)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_heads,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_bridge, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
			            access_expedition_shuttle_helm, access_expedition)

/datum/job/hos/get_description_blurb()
	return	"You are the Chief of Security, as the Chief of Security, it is your job to oversee your Security team to ensure they follow the correct procedures when responding to arrests and threats, managing and overseeing brigging, ensuring all crew present are held on the manifest. Thus, you are held accountable of the Security Team's actions. As the Chief of Security, it is also your job to arrest criminals, assist officers in distress, organize and speak with Command Staff about away-teams and out-bound communications and in cases in which there are no command staff present, act as Acting Captain. You answer directly to the Captain and the First Officer, remember to follow the specified law guidelines and avoid putting yourself in danger when you are on your own."

/datum/job/officer
	minimal_player_age = 0
	supervisors = "the chief of security."
	alt_titles = list("Detective")
	outfit_type = /decl/hierarchy/outfit/job/security/nervasecofficer
	access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_expedition, access_expedition_shuttle_helm, access_medical, access_hydroponics)
	minimal_access = list(access_security, access_forensics_lockers, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks, access_expedition, access_expedition_shuttle_helm)

/datum/job/officer/get_description_blurb()
	return	"You are part of the Security Department, ensuring the protection of the crew from danger during the voyage of the ICS Nerva. It is your job to oversee and protect your crew, which includes reporting threats, making arrests while following set law guidelines, collecting evidence to aid arrests and cataloging evidence. Ensure that you only use lethal weaponry when there is a credible threat to your life, or you may suffer repercussions and dismissal. You answer directly to the Chief of Security."
//sci

/datum/job/scientist
	minimal_player_age = 0
	title = "NanoTrasen Scientist"
	alt_titles = list("NanoTrasen Xenobiologist", "NanoTrasen Anomalist", "NanoTrasen Xenobotanist")
	supervisors = "NanoTrasen Central Command and the captain."
	total_positions = 3
	spawn_positions = 3
	hud_icon = "hudblueshield"
	outfit_type = /decl/hierarchy/outfit/job/nerva/scientist
	access = list(access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch, access_expedition, access_network, access_maint_tunnels)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_xenobiology, access_expedition, access_network, access_maint_tunnels)

/datum/job/scientist/get_description_blurb()
	return	"You are a NanoTrasen scientist, working aboard the ICS Nerva under contract. The captain has provided space on the ship for you to do research, in exchange for a nice payout from NanoTrasen, and access to NanoTrasen research contracts. This unique arrangement is owing to NanoTrasen's weak position in the outer sectors. Thus, you are not fully part of the Nerva's crew, and answer to NanoTrasen Central Command above all else. However, while on the ship, you are expected to answer to the captain or the ranking officer."

//misc

/datum/job/assistant
	alt_titles = list(
	"Technical Assistant","Medical Intern","Cargo Assistant",
	"Botanist" = /decl/hierarchy/outfit/job/service/gardener,
	"Librarian" = /decl/hierarchy/outfit/job/librarian,
	"Journalist" = /decl/hierarchy/outfit/job/librarian
	)

/datum/job/assistant/get_description_blurb()
	return	"You are an Assistant onboard the ICS Nerva. Try to assist your assigned department to the best of your abilities and avoid getting into trouble. Remember that you can ask the Second Officer if you would like to be assigned a new role."

/datum/job/chef
	economic_power = 3
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics, access_bar, access_kitchen)
	alt_titles = list("Bartender" = /decl/hierarchy/outfit/job/service/nervabartender)
	supervisors = "the second officer."
	minimal_player_age = 0

/datum/job/chef/get_description_blurb()
	return	"You are part of the culinary staff aboard the ICS Nerva. It is your job to provide the crew with food, serve alcoholic and non-alcoholic beverages, cooking both exotic and non-exotic meals and ensuring that no fighting occurs in the bar. You answer directly to the Second Officer. Remember to only use your shotgun if a serious fight occurs and avoid serving spiked food or drinks to your customers, or you may face reprecussions."


/datum/job/janitor
	economic_power = 2
	title = "Janitor"
	supervisors = "the second officer."
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 0
	access = list(access_maint_tunnels, access_bar, access_janitor, access_medical, access_mailsorting, access_hydroponics, access_library)


/datum/job/janitor/get_description_blurb()
	return "You are the Janitor aboard the ICS Nerva. It is your job to clean this vessel from top to bottom. This may include mopping, dealing with pest problems, fixing plumbing and ensuring all trash is disposed of. You answer directly to the Second Officer."

/datum/job/chaplain
	minimal_player_age = 0
	economic_power = 4
	title = "Chaplain"
	department = "Medical"
	department_flag = MED|CIV
	hud_icon = "hudchaplain"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer and the chief medical officer"
	access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	minimal_access = list(access_medical, access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels, access_psychiatrist)
	alt_titles = list(
	"Counselor" = /decl/hierarchy/outfit/job/medical/psychiatrist/nerva,
	"Morale Officer" = /decl/hierarchy/outfit/job/chaplain,
	"Psychiatrist" = /decl/hierarchy/outfit/job/medical/psychiatrist/nerva,
	"Psychologist" = /decl/hierarchy/outfit/job/medical/psychiatrist/psychologist/nerva)


	outfit_type = /decl/hierarchy/outfit/job/chaplain

// Chaplain can't really have a job blurb as he has medical and civvie roles.

/datum/job/merchant
	total_positions = 0
	spawn_positions = 0

/datum/job/stowaway
	title = "Stowaway"
	department = "Civilian"
	department_flag = CIV
	hud_icon = "hudunknown"
	total_positions = 1
	spawn_positions = 1
	availablity_chance = 15
	supervisors = "yourself"
	selection_color = "#515151"
	ideal_character_age = 30
	minimal_player_age = 0
	create_record = 0
	account_allowed = 0
	outfit_type = /decl/hierarchy/outfit/job/nerva/stowaway
	latejoin_at_spawnpoints = 1
	announced = FALSE

/datum/job/stowaway/get_description_blurb()
	return	"Survive."

//vox
/datum/map/nerva
	species_to_job_whitelist = list(
		/datum/species/vox = list(/datum/job/ai, /datum/job/cyborg, /datum/job/merchant, /datum/job/stowaway)
	)

//Mime

/datum/job/mime
	title = "Mime"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_theatre)
	minimal_player_age = 0
	outfit_type = /decl/hierarchy/outfit/job/mime

/* //This hasn't worked for a while,
/datum/job/mime/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.miming = 1
		H.verbs += /client/proc/mimespeak
		H.verbs += /client/proc/mimewall
		H.mind.special_verbs += /client/proc/mimespeak
		H.mind.special_verbs += /client/proc/mimewall
*/

/datum/job/mime/get_description_blurb()
	return	"-- .. -- . / -- --- - .... . .-. / ... .... .- .-.. .-.. / ... .- ...- . / ..- ... / .- .-.. .-.. -.-.--"
//Clown :^)

/datum/job/clown
	title = "Clown"
	department = "Civilian"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the second officer"
	selection_color = "#515151"
	access = list(access_maint_tunnels, access_theatre)
	minimal_player_age = 1
	outfit_type = /decl/hierarchy/outfit/job/clown

/datum/job/clown/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.mutations.Add(MUTATION_CLUMSY)


/datum/job/clown/get_description_blurb()
	return	"You are the Clown aboard the ICS Nerva, try your best to entertain the crew. You could answer to the Second Officer, but who would do that?"
