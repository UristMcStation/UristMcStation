// lazily initialized by the first AI to register itself
var/global/list/global_faction_registry

# define IS_REGISTERED_FACTION(id) (id && global_faction_registry && (id <= global_faction_registry.len))
