
/obj/wfc_step_trigger
	icon = 'icons/misc/mark.dmi'
	icon_state = "x3"

	var/step_include_trigger_obj = TRUE
	var/step_callback = null
	var/list/step_callback_args = null
	var/step_callback_delay = 3

	var/unstep_include_trigger_obj = TRUE
	var/unstep_callback = null
	var/list/unstep_callback_args = null
	var/unstep_callback_delay = 3

	invisibility = STEP_TRIGGER_INVISIBILITY


/obj/wfc_step_trigger/Crossed(var/atom/movable/O)
	. = ..(O)

	if(src.step_callback)
		spawn(src.step_callback_delay)
			var/list/_cbargs = list()

			if(src.step_include_trigger_obj)
				_cbargs.Add(O)

			if(!isnull(src.step_callback_args))
				_cbargs.Add(src.step_callback_args)

			call(src.step_callback)(arglist(_cbargs))


/obj/wfc_step_trigger/Uncrossed(var/atom/movable/O)
	. = ..(O)

	if(src.unstep_callback)
		spawn(src.unstep_callback_delay)
			var/list/_cbargs = list()

			if(src.unstep_include_trigger_obj)
				_cbargs.Add(O)

			if(!isnull(src.unstep_callback_args))
				_cbargs.Add(src.unstep_callback_args)

			call(src.unstep_callback)(arglist(_cbargs))

