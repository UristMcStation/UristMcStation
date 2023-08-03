/obj/item/storage/bible
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 4
	var/mob/affecting = null
	var/deity_name = "Christ"
	var/renamed = 0
	var/icon_changed = 0

/obj/item/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

	startswith = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/spacecash/bundle/c50,
		/obj/item/spacecash/bundle/c50,
		)
//BS12 EDIT
 // All cult functionality moved to Null Rod
/obj/item/storage/bible/proc/bless(mob/living/carbon/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/heal_amt = 10
		for(var/obj/item/organ/external/affecting in H.organs)
			if(affecting.heal_damage(heal_amt, heal_amt))
				H.UpdateDamageIcon()
	return

/obj/item/storage/bible/attack(mob/living/M as mob, mob/living/user as mob)

	var/chaplain = 0
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		chaplain = 1


	admin_attack_log(src, M, "Used the [src.name] to attack [M.name] ([M.ckey])", "Has been attacked with [src.name] by [user.name] ([user.ckey])", "bible attack")

	//log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")

	if (!(istype(user, /mob/living/carbon/human)) && SSticker.mode.name != "monkey")
		to_chat(user, "<span class='warning'> You don't have the dexterity to do this!</span>")
		return
	if(!chaplain)
		to_chat(user, "<span class='warning'> The book sizzles in your hands.</span>")
		user.take_organ_damage(0,10)
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'> The [src] slips out of your hand and hits your head.</span>")
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

//	if(..() == BLOCKED)
//		return

	if (M.stat !=2)
		if(M.mind && (M.mind.assigned_role == "Chaplain"))
			to_chat(user, "<span class='warning'> You can't heal yourself!</span>")
			return
		/*if((M.mind in ticker.mode.cult) && (prob(20)))
			to_chat(M, "<span class='warning'> The power of [src.deity_name] clears your mind of heresy!</span>")
			to_chat(user, "<span class='warning'> You see how [M]'s eyes become clear, the cult no longer holds control over him!</span>")
			ticker.mode.remove_cultist(M.mind)*/
		if(istype(M, /mob/living/carbon/human) && prob(60))
			bless(M)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'> [] heals [] with the power of [src.deity_name]!</span>", user, M), 1)
			to_chat(M, "<span class='warning'> May the power of [src.deity_name] compel you to be healed!</span>")
			playsound(src.loc, "punch", 25, 1, -1)
		else
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'>[] beats [] over the head with []!</span>", user, M, src), 1)
			playsound(src.loc, "punch", 25, 1, -1)
	else if(M.stat == 2)
		for(var/mob/O in viewers(M, null))
			O.show_message(text("<span class='danger'>[] smacks []'s lifeless corpse with [].</span>", user, M, src), 1)
		playsound(src.loc, "punch", 25, 1, -1)
	return

/obj/item/storage/bible/bible
	name = "\improper Bible"
	desc = "The central religious text of Christianity."
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/tanakh
	name = "\improper Tanakh"
	desc = "The central religious text of Judaism."
	icon_state = "torah"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/quran
	name = "\improper Quran"
	desc = "The central religious text of Islam."
	icon_state = "koran"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/kojiki
	name = "\improper Kojiki"
	desc = "A collection of myths from ancient Japan."
	icon_state = "kojiki"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/aqdas
	name = "\improper Kitab-i-Aqdas"
	desc = "The central religious text of the Baha'i Faith."
	icon_state = "ninestar"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/guru
	name = "\improper Guru Granth Sahib"
	desc = "The central religious text of the Sikh Faith."
	icon_state = "guru"
	renamed = 1
	icon_changed = 1

/obj/item/storage/bible/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	if(user == M || !ishuman(user) || !ishuman(M))
		return
	if(user.mind && istype(user.mind.assigned_job, /datum/job/chaplain))
		user.visible_message(SPAN_NOTICE("\The [user] places \the [src] on \the [M]'s forehead, reciting a prayer..."))
		if(do_after(user, 5 SECONDS, M, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && user.Adjacent(M))
			user.visible_message("\The [user] finishes reciting \his prayer, removing \the [src] from \the [M]'s forehead.", "You finish reciting your prayer, removing \the [src] from \the [M]'s forehead.")
			if(user.get_cultural_value(TAG_RELIGION) == M.get_cultural_value(TAG_RELIGION))
				to_chat(M, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))
			else
				to_chat(M, "Nothing happened.")
		..()

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && istype(user.mind.assigned_job, /datum/job/chaplain))
		if(A.reagents && A.reagents.has_reagent(/datum/reagent/water)) //blesses all the water in the holder
			to_chat(user, SPAN_NOTICE("You bless \the [A].")) // I wish it was this easy in nethack
			var/water2holy = A.reagents.get_reagent_amount(/datum/reagent/water)
			A.reagents.del_reagent(/datum/reagent/water)
			A.reagents.add_reagent(/datum/reagent/water/holywater,water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/storage/bible/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	if(user.mind && istype(user.mind.assigned_job, /datum/job/chaplain))
		user.visible_message("\The [user] begins to read a passage from \the [src]...", "You begin to read a passage from \the [src]...")
		if(do_after(user, 5 SECONDS, src, do_flags = DO_PUBLIC_UNIQUE))
			user.visible_message("\The [user] reads a passage from \the [src].", "You read a passage from \the [src].")
			for(var/mob/living/carbon/human/H in view(user))
				if(user.get_cultural_value(TAG_RELIGION) == H.get_cultural_value(TAG_RELIGION))
					to_chat(H, SPAN_NOTICE("You feel calm and relaxed, at one with the universe."))

/obj/item/storage/bible/verb/rename_bible()
	set name = "Rename Bible"
	set category = "Object"
	set desc = "Click to rename your bible."

	if(!renamed)
		var/input = sanitizeSafe(input("What do you want to rename your bible to? You can only do this once.", ,""), MAX_NAME_LEN)

		var/mob/M = usr
		if(src && input && !M.stat && in_range(M,src))
			SetName(input)
			to_chat(M, "You name your religious book [input].")
			renamed = 1
			return 1

/obj/item/storage/bible/verb/set_icon()
	set name = "Change Icon"
	set category = "Object"
	set desc = "Click to change your book's icon."

	if(!icon_changed)
		var/mob/M = usr

		for(var/i = 10; i >= 0; i -= 1)
			if(src && !M.stat && in_range(M,src))
				var/icon_picked = input(M, "Icon?", "Book Icon", null) in list("don't change", "bible", "koran", "scrapbook", "white", "holylight", "atheist", "kojiki", "torah", "kingyellow", "ithaqua", "necronomicon", "ninestar")
				if(icon_picked != "don't change" && icon_picked)
					icon_state = icon_picked
				if(i != 0)
					var/confirm = alert(M, "Is this what you want? Chances remaining: [i]", "Confirmation", "Yes", "No")
					if(confirm == "Yes")
						icon_changed = 1
						break
				if(i == 0)
					icon_changed = 1
