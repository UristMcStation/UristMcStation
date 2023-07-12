/*
	data wrapping BYOND's native list-based logic
	for easier manipulation of n-dimensional lists
*/

/datum/array
	// metadata
	var/dims = 2
	var/cols = 5
	var/rows = 4

	// stores the actual array
	// col-major to make it easier to access whole RGBA channels
	// e.g. array.get("1,:") returns the whole R channel, "2,:" the whole G

	var/list/grid = null // to be set during instantiation

	// NOTE: avoid using bare instance.grid directly unless you want to risk mutating it.
	//       instance.get() or instance.grid.Copy() are safer options here

	// absolute fallback, an 'eh, whatever' value
	var/default = 0

	// string (params or JSON) decoding to:
	// > coords=value overrides, for params
	// > a non-associative list of lists, for JSON
	var/definition = COLMX_BASIC
	var/use_json = 1 // class default for the call, overrideable in New()

	/////////////////////////////////////////////
	/* example instance for 3 cols, 3 rows
	  (round brackets - indices of a single item):

	[
	[(1,1),(2,1),(3,1)],
	[(1,2),(2,2),(3,2)],
	[(1,3),(2,3),(3,3)],
	[(1,4),(2,4),(3,4)]
	]
	*/


/datum/array/proc/get(position=null)
	/*
	Expects a string of comma-separated integers or ':' wildcards;
	basically Python slice notation.

	Returns a flattened list, even if all indices are specified.
	*/
	if (!position)
		position = ":"

	var/list/result = list()
	var/list/lens = src.grid.Copy()
	var/regex/re = regex("(:)|(\[0-9]+)")
	var/transpose = 0

	var/list/indices = splittext(position, ",")
	while(length(indices) < src.dims)
		indices.Add(":")

	for(var/i=1, i<=length(indices), i++)
		var/str_idx = indices[i]

		if(findtext(str_idx, re))

			if(findtext(":", str_idx))
				if((transpose+1)==length(indices))
					var/list/flatlist = list()

					for(var/c=1, c<=length(src.grid), c++)
						var/list/flattened_col = src.grid[c]

						if(isnull(flattened_col))
							flatlist += src.grid[c]

						else
							for(var/r=1, r<=length(flattened_col), r++)
								flatlist += flattened_col[r]

					return flatlist
				transpose += 1
				continue

			var/num_idx = text2num(str_idx)

			if(isnull(num_idx))
				return

			if(num_idx < 1)
				return

			if(transpose)
				var/list/transposelens = list()
				for (var/col_ind=1, col_ind<=length(src.grid), col_ind++)
					var/list/currcol = src.grid[col_ind]
					transposelens += currcol[num_idx]
				lens = transposelens.Copy()
				transpose -= 1

			else
				lens = lens[num_idx]

			if (isnull(lens))
				return

	result += lens
	return result

/datum/array/proc/assign(position, var/value=null)
	/*
	Expects a string of comma-separated integers and a numeric value to set.

	Returns 1 on success.
	*/
	if (!position)
		return

	if (isnull(value))
		return

	var/list/indices = splittext(position, ",")
	var/regex/validation_re = regex("\[0-9]+")
	var/list/coords = list()
	var/list/array = src.grid

	for (var/str_idx in indices)
		if(validation_re.Find(str_idx))
			var/num_idx = text2num(str_idx)
			if(!isnull(num_idx))
				coords.Add(num_idx)

	if (length(coords) < src.dims)
		return

	array[coords[1]][coords[2]] = value
	return 1

/datum/array/New(paramstring=null, var/as_json=null)
	var/from_json = 0

	if(isnull(as_json))
		from_json = src.use_json
	else
		from_json = as_json

	var/list/newgrid[src.cols][src.rows]
	src.grid = newgrid

	var/raw_params = null
	var/list/params = list()

	if(paramstring)
		raw_params = paramstring
	else
		raw_params = src.definition

	if(raw_params)
		if(from_json)
			var/list/json = json_decode(raw_params)
			params += json
		else
			params += params2list(raw_params)

	for(var/col=1, col<=src.cols, col++)
		for(var/row=1, row<=src.rows, row++)

			var/coords = "[col],[row]"

			var/value = null

			if(from_json)
				// read transposed! - easier to edit and reason about the equation that way.
				value = params[row][col]
			else
				value = params[coords]

			if(isnull(value))
				value = src.default + 100*col + row

			var/successful = src.assign(coords, value)
			if(!successful)
				log_debug( "Failed to set array @([col],[row])!")
