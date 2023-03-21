/datum/trader/ship/electronics/stock_parts
	speech = list("hail_generic"    = "Hello sir! Welcome to ORIGIN, DIY division, I hope you find what you are looking for.",
				"hail_deny"         = "Your call has been disconnected.",

				"trade_complete"    = "Thank you for shopping at ORIGIN, would you like to put a warranty on that?",
				"trade_blacklist"   = "Sir, this is a /electronics/ store.",
				"trade_no_goods"    = "As much as I'd love to buy that from you, I'm not.",
				"trade_not_enough"  = "Your offer isn't adequete to the item you've selected, sir.",
				"how_much"          = "Your total comes out to VALUE thalers.",

				"compliment_deny"   = "Hahaha! Yeah... funny...",
				"compliment_accept" = "That's very nice of you!",
				"insult_good"       = "That was uncalled for, sir. Don't make me get my manager.",
				"insult_bad"        = "Sir, I am allowed to hang up the phone if you continue, sir.",

				"bribe_refusal"     = "Sorry, sir, but I can't really do that.",
				"bribe_accept"      = "Why not! Glad to be here for a few more minutes.",
				)

	possible_trading_items = list(/obj/item/stock_parts                 = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil              = TRADER_SUBTYPES_ONLY,
								/obj/item/stack/cable_coil/cyborg       = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/random       = TRADER_BLACKLIST,
								/obj/item/stack/cable_coil/cut          = TRADER_BLACKLIST,
								/obj/item/cell                          = TRADER_SUBTYPES_ONLY,
								/obj/item/cell/slime                    = TRADER_BLACKLIST,
								/obj/item/stock_parts/smes_coil         = TRADER_ALL,
								/obj/item/storage/part_replacer         = TRADER_THIS_TYPE)

/datum/trader/ship/gardener
	name = "Garden Ship Employee"
	name_language = TRADER_DEFAULT_NAME
	origin = "Plant Store"
	possible_origins = list("Jojo's Greenhouse", "Olive's Garden")
	speech = list("hail_generic"    = "Hello sir! Welcome to ORIGIN!",
				"hail_deny"         = "Your call has been disconnected.",

				"trade_complete"    = "Thanks for taking that off our hands, we have plenty more!",
				"trade_blacklist"   = "We don't even buy /plants/ much less... that.",
				"trade_no_goods"    = "We don't buy, sorry!  We're running out of space as it is!",
				"trade_not_enough"  = "Your don't have enough for that, sir",
				"how_much"          = "It will be about VALUE for that.",

				"compliment_deny"   = "Do you really thing I haven't heard that one before?",
				"compliment_accept" = "Thanks! Always nice to meet someone friendly.",
				"insult_good"       = "Well, that's hardly nice of you to say.",
				"insult_bad"        = "If you keep that up, I'll just hang up.",

				"bribe_refusal"     = "Sorry, I can't accept that, if I stay much longer, I might just put down roots!",
				"bribe_accept"      = "Sure thing! I can stick around for a bit longer.",
				)

	possible_trading_items = list(/obj/machinery/seed_storage                      = TRADER_THIS_TYPE,
								/obj/machinery/vending/hydronutrients              = TRADER_THIS_TYPE,
								/obj/machinery/portable_atmospherics/hydroponics   = TRADER_THIS_TYPE,
								/obj/item/gun/energy/floragun                      = TRADER_THIS_TYPE,
								/obj/item/device/scanner/plant                     = TRADER_THIS_TYPE,
								/obj/structure/reagent_dispensers/watertank        = TRADER_THIS_TYPE,
								/obj/structure/closet/crate/hydroponics/prespawned = TRADER_THIS_TYPE,
								/obj/item/seeds                                    = TRADER_SUBTYPES_ONLY,
								/obj/item/seeds/cutting                            = TRADER_BLACKLIST,
								/obj/item/seeds/bluespacetomatoseed                = TRADER_BLACKLIST,
								/obj/item/seeds/weeds                              = TRADER_BLACKLIST,
								/obj/item/seeds/brownmold                          = TRADER_BLACKLIST,
								/obj/item/seeds/tobaccoseed                        = TRADER_BLACKLIST)
