/obj/overmap/visitable/sector/exoplanet/chlorine
	name = "chlorine exoplanet"
	desc = "An exoplanet with a chlorine based ecosystem. Large quantities of liquid chlorine are present."
	color = "#c9df9f"
	planetary_area = /area/exoplanet/chlorine
	rock_colors = list(COLOR_GRAY80, COLOR_PALE_GREEN_GRAY, COLOR_PALE_BTL_GREEN)
	plant_colors = list("#eba487", "#ceeb87", "#eb879c", "#ebd687", "#f6d6c9", "#f2b3e0")
	map_generators = list(/datum/random_map/noise/exoplanet/chlorine, /datum/random_map/noise/ore/poor)
	ruin_tags_blacklist = RUIN_HABITAT|RUIN_WATER
	surface_color = "#a3b879"
	water_color = COLOR_BOTTLE_GREEN
	habitability_weight = HABITABILITY_BAD
	has_trees = FALSE
	flora_diversity = 5
	fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/hostile/retaliate/beast/samak/alt, /mob/living/simple_animal/yithian, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/retaliate/jelly)
	megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/jelly/mega)
	sun_brightness_modifier = 0.5 //The dense atmosphere makes it all dark

/obj/overmap/visitable/sector/exoplanet/chlorine/get_atmosphere_color()
	var/air_color = ..()
	return MixColors(list("#e5f2bd", air_color))

/obj/overmap/visitable/sector/exoplanet/chlorine/generate_atmosphere()
	..()
	var/chlor_moles = (rand(1, 6) / 10) * (exterior_atmosphere.total_moles)
	exterior_atmosphere = exterior_atmosphere.remove(chlor_moles )
	exterior_atmosphere.adjust_gas(GAS_CHLORINE, chlor_moles )

	var/singleton/species/H = GLOB.species_by_name[SPECIES_HUMAN]
	var/generator/new_temp = generator("num", H.cold_level_1 + 40, H.heat_level_1 + 10, UNIFORM_RAND)
	exterior_atmosphere.temperature = new_temp.Rand()
	exterior_atmosphere.update_values()
	exterior_atmosphere.check_tile_graphic()

/datum/random_map/noise/exoplanet/chlorine
	descriptor = "chlorine exoplanet"
	smoothing_iterations = 3
	land_type = /turf/simulated/floor/exoplanet/chlorine_sand
	water_type = /turf/simulated/floor/exoplanet/water/shallow/chlorine_liquid
	water_level_min = 2
	water_level_max = 3
	fauna_prob = 2
	flora_prob = 5
	large_flora_prob = 0

/area/exoplanet/chlorine
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/chlorine_sand

/turf/simulated/floor/exoplanet/water/shallow/chlorine_liquid
	name = "chlorine marsh"
	icon = 'icons/turf/chlorine.dmi'
	icon_state = "chlorine_liquid"
	desc = "A pool of noxious liquid chlorine. It's full of silt and plant matter."
	dirt_color = "#d2e0b7"
	reagent_type = /datum/reagent/toxin/chlorine

/turf/simulated/floor/exoplanet/chlorine_sand
	name = "chlorinated sand"
	icon = 'icons/turf/chlorine.dmi'
	icon_state = "chlorine_sand1"
	desc = "Sand that has been heavily contaminated by chlorine."
	dirt_color = "#d2e0b7"
	footstep_type = /singleton/footsteps/sand

/turf/simulated/floor/exoplanet/chlorine_sand/New()
	icon_state = "chlorine_sand[rand(0,11)]"
	..()
