 /*										*****New space to put all UMcS Vending Machines*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/structures&machinery/machinery.dmi' -Glloyd													*/

//attadrabe -- autodrobe from /tg/

/obj/machinery/vending/autodrobe
	name = "\improper AutoDrobe"
	desc = "A vending machine for costumes."
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	icon_state = "theater"
	icon_deny = "theater-deny"
	req_access_txt = "46" //Theatre access needed, unless hacked.
	product_slogans = "Dress for success!;Suited and booted!;It's show time!;Why leave style up to fate? Use AutoDrobe!"
	vend_delay = 15
	vend_reply = "Thank you for using AutoDrobe!"
	products = list(/obj/item/clothing/suit/chickensuit = 1,/obj/item/clothing/head/chicken = 1,/obj/item/clothing/under/gladiator = 1,
					/obj/item/clothing/head/helmet/gladiator = 1,/obj/item/clothing/under/gimmick/rank/captain/suit = 1,/obj/item/clothing/head/flatcap = 1,
					/obj/item/clothing/suit/storage/labcoat/mad = 1,/obj/item/clothing/glasses/gglasses = 1,/obj/item/clothing/shoes/jackboots = 1,
					/obj/item/clothing/under/schoolgirl = 1,/obj/item/clothing/head/kitty = 1,/obj/item/clothing/under/blackskirt = 1,/obj/item/clothing/head/beret = 1,
					/obj/item/clothing/suit/wcoat = 1,/obj/item/clothing/under/suit_jacket = 1,/obj/item/clothing/head/that =1,/obj/item/clothing/head/cueball = 1,
					/obj/item/clothing/under/scratch = 1,/obj/item/clothing/under/kilt = 1,/obj/item/clothing/head/beret = 1,/obj/item/clothing/suit/wcoat = 1,
					/obj/item/clothing/glasses/monocle =1,/obj/item/clothing/head/bowler = 1,/obj/item/weapon/cane = 1,/obj/item/clothing/under/sl_suit = 1,
					/obj/item/clothing/mask/fakemoustache = 1,/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 1,/obj/item/clothing/head/plaguedoctorhat = 1,
					/obj/item/clothing/under/owl = 1,/obj/item/clothing/mask/gas/owl_mask = 1,/obj/item/clothing/suit/apron = 1,/obj/item/clothing/under/waiter = 1,
					/obj/item/clothing/under/pirate = 1,/obj/item/clothing/suit/pirate = 1,/obj/item/clothing/head/pirate = 1,/obj/item/clothing/head/bandana = 1,
					/obj/item/clothing/head/bandana = 1,/obj/item/clothing/under/soviet = 1,/obj/item/clothing/head/ushanka = 1,/obj/item/clothing/suit/imperium_monk = 1,
					/obj/item/clothing/mask/gas/cyborg = 1,/obj/item/clothing/suit/holidaypriest = 1,/obj/item/clothing/head/wizard/marisa/fake = 1,
					/obj/item/clothing/suit/wizrobe/marisa/fake = 1,/obj/item/clothing/under/sundress = 1,/obj/item/clothing/head/witchwig = 1,/obj/item/weapon/staff/broom = 1,
					/obj/item/clothing/suit/wizrobe/fake = 1,/obj/item/clothing/head/wizard/fake = 1,/obj/item/weapon/staff = 3,/obj/item/clothing/mask/gas/sexyclown = 1,
					/obj/item/clothing/under/sexyclown = 1,/obj/item/clothing/mask/gas/sexymime = 1,/obj/item/clothing/under/sexymime = 1,/obj/item/clothing/suit/apron/overalls = 1,
					/obj/item/clothing/head/rabbitears =1) //Pretty much everything that had a chance to spawn.
	contraband = list(/obj/item/clothing/suit/cardborg = 1,/obj/item/clothing/head/cardborg = 1,/obj/item/clothing/suit/judgerobe = 1,/obj/item/clothing/head/powdered_wig = 1)
	premium = list(/obj/item/clothing/suit/hgpirate = 1, /obj/item/clothing/head/hgpiratecap = 1, /obj/item/clothing/head/helmet/roman = 1, /obj/item/clothing/head/helmet/roman/legionaire = 1, /obj/item/clothing/under/roman = 1, /obj/item/clothing/shoes/roman = 1, /obj/item/weapon/shield/riot/roman = 1)

//sustenance from /tg/

/obj/machinery/vending/sustenance
	name = "\improper Sustenance Vendor"
	icon = 'icons/urist/structures&machinery/machinery.dmi'
	desc = "A vending machine which vends food, as required by section 47-C of the NT's Prisoner Ethical Treatment Agreement."
	product_slogans = "Enjoy your meal.;Enough calories to support strenuous labor."
	product_ads = "Sufficiently healthy.;Efficiently produced tofu!;Mmm! So good!;Have a meal.;You need food to live!;Have some more candy corn!;Try our new ice cups!"
	icon_state = "sustenance"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/tofu = 24,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 12,
					/obj/item/weapon/reagent_containers/food/snacks/candy_corn = 6)
	contraband = list(/obj/item/weapon/kitchen/utensil/knife = 6)