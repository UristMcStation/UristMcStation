/*
 * Science
 */
/obj/item/clothing/under/rank/research_director
	desc = "It's a jumpsuit worn by those with the know-how to achieve the position of \"Chief Science Officer\". Its fabric provides minor protection from biological contaminants."
	name = "chief science officer's jumpsuit"
	icon_state = "director"
	item_state = "lb_suit"
	worn_state = "director"
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/research_director/rdalt
	desc = "A dress suit and slacks stained with hard work and dedication to science. Perhaps other things as well, but mostly hard work and dedication."
	name = "head researcher uniform"
	icon_state = "rdalt"
	item_state = "lb_suit"
	worn_state = "rdalt"
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/research_director/dress_rd
	name = "chief science officer dress uniform"
	desc = "Feminine fashion for the style concious CSO. Its fabric provides minor protection from biological contaminants."
	icon_state = "dress_rd"
	item_state = "lb_suit"
	worn_state = "dress_rd"
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/rank/scientist
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has markings that denote the wearer as a scientist."
	name = "scientist's jumpsuit"
	icon_state = "science"
	item_state = "w_suit"
	worn_state = "sciencewhite"
	permeability_coefficient = 0.50
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/under/rank/chemist
	desc = "It's made of a special fiber that gives special protection against biohazards. The striping on the suit denotes the wearer as a trained pharmacist."
	name = "pharmacist's jumpsuit"
	icon_state = "chemistry"
	item_state = "w_suit"
	worn_state = "chemistrywhite"
	gender_icons = 1
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
/*
 * Medical
 */
/obj/item/clothing/under/rank/chief_medical_officer
	desc = "It's a jumpsuit worn by those with the experience to be \"Chief Medical Officer\". It provides minor biological protection."
	name = "chief medical officer's jumpsuit"
	icon_state = "cmo"
	item_state = "w_suit"
	worn_state = "cmo"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/geneticist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a genetics rank stripe on it."
	name = "geneticist's jumpsuit"
	icon_state = "genetics"
	item_state = "w_suit"
	worn_state = "geneticswhite"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/virologist
	desc = "It's made of a special fiber that gives special protection against biohazards. It has a virologist rank stripe on it."
	name = "virologist's jumpsuit"
	icon_state = "virology"
	item_state = "w_suit"
	worn_state = "virologywhite"
	gender_icons = 1
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/nursesuit
	desc = "It's a jumpsuit commonly worn by nursing staff in the medical department."
	name = "nurse's suit"
	icon_state = "nursesuit"
	item_state = "nursesuit"
	worn_state = "nursesuit"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/nurse
	desc = "A dress commonly worn by the nursing staff in the medical department."
	name = "nurse's dress"
	icon_state = "nurse"
	item_state = "nursesuit"
	worn_state = "nurse"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/rank/orderly
	desc = "A white suit to be worn by medical attendants."
	name = "orderly's uniform"
	icon_state = "orderly"
	item_state = "nursesuit"
	worn_state = "orderly"
	gender_icons = 1
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/medical
	desc = "It's made of a special fiber that provides minor protection against biohazards. It has a cross on the chest denoting that the wearer is trained medical personnel."
	name = "medical doctor's jumpsuit"
	icon_state = "medical"
	item_state = "w_suit"
	worn_state = "medical"
	gender_icons = 1
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/medical/paramedic
	name = "short sleeve medical jumpsuit"
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one has a cross on the chest denoting that the wearer is trained medical personnel."
	icon_state = "medical"
	item_state = "medical_short"
	worn_state = "medical_short"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS

/obj/item/clothing/under/rank/medical/scrubs
	name = "scrubs"
	desc = "A loose-fitting garment designed to provide minor protection against biohazards."
	icon_state = "scrubs"
	worn_state = "scrubs"
	gender_icons = 1

/obj/item/clothing/under/rank/medical/scrubs/blue
	name = "blue scrubs"
	color = "#4891e1"

/obj/item/clothing/under/rank/medical/scrubs/green
	name = "green scrubs"
	color = "#255a3e"

/obj/item/clothing/under/rank/medical/scrubs/purple
	name = "purple scrubs"
	color = "#7a1b3f"

/obj/item/clothing/under/rank/medical/scrubs/black
	name = "black scrubs"
	color = "#242424"

/obj/item/clothing/under/rank/medical/scrubs/navyblue
	name = "navy blue scrubs"
	color = "#1f3a69"

/obj/item/clothing/under/rank/medical/scrubs/lilac
	name = "lilac scrubs"
	color = "#c8a2c8"

/obj/item/clothing/under/rank/medical/scrubs/teal
	name = "teal scrubs"
	color = "#008080"

/obj/item/clothing/under/rank/medical/scrubs/heliodor
	name = "heliodor scrubs"
	color = "#aad539"

/obj/item/clothing/under/rank/medical/scrubs/lavender
	name = "lavender scrubs"
	color = "#bebbee"

/obj/item/clothing/under/rank/psych
	desc = "A basic white jumpsuit. It has turqouise markings that denote the wearer as a psychiatrist."
	name = "psychiatrist's jumpsuit"
	icon_state = "psych"
	item_state = "w_suit"
	worn_state = "psych"
	gender_icons = 1

/obj/item/clothing/under/rank/psych/turtleneck
	desc = "A turqouise sweater and a pair of dark blue slacks."
	name = "turqouise turtleneck"
	icon_state = "psychturtle"
	item_state = "b_suit"
	worn_state = "psychturtle"


/*
 * Medsci, unused (i think) stuff
 */
/obj/item/clothing/under/rank/geneticist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "geneticist's jumpsuit"
	icon_state = "geneticist_new"
	item_state = "w_suit"
	worn_state = "geneticist_new"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/chemist_new
	desc = "It's made of a special fiber which provides minor protection against biohazards."
	name = "chemist's jumpsuit"
	icon_state = "chemist_new"
	item_state = "w_suit"
	worn_state = "chemist_new"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/scientist_new
	desc = "Made of a special fiber that gives special protection against biohazards and small explosions."
	name = "scientist's jumpsuit"
	icon_state = "scientist_new"
	item_state = "w_suit"
	worn_state = "scientist_new"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)

/obj/item/clothing/under/rank/virologist_new
	desc = "Made of a special fiber that gives increased protection against biohazards."
	name = "virologist's jumpsuit"
	icon_state = "virologist_new"
	item_state = "w_suit"
	worn_state = "virologist_new"
	permeability_coefficient = 0.50
	armor = list(
		bio = ARMOR_BIO_MINOR
		)
