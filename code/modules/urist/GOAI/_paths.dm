#ifdef GOAI_LIBRARY_FEATURES

// Dev

#define GOAI_DATA_PATH(FP) "goai_data/" + ##FP
#define GOAI_SMARTOBJECT_PATH(FP) "goai_data/smartobject_definitions/" + ##FP
#define GOAI_FACTIONSPEC_PATH(FP) "goai_data/faction_definitions/" + ##FP
#define GOAI_PERSONALITY_PATH(FP) "goai_data/personality_templates/" + ##FP

#endif

#ifdef GOAI_SS13_SUPPORT

// SS13
#define GOAI_DATA_PATH(FP) "code/modules/urist/GOAI/goai_data/" + ##FP
#define GOAI_SMARTOBJECT_PATH(FP) "code/modules/urist/GOAI/goai_data/smartobject_definitions/" + ##FP
#define GOAI_FACTIONSPEC_PATH(FP) "code/modules/urist/GOAI/goai_data/faction_definitions/" + ##FP
#define GOAI_PERSONALITY_PATH(FP) "code/modules/urist/GOAI/goai_data/personality_templates/" + ##FP

#endif

#define DEFAULT_UTILITY_AI_SENSES GOAI_DATA_PATH("dev_sense.json")
#define DEFAULT_FACTION_AI_SENSES GOAI_DATA_PATH("faction_senses.json")
#define DEFAULT_MOBCOMMANDER_PERSONALITY_TEMPLATE GOAI_PERSONALITY_PATH("combat.json")
#define GOAPPLAN_METADATA_PATH GOAI_DATA_PATH("goai_actions.json")
#define GOAPPLAN_ACTIONSET_PATH GOAI_SMARTOBJECT_PATH("goapplan.json")
#define MOVEPATH_ACTIONSET_PATH GOAI_SMARTOBJECT_PATH("movepath.json")
