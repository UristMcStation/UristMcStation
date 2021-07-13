/obj/item/weapon/storage/bible
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

/obj/item/weapon/storage/bible/booze
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

	startswith = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/weapon/spacecash/bundle/c50,
		/obj/item/weapon/spacecash/bundle/c50,
		)
//BS12 EDIT
 // All cult functionality moved to Null Rod
/obj/item/weapon/storage/bible/proc/bless(mob/living/carbon/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/heal_amt = 10
		for(var/obj/item/organ/external/affecting in H.organs)
			if(affecting.heal_damage(heal_amt, heal_amt))
				H.UpdateDamageIcon()
	return

/obj/item/weapon/storage/bible/attack(mob/living/M as mob, mob/living/user as mob)

	var/chaplain = 0
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		chaplain = 1


	admin_attack_log(src, M, "Used the [src.name] to attack [M.name] ([M.ckey])", "Has been attacked with [src.name] by [user.name] ([user.ckey])", "bible attack")

	//log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")

	if (!(istype(user, /mob/living/carbon/human)) && SSticker.mode.name != "monkey")
		user << "<span class='warning'> You don't have the dexterity to do this!</span>"
		return
	if(!chaplain)
		user << "<span class='warning'> The book sizzles in your hands.</span>"
		user.take_organ_damage(0,10)
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		user << "<span class='warning'> The [src] slips out of your hand and hits your head.</span>"
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

//	if(..() == BLOCKED)
//		return

	if (M.stat !=2)
		if(M.mind && (M.mind.assigned_role == "Chaplain"))
			user << "<span class='warning'> You can't heal yourself!</span>"
			return
		/*if((M.mind in ticker.mode.cult) && (prob(20)))
			M << "<span class='warning'> The power of [src.deity_name] clears your mind of heresy!</span>"
			user << "<span class='warning'> You see how [M]'s eyes become clear, the cult no longer holds control over him!</span>"
			ticker.mode.remove_cultist(M.mind)*/
		if(istype(M, /mob/living/carbon/human) && prob(60))
			bless(M)
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='danger'> [] heals [] with the power of [src.deity_name]!</span>", user, M), 1)
			M << "<span class='warning'> May the power of [src.deity_name] compel you to be healed!</span>"
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

/obj/item/weapon/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && (user.mind.assigned_role == "Counselor"))
		if(A.reagents && A.reagents.has_reagent(/datum/reagent/water)) //blesses all the water in the holder
			to_chat(user, "<span class='notice'>You bless \the [A].</span>") // I wish it was this easy in nethack
			var/water2holy = A.reagents.get_reagent_amount(/datum/reagent/water)
			A.reagents.del_reagent(/datum/reagent/water)
			A.reagents.add_reagent(/datum/reagent/water/holywater,water2holy)

/obj/item/weapon/storage/bible/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/weapon/storage/bible/verb/rename_bible()
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

/obj/item/weapon/storage/bible/verb/set_icon()
	set name = "Change Icon"
	set category = "Object"
	set desc = "Click to change your book's icon."

	if(!icon_changed)
		var/mob/M = usr

		for(var/i = 10; i >= 0; i -= 1)
			if(src && !M.stat && in_range(M,src))
				var/icon_picked = input(M, "Icon?", "Book Icon", null) in list("don't change", "bible", "koran", "scrapbook", "white", "holylight", "atheist", "kojiki", "torah", "kingyellow", "ithaqua", "necronomicon")
				if(icon_picked != "don't change" && icon_picked)
					icon_state = icon_picked
				if(i != 0)
					var/confirm = alert(M, "Is this what you want? Chances remaining: [i]", "Confirmation", "Yes", "No")
					if(confirm == "Yes")
						icon_changed = 1
						break
				if(i == 0)
					icon_changed = 1
