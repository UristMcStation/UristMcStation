/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/smallenergy_gun
	name = "Small Energy Gun"
	desc = "A pocket-sized energy based sidearm with three different lethality settings."
	item_cost = 16
	path = /obj/item/gun/energy/gun/small

/datum/uplink_item/item/visible_weapons/shuriken
	name = "Box of shurikens"
	desc = "A small box with six shuriken, which have a high chance to embed into a limb."
	item_cost = 16
	path = /obj/item/storage/box/syndie_kit/shuriken

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	desc = "A gas-powered dart gun capable of delivering chemical payloads across short distances. \
			Requires beakers to be added to the mixer to set what payload to deliver. \
			Uses a unique cartridge loaded with hollow darts."
	item_cost = 12
	path = /obj/item/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	desc = "A self-recharging, almost silent weapon employed by stealth operatives. \
			The darts are coated with a toxin that stuns and poisons quickly."
	item_cost = 24
	path = /obj/item/gun/energy/crossbow

/* /datum/uplink_item/item/visible_weapons/pikecube    Urist Specific Change - Moved to Stealthy Catergory to be in the same area as the carp cube.
	name = "Pike Cube"
	desc = "While it looks like a normal monkey cube, the animal produced is, instead, a space pike. \ Note: The space pike does not like you."
	item_cost = 36
	path = /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/pikecube
*/

/datum/uplink_item/item/visible_weapons/katana
	name = "Katana"
	desc = "A large sharpened steel blade capable of cutting through anything but the thickest armor."
	item_cost = 24
	path = /obj/item/material/sword/katana

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	desc = "A hilt, that when activated, creates a solid beam of pure energy in the form of a sword. \
			Able to slice through people like butter!"
	item_cost = 32
	path = /obj/item/melee/energy/sword
	antag_costs = list(MODE_PARANOIA = 96)

/datum/uplink_item/item/visible_weapons/silenced
	name = "Silenced Holdout Pistol (9mm)"
	desc = "A kit with a pocket-sized holdout 9mm pistol, silencer, and an extra magazine. \
			Attaching the silencer will make it too big to conceal in your pocket."
	item_cost = 20
	path = /obj/item/storage/box/syndie_kit/silenced

/datum/uplink_item/item/visible_weapons/broomstick
	name = "Broomstick Pistol (9mm)"
	desc = "An antique 9mm pistol stolen from a museum. Be warned, it may be faulty and comes unloaded."
	item_cost = 40
	path = /obj/item/gun/projectile/pistol/broomstick

/datum/uplink_item/item/badassery/money_cannon
	name = "Modified Money Cannon"
	item_cost = 48
	path = /obj/item/gun/launcher/money/hacked
	desc = "Too much money? Not enough screaming? Try the Money Cannon."

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	desc = "A energy based sidearm with three different lethality settings."
	item_cost = 24
	path = /obj/item/gun/energy/gun

/datum/uplink_item/item/visible_weapons/revolver //357 and 44 revolvers are functionally identical
	name = "Magnum Revolver (15mm)"
	desc = "A 15mm magnum revolver, with ammunition."
	item_cost = 36
	path = /obj/item/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/ionpistol
	name = "Ion Pistol"
	desc = "Ion rifle in compact form."
	item_cost = 50
	path = /obj/item/gun/energy/ionrifle/small

/datum/uplink_item/item/visible_weapons/grenade_launcher
	name = "Grenade Launcher"
	desc = "A pump action grenade launcher loaded with a random assortment of grenades."
	item_cost = 60
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/gun/launcher/grenade/loaded

//These are for traitors (or other antags, perhaps) to have the option of purchasing some merc gear.
/datum/uplink_item/item/visible_weapons/submachinegun
	name = "C20r Submachine Gun (10mm)"
	item_cost = 64
	path = /obj/item/gun/projectile/automatic/c20r

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "STS-35 Assault Rifle (7.62mm)"
	item_cost = 68
	path = /obj/item/gun/projectile/automatic/sts35

/datum/uplink_item/item/visible_weapons/battlerifle
	name = "Battle Rifle (5.56mm)"
	desc = "Predecessor to the Assault Rifle, works just as well as the new guns."
	item_cost = 65
	path = /obj/item/gun/projectile/automatic/battlerifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/semistrip
	name = "Carbine Rifle (15mm)"
	desc = "For arming your comrades on the (not so) cheap!"
	item_cost = 55
	path = /obj/item/gun/projectile/sniper/semistrip
	antag_roles = list(MODE_REVOLUTIONARY, MODE_MERCENARY)


/datum/uplink_item/item/visible_weapons/advanced_energy_gun
	name = "Advanced Energy Gun"
	item_cost = 68
	path = /obj/item/gun/energy/gun/nuclear

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "Anti-materiel Rifle with ammunition"
	item_cost = 96
	path = /obj/item/storage/secure/briefcase/heavysniper
	antag_costs = list(MODE_PARANOIA = 300)

/*
/datum/uplink_item/item/visible_weapons/psi_amp
	name = "Cerebroenergetic Psionic Amplifier"
	item_cost = 50
	path = /obj/item/clothing/head/helmet/space/psi_amp/lesser
	desc = "A powerful, illegal psi-amp. Boosts latent psi-faculties to extremely high levels."
*/

/datum/uplink_item/item/visible_weapons/machine_pistol
	name = "Machine Pistol (10mm)"
	desc = "A high rate of fire weapon in a smaller form factor, able to sling standard ammunition almost as quick as a submachine gun."
	item_cost = 45
	path = /obj/item/gun/projectile/automatic/machine_pistol

/datum/uplink_item/item/visible_weapons/combat_shotgun
	name = "Combat Shotgun (12g)"
	desc = "A high compacity, pump-action shotgun regularly used for repelling boarding parties in close range scenarios."
	item_cost = 52
	path = /obj/item/gun/projectile/shotgun/pump/combat
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun (12g)"
	desc = "A shortened double-barrel shotgun, able to fire either one, or both, barrels at once."
	item_cost = 40
	path = /obj/item/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/deagle
	name = "Magnum Pistol (15mm)"
	desc = "A 15mm pistol that packs a punch."
	item_cost = 60
	path = /obj/item/gun/projectile/pistol/magnum_pistol

/datum/uplink_item/item/visible_weapons/sigsauer
	name = "Military Pistol (10mm)"
	item_cost = 40
	path = /obj/item/gun/projectile/pistol/optimus

/datum/uplink_item/item/visible_weapons/detective_revolver
	name = "Small Revolver (9mm)"
	desc = "A pocket-sized holdout revolver. Easily concealable."
	item_cost = 24
	path = /obj/item/gun/projectile/revolver/holdout

/datum/uplink_item/item/visible_weapons/pulserifle
	name = "Pulse Rifle"
	desc = "A triple burst, heavy laser rifle, with a large battery compacity."
	item_cost = 68
	path = /obj/item/gun/energy/pulse_rifle
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/visible_weapons/flechetterifle
	name = "Flechette Rifle"
	desc = "A railgun with two togglable fire modes, able to launch flechette ammunition at incredible speeds."
	item_cost = 60
	path = /obj/item/gun/magnetic/railgun/flechette

/datum/uplink_item/item/visible_weapons/railgun // Like a semi-auto AMR
	name = "Railgun"
	desc = "An anti-armour magnetic launching system fed by a high-capacity matter cartridge, \
			capable of firing slugs at intense speeds."
	item_cost = 65
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/gun/magnetic/railgun

/datum/uplink_item/item/visible_weapons/railguntcc // Only slightly better than the normal railgun; but cooler looking
	name = "Advanced Railgun"
	desc = "A modified prototype of the original railgun implement, this time boring slugs out of steel rods loaded into the chamber, \
			now with even MORE stopping power."
	antag_roles = list(MODE_MERCENARY)
	item_cost = 75
	path = /obj/item/gun/magnetic/railgun/tcc

/datum/uplink_item/item/visible_weapons/harpoonbomb
	name = "Explosive Harpoon"
	item_cost = 16
	path = /obj/item/material/harpoon/bomb

/datum/uplink_item/item/visible_weapons/incendiary_laser
	name = "Incendiary Laser Blaster"
	desc = "A laser weapon developed and subsequently banned in Sol space, it sets its targets on fire with dispersed laser technology. \
			Most of these blasters were swiftly bought back and destroyed - but not this one."
	item_cost = 40
	path = /obj/item/gun/energy/incendiary_laser

/datum/uplink_item/item/visible_weapons/boltaction
	name = "Bolt Action Rifle (7.62mm)"
	desc = "For arming your comrades on the cheap!"
	item_cost = 12
	path = /obj/item/gun/projectile/heavysniper/boltaction
	antag_roles = list(MODE_REVOLUTIONARY)

/datum/uplink_item/item/visible_weapons/ionpistol
	name = "Ion Pistol"
	desc = "Ion rifle in compact form."
	item_cost = 36	// TC in line with Magnums/Heavy .44's, to reflect it's nuking capability on Synths.
	path = /obj/item/gun/energy/ionrifle/small
