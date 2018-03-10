
/datum/job/scom/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	..()
	if(!H.mind)
		return
	var/datum/antagonist/antag = all_antag_types()[MODE_SCOM_GD]
	antag.add_antagonist(H.mind)

/datum/job/scom/captain
	title = "Captain"
	department = "Command"
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "SCOM High Command"
	selection_color = "#1d1d4f"
	outfit_type = /decl/hierarchy/outfit/job/captain
	access = list()
	minimal_access = list()

/datum/job/scom/captain/get_access()
	return get_all_station_access()
