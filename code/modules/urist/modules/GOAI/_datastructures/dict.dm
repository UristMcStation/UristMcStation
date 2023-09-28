/dict
	var/list/data


/dict/New(var/list/init_vals = null)
	data = isnull(init_vals) ? list() : init_vals.Copy()
	//to_world_log("DICT: Created with data [data]!")
	return


/dict/proc/Copy()
	var/dict/newdict = new(data.Copy())
	return newdict


/dict/proc/Items()
	return data.Copy()


/dict/proc/HasKey(var/key)
	return (key in data)


/dict/proc/Get(var/key, var/default = null)
	if (HasKey(key))
		var/retrieved = data[key]
		//to_world_log("DICT: Key [key] retrieved, data is [retrieved]")
		return retrieved

	//to_world_log("DICT: Key [key] missing!")
	return default


/dict/proc/Set(var/key, var/val)
	data[key] = val
	return src


/dict/proc/operator[](idx)
	return Get(idx)


/dict/proc/operator[]=(idx, B)
	return Set(idx, B)
