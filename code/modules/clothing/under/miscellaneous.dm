/obj/item/clothing/under/redpyjamas
	name = "red pj's"
	desc = "Sleepwear."
	icon_state = "red_pyjamas"
	worn_state = "red_pyjamas"
	item_state = "w_suit"
	gender_icons = 1

/obj/item/clothing/under/bluepyjamas
	name = "blue pj's"
	desc = "Sleepwear."
	icon_state = "blue_pyjamas"
	worn_state = "blue_pyjamas"
	item_state = "w_suit"
	gender_icons = 1

/obj/item/clothing/under/captain_fly
	name = "rogue's uniform"
	desc = "For the man who doesn't care because he's still free."
	icon_state = "captain_fly"
	item_state = "r_suit"
	worn_state = "captain_fly"

/obj/item/clothing/under/scratch
	name = "white suit"
	desc = "A white suit, suitable for an excellent host."
	icon_state = "scratch"
	item_state = "scratch"
	worn_state = "scratch"

/obj/item/clothing/under/sl_suit
	desc = "It's a very amish looking suit."
	name = "amish suit"
	icon_state = "sl_suit"
	worn_state = "sl_suit"
	item_state = "sl_suit"
	gender_icons = 1

/obj/item/clothing/under/waiter
	name = "waiter's outfit"
	desc = "It's a very smart uniform with a special pocket for tip."
	icon_state = "waiter"
	item_state = "waiter"
	worn_state = "waiter"
	gender_icons = 1

/obj/item/clothing/under/rank/mailman
	name = "mailman's jumpsuit"
	desc = "<i>'Special delivery!'</i>"
	icon_state = "mailman"
	item_state = "b_suit"
	worn_state = "mailman"

/obj/item/clothing/under/sexyclown
	name = "sexy-clown suit"
	desc = "It makes you look HONKable!"
	icon_state = "sexyclown"
	item_state = "clown"
	worn_state = "sexyclown"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/vice
	name = "vice officer's jumpsuit"
	desc = "It's the standard issue pretty-boy outfit, as seen on Holo-Vision."
	icon_state = "vice"
	item_state = "gy_suit"
	worn_state = "vice"

//This set of uniforms looks fairly fancy and is generally used for high-ranking NT personnel from what I've seen, so lets give them appropriate ranks.
/obj/item/clothing/under/rank/centcom
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Captain.\"."
	name = "\improper Officer's Dress Uniform"
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_officer
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral.\"."
	name = "officer's dress uniform"
	icon_state = "officer"
	item_state = "lawyer_black"
	worn_state = "officer"
	displays_id = 0

/obj/item/clothing/under/rank/centcom_captain
	desc = "Gold trim on space-black cloth, this uniform displays the rank of \"Admiral-Executive.\"."
	name = "officer's dress uniform"
	icon_state = "centcom"
	item_state = "lawyer_black"
	worn_state = "centcom"
	displays_id = 0

/obj/item/clothing/under/ert
	name = "\improper ERT tactical uniform"
	desc = "A short-sleeved black uniform, paired with grey digital-camo cargo pants. It looks very tactical."
	icon_state = "ert_uniform"
	item_state = "bl_suit"
	worn_state = "ert_uniform"
	armor = list(
		melee = ARMOR_MELEE_SMALL
		)
	siemens_coefficient = 0.9

/obj/item/clothing/under/space
	name = "\improper NASA jumpsuit"
	desc = "It has a NASA logo on it and is made of space-proofed materials."
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS //Needs gloves and shoes with cold protection to be fully protected.
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/under/acj
	name = "administrative cybernetic jumpsuit"
	icon_state = "syndicate"
	item_state = "bl_suit"
	worn_state = "syndicate"
	desc = "it's a cybernetically enhanced jumpsuit used for administrative duties."
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(
		melee = ARMOR_MELEE_SHIELDED,
		bullet = ARMOR_BALLISTIC_HEAVY,
		laser = ARMOR_LASER_HEAVY,
		energy = ARMOR_ENERGY_SHIELDED,
		bomb = ARMOR_BOMB_SHIELDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SHIELDED
		)
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/under/owl
	name = "owl uniform"
	desc = "A jumpsuit with owl wings. Photorealistic owl feathers! Twooooo!"
	icon_state = "owl"
	worn_state = "owl"
	item_state = "owl"

/obj/item/clothing/under/color/rainbow
	name = "rainbow"
	icon_state = "rainbow"
	item_state = "rainbow"
	worn_state = "rainbow"
	gender_icons = 1

/obj/item/clothing/under/cloud
	name = "cloud"
	icon_state = "cloud"
	worn_state = "cloud"
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/under/psysuit
	name = "dark undersuit"
	desc = "A thick, layered grey undersuit lined with power cables. Feels a little like wearing an electrical storm."
	icon_state = "psysuit"
	item_state = "bl_suit"
	worn_state = "psysuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/under/gentlesuit
	name = "gentleman's suit"
	desc = "A silk black shirt with a white tie and a matching gray vest and slacks. Feels proper."
	icon_state = "gentlesuit"
	item_state = "gy_suit"
	worn_state = "gentlesuit"

/obj/item/clothing/under/gimmick
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/under/gimmick/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	item_state = "dg_suit"
	worn_state = "green_suit"

/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit
	name = "head of personnel's suit"
	desc = "A teal suit and yellow necktie. An authoritative yet tacky ensemble."
	icon_state = "teal_suit"
	item_state = "g_suit"
	worn_state = "teal_suit"

/obj/item/clothing/under/suit_jacket
	name = "black suit"
	desc = "A black suit and red tie. Very formal."
	icon_state = "black_suit"
	item_state = "bl_suit"
	worn_state = "black_suit"

/obj/item/clothing/under/suit_jacket/really_black
	name = "dark black executive suit"
	desc = "A formal black suit and red tie, intended for the galaxy's finest."
	icon_state = "really_black_suit"
	item_state = "jensensuit"
	worn_state = "really_black_suit"

/obj/item/clothing/under/suit_jacket/female
	name = "feminine executive suit"
	desc = "A formal trouser suit for women, intended for the galaxy's finest."
	icon_state = "black_suit_fem"
	item_state = "lawyer_black"
	worn_state = "black_suit_fem"
	gender_icons = 1

/obj/item/clothing/under/suit_jacket/red
	name = "red suit"
	desc = "A red suit and blue tie. Somewhat formal."
	icon_state = "red_suit"
	item_state = "r_suit"
	worn_state = "red_suit"

/obj/item/clothing/under/schoolgirl
	name = "schoolgirl uniform"
	desc = "It's just like one of my Japanese animes!"
	icon_state = "schoolgirl"
	item_state = "b_suit"
	worn_state = "schoolgirl"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/overalls
	name = "laborer's overalls"
	desc = "A set of durable overalls for getting the job done."
	icon_state = "overalls"
	item_state = "lb_suit"
	worn_state = "overalls"

/obj/item/clothing/under/pirate
	name = "pirate outfit"
	desc = "Yarr."
	icon_state = "pirate"
	item_state = "sl_suit"
	worn_state = "pirate"
	gender_icons = 1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/soviet
	name = "soviet uniform"
	desc = "For the Motherland!"
	icon_state = "soviet"
	item_state = "gy_suit"
	worn_state = "soviet"

/obj/item/clothing/under/redcoat
	name = "redcoat uniform"
	desc = "Looks old."
	icon_state = "redcoat"
	item_state = "r_suit"
	worn_state = "redcoat"

/obj/item/clothing/under/kilt
	name = "kilt"
	desc = "Includes shoes and plaid."
	icon_state = "kilt"
	item_state = "kilt"
	worn_state = "kilt"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|FEET

/obj/item/clothing/under/sexymime
	name = "sexy mime outfit"
	desc = "The only time when you DON'T enjoy looking at someone's rack."
	icon_state = "sexymime"
	item_state = "w_suit"
	worn_state = "sexymime"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/gladiator
	name = "gladiator uniform"
	desc = "Are you not entertained? Is that not why you are here?"
	icon_state = "gladiator"
	item_state = "o_suit"
	worn_state = "gladiator"
	body_parts_covered = LOWER_TORSO

//dress
/obj/item/clothing/under/dress
	name = "dress"
	desc = "A fancy dress."
	icon_state = "dress_fire"
	worn_state = "dress_fire"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/dress_fire
	name = "flame dress"
	desc = "A small black dress with blue flames print on it."
	icon_state = "dress_fire"
	item_state = "bl_suit"
	worn_state = "dress_fire"

/obj/item/clothing/under/dress/dress_green
	name = "green dress"
	desc = "A simple, tight fitting green dress."
	icon_state = "dress_green"
	item_state = "g_suit"
	worn_state = "dress_green"

/obj/item/clothing/under/dress/dress_orange
	name = "orange dress"
	desc = "A fancy orange gown for those who like to show leg."
	icon_state = "dress_orange"
	item_state = "y_suit"
	worn_state = "dress_orange"

/obj/item/clothing/under/dress/dress_pink
	name = "pink dress"
	desc = "A simple, tight fitting pink dress."
	icon_state = "dress_pink"
	item_state = "p_suit"
	worn_state = "dress_pink"

/obj/item/clothing/under/dress/dress_purple
	name = "purple dress"
	desc= "A simple, tight fitting purple dress."
	icon_state = "tian_dress"
	item_state = "p_suit"
	worn_state = "tian_dress"

/obj/item/clothing/under/dress/dress_yellow
	name = "yellow dress"
	desc = "A flirty, little yellow dress."
	icon_state = "dress_yellow"
	item_state = "y_suit"
	worn_state = "dress_yellow"

/obj/item/clothing/under/dress/dress_saloon
	name = "saloon girl dress"
	desc = "A old western inspired gown for the girl who likes to drink."
	icon_state = "dress_saloon"
	item_state = "p_suit"
	worn_state = "dress_saloon"


/obj/item/clothing/under/dress/dress_cap
	name = "captain's dress uniform"
	desc = "Feminine fashion for the style concious captain."
	icon_state = "dress_cap"
	item_state = "b_suit"
	worn_state = "dress_cap"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hop
	name = "head of personnel dress uniform"
	desc = "Feminine fashion for the style concious HoP."
	icon_state = "dress_hop"
	item_state = "b_suit"
	worn_state = "dress_hop"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/dress/dress_hr
	name = "human resources director uniform"
	desc = "Superior class for the nosy H.R. Director."
	icon_state = "huresource"
	item_state = "y_suit"
	worn_state = "huresource"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

//wedding stuff
/obj/item/clothing/under/wedding
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/wedding/bride_orange
	name = "orange wedding dress"
	desc = "A big and puffy orange dress."
	icon_state = "bride_orange"
	item_state = "y_suit"
	worn_state = "bride_orange"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_purple
	name = "purple wedding dress"
	desc = "A big and puffy purple dress."
	icon_state = "bride_purple"
	item_state = "p_suit"
	worn_state = "bride_purple"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_blue
	name = "blue wedding dress"
	desc = "A big and puffy blue dress."
	icon_state = "bride_blue"
	item_state = "b_suit"
	worn_state = "bride_blue"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_red
	name = "red wedding dress"
	desc = "A big and puffy red dress."
	icon_state = "bride_red"
	item_state = "r_suit"
	worn_state = "bride_red"
	flags_inv = HIDESHOES

/obj/item/clothing/under/wedding/bride_white
	name = "silky wedding dress"
	desc = "A white wedding gown made from the finest silk."
	icon_state = "bride_white"
	item_state = "nursesuit"
	worn_state = "bride_white"
	flags_inv = HIDESHOES
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress
	name = "sundress"
	desc = "Makes you want to frolic in a field of daisies."
	icon_state = "sundress"
	item_state = "bl_suit"
	worn_state = "sundress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/sundress_white
	name = "white sundress"
	desc = "A white sundress decorated with purple lilies."
	icon_state = "sundress_white"
	item_state = "sundress_white"
	worn_state = "sundress_white"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/blackjumpskirt
	name = "black jumpskirt"
	desc = "A black jumpskirt, with a pink undershirt."
	icon_state = "blackjumpskirt"
	item_state = "bl_suit"
	worn_state = "blackjumpskirt"

/obj/item/clothing/under/shortjumpskirt
	name = "short jumpskirt"
	desc = "A slimming, short jumpskirt."
	icon_state = "shortjumpskirt"
	item_state = "w_suit"
	worn_state = "shortjumpskirt"

/obj/item/clothing/under/captainformal
	name = "captain's formal uniform"
	desc = "A captain's formal-wear, for special occasions."
	icon_state = "captain_formal"
	item_state = "b_suit"
	worn_state = "captain_formal"

/obj/item/clothing/under/hosformalmale
	name = "head of security's formal uniform"
	desc = "A male head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_male"
	item_state = "r_suit"
	worn_state = "hos_formal_male"

/obj/item/clothing/under/hosformalfem
	name = "head of security's formal uniform"
	desc = "A female head of security's formal-wear, for special occasions."
	icon_state = "hos_formal_fem"
	item_state = "r_suit"
	worn_state = "hos_formal_fem"

/obj/item/clothing/under/assistantformal
	name = "assistant's formal uniform"
	desc = "An assistant's formal-wear. Why an assistant needs formal-wear is still unknown."
	icon_state = "assistant_formal"
	item_state = "gy_suit"
	worn_state = "assistant_formal"

/obj/item/clothing/under/suit_jacket/charcoal
	name = "charcoal suit"
	desc = "A charcoal suit and red tie. Very professional."
	icon_state = "charcoal_suit"
	item_state = "bl_suit"
	worn_state = "charcoal_suit"
	gender_icons = 1
	accessories = list(/obj/item/clothing/accessory/navy, /obj/item/clothing/accessory/toggleable/charcoal_jacket)

/obj/item/clothing/under/suit_jacket/navy
	name = "navy suit"
	desc = "A navy suit and red tie, intended for the galaxy's finest."
	icon_state = "navy_suit"
	item_state = "bl_suit"
	worn_state = "navy_suit"
	gender_icons = 1
	accessories = list(/obj/item/clothing/accessory/red, /obj/item/clothing/accessory/toggleable/navy_jacket)

/obj/item/clothing/under/suit_jacket/burgundy
	name = "burgundy suit"
	desc = "A burgundy suit and black tie. Somewhat formal."
	icon_state = "burgundy_suit"
	item_state = "r_suit"
	worn_state = "burgundy_suit"
	gender_icons = 1
	accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/toggleable/burgundy_jacket)

/obj/item/clothing/under/suit_jacket/checkered
	name = "checkered suit"
	desc = "That's a very nice suit you have there. Shame if something were to happen to it, eh?"
	icon_state = "checkered_suit"
	item_state = "gy_suit"
	worn_state = "checkered_suit"
	gender_icons = 1
	accessories = list(/obj/item/clothing/accessory/black, /obj/item/clothing/accessory/toggleable/checkered_jacket)

/obj/item/clothing/under/suit_jacket/tan
	name = "tan suit"
	desc = "A tan suit. Smart, but casual."
	icon_state = "tan_suit"
	item_state = "lb_suit"
	worn_state = "tan_suit"
	gender_icons = 1
	accessories = list(/obj/item/clothing/accessory/yellow, /obj/item/clothing/accessory/toggleable/tan_jacket)

/obj/item/clothing/under/serviceoveralls
	name = "workman outfit"
	desc = "The very image of a working man. Not that you're probably doing work."
	icon_state = "mechanic"
	item_state = "lb_suit"
	worn_state = "mechanic"

/obj/item/clothing/under/cheongsam
	name = "cheongsam"
	desc = "It is a cheongsam dress."
	icon_state = "mai_yang"
	item_state = "mai_yang"
	worn_state = "mai_yang"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/abaya
	name = "abaya"
	desc = "A loose-fitting, robe-like dress."
	icon_state = "abaya"
	item_state = "abaya"
	worn_state = "abaya"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/blazer
	name = "blue blazer"
	desc = "A bold but yet conservative outfit, red corduroys, navy blazer and a tie."
	icon_state = "blue_blazer"
	item_state = "blue_blazer"
	worn_state = "blue_blazer"

/obj/item/clothing/under/harness
	name = "gear harness"
	desc = "How... minimalist."
	icon_state = "gear_harness"
	worn_state = "gear_harness"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/under/pcrc
	name = "\improper PCRC uniform"
	desc = "A uniform belonging to Proxima Centauri Risk Control, a private security firm."
	icon_state = "pcrc"
	item_state = "jensensuit"
	worn_state = "pcrc"
	gender_icons = 1

/obj/item/clothing/under/pcrcsuit
	name = "\improper PCRC suit"
	desc = "A suit belonging to Proxima Centauri Risk Control, a private security firm. This one looks more formal than its utility counterpart."
	icon_state = "pcrcsuit"
	item_state = "jensensuit"
	worn_state = "pcrcsuit"
	gender_icons = 1

/obj/item/clothing/under/grayson
	name = "\improper Grayson overalls"
	desc = "A set of overalls belonging to Grayson Manufactories, a manufacturing and mining company."
	icon_state = "grayson"
	worn_state = "grayson"

/obj/item/clothing/under/wardt
	name = "\improper Ward-Takahashi jumpsuit"
	desc = "A jumpsuit belonging to Ward-Takahashi, a megacorp in the consumer goods and research market."
	icon_state = "wardt"
	worn_state = "wardt"
	gender_icons = 1

/obj/item/clothing/under/dais
	name = "\improper Deimos Advanced Information Systems uniform"
	desc = "The uniform of Deimos Advanced Information Systems, an IT company."
	icon_state = "dais"
	worn_state = "dais"

/obj/item/clothing/under/mbill
	name = "\improper Major Bill's uniform"
	desc = "A uniform belonging to Major Bill's Transportation, a major shipping company."
	icon_state = "mbill"
	worn_state = "mbill"
	gender_icons = 1

/obj/item/clothing/under/morpheus
	name = "\improper Morpheus Cyberkinetics uniform"
	desc = "A pair of overalls belonging to Morpheus Cyberkinetics, an IPC manufacturing company. It doesn't look like it would be comfortable on a human."
	icon_state = "morpheus"
	worn_state = "morpheus"

/obj/item/clothing/under/skinner
	name = "\improper Skinner Catering uniform"
	desc = "A uniform belonging to Skinner's Catering, a dining company."
	icon_state = "skinner"
	worn_state = "skinner"

// Replace this with actual uniform when someone wants to sprite one
/obj/item/clothing/under/confederacy
	name = "\improper Confederate uniform"
	desc = "A military uniform belonging to the Gilgamesh Colonial Confederation, an independent human government."
	icon_state = "confed"
	worn_state = "confed"

/obj/item/clothing/under/saare
	name = "\improper SAARE uniform"
	desc = "A uniform belonging to Strategic Assault and Asset Retention Enterprises, a minor private military corporation."
	icon_state = "saare"
	worn_state = "saare"
	gender_icons = 1

/obj/item/clothing/under/frontier
	name = "frontier clothes"
	desc = "A rugged flannel shirt and denim overalls. A popular style among frontier colonists."
	icon_state = "frontier"
	worn_state = "frontier"

/obj/item/clothing/under/aether
	name = "\improper Aether jumpsuit"
	desc = "A jumpsuit belonging to Aether Atmospherics and Recycling, a company that supplies recycling and atmospheric systems to colonies."
	icon_state = "aether"
	worn_state = "aether"
	gender_icons = 1

/obj/item/clothing/under/focal
	name = "\improper Focal Point jumpsuit"
	desc = "A jumpsuit belonging to Focal Point Energistics, an engineering corporation."
	icon_state = "focal"
	worn_state = "focal"

/obj/item/clothing/under/hephaestus
	name = "\improper Hephaestus jumpsuit"
	desc = "A jumpsuit belonging to Hephaestus Industries, a megacorp best known for its arms production."
	icon_state = "heph"
	worn_state = "heph"
	gender_icons = 1

/obj/item/clothing/under/punpun
	name = "fancy uniform"
	desc = "It looks like it was tailored for a monkey."
	icon_state = "punpun"
	worn_state = "punpun"
	species_restricted = list(SPECIES_MONKEY)
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/onmob_under_monkey.dmi')
	item_flags = ITEM_FLAG_WASHER_ALLOWED | ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/under/punpants
	name = "monkey pants"
	desc = "It looks like it was tailored for a monkey."
	icon_state = "jeansmustang"
	worn_state = "jeansmustang"
	species_restricted = list(SPECIES_MONKEY)
	sprite_sheets = list("Monkey" = 'icons/mob/species/monkey/onmob_under_monkey.dmi')
	item_flags = ITEM_FLAG_WASHER_ALLOWED | ITEM_FLAG_INVALID_FOR_CHAMELEON

/obj/item/clothing/under/rank/psych/turtleneck/sweater
	desc = "A warm looking sweater and a pair of dark blue slacks."
	name = "sweater"
	icon_state = "turtleneck"
	worn_state = "turtleneck"

/obj/item/clothing/under/savage_hunter
	name = "savage hunter's hides"
	desc = "Makeshift hides bound together with the sinew, packwax, and leather of some alien creature."
	icon_state = "hunterhide"
	item_state = "hunter"
	worn_state = "hunter"
	body_parts_covered = LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/savage_hunter/female
	name = "savage huntress's hides"
	desc = "Makeshift hides bound together with the sinew, packwax, and leather of some alien creature. Includes a chestwrap so as not to leave one topless."
	worn_state = "huntress"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS

/obj/item/clothing/under/wetsuit
	name = "tactical wetsuit"
	desc = "For when you want to scuba dive your way into an enemy base but still want to show off a little skin."
	icon_state = "wetsuit"
	item_state = "wetsuit"
	worn_state = "wetsuit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/hazard
	name = "hazard jumpsuit"
	desc = "A high visibility jumpsuit made from heat and radiation resistant materials."
	icon_state = "hazard"
	item_state = "engi_suit"
	worn_state = "hazard"
	gender_icons = 1
	siemens_coefficient = 0.8
	armor = list(
		energy = ARMOR_ENERGY_SMALL,
		rad = ARMOR_RAD_MINOR
		)
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/under/sterile
	name = "sterile jumpsuit"
	desc = "A sterile white jumpsuit with medical markings. Protects against all manner of biohazards."
	icon_state = "sterile"
	item_state = "w_suit"
	worn_state = "sterile"
	gender_icons = 1
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_SMALL
		)

/obj/item/clothing/under/sterile/emrs
	name = "medical uniform"
	desc = "An uniform worn in emergency medical and reanimation services across human space."
	icon_state = "medical_uniform"
	item_state = "medical_uniform"
	worn_state = "medical_uniform"

/obj/item/clothing/under/kimono
	desc = "A traditional robe with remarkably long sleeves, mostly worn by women. <i>Sugoi.</i>"
	name = "kimono"
	icon_state = "kimono"
	worn_state = "kimono"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
