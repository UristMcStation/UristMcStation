var/datum/antagonist/vampire/vamps

/proc/isvampire(var/mob/player)
	if(!vamps || !player.mind)
		return 0
	if(player.mind in vamps.current_antagonists)
		return 1

/datum/antagonist/vampire
	id = MODE_VAMPIRE
	role_text = "Vampire"
	role_text_plural = "Vampires"
	feedback_tag = "vampire_objective"
	restricted_jobs = list("AI", "Cyborg", "Chaplain")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	welcome_text = "To bite someone, target the head and use harm intent with an empty hand. Drink blood to gain new powers. <br>You are weak to holy things and starlight. Don't go into space and avoid the Chaplain, the chapel and, especially, Holy Water."
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	antag_indicator = "vampire"
	uristantag = 1
	initial_spawn_req = 1
	initial_spawn_target = 1
	hard_cap = 999	//should be able to multiply freely, if costs are met
	hard_cap_round = 5
	faction = "undead"

///datum/antagonist/vampire/get_special_objective_text(var/datum/mind/player)
//	return //"<br><b>Real Name:</b> [player.real_name].

/datum/antagonist/vampire/New()
	..()
	vamps = src

/datum/antagonist/vampire/update_antag_mob(var/datum/mind/player)
	..()
	player.current.make_vampire()

/datum/antagonist/vampire/add_antagonist(var/datum/mind/player)
	. = ..()
	if(.)
		player.current.make_vampire()

/datum/antagonist/vampire/remove_antagonist(var/datum/mind/player)
	player.vampire = null
	..()

/datum/antagonist/vampire/create_objectives(var/datum/mind/vampire)
	if(!..())
		return

	var/datum/objective/blood/blood_objective = new
	blood_objective.owner = vampire
	blood_objective.gen_amount_goal(150, 400)
	vampire.objectives += blood_objective

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = vampire
	kill_objective.find_target()
	vampire.objectives += kill_objective

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = vampire
	steal_objective.find_target()
	vampire.objectives += steal_objective

	switch(rand(1,100))
		if(1 to 80)
			if (!(locate(/datum/objective/escape) in vampire.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = vampire
				vampire.objectives += escape_objective
		else
			if (!(locate(/datum/objective/survive) in vampire.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = vampire
				vampire.objectives += survive_objective
	return
