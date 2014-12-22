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
		cartridge = 0

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
/obj/item/weapon/tape/uses/update_icon() //This will be used for updating the iconstate based on what the uses are
	var/newstate
	newstate += initial(src.icon_state)
	if(src.uses > 0)
		return
	if(src:cartridge == 0) //Making sure it's unloaded
		newstate += "_unloaded"
		return
	newstate += "_empty"

/obj/item/weapon/tape/uses/tape_dispenser/verb/use(mob/user as mob)
	set name = "Use"
	set desc = "Use the tape dispenser"
	set category = "Object"

	if(uses < 1)
		user << "<span class='alert'>You try to remove a piece of tape, but then you realize that it's empty</span>"
		return//If it is enpty, return


//Subtypes

//Dispenser Subtypes
/obj/item/weapon/tape/uses/tape_dispenser/office
	subset = "office"
	desc = "This dispenser is used in offices"

/obj/item/weapon/tape/uses/tape_dispenser/shipping
	subset = "shipping"
	desc = "This dispenser is used in shipping"

//Cartridge Subtypes
/obj/item/weapon/tape/uses/tape_cartridge/office
	subset = "office"
	desc = "This cartridge is used in office tape dispensers"

/obj/item/weapon/tape/uses/tape_cartridge/shipping
	subset = "shipping"
	desc = "This cartridge is used in shipping tape dispensers"

//Piece Subtypes
/obj/item/weapon/tape/tape_piece/office
	subset = "office"
	desc = "This piece is from an ofice dispenser"

/obj/item/weapon/tape/tape_piece/shipping
	subset = "shipping"
	desc = "This piece is from a shipping dispenser"