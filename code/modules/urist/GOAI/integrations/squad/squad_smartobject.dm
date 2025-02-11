GOAI_ACTIONSET_FROM_FILE_BOILERPLATE(/datum/squad, GOAI_SMARTOBJECT_PATH("mobsquad.json"))
// This SO is automagically injected into the AI loop from Brain vars, not from a Sense, so
// if we can see it at all, that means we are *in* the appropriate squad in some sense.
GOAI_HAS_UTILITY_ACTIONS_BOILERPLATE_ALWAYS(/datum/squad)
