#include "casino_areas.dm"
#include "../mining/mining_areas.dm"

/obj/overmap/visitable/ship/casino
	name = "passenger liner"
	desc = "Sensors detect an undamaged vessel without any signs of activity."
	color = "#bd6100"
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECOND
	initial_generic_waypoints = list(
		"nav_casino_1",
		"nav_casino_2",
		"nav_casino_3",
		"nav_casino_4",
		"nav_casino_antag",
		"nav_casino_dock"
	)
	initial_restricted_waypoints = list(
		"Casino Cutter" = list("nav_casino_hangar"),
	)

/obj/overmap/visitable/ship/casino/New(nloc, max_x, max_y)
	name = "IPV [pick("Fortuna","Gold Rush","Ebisu","Lucky Paw","Four Leaves")], \a [name]"
	..()

/datum/map_template/ruin/away_site/casino
	name = "Casino"
	id = "awaysite_casino"
	description = "A casino ship!"
	suffixes = list("casino/casino.dmm")
	spawn_cost = 1
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/casino_cutter)
	area_usage_test_exempted_root_areas = list(/area/casino)
	apc_test_exempt_areas = list(
		/area/casino/casino_hangar = NO_SCRUBBER,
		/area/casino/casino_cutter = NO_SCRUBBER|NO_VENT,
		/area/casino/casino_solar_control = NO_SCRUBBER,
		/area/casino/casino_maintenance = NO_SCRUBBER|NO_VENT
	)

/obj/shuttle_landmark/nav_casino/nav1
	name = "Casino Ship Navpoint #1"
	landmark_tag = "nav_casino_1"

/obj/shuttle_landmark/nav_casino/nav2
	name = "Casino Ship Navpoint #2"
	landmark_tag = "nav_casino_2"

/obj/shuttle_landmark/nav_casino/nav3
	name = "Casino Ship Navpoint #3"
	landmark_tag = "nav_casino_3"

/obj/shuttle_landmark/nav_casino/nav4
	name = "Casino Ship Navpoint #4"
	landmark_tag = "nav_casino_4"

/obj/shuttle_landmark/nav_casino/nav5
	name = "Casino Ship Navpoint #5"
	landmark_tag = "nav_casino_antag"

/obj/shuttle_landmark/nav_casino/dock
	name = "Casino Ship Fore Dock"
	landmark_tag = "nav_casino_dock"
	docking_controller = "casino_dock"

/datum/shuttle/autodock/overmap/casino_cutter
	name = "Casino Cutter"
	warmup_time = 15
	move_time = 60
	shuttle_area = /area/casino/casino_cutter
	dock_target = "casino_cutter"
	current_location = "nav_casino_hangar"
	landmark_transition = "nav_casino_transit"
	fuel_consumption = 0.5//it's small
	range = 1
	defer_initialisation = TRUE

/obj/shuttle_landmark/nav_casino/cutter_hangar
	name = "Casino Hangar"
	landmark_tag = "nav_casino_hangar"
	base_area = /area/casino/casino_hangar
	base_turf = /turf/simulated/floor/plating

/obj/shuttle_landmark/nav_casino/cutter_transit
	name = "In transit"
	landmark_tag = "nav_casino_transit"

/obj/machinery/computer/shuttle_control/explore/casino_cutter
	name = "cutter control console"
	shuttle_tag = "Casino Cutter"

/obj/structure/casino/roulette
	name = "roulette"
	desc = "Spin the roulette to try your luck."
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "roulette_r"
	density = FALSE
	anchored = TRUE
	var/busy=0

/obj/structure/casino/roulette/attack_hand(mob/user as mob)
	if (busy)
		to_chat(user,"[SPAN_NOTICE("You cannot spin now! \The [src] is already spinning.")] ")
		return
	visible_message(SPAN_NOTICE("\ [user]  spins the roulette and throws inside little ball."))
	busy = 1
	var/n = rand(0,36)
	var/color = "green"
	add_fingerprint(user)
	if ((n>0 && n<11) || (n>18 && n<29))
		if (n%2)
			color="red"
	else
		color="black"
	if ( (n>10 && n<19) || (n>28) )
		if (n%2)
			color="black"
	else
		color="red"
	spawn(5 SECONDS)
		visible_message(SPAN_NOTICE("\The [src] stops spinning, the ball landing on [n], [color]."))
		busy=0

/obj/structure/casino/roulette_chart
	name = "roulette chart"
	desc = "Roulette chart. Place your bets! "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "roulette_l"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/bj_table
	name = "blackjack table"
	desc = "This is a blackjack table. "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "bj_left"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/bj_table/bj_right
	icon_state = "bj_right"

/obj/structure/casino/oh_bandit
	name = "one armed bandit"
	desc = "Turned off slot machine. "
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "slot_machine"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/craps
	name = "craps table"
	desc = "Craps table: roll dice!"
	icon = 'maps/away/casino/casino_sprites.dmi'
	icon_state = "craps_top"
	density = FALSE
	anchored = TRUE

/obj/structure/casino/craps/craps_down
	icon_state = "craps_down"

/obj/structure/casino/pod_controller
	name = "escape pod controller"
	desc = "An escape pod controller. This one seems to have crashed and doesn't respond to commands."
	icon = 'icons/obj/doors/airlock_machines.dmi'
	icon_state = "airlock_control_off"

//========================used bullet casings=======================
/obj/item/ammo_casing/rifle/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)


/obj/item/ammo_casing/pistol/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)

/obj/item/ammo_casing/pistol/magnum/used/Initialize()
	. = ..()
	expend()
	pixel_x = rand(-10, 10)
	pixel_y = rand(-10, 10)
