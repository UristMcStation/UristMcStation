# define STEP_TRIGGER_INVISIBILITY 101

#define DEEPMAINT_WALL_ICON 'icons/urist/turf/walls.dmi'
#define DEEPMAINT_WALL_ICONSTATE_BASE "arust"
#define DEEPMAINT_WALL_ICONSTATE_DYNAMIC(FromVar) "arust[FromVar]"

#define DEEPMAINT_FLOOR_ICON 'icons/turf/flooring/plating.dmi'
#define DEEPMAINT_FLOOR_ICONSTATE "plating"

#define WFC_CHANGE_TURF(From, To) WfcChangeTurf(From, To)


# ifdef STUB_OUT_SS13

#define DEEPMAINT_DOOR_TYPEVAR(V) var/obj/cover/autodoor/V
#define WFC_MATH_FLOOR(x) FLOOR(x)

#define DEEPMAINT_TURF_BASE /turf

#define DEEPMAINT_WALL_OPACITY 0

#define DEEPMAINT_LIGHT /obj/deepmaint_wall_light

# define qdel_from_weakref(x) del(x)

# else

#define DEEPMAINT_DOOR_TYPEVAR(V) var/obj/machinery/door/airlock/maintenance/V
#define WFC_MATH_FLOOR(x) floor(x)

#define DEEPMAINT_TURF_BASE /turf/unsimulated

#define DEEPMAINT_WALL_OPACITY 1

#define DEEPMAINT_LIGHT /obj/machinery/floor_light/mapped_on

# define qdel_from_weakref(x) qdel(x)

# endif
