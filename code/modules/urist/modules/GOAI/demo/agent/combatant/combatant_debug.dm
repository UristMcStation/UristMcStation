/mob/goai/combatant/verb/InspectGoaiLife()
	set category = "Debug GOAI Agents"
	set src in view(1)

	usr << "X======================================X"
	usr << "|"
	usr << "|       [name] - ALIVE: [life]"
	usr << "|"

	var/path_list = (active_path ? active_path.path : "<No path for null>")
	var/list/brain_plan = null
	var/plan_len = "<No len for null>"
	var/brain_is_planning = null

	if(brain)
		brain_plan = brain.active_plan
		plan_len = (brain_plan ? brain_plan.len : plan_len)
		brain_is_planning = brain.is_planning

		usr << "| Brain: [brain] ([brain.type])"
		for (var/need_key in brain.needs)
			usr << "| [need_key]: [brain.needs[need_key]]"
	else
		usr << "| (brainless)"

	usr << "|"
	usr << "| ACTIVE PATH: [active_path] ([path_list])"
	usr << "| ACTIVE PLAN: [brain_plan] ([plan_len])"
	usr << "|"
	usr << "| PLANNING: [brain_is_planning]"
	usr << "| REPATHING: [is_repathing]"
	usr << "|"
	usr << "X======================================X"

	return
