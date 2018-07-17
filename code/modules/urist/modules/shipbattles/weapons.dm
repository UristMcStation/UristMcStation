/obj/machinery/shipweapons
	name = "shipweapon"
	var/passshield = 0
	var/shielddamage = 0
	var/hulldamage = 0
	var/shipid = null
	var/canfire = 0
	var/recharging = 0
	var/charged = 0
	var/rechargerate = 100
	var/chargingicon = null
	var/chargedicon = null

/obj/machinery/shipweapons/Initialize()
	for(var/obj/machinery/computer/combatcomputer/CC in SSmachines.machinery)
		CC.linkedweapons += src
	..()

/obj/machinery/shipweapons/Process()
	..()

/obj/machinery/shipweapons/missile
	icon = 'icons/urist/96x96.dmi'
	passshield = 1
	var/loaded = 0

/obj/machinery/shipweapons/missile/torpedo
	name = "torpedo launcher"
	icon_state = "torpedo"
	hulldamage = 400 //maybe

/obj/machinery/shipweapons/beam
	var/charging = 0
	icon = 'icons/urist/structures&machinery/64x64machinery.dmi'

/obj/machinery/shipweapons/beam/lightlaser
	name = "light laser cannon"
	shielddamage = 200
	hulldamage = 200
	icon_state = "beamcannon"

/obj/machinery/shipweapons/beam/ion
	name = "ion cannon"
	shielddamage = 400
