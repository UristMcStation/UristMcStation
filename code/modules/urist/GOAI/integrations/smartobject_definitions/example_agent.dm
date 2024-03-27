
# ifdef GOAI_LIBRARY_FEATURES

/mob/living/simple_animal/aitester

GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/mob/living/simple_animal/aitester, "goai_data/smartobject_definitions/example_agent.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_ISPAWN(/mob/living/simple_animal/aitester)

# endif

# ifdef GOAI_SS13_SUPPORT

/* Generic, for all hostile simplemobs; will likely repleace with more specific variants later */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/mob/living/simple_animal/hostile, "goai_data/smartobject_definitions/simplemob_agent.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_ISPAWN(/mob/living/simple_animal/hostile)

/* Real human bean */
GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/mob/living/carbon/human, "goai_data/smartobject_definitions/humanoid_agent.json")
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_ISPAWN(/mob/living/carbon/human)

# endif
