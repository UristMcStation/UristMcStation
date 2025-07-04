/spell/targeted/equip_item/dyrnwyn
	name = "Summon Dyrnwyn"
	desc = "Summons the legendary sword of Rhydderch Hael, said to draw in flame when held by a worthy man."
	feedback = "SD"
	charge_type = Sp_HOLDVAR
	holder_var_type = "fireloss"
	holder_var_amount = 10
	school = "conjuration"
	invocation = "Anrhydeddu Fi!"
	invocation_type = SpI_SHOUT
	spell_flags = INCLUDEUSER
	range = 0
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)
	duration = 30 SECONDS
	max_targets = 1
	equipped_summons = list("active hand" = /obj/item/material/sword)
	delete_old = 0
	var/material = MATERIAL_STEEL

	hud_state = "gen_immolate"


/spell/targeted/equip_item/dyrnwyn/summon_item(new_type)
	var/obj/item/W = new new_type (null, material)
	W.SetName("Dyrnwyn")
	W.damtype = DAMAGE_BURN
	W.hitsound = 'sound/items/Welder2.ogg'
	W.slowdown_per_slot[slot_l_hand] = 0.25
	W.slowdown_per_slot[slot_r_hand] = 0.25
	return W

/spell/targeted/equip_item/dyrnwyn/check_valid_targets(list/targets)
	return TRUE

/spell/targeted/equip_item/dyrnwyn/empower_spell()
	if(!..())
		return 0

	material = MATERIAL_PLASTEEL
	return "Dyrnwyn has been refined: it is now made of plasteel."

/spell/targeted/equip_item/dyrnwyn/tower
	charge_max = 1
