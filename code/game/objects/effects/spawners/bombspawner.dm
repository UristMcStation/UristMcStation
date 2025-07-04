/* The old single tank bombs that dont really work anymore
/obj/spawner/bomb
	name = "bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	var/btype = 0  //0 = radio, 1= prox, 2=time
	var/explosive = 1	// 0= firebomb
	var/btemp = 500	// bomb temperature (degC)
	var/active = 0

/obj/spawner/bomb/radio
	btype = 0

/obj/spawner/bomb/proximity
	btype = 1

/obj/spawner/bomb/timer
	btype = 2

/obj/spawner/bomb/timer/syndicate
	btemp = 450

/obj/spawner/bomb/suicide
	btype = 3

/obj/spawner/bomb/New()
	..()

	switch (src.btype)
		// radio
		if (0)
			var/obj/item/assembly/r_i_ptank/R = new /obj/item/assembly/r_i_ptank(src.loc)
			var/obj/item/tank/phoron/p3 = new /obj/item/tank/phoron(R)
			var/obj/item/device/radio/signaler/p1 = new /obj/item/device/radio/signaler(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive
			p1.b_stat = 0
			p2.secured = 1
			p3.air_contents.temperature = btemp + T0C

		// proximity
		if (1)
			var/obj/item/assembly/m_i_ptank/R = new /obj/item/assembly/m_i_ptank(src.loc)
			var/obj/item/tank/phoron/p3 = new /obj/item/tank/phoron(R)
			var/obj/item/device/prox_sensor/p1 = new /obj/item/device/prox_sensor(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive

			p3.air_contents.temperature = btemp + T0C
			p2.secured = 1

			if(src.active)
				R.part1.secured = 1
				R.part1.icon_state = text("motion[]", 1)
				R.c_state(1, src)

		// timer
		if (2)
			var/obj/item/assembly/t_i_ptank/R = new /obj/item/assembly/t_i_ptank(src.loc)
			var/obj/item/tank/phoron/p3 = new /obj/item/tank/phoron(R)
			var/obj/item/device/timer/p1 = new /obj/item/device/timer(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			p1.master = R
			p2.master = R
			p3.master = R
			R.status = explosive

			p3.air_contents.temperature = btemp + T0C
			p2.secured = 1
		//bombvest
		if(3)
			var/obj/item/clothing/suit/armor/a_i_a_ptank/R = new /obj/item/clothing/suit/armor/a_i_a_ptank(src.loc)
			var/obj/item/tank/phoron/p4 = new /obj/item/tank/phoron(R)
			var/obj/item/device/scanner/health/p1 = new /obj/item/device/scanner/health(R)
			var/obj/item/device/igniter/p2 = new /obj/item/device/igniter(R)
			var/obj/item/clothing/suit/armor/vest/p3 = new /obj/item/clothing/suit/armor/vest(R)
			R.part1 = p1
			R.part2 = p2
			R.part3 = p3
			R.part4 = p4
			p1.master = R
			p2.master = R
			p3.master = R
			p4.master = R
			R.status = explosive

			p4.air_contents.temperature = btemp + T0C
			p2.secured = 1

	qdel(src)
*/

/client/proc/spawn_tanktransferbomb()
	set category = "Debug"
	set desc = "Spawn a tank transfer valve bomb"
	set name = "Instant TTV"

	if(!check_rights(R_SPAWN)) return

	var/obj/spawner/newbomb/proto = /obj/spawner/newbomb/radio/custom

	var/p = input("Enter phoron amount (mol):","Phoron", initial(proto.phoron_amt)) as num|null
	if(isnull(p)) return

	var/o = input("Enter oxygen amount (mol):","Oxygen", initial(proto.oxygen_amt)) as num|null
	if(isnull(o)) return

	var/c = input("Enter carbon dioxide amount (mol):","Carbon Dioxide", initial(proto.carbon_amt)) as num|null
	if(isnull(c)) return

	new /obj/spawner/newbomb/radio/custom(get_turf(mob), p, o, c)

/obj/spawner/newbomb
	name = "TTV bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

	var/assembly_type = /obj/item/device/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/phoron_amt = 12
	var/oxygen_amt = 18
	var/carbon_amt = 0

/obj/spawner/newbomb/traitor
	name = "TTV bomb - traitor"
	assembly_type = /obj/item/device/assembly/signaler
	phoron_amt = 14
	oxygen_amt = 21

/obj/spawner/newbomb/timer
	name = "TTV bomb - timer"
	assembly_type = /obj/item/device/assembly/timer

/obj/spawner/newbomb/timer/syndicate
	name = "TTV bomb - merc"
	//High yield bombs. Yes, it is possible to make these with toxins
	phoron_amt = 16.5
	oxygen_amt = 23.5

/obj/spawner/newbomb/proximity
	name = "TTV bomb - proximity"
	assembly_type = /obj/item/device/assembly/prox_sensor

/obj/spawner/newbomb/radio/custom/New(newloc, ph, ox, co)
	if(ph != null) phoron_amt = ph
	if(ox != null) oxygen_amt = ox
	if(co != null) carbon_amt = co
	..()

/obj/spawner/newbomb/Initialize()
	..()
	var/obj/item/device/transfer_valve/V = new(src.loc)
	var/obj/item/tank/phoron/PT = new(V)
	var/obj/item/tank/oxygen/OT = new(V)

	V.tank_one = PT
	V.tank_two = OT

	PT.master = V
	OT.master = V

	SET_FLAGS(PT.tank_flags, TANK_FLAG_WELDED)
	PT.air_contents.gas[GAS_PHORON] = phoron_amt
	PT.air_contents.gas[GAS_CO2] = carbon_amt
	PT.air_contents.total_moles = phoron_amt + carbon_amt
	PT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE+1
	PT.air_contents.update_values()

	SET_FLAGS(OT.tank_flags, TANK_FLAG_WELDED)
	OT.air_contents.gas[GAS_OXYGEN] = oxygen_amt
	OT.air_contents.total_moles = oxygen_amt
	OT.air_contents.temperature = PHORON_MINIMUM_BURN_TEMPERATURE+1
	OT.air_contents.update_values()


	var/obj/item/device/assembly/S = new assembly_type(V)


	V.attached_device = S

	S.holder = V
	S.set_secure(TRUE)

	V.update_icon()
	return INITIALIZE_HINT_QDEL

///////////////////////
//One Tank Bombs, WOOOOOOO! -Luke
///////////////////////

/obj/spawner/onetankbomb
	name = "Single-tank bomb"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

//	var/assembly_type = /obj/item/device/assembly/signaler

	//Note that the maximum amount of gas you can put in a 70L air tank at 1013.25 kPa and 519K is 16.44 mol.
	var/phoron_amt = 0
	var/oxygen_amt = 0

/obj/spawner/onetankbomb/New(newloc) //just needs an assembly.
	..(newloc)

	var/type = pick(/obj/item/tank/phoron/onetankbomb, /obj/item/tank/oxygen/onetankbomb)
	new type(src.loc)

	qdel(src)

//the other type of bomb spawner for use in mapping to make more accurate destroyed places
/obj/spawner/bomb_simulator
	var/severity = EX_ACT_LIGHT
	var/ex_range = 9

/obj/spawner/bomb_simulator/LateInitialize()
	. = ..()
	explosion(loc, ex_range, severity, adminlog = FALSE)

/obj/spawner/bomb_simulator/heavy
	severity = EX_ACT_HEAVY
