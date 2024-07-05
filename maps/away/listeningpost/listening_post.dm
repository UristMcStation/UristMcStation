#include "listening_areas.dm"


/obj/effect/overmap/visitable/sector/listening_post
	name = "listening post"
	desc = "A listening post, often used to monitor signals and monitor ship traffic."
	icon_state = "object"
	known = FALSE

	initial_generic_waypoints = list(
		"nav_listening_post_1"
		"nav_listening_post_2"
		"nav_listening_post_3"
	)
