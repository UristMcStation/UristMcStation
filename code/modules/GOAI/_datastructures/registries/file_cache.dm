// Assoc list that will store file contents
// to avoid duplicating a ton of heavy I/O work needlessly.

# ifdef GOAI_LIBRARY_FEATURES
var/global/list/filedata_cache = null
# endif

# ifdef GOAI_SS13_SUPPORT
GLOBAL_LIST_EMPTY(filedata_cache)
# endif

// The _Unused arg is just for call-like syntax
# define FILE_CACHE_LAZY_INIT(_Unused) if(isnull(GOAI_LIBBED_GLOB_ATTR(filedata_cache)) || !islist(GOAI_LIBBED_GLOB_ATTR(filedata_cache))) { GOAI_LIBBED_GLOB_ATTR(filedata_cache) = list() }
