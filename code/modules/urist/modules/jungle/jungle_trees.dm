//treeeeeeeeees

/obj/structure/flora/tree/jungle
	name = "jungle tree"
	desc = "A large tree commonly found in jungle areas."

/obj/structure/flora/tree/jungle/large
	icon = 'icons/urist/jungle/trees-large.dmi'
	icon_state = "tree1"

/obj/structure/flora/tree/jungle/large/New()
	if(prob(25))
		icon_state = "tree1"
	if(prob(25))
		icon_state = "tree2"
	if(prob(25))
		icon_state = "tree3"
	if(prob(25))
		icon_state = "tree4"

/obj/structure/flora/tree/jungle/small
	icon = 'icons/urist/jungle/trees-small.dmi'
	icon_state = "tree1"

/obj/structure/flora/tree/jungle/small/New()
	if(prob(10))
		icon_state = "tree1"
	if(prob(10))
		icon_state = "tree2"
	if(prob(10))
		icon_state = "tree3"
	if(prob(10))
		icon_state = "tree4"
	if(prob(10))
		icon_state = "tree5"
	if(prob(10))
		icon_state = "tree6"
	if(prob(10))
		icon_state = "tree7"
	if(prob(10))
		icon_state = "tree8"
	if(prob(10))
		icon_state = "tree9"
	if(prob(10))
		icon_state = "tree10"
