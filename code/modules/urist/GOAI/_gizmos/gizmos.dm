/*
// This module provides utilities for debugging pathfinding.
// This is done by drawing gizmos using vis_contents attachemts.
// The gizmos are created as singleton entires in a global assoc list and can be added with a macro or a proc.
// In either case, the general interface is gizmo_macro_or_proc(target_atom, global.gizmos[key], *args)
*/

#ifndef ENABLE_GOAI_DEBUG_GIZMOS
// stubs, become 'invisible' if gizmos are disabled - to reduce the number of ifdef blocks

#define INIT_GOAI_GIZMOS_IF_NEEDED(Force)
#define ADD_GOAI_GIZMO(Trg, GizmoVar)
#define REMOVE_GOAI_GIZMO(Trg, GizmoVar)
#define ADD_GOAI_TEMP_GIZMO_CUSTOMTTL(Trg, GizmoName, Ttl)
#define ADD_GOAI_TEMP_GIZMO(Trg, GizmoName)

#endif

#ifdef ENABLE_GOAI_DEBUG_GIZMOS

/gizmo
	parent_type = /atom/movable  // atoms did not like being nullspaced
	icon = 'icons/goai_gizmos.dmi'

/gizmo/New(var/icon_name)
	to_world_log("Creating gizmo [icon_name]")
	src.icon_state = icon_name

var/global/list/gizmos = null

/proc/build_goai_gizmos(var/force_rebuild = FALSE)
	if(!islist(global.gizmos))
		global.gizmos = list()

	else if(length(global.gizmos))
		// NOTE: we do not currently account for someone dropping *individual* entries from this list.
		//       The force_rebuild=TRUE can be used to autoheal the list if *that* happens.
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
#define INIT_GOAI_GIZMOS_IF_NEEDED(Force) (build_goai_gizmos(Force))
#define ADD_GOAI_GIZMO(Trg, GizmoVar) (istype(Trg, /atom) && istype(GizmoVar, /gizmo) && (Trg:vis_contents.Add(GizmoVar) || TRUE))
#define REMOVE_GOAI_GIZMO(Trg, GizmoVar) istype(Trg, /atom) && istype(GizmoVar, /gizmo) && (Trg:vis_contents.Remove(GizmoVar))
#define ADD_GOAI_TEMP_GIZMO_CUSTOMTTL(Trg, GizmoName, Ttl) (add_temp_gizmo(Trg, global.gizmos[##GizmoName], Ttl))
#define ADD_GOAI_TEMP_GIZMO(Trg, GizmoName) ADD_GOAI_TEMP_GIZMO_CUSTOMTTL(Trg, ##GizmoName, 10)

/proc/add_temp_gizmo(var/atom/target, var/gizmo/gizmo = null, var/ttl = 10)
	set waitfor = FALSE

	sleep(-1)
	ADD_GOAI_GIZMO(target, gizmo)
	sleep(ttl)
	REMOVE_GOAI_GIZMO(target, gizmo)
	return

/*
// Quick debugging tool
/turf/verb/gizmo_test()
	set src in view()
	INIT_GOAI_GIZMOS_IF_NEEDED(FALSE)
	ADD_GOAI_TEMP_GIZMO(src, "red")
*/

#endif
