# define GOAI_LIBRARY_FEATURES TRUE

/* 515+ support */

#if DM_VERSION < 515

/// Call by name proc references, checks if the proc exists on either this type () (AND ONLY THIS TYPE) or as a global proc.
#define PROC_REF(X) (nameof(.proc/##X))

/// Call by name verb references, checks if the verb exists on either this type or as a global verb.
#define VERB_REF(X) (nameof(.verb/##X))

/// Call by name proc reference, checks if the proc exists on either the given type or as a global proc
#define TYPE_PROC_REF(TYPE, X) (nameof(##TYPE.proc/##X))

/// Call by name verb reference, checks if the verb exists on either the given type or as a global verb
#define TYPE_VERB_REF(TYPE, X) (nameof(##TYPE.verb/##X))

/// Call by name proc reference, checks if the proc is an existing global proc
#define GLOBAL_PROC_REF(X) (/proc/##X)

#else

/// Call by name proc references, checks if the proc exists on either this type () (AND ONLY THIS TYPE) or as a global proc.
#define PROC_REF(X) (/proc/##X)

/// Call by name verb references, checks if the verb exists on either this type or as a global verb.
#define VERB_REF(X) (/verb/##X)

/// Call by name proc reference, checks if the proc exists on either the given type or as a global proc
#define TYPE_PROC_REF(TYPE, X) (##TYPE/proc/##X)

/// Call by name verb reference, checks if the verb exists on either the given type or as a global verb
#define TYPE_VERB_REF(TYPE, X) (##TYPE/verb/##X)

/// Call by name proc reference, checks if the proc is an existing global proc
#define GLOBAL_PROC_REF(X) (/proc/##X)

# endif
