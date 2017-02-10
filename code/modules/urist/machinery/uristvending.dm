 /*										*****New space to put all UMcS Vending Machines*****

Please keep it tidy, by which I mean put comments describing the item before the entry. Icons go to 'icons/urist/structures&machinery/machinery.dmi' -Glloyd													*/

//base define to clean up the object tree.

/obj/machinery/vending/urist
	icon = 'icons/urist/structures&machinery/machinery.dmi'

//attadrabe -- autodrobe from /tg/

/obj/machinery/vending/urist/autodrobe
	name = "\improper AutoDrobe"
	desc = "A vending machine for costumes."
	icon_state = "theater"
	icon_deny = "theater-deny"
	req_access = list(access_theatre) // Theatre access needed, unless hacked.
	product_slogans = "Dress for success!;Suited and booted!;It's show time!;Why leave style up to fate? Use AutoDrobe!"
	vend_delay = 15
	vend_reply = "Thank you for using AutoDrobe!"
	products = list(/obj/item/clothing/suit/chickensuit = 1,/obj/item/clothing/head/chicken = 1,/obj/item/clothing/under/gladiator = 1,
					/obj/item/clothing/head/helmet/gladiator = 1,/obj/item/clothing/under/gimmick/rank/captain/suit = 1,/obj/item/clothing/head/flatcap = 1,
					/obj/item/clothing/suit/storage/toggle/labcoat/mad = 1,/obj/item/clothing/glasses/gglasses = 1,/obj/item/clothing/shoes/jackboots = 1,
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

/obj/machinery/vending/urist/sustenance
	name = "\improper Sustenance Vendor"
	desc = "A vending machine which vends food, as required by section 47-C of the NT's Prisoner Ethical Treatment Agreement."
	product_slogans = "Enjoy your meal.;Enough calories to support strenuous labor."
	product_ads = "Sufficiently healthy.;Efficiently produced tofu!;Mmm! So good!;Have a meal.;You need food to live!;Have some more candy corn!;Try our new ice cups!"
	icon_state = "sustenance"
	products = list(/obj/item/weapon/reagent_containers/food/snacks/tofu = 24,
					/obj/item/weapon/reagent_containers/food/drinks/ice = 12,
					/obj/item/weapon/reagent_containers/food/snacks/candy_corn = 6)
	contraband = list(/obj/item/weapon/material/kitchen/utensil/knife = 6)

//nt vanity machine.

/obj/machinery/vending/urist/nanotrasen
	name = "\improper Nanotrasen vending machine"
	desc = "A vending machine that dispenses goods with the Nanotrasen colours and logo."
	product_slogans = "Nanotrasen, working for you!;Show your loyalty to Nanotrasen!;Glory to Nanotrasen!;Nanotrasen brand goods, buy today!"
	product_ads = "Nanotrasen, definitely not evil!;Nanotrasen, expanding out of control since the 22nd century!;Nanotrasen cares!;Quality goods, quality prices!;Glory to Nanotrasen!;Nanotrasen, paving a brighter future.;Look stylish and loyal!;Nanotrasen, making your work experience better one toolbox at a time!"
	vend_delay = 15
	vend_reply = "Glory to Nanotrasen!"
	icon_state = "clothing2"
	products = list(/obj/item/clothing/under/urist/nanotrasen/blue = 10,/obj/item/clothing/head/soft/nanotrasen/blue = 10,/obj/item/clothing/under/urist/nanotrasen/white = 10,/obj/item/clothing/head/soft/nanotrasen/white = 10,/obj/item/clothing/suit/urist/sweater/nanotrasen = 10,/obj/item/weapon/storage/toolbox/nanotrasen = 4)
	contraband = list(/obj/item/weapon/storage/toolbox/syndicate = 1)
	prices = list(/obj/item/clothing/under/urist/nanotrasen/blue = 100,/obj/item/clothing/head/soft/nanotrasen/blue = 50,/obj/item/clothing/under/urist/nanotrasen/white = 100,/obj/item/clothing/head/soft/nanotrasen/white = 50,/obj/item/clothing/suit/urist/sweater/nanotrasen = 150,/obj/item/weapon/storage/toolbox/nanotrasen = 200)

//dresses!

/obj/machinery/vending/urist/dress
	name = "\improper Automated Dress Vendor"
	desc = "A vending machine that apparently dispenses dresses... What will Nanotrasen think of next?"
	product_ads = "Say yes!;Say yes to the dress!;Buy the dress you've always wanted today!;Beautiful dresses... In space.;Want to impress? Buy a dress!"
	product_slogans = "Say yes!;Say yes to the dress!;You better say yes!;Your id is on file, say yes to the fucking dress.;Beautiful!;Sexy!;Stunning!;Stylish!;Let your inner princess free!;Fabulous!;Buy a new dress today!;The dresses of the future... today!;We know dresses. Buy one today!;Impress people, buy a dress!"
	vend_delay = 15
	vend_reply = "Enjoy your beautiful new dress!"
	icon_state = "dress"
	products = list(/obj/item/clothing/under/urist/dress/teal = 5,/obj/item/clothing/under/urist/dress/yellow = 5,/obj/item/clothing/under/urist/dress/white1 = 5,/obj/item/clothing/under/urist/dress/white2 = 5,/obj/item/clothing/under/dress/dress_fire = 5,/obj/item/clothing/under/dress/dress_green = 5,/obj/item/clothing/under/dress/dress_orange = 5,/obj/item/clothing/under/dress/dress_pink = 5,
					/obj/item/clothing/under/dress/dress_saloon = 5,/obj/item/clothing/under/dress/plaid_blue = 5,/obj/item/clothing/under/dress/plaid_purple = 5,/obj/item/clothing/under/dress/plaid_red = 5,/obj/item/clothing/under/urist/dress/red = 5,
					/obj/item/clothing/under/sundress = 5,/obj/item/clothing/under/wedding/bride_white = 5,/obj/item/clothing/under/urist/formal/blacktango = 5,
					/obj/item/clothing/under/urist/dress/white3 = 5,/obj/item/clothing/under/urist/dress/pink = 5,/obj/item/clothing/under/urist/dress/gold = 5,
					/obj/item/clothing/under/urist/dress/purple = 5,/obj/item/clothing/under/urist/dress/green = 5,/obj/item/clothing/under/urist/dress/black = 5,
					/obj/item/clothing/under/urist/dress/polkadot = 5,/obj/item/clothing/under/urist/dress/dress_blouse = 5,/obj/item/clothing/under/sakura_hokkaido_kimono = 1,/obj/item/clothing/under/urist/dress/princess = 2,/obj/item/clothing/head/princessbow = 2)
	prices = list(/obj/item/clothing/under/urist/dress/teal = 250,/obj/item/clothing/under/urist/dress/yellow = 250,/obj/item/clothing/under/urist/dress/white1 = 250,/obj/item/clothing/under/urist/dress/white2 = 250,/obj/item/clothing/under/dress/dress_fire = 250,/obj/item/clothing/under/dress/dress_green = 250,/obj/item/clothing/under/dress/dress_orange = 250,/obj/item/clothing/under/dress/dress_pink = 250,
					/obj/item/clothing/under/dress/dress_saloon = 250,/obj/item/clothing/under/dress/plaid_blue = 250,/obj/item/clothing/under/dress/plaid_purple = 250,/obj/item/clothing/under/dress/plaid_red = 250,/obj/item/clothing/under/urist/dress/red = 250,
					/obj/item/clothing/under/urist/dress/white3 = 250, /obj/item/clothing/under/urist/dress/pink = 250, /obj/item/clothing/under/urist/dress/gold = 250, /obj/item/clothing/under/urist/dress/purple = 250, /obj/item/clothing/under/urist/dress/green = 250, /obj/item/clothing/under/urist/dress/black = 250,
					/obj/item/clothing/under/sundress = 250,/obj/item/clothing/under/wedding/bride_white = 250,/obj/item/clothing/under/urist/formal/blacktango = 250,
					/obj/item/clothing/under/urist/dress/polkadot = 250,/obj/item/clothing/under/urist/dress/dress_blouse = 250,/obj/item/clothing/under/sakura_hokkaido_kimono = 600,/obj/item/clothing/under/urist/dress/princess = 500,/obj/item/clothing/head/princessbow = 100)
	contraband = list(/obj/item/clothing/under/stripper/mankini = 2)

//Hats!

/obj/machinery/vending/urist/hatdispenser
	name = "Hatlord 9000"
	desc = "It doesn't seem the slightest bit unusual. This frustrates you immensly."
	icon_state = "hats"
	vend_reply = "Take care now!"
	product_ads = "Buy some hats!;A bare head is absolutely ASKING for a robusting!"
	product_slogans = "Warning, not all hats are dog/monkey compatable. Apply forcefully with care.;Apply directly to the forehead.;Who doesn't love spending cash on hats?!;From the people that brought you collectable hat crates, Hatlord!"
	products = list(/obj/item/clothing/head/bowler = 10,/obj/item/clothing/head/urist/beaverhat = 10,/obj/item/clothing/head/urist/boaterhat = 10,/obj/item/clothing/head/urist/fedora = 5,/obj/item/clothing/head/urist/fez = 10,/obj/item/clothing/head/soft/blue = 10,/obj/item/clothing/head/soft/green = 10,/obj/item/clothing/head/soft/purple = 10,/obj/item/clothing/head/soft/yellow = 10,/obj/item/clothing/head/beanie = 10,/obj/item/clothing/head/flatcap = 5,/obj/item/clothing/head/helmet/urist/sombrero = 5,/obj/item/clothing/head/helmet/urist/sombrero/green = 5, /obj/item/clothing/head/helmet/urist/sombrero/shame = 5)//worn hat got the axe, sorry!
	prices = list(/obj/item/clothing/head/bowler = 50,/obj/item/clothing/head/urist/beaverhat = 50,/obj/item/clothing/head/urist/boaterhat = 50,/obj/item/clothing/head/urist/fedora = 100,/obj/item/clothing/head/urist/fez = 50,/obj/item/clothing/head/soft/blue = 30,/obj/item/clothing/head/soft/green = 30,/obj/item/clothing/head/soft/purple = 30,/obj/item/clothing/head/soft/yellow = 30,/obj/item/clothing/head/beanie = 50,/obj/item/clothing/head/flatcap = 100,/obj/item/clothing/head/helmet/urist/sombrero = 75,/obj/item/clothing/head/helmet/urist/sombrero/green = 75, /obj/item/clothing/head/helmet/urist/sombrero/shame = 75)
	contraband = list(/obj/item/clothing/head/bearpelt = 1)
	premium = list(/obj/item/clothing/head/soft/rainbow = 1)

//suits! (although technically not /clothing/suits. honk)

/obj/machinery/vending/urist/suitdispenser
	name = "Suitlord 9000"
	desc = "You wonder for a moment why all of your shirts and pants come conjoined. This hurts your head and you stop thinking about it."
	icon_state = "suits"
	vend_reply = "Come again!"
	product_ads = "Skinny? Looking for some clothes? Suitlord is the machine for you!;BUY MY PRODUCT!"
	product_slogans = "Pre-Ironed, Pre-Washed, Pre-Wor-*BZZT*;Blood of your enemies washes right out!;Who are YOU wearing?;Look dapper! Look like an idiot!;Dont carry your size? How about you shave off some pounds you fat lazy- *BZZT*"
	products = list(/obj/item/clothing/under/color/brown = 10,/obj/item/clothing/under/gentlesuit = 10,/obj/item/clothing/under/suit_jacket = 10,/obj/item/clothing/under/suit_jacket/female = 10,/obj/item/clothing/under/suit_jacket/really_black = 10,
					/obj/item/clothing/under/sl_suit = 10,/obj/item/clothing/under/urist/formal/assistantformal = 10,/obj/item/clothing/under/urist/suit_jacket/black = 10,/obj/item/clothing/under/urist/suit_jacket/burgundy = 10,/obj/item/clothing/under/urist/suit_jacket/charcoal = 10,
					/obj/item/clothing/under/urist/suit_jacket/checkered = 10,/obj/item/clothing/under/urist/suit_jacket/navy = 10,/obj/item/clothing/under/urist/suit_jacket/tan = 10, /obj/item/clothing/under/urist/casual/olive = 10,/obj/item/clothing/under/urist/casual/plaid = 10, /obj/item/clothing/under/urist/casual/suspenders = 10)
	prices = list(/obj/item/clothing/under/color/brown = 150,/obj/item/clothing/under/gentlesuit = 150,/obj/item/clothing/under/suit_jacket = 150,/obj/item/clothing/under/suit_jacket/female = 150,/obj/item/clothing/under/suit_jacket/really_black = 150,
					/obj/item/clothing/under/sl_suit = 150,/obj/item/clothing/under/urist/formal/assistantformal = 150,/obj/item/clothing/under/urist/suit_jacket/black = 150,/obj/item/clothing/under/urist/suit_jacket/burgundy = 150,/obj/item/clothing/under/urist/suit_jacket/charcoal = 150,
					/obj/item/clothing/under/urist/suit_jacket/checkered = 150,/obj/item/clothing/under/urist/suit_jacket/navy = 150,/obj/item/clothing/under/urist/suit_jacket/tan = 150, /obj/item/clothing/under/urist/casual/olive = 150,/obj/item/clothing/under/urist/casual/plaid = 150, /obj/item/clothing/under/urist/casual/suspenders = 150)
	contraband = list(/obj/item/clothing/under/syndicate/tacticool = 1,/obj/item/clothing/under/psyche = 1,/obj/item/clothing/under/color/orange = 1)
	premium = list(/obj/item/clothing/under/color/rainbow = 1)

//shoes!

/obj/machinery/vending/urist/shoedispenser
	name = "Shoelord 9000"
	desc = "Wow, hatlord looked fancy, suitlord looked streamlined, and this is just normal. The guy who designed these must be an idiot."
	icon_state = "shoes"
	vend_reply = "Enjoy your pair!"
	product_ads = "Dont be a hobbit: Choose shoelord.;Shoes snatched? Get on it with shoelord."
	product_slogans = "Put your foot down!;One size fits all!;IM WALKING ON SUNSHINE!;No hobbits allowed.;NO PLEASE WILLY, DONT HURT ME- *BZZT*"
	products = list(/obj/item/clothing/shoes/black = 10,/obj/item/clothing/shoes/brown = 10,/obj/item/clothing/shoes/blue = 10,/obj/item/clothing/shoes/green = 10,/obj/item/clothing/shoes/yellow = 10,/obj/item/clothing/shoes/purple = 10,/obj/item/clothing/shoes/red = 10,/obj/item/clothing/shoes/white = 10,/obj/item/clothing/shoes/urist/kneesock/white = 10,/obj/item/clothing/shoes/urist/kneesock/black = 10,/obj/item/clothing/shoes/urist/kneesock/striped = 10,/obj/item/clothing/shoes/urist/kneesock/purplestriped = 10,/obj/item/clothing/shoes/urist/winter = 10)
	prices = list(/obj/item/clothing/shoes/black = 50,/obj/item/clothing/shoes/brown = 50,/obj/item/clothing/shoes/blue = 50,/obj/item/clothing/shoes/green = 50,/obj/item/clothing/shoes/yellow = 50,/obj/item/clothing/shoes/purple = 50,/obj/item/clothing/shoes/red = 50,/obj/item/clothing/shoes/white = 50,/obj/item/clothing/shoes/urist/kneesock/white = 100,/obj/item/clothing/shoes/urist/kneesock/black = 100,/obj/item/clothing/shoes/urist/kneesock/striped = 100,/obj/item/clothing/shoes/urist/kneesock/purplestriped = 100,/obj/item/clothing/shoes/urist/winter = 100)
	contraband = list(/obj/item/clothing/shoes/jackboots = 1,/obj/item/clothing/shoes/orange = 1)
	premium = list(/obj/item/clothing/shoes/rainbow = 1)

//pants!

/obj/machinery/vending/urist/pantsdispenser
	name = "Pantslord 9000"
	desc = "Wait a minute... Pants without shirts? What will they think of next?"
	icon_state = "pants"
	vend_reply = "Pants: Wear them."
	product_ads = "Don't be a nudist, choose pantslord!;Wake up cold and alone in an unknown room without your pants? We're here to help.;Get on it with pantslord.;I just want my pants back..."
	product_slogans = "Slide into a new pair of pants!;One size fits all!;Wake up cold and alone in an unknown room without your pants? We're here to help.;Pants: Protecting your dignity since time unknown."
	products = list(/obj/item/clothing/under/pants/urist/bluepants = 10,/obj/item/clothing/under/pants/urist/camo = 10,/obj/item/clothing/under/pants/urist/khaki = 10,/obj/item/clothing/under/pants/urist/trackpants = 10,/obj/item/clothing/under/pants/urist/jeans_m = 10,/obj/item/clothing/under/pants/urist/jeans_d = 10,/obj/item/clothing/under/pants/urist/jeans_d = 10,/obj/item/clothing/under/pants/urist/redpants = 10,/obj/item/clothing/under/pants/urist/whitepants = 10,/obj/item/clothing/under/pants/urist/jeans_b = 10)
	prices = list(/obj/item/clothing/under/pants/urist/bluepants = 100,/obj/item/clothing/under/pants/urist/camo = 100,/obj/item/clothing/under/pants/urist/khaki = 100,/obj/item/clothing/under/pants/urist/trackpants = 100,/obj/item/clothing/under/pants/urist/jeans_m = 100,/obj/item/clothing/under/pants/urist/jeans_d = 100,/obj/item/clothing/under/pants/urist/jeans_d = 100,/obj/item/clothing/under/pants/urist/redpants = 100,/obj/item/clothing/under/pants/urist/whitepants = 100,/obj/item/clothing/under/pants/urist/jeans_b = 100)
//	contraband = list(/obj/item/clothing/shoes/jackboots = 1,/obj/item/clothing/shoes/orange = 1)
	premium = list(/obj/item/clothing/under/pants/urist/militarypants = 1)

//coats!

/obj/machinery/vending/urist/coatdispenser
	name = "Coatlord 9000"
	desc = "A vendor for coats and jackets. For some reason, you feel like this should be called Suitlord instead..."
	icon_state = "coat"
	vend_reply = "Stay classy!"
	product_ads = "Choose Coatlord, and keep yourself warm.;Need a coat? We're here for you."
	product_slogans = "Cover yourself!;Dress to impress!;Lumberjack approved!;Warning, leather jackets are not vegan.;Can't afford shoes, pants, suits or dresses? Well fuck off, we didn't want your money anyways."
	products = list(/obj/item/clothing/suit/coat/jacket/leather = 5,/obj/item/clothing/suit/coat/jacket = 10,/obj/item/clothing/suit/coat = 10,/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 10,/obj/item/clothing/suit/storage/lawyer/purpjacket = 10,/obj/item/clothing/suit/urist/blackjacket = 10, /obj/item/clothing/suit/storage/toggle/urist/coat/navycoat = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/charcoat = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/burgcoat = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/brown = 5, /obj/item/clothing/suit/storage/toggle/urist/coat/black = 5,
					/obj/item/clothing/suit/urist/sweater/pink = 5,/obj/item/clothing/suit/urist/sweater/blue = 5,/obj/item/clothing/suit/urist/sweater/blue/heart = 5,/obj/item/clothing/suit/urist/sweater/mint = 5)
	prices = list(/obj/item/clothing/suit/coat/jacket/leather = 500,/obj/item/clothing/suit/coat/jacket = 200,/obj/item/clothing/suit/coat = 200,/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 300,/obj/item/clothing/suit/storage/lawyer/purpjacket = 300,/obj/item/clothing/suit/urist/blackjacket = 300, /obj/item/clothing/suit/storage/toggle/urist/coat/navycoat = 600, /obj/item/clothing/suit/storage/toggle/urist/coat/charcoat = 600, /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat = 600, /obj/item/clothing/suit/storage/toggle/urist/coat/blackcoat/suit = 900, /obj/item/clothing/suit/storage/toggle/urist/coat/burgcoat = 600, /obj/item/clothing/suit/storage/toggle/urist/coat/brown = 200, /obj/item/clothing/suit/storage/toggle/urist/coat/black = 200,
					/obj/item/clothing/suit/urist/sweater/pink = 200,/obj/item/clothing/suit/urist/sweater/blue = 200,/obj/item/clothing/suit/urist/sweater/blue/heart = 200,/obj/item/clothing/suit/urist/sweater/mint = 200)
	contraband = list(/obj/item/clothing/suit/storage/urist/coat/tajcoat = 1)
//	premium = list(/obj/item/clothing/shoes/rainbow = 1)

//Belts!

/obj/machinery/vending/urist/beltdispenser
	name = "Beltlord 9000"
	desc = "A place to buy belts of all kinds! Useful belts! Useless belts! We have them all!"
	icon_state = "belt"
	vend_reply = "Remember to buckle up!"
	product_ads = "Keeping pants from falling down since 2456!; All the belts you could ask for!"
	product_slogans = "Belts for everyone!; I knew a guy who didn't wear belts, he died!; All belt buckles are made from 100% pure silver, honest!"
	products = list(/obj/item/weapon/storage/belt/vanity/leather = 5,/obj/item/weapon/storage/belt/vanity/cowboy = 5,/obj/item/weapon/storage/belt/vanity/black = 10,/obj/item/weapon/storage/belt/vanity/red = 10,/obj/item/weapon/storage/belt/vanity/green = 10,/obj/item/weapon/storage/belt/vanity/purple = 10,/obj/item/weapon/storage/belt/vanity/blue = 10,/obj/item/weapon/storage/belt/vanity/orange = 10)
	prices = list(/obj/item/weapon/storage/belt/vanity/leather = 250,/obj/item/weapon/storage/belt/vanity/cowboy = 250,/obj/item/weapon/storage/belt/vanity/black = 100,/obj/item/weapon/storage/belt/vanity/red = 100,/obj/item/weapon/storage/belt/vanity/green = 100,/obj/item/weapon/storage/belt/vanity/purple = 100,/obj/item/weapon/storage/belt/vanity/blue = 100,/obj/item/weapon/storage/belt/vanity/orange = 100)
	contraband = list(/obj/item/weapon/storage/belt/utility = 1)
