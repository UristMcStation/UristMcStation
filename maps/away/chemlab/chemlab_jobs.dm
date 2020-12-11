// Chem Lab Jobs //

// Lab Supervisor - (HoS/Security, with less space law.)
/datum/job/submap/chemlab_supervisor
	title = "Lab Supervisor"
	total_positions = 1
	outfit_type = /decl/hierarchy/outfit/job/chemlab/supervisor
	supervisors = "yourself"
	info = "To pay back your dues, you have been tasked to maintain a watchful eye on one of the main labratories of the Sleeping Carp Cartel.\
	Ensure that your underlings continue to experiment and produce dangerous chemicals and narcotics, be aware of any ships in the sector \
	and remember to treat your underlings well, or you may pay dearly. Should you feel that the labratory is going to be lost to hostiles \
	you can activate the self-destruct device found in the Vault, be aware that this has a one minute window to be deactivated, crew expendable."

// Lab Workers - (Voluntary Lab Work, right?)
/datum/job/submap/chemlab_labworker
	title = "Lab Worker"
	supervisors = "the supervisor"
	total_positions = 2
	outfit_type = /decl/hierarchy/outfit/job/chemlab/lab
	info = "You are one of the main lab workers tasked with producing dangerous chemicals and narcotics for the Sleeping Carp Cartel. \
	Work together with your labratory team and be aware of any ships that could try to loot, or attack you. You will have a plethora\
	of small department wings to experiment with, and a large stockpile of chemicals, you can also try to sell produce on the trading console.\
	Checking your chemical storage sector may let you use rare and unusual chemicals, not commonly found or available in a dispensor, be careful."


/* Outfits

/decl/hierarchy/outfit/job/chemlab
	hierarchy_type = /decl/hierarchy/outfit/job/chemlab
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store
	r_pocket = /obj/item/device/radio
	l_ear = null
	r_ear = null

/decl/hierarchy/outfit/job/chemlab/worker
	name = CHEMLAB_OUTFIT_JOB_NAME("Worker")
	id_type = /obj/item/weapon/card/id/chemlab

/decl/hierarchy/outfit/job/chemlab/supervisor
//	name = CHEMLAB_OUTFIT_JOB_NAME("Supervisor")
	shoes = /obj/item/clothing/shoes/black
	id_type = /obj/item/weapon/card/id/chemlab_supervisor

*/ //Spawnpoint Markers

/obj/effect/submap_landmark/spawnpoint/supervisor
	name = "Lab Supervisor"

/obj/effect/submap_landmark/spawnpoint/labworker
	name = "Lab Worker"
