// Chemical Labratory Jobs.

// Lab Supervisor - (Security Mix/QM)

/datum/job/submap/chemical_lab_supervisor
	title = "Lab Supervisor"
	total_positions = 1
	outfit_type = /decl/hierachy/outfit/chemical_lab/supervisor
	supervisors = "yourself"
	access = list(access_chemical_lab_worker, access_chemical_lab_supervisor)
	info = "You are the Supervisor of an illict chemical manfucatoring operation, on an asteroid hidden in deep space. Ensure that your workers are safe, \
	and that production runs smoothly. You have been graciously granted multiple wings (Virology, Botany) to assist in chemistry and pathogen production. \
	Be aware of outside interferance, trading with vessels is always welcome, but be aware of potential raiders or looters. \
	Your crew is ultimately expendable, however it is ill-advised to abuse, or kill workers unless your life is threatened. You have been provided a small brig to contain unruley workers, or boarders. \
	In the event of a total labratory loss, you have been provided with an envelope on how to activate the self-destruct system inside of the Vault. Be aware that once this is activated, you have one minute to cancel. \
	Your employers have graciously granted you a one-seater escape vessel, use this only in the event of total loss. Lab Workers are not to know of it's existence, crew who do can be dealt with to your discretion. \
	To the south of the Laboratory in space is a small auxilary tool and construction storage area full of supplies if you wish to fortify or adjust your lab."

// Lab Worker - (Lab Worker)

/datum/job/submap/chemical_lab_worker
	title = "Lab Worker"
	total_positions = 2
	spawn_positions = 2
	supervisors = "lab supervisor"
	outfit_type = /decl/hierachy/outfit/chemical_lab/worker
	access = list(access_chemical_lab_worker)
	info = "You are one of the primary laboratory workers located on a hidden asteroid deep in space. \
	Work together with your team, you have a plethora of reagents to experiment with, including an additional virology and botanical wing. \
	You can find rare and unusual reagents occasionally from your chemical storage.\
	Your Supervisor is in charge of what you are doing, it is unwise to cause issues. \
	Be aware that outside interferance could comprimise your illict operations, be aware of any vessels that intend to board, or destroy your operation. While you are not \
	actively aggressive, you are able to defend your labratory if it is under attack."


/obj/effect/submap_landmark/spawnpoint/supervisor
	name = "Lab Supervisor"

/obj/effect/submap_landmark/spawnpoint/labworker
	name = "Lab Worker"

/decl/hierachy/outfit/chemical_lab
	hierarchy_type = /decl/hierarchy/outfit/job/chemical_lab
	pda_type = /obj/item/modular_computer/pda
	r_pocket = /obj/item/device/radio
	l_eat = /obj/item/device/radio/headset
	r_ear = null

/decl/hierachy/outfit/chemical_lab/worker
	name = CHEMICAL_OUTFIT_JOB_NAME("Lab Worker")
	id_type = /obj/item/weapon/card/id/chemical_lab_worker
	head = /obj/item/clothing/head/biohazardradiationhood
	suit = /obj/item/clothing/suit/biohazardradiation
	gloves = /obj/item/clothing/gloves/biohazard

/decl/hierachy/outfit/chemical_lab/supervisor
	name = CHEMICAL_OUTFIT_JOB_NAME("Lab Supervisor")
	id_type = /obj/item/weapon/card/id/chemical_lab_supervisor
	uniform = /obj/item/clothing/under/urist/
	shoes = /obj/item/clothing/shoes/black
	l_pocket = /obj/item/

