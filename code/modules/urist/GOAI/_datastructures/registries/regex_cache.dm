// Smallish global assoc to accelerate parsing, mainly of Dynamic Queries
// Why global? It's a cache, this kind of thing is what globals are actually *for*.

// Define so we can check ifdefs
# define USE_REGEX_CACHE 1

// Lazy init!
// We need to do ifnull in case someone drops it by VV, so might as well.
// This also provides a nice and safe way to invalidate the cache if it gets too big - just null it here and let GC clean it up

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/regex_cache = null
# endif

# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(regex_cache)
# endif


// The _Unused arg is just for call-like syntax, pass in whatever
# define REGEX_CACHE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(regex_cache)) || !islist(GOAI_LIBBED_GLOB_ATTR(regex_cache))) { GOAI_LIBBED_GLOB_ATTR(regex_cache) = list() }
