/spell/targeted/equip_item/seed
	name = "Summon Seed"
	desc = "This spell summons a random seed into the hand of the wizard."
	feedback = "SE"
	delete_old = 0

	spell_flags = INCLUDEUSER | NEEDSCLOTHES
	invocation_type = SpI_WHISPER
	invocation = "Ria'li  akta."

	equipped_summons = list("active hand" = /obj/item/seeds/random)
	compatible_mobs = list(/mob/living/carbon/human)

	charge_max = 1 MINUTE
	cooldown_min = 20 SECONDS
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 0)

	range = 0
	max_targets = 1

	hud_state = "wiz_seed"

/spell/targeted/equip_item/seed/check_valid_targets(list/targets)
	return TRUE
