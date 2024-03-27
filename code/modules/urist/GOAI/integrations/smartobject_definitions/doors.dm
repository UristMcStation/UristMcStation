
# ifdef GOAI_LIBRARY_FEATURES

/* Plain Old Doors */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/cover/door, "goai_data/smartobject_definitions/door.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_CHEBYSHEV(/obj/cover/door, 1)

/* Autodoors */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/cover/autodoor, "goai_data/smartobject_definitions/autodoor.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_CHEBYSHEV(/obj/cover/autodoor, 1)

# endif

# ifdef GOAI_SS13_SUPPORT

/* Plain Old Doors */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/machinery/door/unpowered, "goai_data/smartobject_definitions/ss13_door.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_CHEBYSHEV(/obj/cover/door, 1)

/* Autodoors */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/machinery/door/airlock, "goai_data/smartobject_definitions/ss13_autodoor.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_CHEBYSHEV(/obj/machinery/door/airlock, 1)

# endif
