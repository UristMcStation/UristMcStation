// BUILDABLE SMES(Superconducting Magnetic Energy Storage) UNIT
//
// Last Change 1.1.2015 by Atlantis - Happy New Year!
//
// This is subtype of SMES that should be normally used. It can be constructed, deconstructed and hacked.
// It also supports RCON System which allows you to operate it remotely, if properly set.

//MAGNETIC COILS - These things actually store and transmit power within the SMES. Different types have different
/obj/item/stock_parts/smes_coil
	name = "superconductive magnetic coil"
	desc = "Standard superconductive magnetic coil with average capacity and I/O rating."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	w_class = ITEM_SIZE_LARGE							// It's LARGE (backpack size)
	origin_tech = list(TECH_MATERIAL = 7, TECH_POWER = 7, TECH_ENGINEERING = 5)
	base_type = /obj/item/stock_parts/smes_coil
	part_flags = PART_FLAG_HAND_REMOVE
	var/ChargeCapacity = 50 KILOWATTS
	var/IOCapacity = 250 KILOWATTS

// 20% Charge Capacity, 60% I/O Capacity. Used for substation/outpost SMESs.
/obj/item/stock_parts/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "Cheaper model of standard superconductive magnetic coil. It's capacity and I/O rating are considerably lower."
	icon_state = "smes_coil_weak"
	ChargeCapacity = 10 KILOWATTS
	IOCapacity = 150 KILOWATTS

// 500% Charge Capacity, 40% I/O Capacity. Holds a lot of energy, but charges slowly if not combined with other coils. Ideal for backup storage.
/obj/item/stock_parts/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "Specialised version of standard superconductive magnetic coil. This one has significantly stronger containment field, allowing for significantly larger power storage. It's IO rating is much lower, however."
	icon_state = "smes_coil_capacitance"
	ChargeCapacity = 250 KILOWATTS
	IOCapacity = 100 KILOWATTS

// 40% Charge Capacity, 500% I/O Capacity. Technically turns SMES into large super capacitor. Ideal for shields.
/obj/item/stock_parts/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "Specialised version of standard superconductive magnetic coil. While this one won't store almost any power, it rapidly transfers current, making it useful in systems which require large throughput."
	icon_state = "smes_coil_transmission"
	ChargeCapacity = 20 KILOWATTS
	IOCapacity = 1.25 MEGAWATTS

// A superpowered coil to be used on event SMES units, away sites that run lots of power, and maybe as a rare merchant item.
/obj/item/stock_parts/smes_coil/advanced
	name = "advanced magnetic coil"
	desc = " An advanced magnetic coil made from rare materials. Can store and transfer more power than any previous designs."
	ChargeCapacity = 500 KILOWATTS
	IOCapacity = 2.5 MEGAWATTS


// DEPRECATED
// These are used on individual outposts as backup should power line be cut, or engineering outpost lost power.
// 1M Charge, 150K I/O
/obj/machinery/power/smes/buildable/outpost_substation
	uncreated_component_parts = list(/obj/item/stock_parts/smes_coil/weak = 1)

// This one is pre-installed on engineering shuttle. Allows rapid charging/discharging for easier transport of power to outpost
// 11M Charge, 2.5M I/O
/obj/machinery/power/smes/buildable/power_shuttle
	uncreated_component_parts = list(
		/obj/item/stock_parts/smes_coil/super_io = 2,
		/obj/item/stock_parts/smes_coil = 1)

// END SMES SUBTYPES

// SMES itself
/obj/machinery/power/smes/buildable
	var/safeties_enabled = 1 	// If 0 modifications can be done without discharging the SMES, at risk of critical failure.
	var/failing = 0 			// If 1 critical failure has occured and SMES explosion is imminent.
	wires = /datum/wires/smes
	var/grounding = 1			// Cut to quickly discharge, at cost of "minor" electrical issues in output powernet.
	var/RCon = 1				// Cut to disable AI and remote control.
	var/RCon_tag = "NO_TAG"		// RCON tag, change to show it on SMES Remote control console.
	var/emp_proof = 0			// Whether the SMES is EMP proof

	charge = 0
	should_be_mapped = 1
	base_type = /obj/machinery/power/smes/buildable
	maximum_component_parts = list(/obj/item/stock_parts/smes_coil = 6, /obj/item/stock_parts = 15)
	interact_offline = TRUE

/obj/machinery/power/smes/buildable/malf_upgrade(mob/living/silicon/ai/user)
	..()
	malf_upgraded = 1
	emp_proof = 1
	RefreshParts()
	to_chat(user, "\The [src] has been upgraded. It's transfer rate and capacity has increased, and it is now resistant against EM pulses.")
	return 1


/obj/machinery/power/smes/buildable/max_cap_in_out/Initialize()
	. = ..()
	charge = capacity
	input_attempt = TRUE
	output_attempt = TRUE
	input_level = input_level_max
	output_level = output_level_max


/obj/machinery/power/smes/buildable/Destroy()
	for(var/datum/nano_module/rcon/R in world)
		R.FindDevices()
	return ..()

// Proc: process()
// Parameters: None
// Description: Uses parent process, but if grounding wire is cut causes sparks to fly around.
// This also causes the SMES to quickly discharge, and has small chance of damaging output APCs.
/obj/machinery/power/smes/buildable/Process()
	if(!grounding && (Percentage() > 5))
		var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
		s.set_up(5, 1, src)
		s.start()
		charge -= (output_level_max * CELLRATE)
		if(powernet && prob(1)) // Small chance of overload occuring since grounding is disabled.
			powernet.apcs_overload(5,10,20)

	..()

// Proc: attack_ai()
// Parameters: None
// Description: AI requires the RCON wire to be intact to operate the SMES.
/obj/machinery/power/smes/buildable/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	if(RCon)
		..()
	else // RCON wire cut
		to_chat(user, SPAN_WARNING("Connection error: Destination Unreachable."))

// Proc: recalc_coils()
// Parameters: None
// Description: Updates properties (IO, capacity, etc.) of this SMES by checking internal components.
/obj/machinery/power/smes/buildable/RefreshParts()
	..()
	capacity = 0
	input_level_max = 0
	output_level_max = 0
	for(var/obj/item/stock_parts/smes_coil/C in component_parts)
		capacity += C.ChargeCapacity
		input_level_max += C.IOCapacity
		output_level_max += C.IOCapacity
	if(malf_upgraded)
		capacity *= 1.2
		input_level_max *= 2
		output_level_max *= 2
	charge = clamp(charge, 0, capacity)

// Proc: total_system_failure()
// Parameters: 2 (intensity - how strong the failure is, user - person which caused the failure)
// Description: Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/power/smes/buildable/proc/total_system_failure(intensity = 0, mob/user as mob)
	// SMESs store very large amount of power. If someone screws up (ie: Disables safeties and attempts to modify the SMES) very bad things happen.
	// Bad things are based on charge percentage.
	// Possible effects:
	// Sparks - Lets out few sparks, mostly fire hazard if phoron present. Otherwise purely aesthetic.
	// Shock - Depending on intensity harms the user. Insultated Gloves protect against weaker shocks, but strong shock bypasses them.
	// EMP Pulse - Lets out EMP pulse discharge which screws up nearby electronics.
	// Light Overload - X% chance to overload each lighting circuit in connected powernet. APC based.
	// APC Failure - X% chance to destroy APC causing very weak explosion too. Won't cause hull breach or serious harm.
	// SMES Explosion - X% chance to destroy the SMES, in moderate explosion. May cause small hull breach.

	if (!intensity)
		return

	var/mob/living/carbon/human/h_user = null
	if (!istype(user, /mob/living/carbon/human))
		return
	else
		h_user = user


	// Preparations
	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	// Check if user has protected gloves.
	var/user_protected = 0
	if(h_user.gloves)
		var/obj/item/clothing/gloves/G = h_user.gloves
		if(G.siemens_coefficient == 0)
			user_protected = 1
	log_and_message_admins("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [user.ckey], Intensity: [intensity]/100", user, src)


	switch (intensity)
		if (0 to 15)
			// Small overcharge
			// Sparks, Weak shock
			s.set_up(2, 1, src)
			s.start()
			if(user_protected && prob(80))
				to_chat(h_user, SPAN_WARNING("Small electrical arc almost burns your hand. Luckily you had your gloves on!"))
			else
				to_chat(h_user, SPAN_DANGER("Small electrical arc sparks and burns your hand as you touch the [src]!"))
				h_user.electrocute_act(rand(5,20), src, def_zone = h_user.hand ? BP_L_HAND : BP_R_HAND)//corrected to counter act armor and stuff
			charge = 0

		if (16 to 35)
			// Medium overcharge
			// Sparks, Medium shock, Weak EMP
			s.set_up(4,1,src)
			s.start()
			if (user_protected && prob(25))
				to_chat(h_user, SPAN_WARNING("Medium electrical arc sparks and almost burns your hand. Luckily you had your gloves on!"))
			else
				to_chat(h_user, SPAN_DANGER("Medium electrical sparks as you touch the [src], severely burning your hand!"))
				h_user.electrocute_act(rand(15,35), src, def_zone = h_user.hand ? BP_L_HAND : BP_R_HAND)
			spawn(0)
				empulse(src.loc, 2, 4)
			if(powernet)
				powernet.apcs_overload(0, 5, 10)
			charge = 0

		if (36 to 60)
			// Strong overcharge
			// Sparks, Strong shock, Strong EMP, 10% light overload. 1% APC failure
			s.set_up(7,1,src)
			s.start()
			if (user_protected)
				to_chat(h_user, SPAN_DANGER("Strong electrical arc sparks between you and [src], ignoring your gloves and burning your hand!"))
				h_user.electrocute_act(rand(30,60), src, def_zone = h_user.hand ? BP_L_HAND : BP_R_HAND)
				h_user.Paralyse(3)
			else
				to_chat(h_user, SPAN_DANGER("Strong electrical arc sparks between you and [src], knocking you out for a while!"))
				h_user.electrocute_act(rand(40,80), src, def_zone = ran_zone(null))
				h_user.Paralyse(6)
			spawn(0)
				empulse(src.loc, 8, 16)
			charge = 0
			if(powernet)
				powernet.apcs_overload(1, 10, 20)
			energy_fail(10)
			src.ping("Caution. Output regulators malfunction. Uncontrolled discharge detected.")

		if (61 to INFINITY)
			// Massive overcharge
			// Sparks, Near - instantkill shock, Strong EMP, 25% light overload, 5% APC failure. 50% of SMES explosion. This is bad.
			s.set_up(10,1,src)
			s.start()
			to_chat(h_user, SPAN_WARNING("Massive electrical arc sparks between you and [src].<br>Last thing you can think about is [SPAN_CLASS("danger", "\"Oh shit...\"")]"))
			// Remember, we have few gigajoules of electricity here.. Turn them into crispy toast.
			h_user.electrocute_act(rand(170,210), src, def_zone = ran_zone(null))
			h_user.Paralyse(8)
			spawn(0)
				empulse(src.loc, 32, 64)
			charge = 0
			if(powernet)
				powernet.apcs_overload(5, 25, 100)
			energy_fail(30)
			src.ping("Caution. Output regulators malfunction. Significant uncontrolled discharge detected.")

			if (prob(50))
				// Added admin-notifications so they can stop it when griffed.
				log_and_message_admins("SMES explosion imminent.", user)
				src.ping("DANGER! Magnetic containment field unstable! Containment field failure imminent!")
				failing = 1
				// 30 - 60 seconds and then BAM!
				spawn(rand(300,600))
					if(!failing) // Admin can manually set this var back to 0 to stop overload, for use when griffed.
						update_icon()
						src.ping("Magnetic containment stabilised.")
						return
					src.ping("DANGER! Magnetic containment field failure in 3 ... 2 ... 1 ...")
					explosion(src.loc, 7)
					// Not sure if this is necessary, but just in case the SMES *somehow* survived..
					qdel(src)

/obj/machinery/power/smes/buildable/proc/check_total_system_failure(mob/user)
	// Probability of failure if safety circuit is disabled (in %)
	var/failure_probability = capacity ? round((charge / capacity) * 100) : 0

	// If failure probability is below 5% it's usually safe to do modifications
	if (failure_probability < 5)
		failure_probability = 0

	if (failure_probability && prob(failure_probability * (0.5)))// 0.5 - 1.5, step of 0.25
		total_system_failure(failure_probability, user)
		return TRUE

// Proc: update_icon()
// Parameters: None
// Description: Allows us to use special icon overlay for critical SMESs
/obj/machinery/power/smes/buildable/on_update_icon()
	if (failing)
		ClearOverlays()
		AddOverlays(image('icons/obj/machines/power/smes.dmi', "smes-crit"))
	else
		..()

/obj/machinery/power/smes/buildable/cannot_transition_to(state_path, mob/user)
	if(failing)
		return SPAN_WARNING("\The [src]'s screen is flashing with alerts. It seems to be overloaded! Touching it now is probably not a good idea.")

	if(state_path == /singleton/machine_construction/default/deconstructed)
		if(charge > (capacity/100) && safeties_enabled)
			return SPAN_WARNING("\The [src]'s safety circuit is preventing modifications while it's charged!")
		if(output_attempt || input_attempt)
			return SPAN_WARNING("Turn \the [src] off first!")
		if(!MACHINE_IS_BROKEN(src))
			return SPAN_WARNING("You have to disassemble the terminal[num_terminals > 1 ? "s" : ""] first!")
		if(user)
			if(!do_after(user, 5 SECONDS * number_of_components(/obj/item/stock_parts/smes_coil), src, DO_REPAIR_CONSTRUCT) && isCrowbar(user.get_active_hand()))
				return MCS_BLOCK
			if(check_total_system_failure(user))
				return MCS_BLOCK
	return ..()

/obj/machinery/power/smes/buildable/can_add_component(obj/item/stock_parts/component, mob/user)
	if(charge > (capacity/100) && safeties_enabled)
		to_chat(user,  SPAN_WARNING("\The [src]'s safety circuit is preventing modifications while it's charged!"))
		return FALSE
	. = ..()
	if(!.)
		return
	if(istype(component,/obj/item/stock_parts/smes_coil))
		if(output_attempt || input_attempt)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return FALSE
		if(!do_after(user, 0.1 SECONDS, src, DO_REPAIR_CONSTRUCT) || check_total_system_failure(user))
			return FALSE

/obj/machinery/power/smes/buildable/remove_part_and_give_to_user(path, mob/user)
	if(charge > (capacity/100) && safeties_enabled)
		to_chat(user,  SPAN_WARNING("\The [src]'s safety circuit is preventing modifications while it's charged!"))
		return
	if(ispath(path,/obj/item/stock_parts/smes_coil))
		if(output_attempt || input_attempt)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return
		if(!do_after(user, 0.1 SECONDS, src, DO_REPAIR_CONSTRUCT) || check_total_system_failure(user))
			return
	..()

/obj/machinery/power/smes/buildable/use_tool(obj/item/W, mob/living/user, list/click_params)
	// No more disassembling of overloaded SMESs. You broke it, now enjoy the consequences.
	if (failing)
		to_chat(user, SPAN_WARNING("\The [src]'s screen is flashing with alerts. It seems to be overloaded! Touching it now is probably not a good idea."))
		return TRUE

	// Multitool - change RCON tag
	if(isMultitool(W))
		var/newtag = input(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system") as text
		if(newtag)
			RCon_tag = newtag
			to_chat(user, SPAN_NOTICE("You changed the RCON tag to: [newtag]"))
		return TRUE

	return ..()

// Proc: toggle_input()
// Parameters: None
// Description: Switches the input on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_input()
	inputting(!input_attempt)
	update_icon()

// Proc: toggle_output()
// Parameters: None
// Description: Switches the output on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_output()
	outputting(!output_attempt)
	update_icon()

// Proc: set_input()
// Parameters: 1 (new_input - New input value in Watts)
// Description: Sets input setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_input(new_input = 0)
	input_level = clamp(new_input, 0, input_level_max)
	update_icon()

// Proc: set_output()
// Parameters: 1 (new_output - New output value in Watts)
// Description: Sets output setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_output(new_output = 0)
	output_level = clamp(new_output, 0, output_level_max)
	update_icon()

/obj/machinery/power/smes/buildable/emp_act(severity)
	if(emp_proof)
		return
	..(severity)
