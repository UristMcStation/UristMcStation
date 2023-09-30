/material/proc/dump_recipes(var/material/reinf_mat)
	var/list/recipes = list()

	if(reinf_mat && (reinf_mat.integrity <= src.integrity || reinf_mat.is_brittle()))
		return

	for(var/listed_recipie in src.get_recipes(reinf_mat))
		if(istype(listed_recipie, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = listed_recipie
			for(var/datum/stack_recipe/stack_recipie in srl.recipes)
				recipes.Add(list(list(
					"product" = stack_recipie.result_type,
					"mat_cost" = stack_recipie.req_amount,
					"prod_amount" = stack_recipie.res_amount
				)))
		else if(istype(listed_recipie, /datum/stack_recipe))
			var/datum/stack_recipe/stack_recipie = listed_recipie

			recipes.Add(list(list(
				"product" = stack_recipie.result_type,
				"mat_cost" = stack_recipie.req_amount,
				"prod_amount" = stack_recipie.res_amount
			)))

	return recipes
