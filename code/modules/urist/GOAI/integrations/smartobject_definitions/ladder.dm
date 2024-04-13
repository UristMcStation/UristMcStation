
# ifdef GOAI_LIBRARY_FEATURES

/obj/structure/ladder
	goai_processing_visibility = GOAI_VISTYPE_ELEVATED

GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/structure/ladder, "goai_data/smartobject_definitions/ladder.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_MANHATTAN(/obj/structure/ladder, 5)

# endif


# ifdef GOAI_SS13_SUPPORT

/obj/structure/ladder
	goai_processing_visibility = GOAI_VISTYPE_ELEVATED

GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/obj/structure/ladder, "code/modules/urist/GOAI/goai_data/smartobject_definitions/ladder.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_PROXIMITY_MANHATTAN(/obj/structure/ladder, 5)

# endif
