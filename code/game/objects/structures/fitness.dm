/obj/structure/fitness
	icon = 'icons/obj/structures/gym_equipment.dmi'
	anchored = TRUE
	var/being_used = 0

/obj/structure/fitness/punchingbag
	name = "punching bag"
	desc = "A punching bag."
	icon_state = "punchingbag"
	density = TRUE
	var/list/hit_message = list("hit", "punch", "kick", "robust")

/obj/structure/fitness/punchingbag/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		..()
		return
	var/synth = user.isSynthetic()
	if(!synth && user.nutrition < 20)
		to_chat(user, SPAN_WARNING("You need more energy to use the punching bag. Go eat something."))
	else
		if(user.a_intent == I_HURT)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			flick("[icon_state]_hit", src)
			playsound(src.loc, 'sound/effects/woodhit.ogg', 25, 1, -1)
			user.do_attack_animation(src)
			user.update_personal_goal(/datum/goal/punchingbag, 1)
			if(!synth)
				user.adjust_nutrition(-(5 * DEFAULT_HUNGER_FACTOR))
				user.adjust_hydration(-(5 * DEFAULT_THIRST_FACTOR))
			to_chat(user, SPAN_WARNING("You [pick(hit_message)] \the [src]."))

/obj/structure/fitness/weightlifter
	name = "weightlifting machine"
	desc = "A machine used to lift weights."
	icon_state = "weightlifter"
	var/weight = 1
	var/list/qualifiers = list("with ease", "without any trouble", "with great effort")


/obj/structure/fitness/weightlifter/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wrench - Set weight level
	if (isWrench(tool))
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		weight = ((weight) % length(qualifiers)) + 1
		user.visible_message(
			SPAN_NOTICE("\The [user] adjusts \the [src]'s weight level with \a [tool]."),
			SPAN_NOTICE("You set \the [src]'s weight level to [weight] with \the [tool].")
		)
		return TRUE

	return ..()


/obj/structure/fitness/weightlifter/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/synth = user.isSynthetic()
	if(user.loc != src.loc)
		to_chat(user, SPAN_WARNING("You must be on the weight machine to use it."))
		return
	if(!synth && user.nutrition < 50)
		to_chat(user, SPAN_WARNING("You need more energy to lift weights. Go eat something."))
		return
	if(being_used)
		to_chat(user, SPAN_WARNING("The weight machine is already in use by somebody else."))
		return
	else
		being_used = 1
		playsound(src.loc, 'sound/effects/weightlifter.ogg', 50, 1)
		user.set_dir(SOUTH)
		flick("[icon_state]_[weight]", src)
		if(do_after(user, (2 + weight) SECONDS, src, DO_DEFAULT | DO_BOTH_UNIQUE_ACT))
			playsound(src.loc, 'sound/effects/weightdrop.ogg', 25, 1)
			if(!synth)
				user.nutrition -= weight * 10
			to_chat(user, "<span class='notice'>You lift the weights [qualifiers[weight]].</span>")
		being_used = FALSE
