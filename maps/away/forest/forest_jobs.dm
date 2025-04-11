
/singleton/hierarchy/outfit/job/forest_settler
	name = "Pioneer"
	uniform = /obj/item/clothing/under/frontier
	shoes = /obj/item/clothing/shoes/dutyboots
	suit = /obj/item/clothing/suit/storage/toggle/hoodie/smw
	gloves = /obj/item/clothing/gloves/urist/leather
	back = /obj/item/storage/backpack/rucksack/tan
	backpack_contents = list(/obj/item/device/flashlight/trainlantern = 1, /obj/item/storage/firstaid/regular = 1)

/datum/job/submap/forest_settler
	title = "Terrestrial Pioneer"
	supervisors = "your chosen deity if they can hear you out here."
	total_positions = 4
	outfit_type = /singleton/hierarchy/outfit/job/forest_settler
	info = "Whether the boredom of space life or a desire to get away from the bustle of city life, \
			you are now out on the frontier of human settlement, in a boreal forest valley of a relatively temperate planet. \
			However it isn't as easy as the books and holovids made it look, \
			especially not with the local geneseeded fauna. Still, it can't be worse than the Graveworlds or the Crisis refugee camps.\
			Either way, whatever happens out here at the fringe is between you and your god."

/obj/submap_landmark/spawnpoint/forest_settler
	name = "Terrestrial Pioneer"
