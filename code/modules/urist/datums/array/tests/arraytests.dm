
/proc/TestArrays(params, as_json=1)
	var/datum/array/M = new(params, as_json=1)

	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

	log_debug( "SINGLE INDEX TEST")

	for(var/col=1, col<=M.cols, col++)
		for(var/row=1, row<=M.rows, row++)
			var/list/response = M.get("[col],[row]")
			if(!isnull(response))
				log_debug( "([col],[row]) --> [response.Join(",")]")
			else
				log_debug( "([col],[row]) --> MISSING!")

	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

	log_debug( "ROW WILDCARD TEST")

	for(var/col=1, col<=M.cols, col++)
		var/list/response = M.get("[col]")
		if(!isnull(response))
			log_debug( "([col],:) --> [response.Join(",")]")
		else
			log_debug( "([col],:) --> MISSING!")

	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

	log_debug( "COL WILDCARD TEST")

	for(var/row=1, row<=M.rows, row++)
		var/list/response = M.get(":,[row]")
		if(!isnull(response))
			log_debug( "(:,[row]) --> [response.Join(",")]")
		else
			log_debug( "(:,[row]) --> MISSING!")

	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

	log_debug( "DUAL WILDCARD TEST")

	for(var/col=1, col<=1, col++)
		var/list/response = M.get(":")
		if(!isnull(response))
			log_debug( "(:,:) --> [response.Join(",")]")
		else
			log_debug( "(:,:) --> MISSING!")


	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

	log_debug( "DEFAULTS TEST")

	for(var/col=1, col<=1, col++)
		var/list/response = M.get()
		if(!isnull(response))
			log_debug( "() --> [response.Join(",")]")
		else
			log_debug( "() --> MISSING!")

	log_debug( " ")
	log_debug( "==================")
	log_debug( " ")

/mob/verb/test_arrays(params as null|text)
	return TestArrays(params, as_json=1)


/mob/verb/set_color(defkey as null|anything in list("grey", "noir", "expressionist", "grimdark", "custom"))
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
		log_debug( "No matrix :(")
		return

	log_debug( "Matrix: [json_encode(mtrx.get())]")

	var/list/matrix_flat = mtrx.get()
	usr.client.color = matrix_flat
