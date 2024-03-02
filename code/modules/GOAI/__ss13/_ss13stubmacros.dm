// Fake implementations of SS13 features to keep the compiler and maintainers happy

# define GOAI_GLOBAL_LIST_PREFIX(GLOBJECT) global.##GLOBJECT

# ifdef GOAI_LIBRARY_FEATURES
// without SS13 support

// Fake qdels using plain old del()
# define qdel(x) del(x)

// Fake weakrefs
# define GOAI_LIBBED_WEAKREF(X) X
# define GOAI_LIBBED_WEAKREF_TYPE atom

// Plain globals
// NOTE: this macro is extra-weird looking, even by macro standards.
# define GOAI_LIBBED_GLOB_PREFIX(operator)
# define GOAI_LIBBED_GLOB_ATTR(GLOBJECT) global.##GLOBJECT

# else


# endif


# ifdef GOAI_SS13_SUPPORT
// with SS13 support

// Use actual weakrefs
# define GOAI_LIBBED_WEAKREF(X) weakref(X)
# define GOAI_LIBBED_WEAKREF_TYPE weakref

// We 'SS13-ify' globals using a prefix + access op (`.` / `?.`)
# define GOAI_LIBBED_GLOB_PREFIX(operator) GLOB.
# define GOAI_LIBBED_GLOB_ATTR(GLOBJECT) GLOB.##GLOBJECT

# endif
