
/datum/gear/workvisa
	description = "A work visa issued by the Terran Confederacy for the purpose of work."

/datum/gear/workvisa/uha
	display_name = "work visa (UHA)"
	description = "A work visa issued by the United Human Alliance for the purpose of work."

/datum/gear/travelvisa
	description = "A travel visa issued by the Terran Confederacy for the purpose of recreation."

/datum/gear/travelvisa/uha
	display_name = "travel visa (UHA)"
	description = "A travel visa issued by the United Human Alliance for the purpose of recreation."
	
/datum/gear/doll/unathi
	display_name = "webbing vest selection"
	path = /obj/item/vanity/doll

/datum/gear/doll/unathi/New()
	..()
	var/dolls_unathi = list()
	dolls_unathi += /obj/item/vanity/doll/unathi/green
	dolls_unathi += /obj/item/vanity/doll/unathi/red
	dolls_unathi += /obj/item/vanity/doll/unathi/black
	dolls_unathi += /obj/item/vanity/doll/unathi/yellow
	dolls_unathi += /obj/item/vanity/doll/unathi/white
	dolls_unathi += /obj/item/vanity/doll/unathi/purple
	dolls_unathi += /obj/item/vanity/doll/unathi/orange
	dolls_unathi += /obj/item/vanity/doll/unathi/brown
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(dolls_unathi)

/datum/gear/foundation_civilian //no registered psychics here
	allowed_roles = list()
