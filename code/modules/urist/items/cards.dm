/obj/item/toy/card
	name = "Card"
	desc = "Card"
	icon = 'icons/urist/items/cards.dmi'
	icon_state = "hearts"
	var/suit = "Hearts"
	var/rank = "Ace"
	var/faceup = 1
	w_class = 2
	New(var/location, var/suit, var/rank,var/faceup=1)
		..()
		src.rank = rank
		src.suit = suit
		src.faceup = faceup
		if(faceup)
			name = "[rank] of [suit]"
		else
			name = "Card"
		update_icon()

	verb/Flip()
		var/comment = ""
		if(!faceup && !ismob(loc)) //Does not show what card you got to your opponent if you flip it in your hand
			comment = " It's [rank] of [suit]!"
		usr.visible_message("<span class='notice'>[usr] flips [src].[comment]</span>","<span class='notice'>You flip [src].[comment]</span>")
		faceup = !faceup
		if(faceup)
			name = "[rank] of [suit]"
		else
			name = "Card"
		update_icon()

	attack_self(mob/user as mob)
		..()
		Flip()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		var/mob/M = user
		if(istype(W,/obj/item/toy/card) && loc==user)
			M.drop_item()
			M.remove_from_mob(src)
			var/obj/item/toy/cardhand/hand = new /obj/item/toy/cardhand(loc)
			M.put_in_hands(hand)
			W.loc = hand
			src.loc = hand
		..()
		return

	update_icon()
		if(!faceup)
			icon_state = "hidden"
		else
			icon_state = "[suit]"
			//or if someone bothers to add more sprites
			//icon_state = "[suit]_[rank]
		return

/obj/item/toy/cardhand
	name = "Card hand"
	desc = ""
	icon = 'icons/urist/items/cards.dmi'
	icon_state = "hand"
	w_class = 2

	examine()
		..()
		for(var/obj/item/toy/card/R in contents)
			usr << R.name
		return

	attack_self(mob/user as mob)
		examine()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		var/mob/M = user
		if(istype(W,/obj/item/toy/card) && loc==user)
			M.drop_item()
			W.loc = src
		..()
		return

	verb/show()
		set name = "Show hand"
		set category = "Object"

		var/message = ""
		for(var/obj/item/toy/card/R in contents)
			message += "[R.name]</br>"
		usr.visible_message("<span class='notice'>[usr] shows his hand:</br>[message]</span>","<span class='notice'>You show your hand:</br> [message] </span>")
		return

	verb/pick_card()
		set name = "Pick card"
		set category = "Object"

		var/mob/M = usr
		var/obj/item/toy/card
		if(contents.len>1)
			card = input(usr, "Select a card to pick.", "Card hand") in contents
			card.loc = M
			M.put_in_hands(card)
		else:
			card = contents[1]
			card.loc = M
			M.put_in_hands(card)
			qdel(src)
		return


/obj/item/weapon/storage/deck
	name = "Card deck"
	desc = "Deck of cards!"
	icon = 'icons/urist/items/cards.dmi'
	icon_state = "deck"
	can_hold = list("/obj/item/toy/card")
	var/list/cardsuits = list("Clubs","Diamonds","Spades","Hearts")
	var/list/cardranks = list("Ace","Jack","Queen","King","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten")
	storage_slots = 52
	allow_quick_empty = 0
	allow_quick_gather = 0
	w_class = 2 //Pocket size
	max_storage_space = 104 //Could be higher i guess
	use_to_pickup = 1

	New()
		..()
		for(var/suit in cardsuits)
			for(var/rank in cardranks)
				new /obj/item/toy/card(src,suit,rank,0)
		src.contents = shuffle(src.contents)

	verb/shuffle_deck()
		set name = "Shuffle deck"
		set category = "Object"

		src.contents = shuffle(src.contents)
		usr.visible_message("<span class='notice'>[usr] shuffles the cards.</span>","<span class='notice'>You shuffle the cards in the deck.</span>")
		return

	verb/pull_card()
		set name = "Pull card"
		set category = "Object"
		set src in oview(1)

		if(contents && contents.len>0)
			usr.visible_message("<span class='notice'>[usr] pulls the card from the deck.</span>","<span class='notice'>You pull the card from the deck! </span>")
			var/I = src.contents[1]
			var/mob/M = usr
			M.put_in_hands(I)
		else
			usr << "Deck is empty!"

	attack_self(mob/user as mob)
		pull_card()

