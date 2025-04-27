/*
// This module provides utilities for debugging pathfinding.
// This is done by drawing gizmos using vis_contents attachemts
*/

#ifdef ENABLE_GOAI_DEBUG_PATHFINDING_GIZMOS

/gizmo
	parent_type = /obj
	icon = 'icons/goai_gizmos.dmi'

/gizmo/New(var/icon_name)
	to_world_log("Creating gizmo [icon_name]")
	src.icon_state = icon_name

var/global/list/gizmos = list()

/proc/build_gizmos()
	if(length(gizmos))
		return FALSE

	// TR-corner dots
	global.gizmos["blue"] = new /gizmo(icon_name="dot_blue")
	global.gizmos["red"] = new /gizmo(icon_name="dot_red")
	global.gizmos["yellow"] = new /gizmo(icon_name="dot_yellow")
	global.gizmos["green"] = new /gizmo(icon_name="dot_green")
	global.gizmos["grey"] = new /gizmo(icon_name="dot_grey")
	// TL-corner dots
	global.gizmos["yellowTL"] = new /gizmo(icon_name="dot_tl_yellow")
	global.gizmos["greyTL"] = new /gizmo(icon_name="dot_tl_grey")
	// Centered dots
	global.gizmos["blueC"] = new /gizmo(icon_name="dot_centered_blue")
	global.gizmos["redC"] = new /gizmo(icon_name="dot_centered_red")
	global.gizmos["greenC"] = new /gizmo(icon_name="dot_centered_green")
	global.gizmos["greyC"] = new /gizmo(icon_name="dot_centered_grey")
	// Outlines (around tile)
	global.gizmos["redO"] = new /gizmo(icon_name="outline_red")
	global.gizmos["greenO"] = new /gizmo(icon_name="outline_green")
	global.gizmos["blueO"] = new /gizmo(icon_name="outline_blue")
	global.gizmos["greyO"] = new /gizmo(icon_name="outline_grey")
	// Centered X-shape
	global.gizmos["redX"] = new /gizmo(icon_name="x_centered_red")
	global.gizmos["greenX"] = new /gizmo(icon_name="x_centered_green")
	global.gizmos["blueX"] = new /gizmo(icon_name="x_centered_blue")
	global.gizmos["greyX"] = new /gizmo(icon_name="x_centered_grey")
	return TRUE

// short-circuiting trick to make this easily inlineable; we know it's a non-null atom, so can use the Evil Colon Operator safely
#define ADD_PATHFINDING_GIZMO(Trg, GizmoVar) (istype(Trg, /atom) && istype(GizmoVar, /gizmo) && (Trg:vis_contents.Add(GizmoVar) || TRUE))
#define REMOVE_PATHFINDING_GIZMO(Trg, GizmoVar) istype(Trg, /atom) && istype(GizmoVar, /gizmo) && (Trg:vis_contents.Remove(GizmoVar))

/proc/add_gizmo(var/atom/target, var/image/gizmo = null)
	// proc mainly for stuff like callbacks
	return ADD_PATHFINDING_GIZMO(target, gizmo)

/proc/add_temp_gizmo(var/atom/target, var/gizmo/gizmo = null, var/ttl = 10)
	set waitfor = FALSE

	sleep(-1)
	ADD_PATHFINDING_GIZMO(target, gizmo)
	sleep(ttl)
	REMOVE_PATHFINDING_GIZMO(target, gizmo)
	return

#endif

/*
/turf/verb/gizmo_test()
	set src in view()
	build_gizmos()
	add_temp_gizmo(src, global.gizmos["red"])
*/
