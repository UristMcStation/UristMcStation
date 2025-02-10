// Hey! Listen! Update \config\exoplanet_ruin_blacklist.txt with your new ruins!
/datum/map_template/ruin/exoplanet
	prefix = "maps/random_ruins/exoplanet_ruins/"
	var/list/ruin_tags

/* Go to \maps\_maps.dm and setup a include - i.e #include "random_ruins\exoplanet_ruins\examplefolder\examplemap.dm"
in order to setup your new exoplanet ruins you have added.
for ease of testing, use template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED  in your /datum/map_template/ruin/exoplanet/examplemap    in order to force it each round. - Y */
