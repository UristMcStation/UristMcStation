//Holder for skill information for mobs.

/datum/skillset
	var/skill_list = list()
	var/mob/owner
	var/default_value = SKILL_DEFAULT
	var/skills_transferable = TRUE

/datum/skillset/New(mob/mob)
	owner = mob
	..()

/datum/skillset/Destroy()
	owner = null
	. = ..()

/datum/skillset/proc/from_datum(decl/hierarchy/skill/skill)
	return skill_list[skill] || default_value

/datum/skillset/proc/from_path(skill_path)
	for(var/decl/hierarchy/skill/S in skill_list)
		if(istype(S, skill_path))
			return from_datum(S)			// So that if from_datum is modified, so is this.
	return from_datum()

/datum/skillset/proc/obtain_from_mob(mob/mob)
	if(!istype(mob) || !skills_transferable || !mob.skillset.skills_transferable)
		return
	skill_list = mob.skillset.skill_list
	default_value = mob.skillset.default_value

/datum/skillset/proc/set_antag_skills()
	skill_list = list()
	return												//Antags get generic skills, unless this is modified

/datum/skillset/proc/obtain_from_client(datum/job/job, client/given_client, override = 0)
	if(!skills_transferable)
		return
	if(!override && owner.mind && player_is_antag(owner.mind))		//Antags are dealt with at a different time. Note that this may be called before or after antag roles are assigned.
		return
	if(!given_client)
		return

	var/allocation = given_client.prefs.skills_allocated[job] || list()
	skill_list = list()

	for(var/decl/hierarchy/skill/S in GLOB.skills)
		var/min = given_client.prefs.get_min_skill(job, S)
		skill_list[S] = min + (allocation[S] || 0)

// Show skills verb

mob/living/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	skillset.open_ui()

datum/skillset/proc/open_ui()
	if(!owner)
		return
	if(!NM)
		NM = new nm_type(owner)
	NM.ui_interact(owner)

	var/HTML = list()
	HTML += "<body>"
	HTML += "<b>Skills: [M]</b><br>"
	HTML += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/V in skill.children)
		HTML += "<tr><th colspan = 4><b>[V.name]</b>"
		HTML += "</th></tr>"
		for(var/decl/hierarchy/skill/S in V.children)
			var/level = M.skillset.from_datum(S)
			HTML += "<tr style='text-align:left;'>"
			HTML += "<th>[S.name]</th>"
			for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
				HTML += "<th><font color=[(level == i) ? "red" : "black"]>[S.levels[i]]</font></th>"
			HTML += "</tr>"
	HTML += "</table>"

	show_browser(user, null, "window=preferences")
	show_browser(user, jointext(HTML, null), "window=show_skills;size=700x900")

mob/living/carbon/human/verb/show_skills()
	set category = "IC"
	set name = "Show Own Skills"

	show_skill_window(src, src)