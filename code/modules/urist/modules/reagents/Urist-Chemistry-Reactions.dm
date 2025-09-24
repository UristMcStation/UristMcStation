// Urist Specific Chemistry Reactions go here.

//singleton/reaction/urist_example
//	name = "Example"
//	result = /datum/reagent/example
//	required_reagents = list(/datum/reagent/example = 1, /datum/reagent/example_2 = 1)
//	result_amount = 5

/singleton/reaction/napalk
	name = "Napalk"
	result = /datum/reagent/drink/napalk
	required_reagents = list(/datum/reagent/drink/pilk = 1, /datum/reagent/napalm = 1)
	result_amount = 2
	mix_message = "The pilk mixes with the gooey napalm, forming a slick slurry of a substance that reeks of milk and gasoline. This is a crime against humanity."

/singleton/reaction/pilk
	name = "Pilk"
	result = /datum/reagent/drink/pilk
	required_reagents = list(/datum/reagent/drink/milk = 1, /datum/reagent/drink/space_cola = 1)
	result_amount = 2
	mix_message = "The cola mixes together with the milk, forming a gross, off-brown substance. A chill goes down your spine, and in the distance, you think you can hear someone weeping."

/singleton/reaction/spacelube // Restores Space Lube from Bay Merge.
	name = "Space Lube"
	result = /datum/reagent/lube
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/silicon = 1, /datum/reagent/acetone = 1)
	result_amount = 4
	mix_message = "The solution becomes thick and slimy."
