/material/iron/generate_recipes(reinforce_material)
	.=..()
	if(reinforce_material)	//recipies below don't support composite materials
		return

	. += new/datum/stack_recipe/furniture/anvil(src)

/datum/stack_recipe/furniture/anvil
	title = "anvil"
	result_type = /obj/structure/anvil
	req_amount = 12
	time = 60
