/datum/mind
	var/list/learned_spells

/mob/Stat()
	. = ..()
	if(. && ability_master && ability_master.spell_objects)
		for(var/obj/screen/ability/spell/screen in ability_master.spell_objects)
			var/spell/S = screen.spell
			if((!S.connected_button) || !statpanel(S.panel))
				continue //Not showing the noclothes spell
			switch(S.charge_type)
				if(Sp_RECHARGE)
					statpanel(S.panel,"[S.charge_counter/10.0]/[S.charge_max/10]",S.connected_button)
				if(Sp_CHARGES)
					statpanel(S.panel,"[S.charge_counter]/[S.charge_max]",S.connected_button)
				if(Sp_HOLDVAR)
					statpanel(S.panel,"[S.holder_var_type] [S.holder_var_amount]",S.connected_button)


/proc/restore_spells(mob/H)
	if(H.mind && H.mind.learned_spells)
		var/list/spells = list()
		for(var/spell/spell_to_remove in H.mind.learned_spells) //remove all the spells from other people.
			if(ismob(spell_to_remove.holder))
				var/mob/M = spell_to_remove.holder
				spells += spell_to_remove
				M.remove_spell(spell_to_remove)

		for(var/spell/spell_to_add in spells)
			H.add_spell(spell_to_add)
	H.ability_master.update_abilities(0,H)

/mob/proc/add_spell(spell/spell_to_add, spell_base = "wiz_spell_ready")
	if(!ability_master)
		ability_master = new()
	spell_to_add.holder = src
	if(mind)
		if(!mind.learned_spells)
			mind.learned_spells = list()
		mind.learned_spells |= spell_to_add
	ability_master.add_spell(spell_to_add, spell_base)
	return 1

/mob/proc/remove_spell(spell/spell_to_remove)
	if(!spell_to_remove || !istype(spell_to_remove))
		return

	if(mind)
		mind.learned_spells -= spell_to_remove
	if (ability_master)
		ability_master.remove_ability(ability_master.get_ability_by_spell(spell_to_remove))
	return 1

/mob/proc/silence_spells(amount = 0)
	if(amount < 0)
		return

	if(!ability_master)
		return

	ability_master.silence_spells(amount)
