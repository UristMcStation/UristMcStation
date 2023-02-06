// Template:
// # define BSR_FLAVOR_ ""

 // Used to pad out powersets; always available.
 // As such, most powers should have it, but you can leave it out
 // if you want a power to be unique to a flavor.
# define BSR_FLAVOR_GENERIC "generic"


// Generic, granular tags; more flexible.
# define BSR_FLAVOR_DARK "darkness"
# define BSR_FLAVOR_BLOOD "blood"
# define BSR_FLAVOR_SPACE "spatial"
# define BSR_FLAVOR_FLESH "flesh"
# define BSR_FLAVOR_OCCULT "occult"
# define BSR_FLAVOR_SCIFI "sci-fi"

// These are special tags meant to force a specific archetype
// Generally, they will correspond to a combination of the more granular tags
# define BSR_FLAVOR_BLUESPACE "bluespace"
# define BSR_FLAVOR_CHIMERA "chimera"
# define BSR_FLAVOR_CHAOTIC "chaotic"
# define BSR_FLAVOR_DEMONIC "demonic"
# define BSR_FLAVOR_CULTIST "cult"
# define BSR_FLAVOR_VAMPIRE "vampire"

//# define BSR_ALL_FLAVORS_LIST list(BSR_FLAVOR_BLUESPACE, BSR_FLAVOR_CHIMERA, BSR_FLAVOR_OCCULT, BSR_FLAVOR_DEMONIC, BSR_FLAVOR_VAMPIRE)
# define BSR_ALL_FLAVORS_LIST list(BSR_FLAVOR_OCCULT, BSR_FLAVOR_VAMPIRE)

// Tracker keys
# define TRACKER_KEY_WARDS "wards"

// const-ey things
# define BSR_DEFAULT_DISTORTION_PER_TICK 100
# define BSR_DEFAULT_DECISECONDS_PER_TICK 100 // 10 seconds

# define BSR_SUPPRESSION_IN_DECISECONDS(_Deciseconds, _DistPerTick, _DecisPerTick) (_Deciseconds * (_DistPerTick / _DecisPerTick))
# define BSR_SUPPRESSION_IN_SECONDS(_Seconds, _DistPerTick, _DecisPerTick) ( BSR_SUPPRESSION_IN_DECISECONDS(_Seconds * 10, _DistPerTick, _DecisPerTick))
# define BSR_SUPPRESSION_IN_MINUTES(_Minutes, _DistPerTick, _DecisPerTick) ( BSR_SUPPRESSION_IN_DECISECONDS(_Minutes * 600, _DistPerTick, _DecisPerTick))
