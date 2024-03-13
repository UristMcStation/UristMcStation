/datum/event_queue
	var/const/default_queue_name = "EventQueue"

	var/name
	var/list/events


/datum/event_queue/New(var/name = null)
	. = ..()

	src.name = (name ? name : src.default_queue_name)
	src.events = (src.events || list())


/datum/event_queue/proc/Add(var/item = null)
	src.events = (src.events || list())
	src.events.Add(item)
	return src


/datum/event_queue/proc/Pop()
	if(!(src.events))
		return

	var/curr_len = src.events.len
	var/item = src.events[curr_len--]
	return item


/datum/event_queue/proc/Items()
	if(!(src.events))
		src.events = list()

	return src.events



/datum/event_queue/hit
