/material/proc/dump_recipes(var/material/reinf_mat)
	var/list/recipes = list()

	if(reinf_mat && (reinf_mat.integrity <= src.integrity || reinf_mat.is_brittle()))
		return

	for(var/listed_recipe in src.get_recipes(reinf_mat))
		if(istype(listed_recipe, /datum/stack_recipe_list))
			var/datum/stack_recipe_list/srl = listed_recipe
			for(var/datum/stack_recipe/stack_recipe in srl.recipes)
				recipes.Add(list(list(
					"product" = stack_recipe.result_type,
					"mat_cost" = stack_recipe.req_amount,
					"prod_amount" = stack_recipe.res_amount
				)))
		else if(istype(listed_recipe, /datum/stack_recipe))
			var/datum/stack_recipe/stack_recipe = listed_recipe

			recipes.Add(list(list(
				"product" = stack_recipe.result_type,
				"mat_cost" = stack_recipe.req_amount,
				"prod_amount" = stack_recipe.res_amount
			)))

	return recipes
