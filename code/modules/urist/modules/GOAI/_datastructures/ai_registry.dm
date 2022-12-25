// lazily initialized by the first AI to register itself
var/global/list/global_goai_registry

# define IS_REGISTERED_AI(id) (id && global_goai_registry && (id <= global_goai_registry.len))
