/datum/spellbound_type
	var/name = "Stuff"
	var/desc = "spells n shit"
	var/equipment = list()
	var/spells = list()

/datum/spellbound_type/proc/spawn_servant(atom/a, mob/master, mob/user)
	set waitfor = 0
	var/mob/living/carbon/human/H = new(a)
	H.ckey = user.ckey
	H.change_appearance(APPEARANCE_BASIC)

	var/obj/item/implant/translator/natural/I = new()
	I.implant_in_mob(H, BP_HEAD)
	if (length(master.languages))
		var/datum/language/lang = master.languages[1]
		H.add_language(lang.name)
		H.set_default_language(lang)
		I.languages[lang.name] = 1

	modify_servant(equip_servant(H), H)
	set_antag(H.mind, master)
	var/name_choice = sanitize(input(H, "Choose a name. If you leave this blank, it will be defaulted to your current characters.", "Name change") as null|text, MAX_NAME_LEN)
	if(name_choice)
		H.SetName(name_choice)
		H.real_name = name_choice

/datum/spellbound_type/proc/equip_servant(mob/living/carbon/human/H)
	for(var/stype in spells)
		var/spell/S = new stype()
		S.spell_flags &= ~NEEDSCLOTHES
		H.add_spell(S)
	. = list()
	for(var/etype in equipment)
		var/obj/item/I = new etype(get_turf(H))
		if(istype(I, /obj/item/clothing))
			I.canremove = 0
		H.equip_to_slot_if_possible(I,equipment[etype], TRYEQUIP_REDRAW | TRYEQUIP_SILENT | TRYEQUIP_FORCE)
		. += I

/datum/spellbound_type/proc/set_antag(datum/mind/M, mob/master)
	return

/datum/spellbound_type/proc/modify_servant(list/items, mob/living/carbon/human/H)
	return

/datum/spellbound_type/apprentice
	name = "Apprentice"
	desc = "Summon your trusty apprentice, equipped with their very own spellbook."
	equipment = list(/obj/item/clothing/head/wizard = slot_head,
					/obj/item/clothing/under/color/lightpurple = slot_w_uniform,
					/obj/item/clothing/shoes/sandal = slot_shoes,
					/obj/item/staff = slot_r_hand,
					/obj/item/spellbook/apprentice = slot_l_hand,
					/obj/item/clothing/suit/wizrobe = slot_wear_suit)
	spells = list(/spell/noclothes)

/datum/spellbound_type/apprentice/set_antag(datum/mind/M, mob/master)
	GLOB.wizards.add_antagonist_mind(M,1,ANTAG_APPRENTICE,"<b>You are an apprentice-type Servant! You're just an ordinary Wizard-To-Be, with no special abilities, but do not need robes to cast spells. Follow your teacher's orders!</b>")
	M.current?.faction = master.faction

/datum/spellbound_type/servant
	var/spiel = "You don't do anything in particular."

/datum/spellbound_type/servant/set_antag(datum/mind/M, mob/master)
	GLOB.wizards.add_antagonist_mind(M,1,ANTAG_SERVANT, "<b>You are a [name]-type Servant!</b> [spiel]")
	M.current?.faction = master.faction

/datum/spellbound_type/servant/caretaker
	name = "Caretaker"
	desc = "A healer, a medic, a shoulder to cry on. This servant will heal you, even from near death."
	spiel = "<i>'The last enemy that will be destroyed is death.'</i> You can perceive any injuries with simple sight, and heal them with the Trance spell; potentially even reversing death itself! However, this comes at a price; Trance will become increasingly harder to use as you use it, until you can use it no longer. Be cautious, and aid your Master in any way possible!"
	equipment = list(/obj/item/clothing/under/caretaker = slot_w_uniform,
					/obj/item/clothing/shoes/dress/caretakershoes = slot_shoes)
	spells = list(/spell/toggle_armor/caretaker,
				/spell/targeted/heal_target/touch,
				/spell/aoe_turf/knock/slow,
				/spell/targeted/heal_target/area/slow,
				/spell/targeted/analyze,
				/spell/targeted/heal_target/trance
				)

/datum/spellbound_type/servant/champion
	name = "Champion"
	desc = "A knight in shining armor; a warrior, a protector, and a loyal friend."
	spiel = "Your sword and armor are second to none, but you have no unique supernatural powers beyond summoning the sword to your hands. Protect your Master with your life!"
	equipment = list(/obj/item/clothing/under/bluetunic = slot_w_uniform,
					/obj/item/clothing/shoes/jackboots/medievalboots = slot_shoes)
	spells = list(/spell/toggle_armor/champion,
				/spell/toggle_armor/excalibur)

/datum/spellbound_type/servant/familiar
	name = "Familiar"
	desc = "A friend! Or are they a pet? They can transform into animals, and take some particular traits from said creatures."
	spiel = "This form of yours is weak in comparison to your transformed form, but that certainly won't pose a problem, considering the fact that you have an alternative. Whatever it is you can turn into, use its powers wisely and serve your Master as well as possible!"
	equipment = list(/obj/item/clothing/head/familiarband = slot_head,
					/obj/item/clothing/under/familiargarb = slot_w_uniform)

/datum/spellbound_type/servant/familiar/modify_servant(list/equipment, mob/living/carbon/human/H)
	var/familiar_type
	switch(input(H,"Choose your desired animal form:", "Form") as anything in list("Space Pike", "Possum", "Cat", "Bear"))
		if("Space Pike")
			H.mutations |= mNobreath
			H.mutations |= MUTATION_SPACERES
			familiar_type = /mob/living/simple_animal/hostile/carp/pike
			var/spell/aoe_turf/conjure/mirage/M = new()
			H.add_spell(M)
			M.spell_flags &= ~NEEDSCLOTHES
		if("Possum")
			familiar_type = /mob/living/simple_animal/passive/opossum
			var/spell/aoe_turf/conjure/summonrandomstuff/srs = new()
			H.add_spell(srs)
		if("Cat")
			H.mutations |= mRun
			familiar_type = /mob/living/simple_animal/passive/cat/fluff/bones
			var/spell/targeted/exhude_pleasantness/ep = new()
			var/spell/aoe_turf/knock/k = new()
			var/spell/invisibility/i = new()
			H.add_spell(ep)
			H.add_spell(k)
			H.add_spell(i)
			i.spell_flags &= ~NEEDSCLOTHES
		if("Bear")
			var/obj/item/clothing/under/under = locate() in equipment
			var/obj/item/clothing/head/head = locate() in equipment

			var/datum/extension/armor/A = get_extension(under, /datum/extension/armor)
			if(A)
				A.armor_values = list(
					melee = ARMOR_MELEE_VERY_HIGH,
					bullet = ARMOR_BALLISTIC_PISTOL,
					laser = ARMOR_LASER_SMALL,
					energy = ARMOR_ENERGY_SMALL
					) //More armor
			A = get_extension(head, /datum/extension/armor)
			if(A)
				A.armor_values = list(
					melee = ARMOR_MELEE_RESISTANT,
					bullet = ARMOR_BALLISTIC_MINOR,
					laser = ARMOR_LASER_MINOR,
					energy = ARMOR_ENERGY_MINOR
					)
			familiar_type = /mob/living/simple_animal/hostile/bear
			var/spell/aoe_turf/exchange_wounds/ew = new()
			H.add_spell(ew)
			H.add_aura(new /obj/aura/regenerating/human(H))

	var/spell/targeted/shapeshift/familiar/F = new()
	F.possible_transformations = list(familiar_type)
	H.add_spell(F)

/datum/spellbound_type/servant/fiend
	name = "Fiend"
	desc = "A practitioner of dark and evil magics, almost certainly a demon, and possibly a lawyer."
	spiel = "The Summoning Ritual has bound you to this world with limited access to your infernal powers; you'll have to be strategic in how you use them. Follow your Master's orders as well as you can!"
	spells = list(/spell/targeted/projectile/dumbfire/fireball/firebolt,
				/spell/targeted/ethereal_jaunt,
				/spell/targeted/torment,
				/spell/area_teleport,
				/spell/hand/charges/blood_shard
				)

/datum/spellbound_type/servant/fiend/equip_servant(mob/living/carbon/human/H)
	var/outfit_gender = input(H, "Which outfit would you like?") in list("Masculine","Feminine")
	if(outfit_gender == "Masculine")
		equipment = list(/obj/item/clothing/under/lawyer/fiendsuit = slot_w_uniform,
						/obj/item/clothing/shoes/dress/devilshoes = slot_shoes)
		spells += /spell/toggle_armor/fiend
	else
		equipment = list(/obj/item/clothing/under/devildress = slot_w_uniform,
					/obj/item/clothing/shoes/dress/devilshoes = slot_shoes)
		spells += /spell/toggle_armor/fiend/fem
	..()

/datum/spellbound_type/servant/infiltrator
	name = "Infiltrator"
	desc = "A spy and a manipulator to the end, capable of hiding in plain sight and falsifying information to your heart's content."
	spiel = "On the surface, you are a completely normal person, but is that really all you are? People are so easy to fool, do as your Master says, and do it with style!"
	spells = list(/spell/toggle_armor/infil_items,
				/spell/targeted/exhude_pleasantness,
				/spell/targeted/genetic/blind/hysteria)

/datum/spellbound_type/servant/infiltrator/equip_servant(mob/living/carbon/human/H)
	var/outfit_gender = input(H, "Which outfit would you like?") in list("Masculine","Feminine")
	if(outfit_gender == "Masculine")
		equipment = list(/obj/item/clothing/under/lawyer/infil = slot_w_uniform,
						/obj/item/clothing/shoes/dress/infilshoes = slot_shoes)
		spells += /spell/toggle_armor/infiltrator
	else
		equipment = list(/obj/item/clothing/under/lawyer/infil/fem = slot_w_uniform,
					/obj/item/clothing/shoes/dress/infilshoes = slot_shoes)
		spells += /spell/toggle_armor/infiltrator/fem
	..()

/datum/spellbound_type/servant/overseer
	name = "Overseer"
	desc = "A ghost, or an imaginary friend; the Overseer is immune to space and can turn invisible at a whim, but has little offensive capabilities."
	spiel = "Physicality is not something you are familiar with. Indeed, injuries cannot slow you down, but you can't fight back, either! In addition to this, you can reach into the void and return the soul of a single departed crewmember via the revoke death verb, if so desired; this can even revive your Master, should they fall in combat before you do. Serve them well."
	equipment = list(/obj/item/clothing/under/grimhoodie = slot_w_uniform,
					/obj/item/clothing/shoes/sandal/grimboots = slot_shoes,
					/obj/item/contract/wizard/xray = slot_l_hand,
					/obj/item/contract/wizard/telepathy = slot_r_hand)
	spells = list(/spell/toggle_armor/overseer,
				/spell/targeted/ethereal_jaunt,
				/spell/invisibility,
				/spell/targeted/revoke)

/datum/spellbound_type/servant/overseer/equip_servant(mob/living/carbon/human/H)
	..()
	H.add_aura(new /obj/aura/regenerating(H))
	for(var/spell/S in H.mind.learned_spells)
		S.spell_flags |= NO_SOMATIC
		S.cast_delay = 0

/obj/cleanable/spellbound
	name = "strange rune"
	desc = "some sort of runic symbol drawn in... crayon?"
	icon = 'icons/obj/rune.dmi'
	icon_state = "spellbound"
	var/datum/spellbound_type/stype
	var/last_called = 0

/obj/cleanable/spellbound/New(loc, spell_type)
	stype = new spell_type()
	return ..(loc)

/obj/cleanable/spellbound/attack_hand(mob/user)
	if(last_called > world.time )
		return
	to_chat(user, "<span class='notice'>You call out to the spectral plane for assistance!</span>")
	last_called = world.time + 30 SECONDS
	var/datum/ghosttrap/G = get_ghost_trap("wizard familiar")
	for(var/mob/observer/ghost/ghost in GLOB.player_list)
		if(G.assess_candidate(ghost,null,FALSE))
			to_chat(ghost,"[SPAN_NOTICE("<b>A wizard is requesting a Spell-Bound Servant!</b>")] (<a href='byond://?src=\ref[src];master=\ref[user]'>Join</a>)")

/obj/cleanable/spellbound/CanUseTopic(mob)
	if(isliving(mob))
		return STATUS_CLOSE
	return STATUS_INTERACTIVE

/obj/cleanable/spellbound/OnTopic(mob/user, href_list, state)
	if(href_list["master"] && !QDELETED(src))
		var/mob/master = locate(href_list["master"])
		stype.spawn_servant(get_turf(src),master,user)
		qdel(src)
	return TOPIC_HANDLED

/obj/cleanable/spellbound/Destroy()
	qdel(stype)
	stype = null
	return ..()

/obj/item/summoning_stone
	name = "summoning stone"
	desc = "a small non-descript stone of dubious origin."
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "stone"
	throw_speed = 5
	throw_range = 10
	w_class = ITEM_SIZE_TINY

/obj/item/summoning_stone/attack_self(mob/user)
	if(user.z in GLOB.using_map.admin_levels)
		to_chat(user, SPAN_WARNING("You cannot use \the [src] here."))
		return
	user.set_machine(src)
	interact(user)

/obj/item/summoning_stone/interact(mob/user)
	var/list/types = subtypesof(/datum/spellbound_type) - /datum/spellbound_type/servant
	if(user.mind && !GLOB.wizards.is_antagonist(user.mind))
		use_type(pick(types),user)
		return
	var/dat = "<center><b><h3>Summoning Stone</h3></b><i>Choose a companion to help you.</i><br><br></center>"
	for(var/type in types)
		var/datum/spellbound_type/SB = type
		dat += "<br><a href='byond://?src=\ref[src];type=[type]'>[initial(SB.name)]</a> - [initial(SB.desc)]"
	show_browser(user,dat,"window=summoning")
	onclose(user,"summoning")

/obj/item/summoning_stone/proc/use_type(type, mob/user)
	new /obj/cleanable/spellbound(get_turf(src),type)
	show_browser(user, null, "window=summoning")
	qdel(src)

/obj/item/summoning_stone/OnTopic(user, href_list, state)
	if(href_list["type"])
		use_type(href_list["type"],user)
	return TOPIC_HANDLED
