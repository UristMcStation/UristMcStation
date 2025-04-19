/spell/aoe_turf/conjure/summonrandomstuff
	name = "Summon Random Items"
	desc = "This spell summons random, mostly useless items."
	invocation_type = SpI_EMOTE
	invocation = "does some jazz hands!"
	summon_type = list(
		/obj/item/reagent_containers/food/snacks/sliceable/cheesewheel/fresh,
		/obj/item/reagent_containers/food/snacks/cheesewedge/fresh,
		/obj/item/glass_jar,
		/obj/item/gun/launcher/foam/revolver,
		/obj/item/reagent_containers/food/condiment/small/saltshaker,
		/obj/random/action_figure,
		/obj/random/toy,
		/obj/random/soap,
		/obj/random/pen,
		/obj/random/cuteanimal,
		/obj/random/utensil,
		/obj/random/tool,
		/obj/random/plushie,
		/obj/random/snack,
		/obj/random/mre/dessert,
		/obj/random/coin,
		/obj/item/reagent_containers/food/snacks/checker,
		/obj/item/material/ashtray,
		/obj/random/dice,
		/obj/random/single/playing_cards,
		/obj/random/single/cola,
		/obj/item/mirror,
		/obj/item/clothing/accessory/kneepads,
		/obj/item/book/manual/security_space_law/urist,
		/obj/random/smokes,
		/obj/item/papercrafts/airplane,
		/obj/item/stamp/denied,
		/obj/item/clothing/gloves/insulated/cheap,
		/obj/random/drinkbottle,
		/obj/item/caution,
		/obj/item/stool/urist/bar,
		/obj/item/paper
		)
	summon_amt = 5
	range = 3
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 0, Sp_POWER = 3)
	hud_state = "friendly"

/spell/aoe_turf/conjure/summonrandomstuff/empower_spell()
	if(!..())
		return 0

	if(spell_levels[Sp_POWER]%2 == 1)
		summon_amt += 5
		range += 1

	return "The spell [src] now summons more items at a greater distance."
