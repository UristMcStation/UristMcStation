/var/global/list/scomscience_recipes
/var/global/list/scomscience_categories

/proc/populate_scomscience_recipes()

	//Create global scomscience recipe list if it hasn't been made already.
	scomscience_recipes = list()
	scomscience_categories = list()
	for(var/R in subtypesof(/datum/scomscience/recipe))
		var/datum/scomscience/recipe/recipe = new R
		scomscience_recipes += recipe
		scomscience_categories |= recipe.category

		//var/obj/I = new recipe.path //what the fuck
		//if(recipe.resources) //This is pointless
		//	qdel(I) //TODO: Come back to this

/datum/scomscience/recipe
	var/name = "object"
	var/path
	var/resources = 0
	var/scomtechlvl = 0
	var/category = "All"
	var/power_use = 0
	var/hidden

//tier 1 - stuff you have from the start

//sniper

/datum/scomscience/recipe/bsniper
	name = "projectile sniper"
	path = /obj/item/weapon/gun/projectile/sniper
	category = "Sniper"
	scomtechlvl = 0
	resources = 100

/datum/scomscience/recipe/bsniperammo
	name = "sniper ammo"
	path = /obj/item/weapon/storage/box/sniperammo
	category = "Sniper"
	resources = 100

//assault

/datum/scomscience/recipe/shotgunammo
	name = "shotgun ammo"
	path = /obj/item/weapon/storage/box/shotgunammo
	category = "Assault"
	resources = 100

/datum/scomscience/recipe/shotgun
	name = "shotgun"
	path = /obj/item/weapon/gun/projectile/shotgun/pump/combat
	category = "Assault"
	resources = 100

//heavy

/datum/scomscience/recipe/l6saw
	name = "light machine gun"
	path = /obj/item/weapon/gun/projectile/automatic/l6_saw
	category = "Heavy"
	resources = 100

/datum/scomscience/recipe/l6sawammo
	name = "light machine gun ammo"
	path = /obj/item/weapon/storage/box/lmgammo
	category = "Heavy"
	resources = 100

//medic

/datum/scomscience/recipe/c20r
	name = "C-20r SMG"
	path = /obj/item/weapon/gun/projectile/automatic/c20r
	category = "Medic"
	resources = 100

/datum/scomscience/recipe/c20ammo
	name = "C-20r ammo"
	path = /obj/item/weapon/storage/box/c20ammo
	category = "Medic"
	resources = 100

/datum/scomscience/recipe/advmed
	name = "advanced medkit"
	path = /obj/item/weapon/storage/firstaid/adv
	category = "Medic"
	resources = 100

/datum/scomscience/recipe/combatdefib
	name = "combat defibrillator"
	path = /obj/item/weapon/defibrillator/compact/combat/loaded
	category = "Medic"
	resources = 400

//general

/datum/scomscience/recipe/pistol
	name = "Knight pistol"
	path = /obj/item/weapon/gun/projectile/silenced/knight
	category = "General"
	resources = 80

/datum/scomscience/recipe/pistolammo
	name = "Knight ammo"
	path = /obj/item/weapon/storage/box/knightammo
	category = "General"
	resources = 50

//leader //add more shit here later

//vehicles

/datum/scomscience/recipe/motorcycle
	name = "Motorcycle"
	path = /obj/vehicle/train/cargo/engine/motorcycle_4dir
	category = "Vehicles"
	resources = 800

//tier 2 - lets have everything here by 3 missions in.

datum/scomscience/recipe/lsniper
	name = "LWAP sniper"
	path = /obj/item/weapon/gun/energy/sniperrifle
	category = "Sniper"
	scomtechlvl = 3
	hidden = 1
	resources = 500

/datum/scomscience/recipe/sniperarmort2
	name = "sniper rig"
	path = /obj/item/weapon/rig/light/scomsniper
	category = "Sniper"
	scomtechlvl = 3
	hidden = 1
	resources = 600

//assault

/datum/scomscience/recipe/assaultarmort2
	name = "advanced assault armour"
	path = /obj/item/clothing/suit/storage/vest/merc
	category = "Assault"
	scomtechlvl = 3
	hidden = 1
	resources = 300

/datum/scomscience/recipe/assaulthelmett2
	name = "advanced assault helmet"
	path = /obj/item/clothing/head/helmet/tactical
	category = "Assault"
	scomtechlvl = 3
	hidden = 1
	resources = 200

/datum/scomscience/recipe/lasrifle
	name = "laser rifle"
	path = /obj/item/weapon/gun/energy/laser/rifle
	category = "Assault"
	scomtechlvl = 3
	hidden = 1
	resources = 400

//heavy

/datum/scomscience/recipe/heavyarmort2
	name = "advanced heavy armour"
	path = /obj/item/clothing/suit/armor/riot
	category = "Heavy"
	scomtechlvl = 3
	hidden = 1
	resources = 250

/datum/scomscience/recipe/heavyhelmett2
	name = "advanced heavy helmet"
	path = /obj/item/clothing/head/helmet/riot
	category = "Heavy"
	scomtechlvl = 3
	hidden = 1
	resources = 350

/datum/scomscience/recipe/lascannon
	name = "laser cannon"
	path = /obj/item/weapon/gun/energy/lasercannon
	category = "Heavy"
	scomtechlvl = 3
	hidden = 1
	resources = 500

//medic

/datum/scomscience/recipe/lascarbine
	name = "laser carbine"
	path = /obj/item/weapon/gun/energy/laser
	category = "Medic"
	scomtechlvl = 3
	hidden = 1
	resources = 400

/datum/scomscience/recipe/medichelmett2
	name = "advanced medic helmet"
	path = /obj/item/clothing/head/helmet/ert/medical
	category = "Medic"
	scomtechlvl = 3
	hidden = 1
	resources = 200

/datum/scomscience/recipe/medicarmort2
	name = "advanced medic armour"
	path = /obj/item/weapon/rig/medical
	category = "Medic"
	scomtechlvl = 3
	hidden = 1
	resources = 300

/datum/scomscience/recipe/medst2
	name = "advanced autoinjector box"
	path = /obj/item/weapon/storage/box/autoinjectorscom
	category = "Medic"
	scomtechlvl = 2
	hidden = 1
	resources = 150

/datum/scomscience/recipe/medgt2
	name = "advanced healing grenade"
	path = /obj/item/weapon/grenade/chem_grenade/heal
	category = "Medic"
	scomtechlvl = 2
	hidden = 1
	resources = 80

//leader

/datum/scomscience/recipe/leaderhelmett2
	name = "advanced squad leader helmet"
	path = /obj/item/clothing/head/helmet/ert
	category = "Squad Leader"
	scomtechlvl = 3
	hidden = 1
	resources = 200

/datum/scomscience/recipe/leaderarmort2
	name = "advanced squad leader armour"
	path = /obj/item/clothing/suit/armor/vest/ert
	scomtechlvl = 3
	hidden = 1
	resources = 300

//general

/datum/scomscience/recipe/lpistol
	name = "laser pistol"
	path = /obj/item/weapon/gun/energy/laser/pistol
	category = "General"
	scomtechlvl = 3
	hidden = 1
	resources = 200

/datum/scomscience/recipe/esword
	name = "energy sword"
	path = /obj/item/weapon/melee/energy/sword/blue
	category = "General"
	scomtechlvl = 4
	hidden = 1
	resources = 200

/datum/scomscience/recipe/eshield
	name = "energy shield"
	path = /obj/item/weapon/shield/energy
	category = "General"
	scomtechlvl = 4
	hidden = 1
	resources = 200

//vehicles

/datum/scomscience/recipe/fourwheel
	name = "Four wheeler"
	path = /obj/vehicle/train/cargo/engine/fourwheeler
	category = "Vehicles"
	scomtechlvl = 1
	hidden = 1
	resources = 1000

/datum/scomscience/recipe/cvrt2
	name = "CVR"
	path = /obj/mecha/working/cvrt/basic
	category = "Vehicles"
	scomtechlvl = 2
	hidden = 1
	resources = 2500

//tier 3 - we have everything here by the time we go to the station probably

//sniper

/datum/scomscience/recipe/psniper
	name = "pulse sniper"
	path = /obj/item/weapon/gun/energy/sniperrifle/pulse
	category = "Sniper"
	scomtechlvl = 7
	hidden = 1
	resources = 1000

/datum/scomscience/recipe/sniperarmort3
	name = "futuristic sniper rig"
	path = /obj/item/weapon/rig/scomsniper
	category = "Sniper"
	scomtechlvl = 7
	hidden = 1
	resources = 1000

//assault

/datum/scomscience/recipe/assaultarmort3
	name = "futuristic assault rig"
	path = /obj/item/weapon/rig/ert/security/scom
	category = "Assault"
	scomtechlvl = 7
	hidden = 1
	resources = 900

/datum/scomscience/recipe/prifle
	name = "pulse rifle"
	path = /obj/item/weapon/gun/energy/pulse_rifle
	category = "Assault"
	scomtechlvl = 7
	hidden = 1
	resources = 800

//heavy

/datum/scomscience/recipe/heavyarmort3
	name = "futuristic heavy rig"
	path = /obj/item/weapon/rig/combat
	category = "Heavy"
	scomtechlvl = 7
	hidden = 1
	resources = 1000

/datum/scomscience/recipe/pcannon
	name = "pulse cannon"
	path = /obj/item/weapon/gun/energy/pulse_rifle/cannon
	category = "Heavy"
	scomtechlvl = 7
	hidden = 1
	resources = 1000

//medic

/datum/scomscience/recipe/priflem
	name = "pulse rifle"
	path = /obj/item/weapon/gun/energy/pulse_rifle
	category = "Medic"
	scomtechlvl = 7
	hidden = 1
	resources = 800

/datum/scomscience/recipe/medicarmort3
	name = "futuristic medic rig"
	path = /obj/item/weapon/rig/ert/medical/scom
	category = "Medic"
	scomtechlvl = 7
	hidden = 1
	resources = 900

/datum/scomscience/recipe/medst3
	name = "futuristic autoinjector"
	path = /obj/item/weapon/reagent_containers/hypospray/autoinjector/admin
	category = "Medic"
	scomtechlvl = 6
	hidden = 1
	resources = 300

//leader

/datum/scomscience/recipe/leaderarmort3
	name = "futuristic squad leader rig"
	path = /obj/item/weapon/rig/ert/scomlead
	category = "Squad Leader"
	scomtechlvl = 7
	hidden = 1
	resources = 900

//general

/datum/scomscience/recipe/ppistol
	name = "pulse pistol"
	path = /obj/item/weapon/gun/energy/pulse_rifle/pistol
	category = "General"
	scomtechlvl = 6
	hidden = 1
	resources = 600

/datum/scomscience/recipe/eaxe
	name = "energy axe"
	path = /obj/item/weapon/melee/energy/axe
	category = "General"
	scomtechlvl = 6
	hidden = 1
	resources = 850

/datum/scomscience/recipe/borgkit
	name = "Cyborg Modification Kit"
	path = /obj/item/scom/borgmodkit
	category = "General"
	scomtechlvl = 6
	hidden = 1
	resources = 800

//vehicles

/datum/scomscience/recipe/cvrt3
	name = "advanced CVR"
	path = /obj/mecha/working/cvrt/upgraded
	category = "Vehicles"
	scomtechlvl = 6
	hidden = 1
	resources = 6000

//last bit of armour. OP as fuuuck :) //out for now

///datum/scomscience/recipe/assaultarmort3
//	name = "ultimate rig"
//	path = /obj/item/weapon/storage/box/shotgunammo
//	category = "General"
//	scomtechlvl = 10
//	hidden = 1
//	resources = 2000