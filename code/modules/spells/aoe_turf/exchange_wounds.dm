/spell/aoe_turf/exchange_wounds
	name = "Exchange Wounds"
	desc = "Syphon the wounds from your allies."
	feedback = "EW"
	school = "transmutation"
	invocation = "Esh Yek Vai!"
	invocation_type = SpI_SHOUT
	charge_max = 400
	spell_flags = 0

	var/amt_healed = 0
	var/heal_max = 100
	range = 4
	inner_radius = 0
	number_of_channels = 0
	time_between_channels = 20

	hud_state = "wiz_exchange"

/spell/aoe_turf/exchange_wounds/perform()
	amt_healed = 0
	..()

/spell/aoe_turf/exchange_wounds/cast(list/targets, mob/living/user)
	new /obj/temporary(get_turf(user),10,'icons/effects/effects.dmi',"purple_electricity_constant")
	for(var/t in targets)
		for(var/mob/living/L in t)
			if(L.faction != user.faction)
				continue
			new /obj/temporary(get_turf(L),10,'icons/effects/effects.dmi',"green_sparkles")
			if(L.getBruteLoss() > 10)
				L.adjustBruteLoss(-10)
				user.adjustBruteLoss(10)
				amt_healed += 10
			if(L.getFireLoss() > 10)
				L.adjustFireLoss(-10)
				user.adjustFireLoss(10)
				amt_healed += 10
