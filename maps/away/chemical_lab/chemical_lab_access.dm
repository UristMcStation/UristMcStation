// Chemical Labratory Access + IDs.
/var/const/access_chemical_lab_worker = "ACCESS_CHEMICAL_LAB_WORKER"
/datum/access/chemical_lab_worker
	id = access_chemical_lab_worker
	desc = "Chemical Lab Worker"
	region = ACCESS_REGION_NONE

/var/const/access_chemical_lab_supervisor = "ACCESS_CHEMICAL_LAB_SUPERVISOR"
/datum/access/chemical_lab_supervisor
	id = access_chemical_lab_supervisor
	desc = "Chemical Lab Supervisor"
	region = ACCESS_REGION_NONE

/obj/item/weapon/card/id/chemical_lab_worker
	access = list(access_chemical_lab_worker)

/obj/item/weapon/card/id/chemical_lab_supervisor
	access = list(access_chemical_lab_worker, access_chemical_lab_supervisor)