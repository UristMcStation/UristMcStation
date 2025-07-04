#define AB_ITEM 1
#define AB_SPELL 2
#define AB_INNATE 3
#define AB_GENERIC 4
#define AB_ITEM_USE_ICON 5

#define AB_CHECK_RESTRAINED 1
#define AB_CHECK_STUNNED 2
#define AB_CHECK_LYING 4
#define AB_CHECK_ALIVE 8
#define AB_CHECK_INSIDE 16
#define AB_CHECK_INSIDE_ACCESSORY 32


/datum/action
	var/name = "Generic Action"
	var/desc = null
	var/action_type = AB_ITEM
	var/procname = null
	var/atom/movable/target = null
	var/check_flags = 0
	var/processing = 0
	var/active = 0
	var/obj/screen/movable/action_button/button = null
	var/button_icon = 'icons/obj/action_buttons/actions.dmi'
	var/button_icon_state = "default"
	var/background_icon_state = "bg_default"
	var/mob/living/owner

/datum/action/New(Target)
	target = Target

/datum/action/Destroy()
	if(owner)
		Remove(owner)
	return ..()

/datum/action/proc/SetTarget(atom/Target)
	target = Target

/datum/action/proc/Grant(mob/living/T)
	if(owner)
		if(owner == T)
			return
		Remove(owner)
	owner = T
	owner.actions.Add(src)
	owner.update_action_buttons()
	return

/datum/action/proc/Remove(mob/living/T)
	if(button)
		if(T.client)
			T.client.screen -= button
		qdel(button)
		button = null
	T.actions.Remove(src)
	T.update_action_buttons()
	owner = null
	return

/datum/action/proc/Trigger()
	if(!Checks())
		return
	switch(action_type)
		if(AB_ITEM, AB_ITEM_USE_ICON)
			if(target)
				var/obj/item/item = target
				item.ui_action_click(owner)
		//if(AB_SPELL)
		//	if(target)
		//		var/obj/proc_holder/spell = target
		//		spell.Click()
		if(AB_INNATE)
			if(!active)
				Activate()
			else
				Deactivate()
		if(AB_GENERIC)
			if(target && procname)
				call(target,procname)(usr)
	return

/datum/action/proc/Activate()
	return

/datum/action/proc/Deactivate()
	return

/datum/action/proc/ProcessAction()
	return

/datum/action/proc/CheckRemoval(mob/living/user) // 1 if action is no longer valid for this mob and should be removed
	return 0

/datum/action/proc/IsAvailable()
	return Checks()

/datum/action/proc/Checks()// returns 1 if all checks pass
	if(!owner)
		return 0
	if(check_flags & AB_CHECK_RESTRAINED)
		if(owner.restrained())
			return 0
	if(check_flags & AB_CHECK_STUNNED)
		if(owner.stunned)
			return 0
	if(check_flags & AB_CHECK_LYING)
		if(owner.lying)
			return 0
	if(check_flags & AB_CHECK_ALIVE)
		if(owner.stat)
			return 0
	if(check_flags & AB_CHECK_INSIDE)
		if(!(target in owner))
			return 0
	if(check_flags & AB_CHECK_INSIDE_ACCESSORY)
		if(!(target in owner))
			var/obj/item/clothing/C = target.loc
			if (!(istype(C) && (C in owner) && (target in C.accessories)))
				return 0
	return 1

/datum/action/proc/UpdateName()
	return name

/datum/action/proc/UpdateDesc()
	return desc

/obj/screen/movable/action_button
	var/datum/action/owner
	screen_loc = "WEST,NORTH"
	/// String. Title of the tooltip displayed on hover. Set during `Initialize()`, defaults to `owner.target.name`.
	var/tooltip_title


/obj/screen/movable/action_button/Initialize(mapload, _owner)
	. = ..(mapload)
	owner = _owner
	if (owner?.target)
		tooltip_title = owner.target.name


/obj/screen/movable/action_button/Click(location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["shift"])
		moved = 0
		return 1
	if(usr.next_move >= world.time) // Is this needed ?
		return
	owner.Trigger()
	return 1


/obj/screen/movable/action_button/MouseEntered(location, control, params)
	openToolTip(usr, src, params, tooltip_title, name)


/obj/screen/movable/action_button/MouseExited(location, control, params)
	closeToolTip(usr)


/obj/screen/movable/action_button/proc/UpdateIcon()
	if(!owner)
		return
	icon = owner.button_icon
	icon_state = owner.background_icon_state

	ClearOverlays()
	var/image/img
	if(owner.action_type == AB_ITEM && owner.target)
		var/obj/item/I = owner.target
		img = image(I.icon, src , I.icon_state)
	else if(owner.button_icon && owner.button_icon_state)
		img = image(owner.button_icon,src,owner.button_icon_state)
	img.pixel_x = 0
	img.pixel_y = 0
	AddOverlays(img)

	if(!owner.IsAvailable())
		color = rgb(128,0,0,128)
	else
		color = rgb(255,255,255,255)

/obj/screen/movable/action_button/MouseEntered(location, control, params)
	openToolTip(user = usr, tip_src = src, params = params, title = name, content = desc)
	..()

/obj/screen/movable/action_button/MouseDown()
	closeToolTip(usr)
	..()

/obj/screen/movable/action_button/MouseExited()
	closeToolTip(usr)
	..()

//Hide/Show Action Buttons ... Button
/obj/screen/movable/action_button/hide_toggle
	name = "Hide Buttons"
	icon = 'icons/obj/action_buttons/actions.dmi'
	icon_state = "bg_default"
	var/hidden = 0

/obj/screen/movable/action_button/hide_toggle/Click()
	usr.hud_used.action_buttons_hidden = !usr.hud_used.action_buttons_hidden

	hidden = usr.hud_used.action_buttons_hidden
	if(hidden)
		name = "Show Buttons"
	else
		name = "Hide Buttons"
	UpdateIcon()
	usr.update_action_buttons()


/obj/screen/movable/action_button/hide_toggle/proc/InitialiseIcon(mob/living/user)
	if(isalien(user))
		icon_state = "bg_alien"
	else
		icon_state = "bg_default"
	UpdateIcon()
	return

/obj/screen/movable/action_button/hide_toggle/UpdateIcon()
	ClearOverlays()
	var/image/img = image(icon,src,hidden?"show":"hide")
	AddOverlays(img)
	return

//This is the proc used to update all the action buttons. Properly defined in /mob/living
/mob/proc/update_action_buttons()
	return

#define AB_WEST_OFFSET 4
#define AB_NORTH_OFFSET 26
#define AB_MAX_COLUMNS 10

/datum/hud/proc/ButtonNumberToScreenCoords(number) // TODO : Make this zero-indexed for readabilty
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	var/coord_col = "+[col-1]"
	var/coord_col_offset = AB_WEST_OFFSET+2*col
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = AB_NORTH_OFFSET
	return "WEST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/datum/hud/proc/SetButtonCoords(obj/screen/button,number)
	var/row = round((number-1)/AB_MAX_COLUMNS)
	var/col = ((number - 1)%(AB_MAX_COLUMNS)) + 1
	button.SetTransform(
		offset_x = 32 * (col - 1) + AB_WEST_OFFSET + 2 * col,
		offset_y = -32 * (row + 1) + AB_NORTH_OFFSET
	)

//Presets for item actions
/datum/action/item_action
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/CheckRemoval(mob/living/user)
	return !(target in user)

/datum/action/item_action/accessory
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUNNED|AB_CHECK_LYING|AB_CHECK_ALIVE|AB_CHECK_INSIDE_ACCESSORY

/datum/action/item_action/accessory/CheckRemoval(mob/living/user)
	return !(target in user || (target.loc && (target.loc in user)))

/datum/action/item_action/hands_free
	check_flags = AB_CHECK_ALIVE|AB_CHECK_INSIDE

/datum/action/item_action/organ
	action_type = AB_ITEM_USE_ICON
	button_icon = 'icons/obj/action_buttons/organs.dmi'

/datum/action/item_action/organ/SetTarget(atom/Target)
	. = ..()
	var/obj/item/organ/O = target
	if(istype(O))
		O.refresh_action_button()

/datum/action/item_action/organ/augment
	button_icon = 'icons/obj/augment.dmi'

#undef AB_WEST_OFFSET
#undef AB_NORTH_OFFSET
#undef AB_MAX_COLUMNS
