//Something tells me i'm going to regret this. -a-k22

#define POWER_CONVERSION_EFFICENCY 0.35

/obj/machinery/shipweapons/charge
	name = "charge weapon"
	desc = "You shouldn't be seeing this, but if you are, ignore it."
	var/obj/machinery/power/smes/buildable/capacitor //Our power storage unit. We draw from this when we fire.
	var/found_smes = 0 //Have we found our SMES unit?
	rechargerate = 2 MINUTES //should be pretty long, given how powerful these can get!
	var/shield_damage_ratio = 1 //Some weapons are better against hull; others against shielding.
	var/hull_damage_ratio = 1
	var/power_use_ratio = 0.20 //Use 20% of our capacitor's charge at a time.
	var/id //Used for finding SMES units.

/obj/machinery/shipweapons/charge/beam/lightlaser
	name = "bombast laser cannon"
	shielddamage = 200
	hulldamage = 100
	icon_state = "lasercannon"
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'
	idle_power_usage = 10
	active_power_usage = 2000
	component_hit = 20
	projectile_type = /obj/item/projectile/beam/ship/lightlaser
	fire_anim = 5
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/machinery/shipweapons/charge/Process()
	locate_capacitor()
	if(!capacitor)
		found_smes = 0
	if(!charged && !recharging)
		Charging()

	..()

/obj/machinery/shipweapons/charge/Fire()
	if(!capacitor)
		return
	var/power_to_use = capacitor.capacity * power_use_ratio
	if(capacitor.charge < power_to_use)
		return
	capacitor.charge -= power_to_use //use the power
	power_to_use = power_to_use * POWER_CONVERSION_EFFICENCY //Converting power isn't efficent, take the angel's share.
	shielddamage = power_to_use * shield_damage_ratio //Apply hull/shield damage ratios.
	hulldamage = power_to_use * hull_damage_ratio
	..() // then do the rest of the stuff, sure.

/obj/machinery/shipweapons/charge/proc/locate_capacitor()
	if(!found_smes && !capacitor)
		for(var/obj/machinery/power/smes/buildable/C in orange(2))
			capacitor = C
			found_smes = 1

#undef POWER_CONVERSION_EFFICENCY
