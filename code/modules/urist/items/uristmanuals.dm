// Books + Manuals for Urist - S


// ICS Nerva version of Space Law - Moves this out of TG.

/obj/item/weapon/book/manual/security_space_law/nervaspacelaw
	name = "ICS Nerva - Security Law & Regulation Guidelines."
	desc = "A book describing the multiple sentencings for different crimes aboard the ICS Nerva."
	icon = 'icons/urist/items/library.dmi'
	icon_state = "icsnervalaw"
	author = "ICS Nerva Security Team"
	title = "Security Law & Regulation Guidelines"

/obj/item/weapon/book/manual/security_space_law/nervaspacelaw/New()
	..()

	var/nervalaw = file2text('ingame_manuals/icsnervalaw.html')
	if(!nervalaw)
		nervalaw = "Error loading help (file /ingame_manuals/icsnervalaw.html is probably missing). Please report this to server administration staff."

	dat = nervalaw


/obj/item/weapon/book/manual/maintenance/assistantscookbook
	name = "Assistant's Cookbook"
	desc = "An outlawed manual showing you how to make dangerous weaponry for self defense and sticking it to the MAN!"
	icon = 'icons/urist/items/library.dmi'
	icon_state = "cookbook"
	author = "Urist McCrowbar"
	title = "Assistant's Cookbook - Armed and Dangerous!"

/obj/item/weapon/book/manual/maintenance/assistantscookbook/New()
	..()

	var/assistantcookbook = file2text('ingame_manuals/assistantcookbook.html')
	if(!assistantcookbook)
		assistantcookbook = "Error loading help (file /ingame_manuals/assistantcookbook.html is probably missing). Please report this to server administration staff."

	dat = assistantcookbook
