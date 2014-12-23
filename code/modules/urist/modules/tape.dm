//TGameCo's Tape


//Utility Definitions
/obj/item/weapon/tape/
	//Variables
	urist_only = 1
	w_class = 1
	icon = 'icons/urist/items/tape.dmi'

	//Custom Variables
	var
		subset = "generic"
		objtype

/obj/item/weapon/tape/uses
	//Variables
	//Custom Variables
	var
		max_uses = 25
		uses = 25

/obj/item/weapon/tape/uses/tape_dispenser
	//Variables
	name = "Tape Dispenser"
	icon_state = "GenericDispenser"
	item_state = "GenericDispenser"
	force = 1
	objtype = "td"

	//Custom Variables
	var
		cartridge = 1

/obj/item/weapon/tape/uses/tape_cartridge
	name = "Tape Cartridge"
	icon_state = "GenericCartridge"
	item_state = "GenericCartridge"
	force = 1
	objtype = "tc"

	//Custom Variables

/obj/item/weapon/tape/tape_piece
	name = "Tape Piece"
	icon_state = "GenericPiece"
	item_state = "GenericPiece"
	force = 1
	objtype = "tp"

//Procs

//Icon Updating
/obj/item/weapon/tape/uses/update_icon() //This will be used for updating the cartridge's iconstate based on what the uses are
	var/newstate
	newstate += initial(src.icon_state)
	if(src.uses == 0)
		newstate += "_empty"
		icon_state = newstate
		return
	icon_state = newstate

/obj/item/weapon/tape/uses/tape_dispenser/update_icon() //This will be used for updating the tape dispenser
	var/newstate
	newstate += initial(src.icon_state)
	if(src:cartridge == 0) //It'll set the sprite to have _unloaded at the end, as unloaded things can't be empty
		newstate += "_unloaded"
		icon_state = newstate
		return
	if(src.uses == 0)
		newstate += "_empty"
		icon_state = newstate
		return
	icon_state = newstate

//Using verbs
/obj/item/weapon/tape/uses/tape_dispenser/verb/use()
	set name = "Use Dispenser"
	set desc = "Use the tape dispenser"
	set category = "Object"
	set src in view(1)
	var/mob/user = usr

	if(cartridge == 0) //Prevents people from taking a thing when it's not loaded
		user << "<span class='alert'>You try to remove a piece of tape, but then you realize that it's unloaded</span>"
		return

	if(uses < 1) //Prevents people from taking a thing when it's empty
		user << "<span class='alert'>You try to remove a piece of tape, but then you realize that it's empty</span>"
		return//If it is enpty, return

	//The real work
	uses-= 1
	var/tapepiecepath = text2path("/obj/item/weapon/tape/tape_piece/[subset]")
	var/obj/item/weapon/tape/tapepiece = new tapepiecepath //Couldn't do this any other way
	if(!tapepiece) //Making sure the tape is a thing
		user << "<span class='alert'>HALP! [subset] isn't a thingy!"
		return
	user.visible_message("[user] removed a piece of tape from a tape dispenser", "You remove a piece of tape from the dispenser", "You hear the tearing of tape")
	user.put_in_hands(tapepiece)
	update_icon() //Just making sure the tape dispenser is updated

/obj/item/weapon/tape/uses/tape_dispenser/verb/remove_cartridge()
	set name = "Remove Cartridge"
	set desc = "Remove the cartridge from the tape dispenser"
	set category = "Object"
	set src in view(1)
	var/mob/user = usr

	if(cartridge == 0) //Prevents people from taking a cartridge when there isn't one
		user << "<span class='alert'>You try to remove the cartridge, but then you realize that it's unloaded</span>"
		return

	//The real work
	var/cartridgepath = text2path("/obj/item/weapon/tape/uses/tape_cartridge/[subset]")
	var/obj/item/weapon/tape/uses/tape_cartridge/newcartridge = new cartridgepath
	if(!newcartridge)
		user << "<span class='alert'>HALP! [subset] isn't a cartridge!</span>"
		return
	cartridge = 0
	newcartridge.uses = uses
	uses = 0
	user.visible_message("[user] removed the cartridge from the tape dispenser", "You remove the cartridge from the tape dispenser", "You hear the clinking of plastic")
	user.put_in_hands(newcartridge)
	newcartridge.update_icon()
	update_icon() //Just making sure the tape dispenser is updated

/obj/item/weapon/tape/uses/tape_dispenser/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/tape/uses/tape_cartridge))
		var/obj/item/weapon/tape/uses/tape_cartridge/target = I
		if(target.subset != subset)
			user << "<span class='alert'>You try to insert the cartridge, but then you realize the cartridge doesn't fit.</span>"
			return
		if(src:cartridge == 1)
			user << "<span class='alert'>You try to insert the cartridge, then you realize how dumb you are when you spot the cartridge already in there</span>"
			return
		src:cartridge = 1
		src:uses = target.uses
		user.visible_message("[user] inserted the cartridge into the dispenser", "You insert the cartridge into the dispenser", "You hear the clinking of plastic")
		update_icon()
		del I
	..()

//Subtypes

//Dispenser Subtypes
/obj/item/weapon/tape/uses/tape_dispenser/generic
	subset = "generic"
	desc = "This dispenser is used everywhere"

/obj/item/weapon/tape/uses/tape_dispenser/office
	icon_state = "OfficeDispenser"
	subset = "office"
	desc = "This dispenser is used in offices"

/obj/item/weapon/tape/uses/tape_dispenser/shipping
	icon_state = "ShippingDispenser"
	subset = "shipping"
	desc = "This dispenser is used in shipping"

//Cartridge Subtypes
/obj/item/weapon/tape/uses/tape_cartridge/generic
	subset = "generic"
	desc = "This cartridge is used in generic tape dispensers"

/obj/item/weapon/tape/uses/tape_cartridge/office
	icon_state = "OfficeCartridge"
	subset = "office"
	desc = "This cartridge is used in office tape dispensers"

/obj/item/weapon/tape/uses/tape_cartridge/shipping
	icon_state = "ShippingCartridge"
	subset = "shipping"
	desc = "This cartridge is used in shipping tape dispensers"

//Piece Subtypes
/obj/item/weapon/tape/tape_piece/generic
	subset = "generic"
	desc = "This piece is from a generic dispenser"

/obj/item/weapon/tape/tape_piece/office
	icon_state = "OfficePiece"
	subset = "office"
	desc = "This piece is from an office dispenser"

/obj/item/weapon/tape/tape_piece/shipping
	icon_state = "ShippingPiece"
	subset = "shipping"
	desc = "This piece is from a shipping dispenser"