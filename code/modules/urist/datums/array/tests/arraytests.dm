
/proc/TestArrays(var/params, as_json=1)
	var/datum/array/M = new(params, as_json=1)

	world.log << " "
	world.log << "=================="
	world.log << " "

	world.log << "SINGLE INDEX TEST"

	for(var/col=1, col<=M.cols, col++)
		for(var/row=1, row<=M.rows, row++)
			var/list/response = M.get("[col],[row]")
			if(!isnull(response))
				world.log << "([col],[row]) --> [response.Join(",")]"
			else
				world.log << "([col],[row]) --> MISSING!"

	world.log << " "
	world.log << "=================="
	world.log << " "

	world.log << "ROW WILDCARD TEST"

	for(var/col=1, col<=M.cols, col++)
		var/list/response = M.get("[col]")
		if(!isnull(response))
			world.log << "([col],:) --> [response.Join(",")]"
		else
			world.log << "([col],:) --> MISSING!"

	world.log << " "
	world.log << "=================="
	world.log << " "

	world.log << "COL WILDCARD TEST"

	for(var/row=1, row<=M.rows, row++)
		var/list/response = M.get(":,[row]")
		if(!isnull(response))
			world.log << "(:,[row]) --> [response.Join(",")]"
		else
			world.log << "(:,[row]) --> MISSING!"

	world.log << " "
	world.log << "=================="
	world.log << " "

	world.log << "DUAL WILDCARD TEST"

	for(var/col=1, col<=1, col++)
		var/list/response = M.get(":")
		if(!isnull(response))
			world.log << "(:,:) --> [response.Join(",")]"
		else
			world.log << "(:,:) --> MISSING!"


	world.log << " "
	world.log << "=================="
	world.log << " "

	world.log << "DEFAULTS TEST"

	for(var/col=1, col<=1, col++)
		var/list/response = M.get()
		if(!isnull(response))
			world.log << "() --> [response.Join(",")]"
		else
			world.log << "() --> MISSING!"

	world.log << " "
	world.log << "=================="
	world.log << " "

/mob/verb/test_arrays(var/params as null|text)
	return TestArrays(params, as_json=1)


/mob/verb/set_color(var/defkey as null|anything in list("grey", "noir", "expressionist", "grimdark", "custom"))
	var/definition = null
	if(defkey == "custom")
		definition=input("Enter a JSON representation ")
	else
		var/list/definitionmap = list("grey"=COLMX_GREYSCALE, "noir"=COLMX_NOIR, "expressionist"=COLMX_EXPRESSIONIST, "grimdark"=COLMX_GRIMDARK)
		definition = definitionmap[defkey]
	if(!definition)
		definition = COLMX_BASIC

	var/datum/array/mtrx = new(definition, as_json=1)

	if(!mtrx)
		world.log << "No matrix :("
		return

	world.log << "Matrix: [json_encode(mtrx.get())]"

	var/list/matrix_flat = mtrx.get()
	usr.client.color = matrix_flat
