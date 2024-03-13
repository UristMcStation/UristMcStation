// Smallish global assoc to accelerate parsing, mainly of Dynamic Queries
// Why global? It's a cache, this kind of thing is what globals are actually *for*.

// Define so we can check ifdefs
# define USE_DYNAQUERY_CACHE 1

// Lazy init!
// We need to do ifnull in case someone drops it by VV, so might as well.
// This also provides a nice and safe way to invalidate the cache if it gets too big - just null it here and let GC clean it up

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/dynamic_query_cache = null
var/global/list/dynamic_query_cache_ttls = null
# endif

# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(dynamic_query_cache)
GLOBAL_LIST_EMPTY(dynamic_query_cache_ttls)
# endif


// The _Unused arg is just for call-like syntax, pass in whatever
# define DYNAQUERY_CACHE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache)) || !islist(GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache))) { GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache) = list() }; if(isnull(GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls)) || !islist(GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls))) { GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls) = list() }
# define DYNAQUERY_CACHE_INVALIDATE(_Unused) GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache) = list(); GOAI_LIBBED_GLOB_ATTR(dynamic_query_cache_ttls) = list()
