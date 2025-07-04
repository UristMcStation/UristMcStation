/datum/map_template/ruin/exoplanet/monolith
	name = "Monolith Ring"
	id = "planetsite_monoliths"
	description = "Bunch of monoliths surrounding an artifact."
	suffixes = list("monoliths/monoliths.dmm")
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_NO_RUINS
	ruin_tags = RUIN_ALIEN

/obj/structure/monolith
	name = "monolith"
	desc = "An obviously artifical structure of unknown origin. The symbols '𒁀𒀝 𒋢𒌦 𒉡 𒋺𒂊' are engraved on the base." //for the sake of the reader, "BAKU SUUN NU TAKE"
	icon = 'icons/obj/structures/monolith.dmi'
	icon_state = "jaggy1"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	anchored = TRUE
	var/active = 0

/obj/structure/monolith/Initialize()
	. = ..()
	icon_state = "jaggy[rand(1,4)]"
	var/material/A = SSmaterials.get_material_by_name(MATERIAL_ALIENALLOY)
	if(A)
		color = A.icon_colour
	if(GLOB.using_map.use_overmap)
		var/obj/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			desc += "\nThere are images on it: [E.get_engravings()]"
	update_icon()

/obj/structure/monolith/on_update_icon()
	ClearOverlays()
	if(active)
		var/image/I = image(icon,"[icon_state]decor")
		I.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
		I.color = get_random_colour(150, 255)
		I.layer = ABOVE_LIGHTING_LAYER
		I.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		AddOverlays(I)
		set_light(2, 0.3, l_color = I.color)

	var/turf/simulated/floor/exoplanet/T = get_turf(src)
	if(istype(T))
		var/image/I = overlay_image(icon, "dugin", T.dirt_color, RESET_COLOR)
		AddOverlays(I)

/obj/structure/monolith/attack_hand(mob/user)
	visible_message("[user] touches \the [src].")
	if(GLOB.using_map.use_overmap && istype(user,/mob/living/carbon/human))
		var/obj/overmap/visitable/sector/exoplanet/E = map_sectors["[z]"]
		if(istype(E))
			var/mob/living/carbon/human/H = user
			if(!H.isSynthetic())
				playsound(src, 'sound/effects/zapbeep.ogg', 100, 1)
				active = 1
				update_icon()
				if(prob(70))
					to_chat(H, SPAN_NOTICE("As you touch \the [src], you suddenly get a vivid image - [E.get_engravings()]"))
				else
					to_chat(H, SPAN_WARNING("An overwhelming stream of information invades your mind!"))
					var/vision = ""
					for(var/i = 1 to 10)
						vision += pick(E.actors) + " " + pick("killing","dying","gored","expiring","exploding","mauled","burning","flayed","in agony") + ". "
					to_chat(H, SPAN_DANGER(FONT_NORMAL(uppertext(vision))))
					H.Paralyse(2)
					H.hallucination(20, 100)
				return
	to_chat(user, SPAN_NOTICE("\The [src] is still."))
	return ..()

/turf/simulated/floor/fixed/alium/ruin
	name = "ancient alien plating"
	desc = "This obviously wasn't made for your feet. Looks pretty old."
	initial_gas = null

/turf/simulated/floor/fixed/alium/ruin/Initialize()
	. = ..()
	if(prob(10))
		ChangeTurf(get_base_turf_by_area(src))
