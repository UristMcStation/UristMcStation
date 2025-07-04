

/obj/item/clothing/head/centhat
	name = "\improper CentComm. hat"
	icon_state = "centcom"
	item_state_slots = list(
		slot_l_hand_str = "centhat",
		slot_r_hand_str = "centhat",
		)
	desc = "It's good to be emperor."
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/hairflower
	name = "hair flower pin"
	icon_state = "hairflower"
	desc = "A floral pin with a clip on the back to attach to hair."
	slot_flags = SLOT_HEAD | SLOT_EARS
	body_parts_covered = 0

/obj/item/clothing/head/hairflower/red
	color = COLOR_RED

/obj/item/clothing/head/hairflower/blue
	color = COLOR_BLUE

/obj/item/clothing/head/hairflower/pink
	color = COLOR_PINK

/obj/item/clothing/head/hairflower/yellow
	color = COLOR_YELLOW

/obj/item/clothing/head/hairflower/bow
	icon_state = "bow"
	name = "hair bow"
	desc = "A ribbon tied into a bow with a clip on the back to attach to hair."

/obj/item/clothing/head/powdered_wig
	name = "powdered wig"
	desc = "A powdered wig."
	icon_state = "pwig"
	item_state = "pwig"

/obj/item/clothing/head/that
	name = "tophat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"
	item_state = "tophat"
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/redcoat
	name = "redcoat's hat"
	icon_state = "redcoat"
	desc = "<i>'I guess it's a redhead.'</i>"
	body_parts_covered = 0

/obj/item/clothing/head/mailman
	name = "mail cap"
	icon_state = "mailman"
	desc = "<i>Choo-choo</i>!"
	body_parts_covered = 0

/obj/item/clothing/head/plaguedoctorhat
	name = "plague doctor hat"
	desc = "These were once used by Plague doctors. They're pretty much useless."
	icon_state = "plaguedoctor"
	permeability_coefficient = 0.01
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/hasturhood
	name = "hastur's hood"
	desc = "It's unspeakably stylish."
	icon_state = "hasturhood"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/nursehat
	name = "nurse's hat"
	desc = "It allows quick identification of trained medical personnel."
	icon_state = "nursehat"
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/syndicatefake
	name = "red space-helmet replica"
	item_state_slots = list(
		slot_l_hand_str = "syndicate-helm-black-red",
		slot_r_hand_str = "syndicate-helm-black-red",
		)
	icon_state = "syndicate"
	desc = "A plastic replica of a syndicate agent's space helmet, you'll look just like a real murderous syndicate agent in this! This is a toy, it is not made for use in space!"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = HEAD|FACE|EYES
	item_flags = null

/obj/item/clothing/head/cueball
	name = "cueball helmet"
	desc = "A large, featureless white orb mean to be worn on your head. How do you even see out of this thing?"
	icon_state = "cueball"
	item_state = "cueball"
	flags_inv = BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	item_flags = null

/obj/item/clothing/head/cardborg
	name = "cardborg helmet"
	desc = "A helmet made out of a box."
	icon_state = "cardborg_h"
	item_state = "cardborg_h"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	item_flags = null

/obj/item/clothing/head/cardborg/Initialize()
	. = ..()
	set_extension(src, /datum/extension/appearance/cardborg)

/obj/item/clothing/head/rabbitears
	name = "rabbit ears"
	desc = "Nyaaaaaaa, what's up doc?"
	icon_state = "bunny"
	body_parts_covered = 0

/obj/item/clothing/head/flatcap
	name = "flat cap"
	desc = "A working man's cap."
	icon_state = "flatcap_white"
	item_state_slots = list(
		slot_l_hand_str = "det_hat",
		slot_r_hand_str = "det_hat",
		)
	siemens_coefficient = 0.9


/obj/item/clothing/head/mariner
	name = "mariner's cap"
	desc = "A cap loved by farmers, sailors and rabblerousers in the whole galaxy."
	icon_state = "mariner_white"
	siemens_coefficient = 0.9

/obj/item/clothing/head/pirate
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "pirate"
	body_parts_covered = 0

/obj/item/clothing/head/hgpiratecap
	name = "pirate hat"
	desc = "Yarr."
	icon_state = "hgpiratecap"
	body_parts_covered = 0

/obj/item/clothing/head/bandana
	name = "pirate bandana"
	desc = "Yarr."
	icon_state = "pirate_bandana"
	body_parts_covered = 0

/obj/item/clothing/head/bowler
	name = "bowler-hat"
	desc = "Gentleman, elite aboard!"
	icon_state = "bowler"
	body_parts_covered = 0

//stylish bs12 hats

/obj/item/clothing/head/bowlerhat
	name = "bowler hat"
	icon_state = "bowler_hat"
	desc = "For the gentleman of distinction."
	body_parts_covered = 0

/obj/item/clothing/head/bowlerhat/razor
	name = "bowler-hat"
	desc = "The brim of this hat is covered in thin razors."
	sharp = TRUE
	edge = TRUE
	force = 10
	throwforce = 60
	throw_range = 9
	throw_speed = 4
	does_spin = FALSE
	attack_verb = list("sliced", "torn", "cut")
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
		)

/obj/item/clothing/head/beaverhat
	name = "beaver hat"
	icon_state = "beaver_hat"
	desc = "Soft felt makes this hat both comfortable and elegant."

/obj/item/clothing/head/boaterhat
	name = "boater hat"
	icon_state = "boater_hat"
	desc = "The ultimate in summer fashion."

/obj/item/clothing/head/fedora
	name = "fedora"
	icon_state = "fedora"
	desc = "A sharp, stylish hat."

/obj/item/clothing/head/panama
	name = "panama hat"
	icon_state = "panama"
	desc = "A hat that makes you want to smuggle drugs."


/obj/item/clothing/head/feathertrilby
	name = "feather trilby"
	icon_state = "feather_trilby"
	desc = "A sharp, stylish hat with a feather."

/obj/item/clothing/head/fez
	name = "fez"
	icon_state = "fez"
	desc = "You should wear a fez. Fezzes are cool."

//end bs12 hats

/obj/item/clothing/head/witchwig
	name = "witch costume wig"
	desc = "Eeeee~heheheheheheh!"
	icon_state = "witch"
	flags_inv = BLOCKHAIR
	siemens_coefficient = 2.0

/obj/item/clothing/head/chicken
	name = "chicken suit head"
	desc = "Bkaw!"
	icon_state = "chickenhead"
	item_state_slots = list(
		slot_l_hand_str = "chickensuit",
		slot_r_hand_str = "chickensuit",
		)
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7
	body_parts_covered = HEAD|FACE|EYES

/obj/item/clothing/head/bearpelt
	name = "bear pelt hat"
	desc = "Fuzzy."
	icon_state = "bearpelt"
	flags_inv = BLOCKHAIR
	siemens_coefficient = 0.7

/obj/item/clothing/head/xenos
	name = "xenos helmet"
	icon_state = "xenos"
	item_state_slots = list(
		slot_l_hand_str = "xenos_helm",
		slot_r_hand_str = "xenos_helm",
		)
	desc = "A helmet made out of chitinous alien hide."
	w_class = ITEM_SIZE_NORMAL
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	siemens_coefficient = 2.0
	body_parts_covered = HEAD|FACE|EYES
	item_flags = null

/obj/item/clothing/head/philosopher_wig
	name = "natural philosopher's wig"
	desc = "A stylish monstrosity unearthed from Earth's Renaissance period. With this most distinguish'd wig, you'll be ready for your next soiree!"
	icon_state = "philosopher_wig"
	item_state_slots = list(
		slot_l_hand_str = "pwig",
		slot_r_hand_str = "pwig",
		)
	flags_inv = BLOCKHAIR
	body_parts_covered = 0

/obj/item/clothing/head/hijab
	name = "hijab"
	desc = "A veil which is wrapped to cover the head and chest."
	icon_state = "hijab"
	body_parts_covered = 0
	flags_inv = BLOCKHAIR

/obj/item/clothing/head/kippa
	name = "kippa"
	desc = "A small, brimless cap."
	icon_state = "kippa"
	body_parts_covered = 0

/obj/item/clothing/head/turban
	name = "turban"
	desc = "A sturdy cloth, worn around the head."
	icon_state = "turban"
	body_parts_covered = 0
	flags_inv = BLOCKHEADHAIR //Shows beards!

/obj/item/clothing/head/cowboy_hat
	name = "cowboy hat"
	desc = "A wide-brimmed hat, in the prevalent style of America's frontier period. By SolGov law, you are required to wear this hat while watching True Grit."
	icon_state = "cowboyhat"
	item_state = "cowboy_hat"
	body_parts_covered = 0

/obj/item/clothing/head/taqiyah
	name = "taqiyah"
	desc = "A short, rounded skullcap usually worn for religious purposes."
	icon_state = "taqiyah"
	item_state = "taqiyah"
	body_parts_covered = 0

/obj/item/clothing/head/rastacap
	name = "rastacap"
	desc = "A round, crocheted cap, often worn to tuck hair away or for religious purposes."
	icon_state = "rastacap"
	item_state = "rastacap"
	body_parts_covered = 0
	flags_inv = BLOCKHEADHAIR

/obj/item/clothing/head/tank
	name = "padded cap"
	desc = "A padded skullcup for those prone to bumping their heads against hard surfaces."
	icon_state = "tank"
	flags_inv = BLOCKHEADHAIR
	color = "#5f5f5f"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bomb = ARMOR_BOMB_PADDED
		)

/obj/item/clothing/head/tank/olive
	color = "#727c58"

/obj/item/clothing/head/tank/tan
	color = "#ae9f79"

/obj/item/clothing/head/beanie
	name = "beanie"
	desc = "A head-hugging brimless winter cap. This one is tight."
	icon_state = "beanie"
	item_state = "beanie"
	body_parts_covered = 0

/obj/item/clothing/head/helmet/facecover
	name = "face cover"
	desc = "A helmet made of plastic. It's completely opaque. This will stop the stare."
	icon_state = "facecover"
	valid_accessory_slots = null
	tint = TINT_BLIND
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/head/beret/pcrc
	name = "\improper PCRC beret"
	desc = "A navy beret with the emblem of Proxima Centauri Risk Control, a private security firm. For agents that are more inclined towards style than safety."
	icon_state = "beret_corporate_pcrc"

/obj/item/clothing/head/beret/saare
	name = "\improper SAARE beret"
	desc = "A gray beret with the emblem of Strategic Assault and Asset Retention Enterprises, a private military corporation. For mercenaries that are more inclined towards style than safety."
	icon_state = "beret_corporate_saare"

/obj/item/clothing/head/deckcrew
	name = "deck crew helmet"
	desc = "A helmet with ear protection and a visor, used in hangars on many ships."
	icon_state = "deckcrew"
	flags_inv = BLOCKHEADHAIR
	volume_multiplier = 0.1

/obj/item/clothing/head/deckcrew/green
	name = "green deck crew helmet"
	desc = "A helmet with ear protection and a visor, used by support staff in Fleet hangars."
	icon_state = "deckcrew_g"

/obj/item/clothing/head/deckcrew/blue
	name = "blue deck crew helmet"
	desc = "A helmet with ear protection and a visor, used by tug operators in Fleet hangars."
	icon_state = "deckcrew_b"

/obj/item/clothing/head/deckcrew/yellow
	name = "yellow deck crew helmet"
	desc = "A helmet with ear protection and a visor, used by traffic control in Fleet hangars."
	icon_state = "deckcrew_y"

/obj/item/clothing/head/deckcrew/purple
	name = "purple deck crew helmet"
	desc = "A helmet with ear protection and a visor, used by fueling personnel in Fleet hangars."
	icon_state = "deckcrew_p"

/obj/item/clothing/head/deckcrew/red
	name = "red deck crew helmet"
	desc = "A helmet with ear protection and a visor, used by munitions handlers in Fleet hangars."
	icon_state = "deckcrew_r"
