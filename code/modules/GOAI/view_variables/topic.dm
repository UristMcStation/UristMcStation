# ifdef GOAI_LIBRARY_FEATURES

/client/proc/view_var_Topic(href, href_list, hsrc)
	//This should all be moved over to datum/admins/Topic() or something ~Carn
	/*if( (usr.client != src) )// || !src.holder )
		return*/

	if(href_list["Vars"])
		debug_variables(locate(href_list["Vars"]))

	else if(href_list["varnameedit"] && href_list["datumedit"])
		to_world("Varname Edit HIT!")
		var/D = locate(href_list["datumedit"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnameedit"], 1)

	else if(href_list["varnamechange"] && href_list["datumchange"])
		to_world("Varname Change HIT!")
		var/D = locate(href_list["datumchange"])
		if(!istype(D,/datum) && !istype(D,/client))
			to_chat(usr, "This can only be used on instances of types /client or /datum")
			return

		modify_variables(D, href_list["varnamechange"], 0)

	/*
	else if(href_list["varnamemass"] && href_list["datummass"])
		var/atom/A = locate(href_list["datummass"])
		if(!istype(A))
			to_chat(usr, "This can only be used on instances of type /atom")
			return

		cmd_mass_modify_object_variables(A, href_list["varnamemass"])
	*/
	/*
	else if(href_list["drop_everything"])
		if(!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/M = locate(href_list["drop_everything"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_admin_drop_everything(M)

	else if(href_list["direct_control"])
		if(!check_rights(0))	return

		var/mob/M = locate(href_list["direct_control"])
		if(!istype(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(usr.client)
			usr.client.cmd_assume_direct_control(M)

	else if(href_list["delthis"])
		var/obj/O = locate(href_list["delthis"])
		if(!isobj(O))
			to_chat(usr, "This can only be used on instances of type /obj")
			return
		cmd_admin_delete(O)

	else if(href_list["delall"])
		var/obj/O = locate(href_list["delall"])
		if(!isobj(O))
			to_chat(usr, "This can only be used on instances of type /obj")
			return

		var/action_type = alert("Strict type ([O.type]) or type and all subtypes?",,"Strict type","Type and subtypes","Cancel")
		if(action_type == "Cancel" || !action_type)
			return

		if(alert("Are you really sure you want to delete all objects of type [O.type]?",,"Yes","No") != "Yes")
			return

		if(alert("Second confirmation required. Delete?",,"Yes","No") != "Yes")
			return

		var/O_type = O.type
		switch(action_type)
			if("Strict type")
				var/i = 0
				for(var/obj/Obj in world)
					if(Obj.type == O_type)
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type [O_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type [O_type] ([i] objects deleted)</span>")
			if("Type and subtypes")
				var/i = 0
				for(var/obj/Obj in world)
					if(istype(Obj,O_type))
						i++
						qdel(Obj)
				if(!i)
					to_chat(usr, "No objects of this type exist")
					return
				log_admin("[key_name(usr)] deleted all objects of type or subtype of [O_type] ([i] objects deleted)")
				message_admins("<span class='notice'>[key_name(usr)] deleted all objects of type or subtype of [O_type] ([i] objects deleted)</span>")
	*/

	else if(href_list["addverb"])

		var/mob/living/H = locate(href_list["addverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living")
			return
		var/list/possibleverbs = list()
		possibleverbs += "Cancel" 								// One for the top...
		//possibleverbs += typesof(/mob/proc,/mob/verb,/mob/living/proc,/mob/living/verb)
		/*switch(H.type)
			if(/mob/living/carbon/human)
				possibleverbs += typesof(/mob/living/carbon/proc,/mob/living/carbon/verb,/mob/living/carbon/human/verb,/mob/living/carbon/human/proc)
		*/
		possibleverbs -= H.verbs
		possibleverbs += "Cancel" 								// ...And one for the bottom

		var/verb = input("Select a verb!", "Verbs",null) as anything in possibleverbs
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb || verb == "Cancel")
			return
		else
			H.verbs += verb

	else if(href_list["remverb"])
		var/mob/H = locate(href_list["remverb"])

		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob")
			return
		var/verb = input("Please choose a verb to remove.","Verbs",null) as null|anything in H.verbs
		if(!H)
			to_chat(usr, "Mob doesn't exist anymore")
			return
		if(!verb)
			return
		else
			H.verbs -= verb

	/*
	else if(href_list["call_proc"])
		var/datum/D = locate(href_list["call_proc"])
		if(istype(D) || istype(D, /client)) // can call on clients too, not just datums
			callproc_targetpicked(1, D)
	*/
	return

#endif
