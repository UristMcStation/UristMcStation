/*										*****New space to put all UristMcStation Science Stuff*****

Please keep it tidy, by which I mean put comments describing the item before the entry. I've pretty much got all categories now. Any science designs for UMcS
(i.e. plasma pistol) go here. At the moment, it's just the plasma pistol, but I'm sure more will pop up. -Glloyd */

//Plasma pistol

datum/design/plasmapistol
	name = "Phoron Pistol"
	desc = "Weaponized phoron... Scary."
	id = "plasmapistol"
	req_tech = list("combat" = 4, "materials" = 4, "plasmatech" = 3, "magnets" = 2)
	build_type = PROTOLATHE
	materials = list("$silver" = 1000, "$metal" = 4000, "$uranium" = 1000, "$glass" = 500, "$gold" = 500, "$plasma" = 500)
	build_path = /obj/item/weapon/gun/energy/plasmapistol
	sort_string = "XAAAA"