// Uplink Items specifically made for Urist

// Holdout Dagger/Pen Dagger
/*
/obj/item/pen/dagger
	desc = "It's a normal black ink pen, the nib feels sharp to touch and is harder to click."
	origin_tech = TECH_COMBAT = 1
	var/dagger = FALSE
	w_class = ITEM_SIZE_TINY


*/
// Urist's Homebrew.

/obj/item/reagent_containers/food/drinks/bottle/uristmoonshine
	name = "Urist's Moonshine"
	desc = "A dusty looking bottle of plump helmet moonshine. It has a label stating 'URIST MCDWARFS, DO NOT TOUCH!'"
//	icon_state = "moonshine"
//	center_of_mass = "x=16;y=6"

// Bluespace Shotglass.

/obj/item/reagent_containers/food/drinks/glass2/shot/bluespace
	name = "shot glass"
	desc = "A small glass, designed so that its contents can be consumed in one gulp. It looks bigger from the inside."
	base_name = "shot"
	base_icon = "shot"
	icon = 'icons/obj/drink_glasses/shot.dmi'
	filling_states = "33;66;100"
	volume = 80
	matter = list(MATERIAL_GLASS = 15)
	possible_transfer_amounts = "1;5;30"
	rim_pos = "y=17;x_left=13;x_right=21"
//	var/drinkall

// Greytide Toolbox

/obj/item/storage/toolbox/greytide				// It would be funny if going bald would increase the damage even more... perhaps i should add that, truely we are not bay
	name = "Ancient Toolbox"
	desc = "An ancient dusty red toolbox. It looks very robust. Only a true greytider could use this."
//	icon_state = "fillthisin"
//	icon_state = "red"
//	item_state = "toolbox_red"
	force = 30
	attack_cooldown = 10
	melee_accuracy_bonus = 0
	base_parry_chance = 35
	w_class = ITEM_SIZE_LARGE
	attack_verb = list("robusts", "robusted", "greytides", "bludgeoned") // shitter tech
	use_sound = 'sound/effects/storage/toolbox.ogg'
	matter = list(MATTER_STEEL = 10000)

/obj/item/seeds/maneater
	name = "Maneater Seeds"
	desc = "A pack of maneater seeds. You probably don't want to be around these when they are ready."
	icon_state = "fillthis in"

/obj/item/reagent_containers/glass/bottle/unknownreagent
	name = "Unknown Reagent."
	desc = "Containers a strange crimson red substance..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-4"


/obj/item/reagent_containers/glass/bottle/unknownreagent/New()
	..()
	reagents.add_reagent(/datum/reagent/zombie, 5)
	update_icon()
