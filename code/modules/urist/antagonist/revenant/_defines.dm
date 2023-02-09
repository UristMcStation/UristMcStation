// Template:
// # define BSR_FLAVOR_ ""

 // Used to pad out powersets; always available.
 // As such, most powers should have it, but you can leave it out
 // if you want a power to be unique to a flavor.
# define BSR_FLAVOR_GENERIC "generic"


// Generic, granular tags; more flexible.
# define BSR_FLAVOR_DARK "darkness"
# define BSR_FLAVOR_BLOOD "blood"
# define BSR_FLAVOR_DEATH "death"
# define BSR_FLAVOR_SPACE "spatial"
# define BSR_FLAVOR_FLESH "flesh"
# define BSR_FLAVOR_PLAGUE "disease"
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

# define BSR_ALL_FLAVORS_LIST list(BSR_FLAVOR_BLUESPACE, BSR_FLAVOR_CHIMERA, BSR_FLAVOR_OCCULT, BSR_FLAVOR_DEMONIC, BSR_FLAVOR_VAMPIRE)

// Tracker keys
# define TRACKER_KEY_WARDS "wards"

// const-ey things
# define BSR_DEFAULT_MAXPERC_PER_TURF 10
# define BSR_DEFAULT_HALFWAY_PER_TURF 200
# define BSR_DEFAULT_DISTORTION_PER_TICK 100
# define BSR_DEFAULT_DECISECONDS_PER_TICK 50 // 5 seconds

// Helpers; return the integrated growth of Distortion over some amount of ticks given the derivatives
// Can be used to figure out how much Suppression to apply in terms of gameplay time.

# define BSR_DISTORTION_GROWTH_OVER_DECISECONDS(_Deciseconds, _DistPerTick, _DecisPerTick) (_Deciseconds * (_DistPerTick / _DecisPerTick))
# define BSR_DISTORTION_GROWTH_OVER_SECONDS(_Seconds, _DistPerTick, _DecisPerTick) ( BSR_DISTORTION_GROWTH_OVER_DECISECONDS(_Seconds SECONDS, _DistPerTick, _DecisPerTick))
# define BSR_DISTORTION_GROWTH_OVER_MINUTES(_Minutes, _DistPerTick, _DecisPerTick) ( BSR_DISTORTION_GROWTH_OVER_DECISECONDS(_Minutes MINUTES, _DistPerTick, _DecisPerTick))

// Thresholds for increasing the Distortion radius
// Might have to put these in config later
# define BSR_THRESHOLD_RADIUS_THREETILES BSR_DISTORTION_GROWTH_OVER_MINUTES(5, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
# define BSR_THRESHOLD_RADIUS_FIVETILES BSR_DISTORTION_GROWTH_OVER_MINUTES(30, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)
# define BSR_THRESHOLD_RADIUS_SEVENTILES BSR_DISTORTION_GROWTH_OVER_MINUTES(60, BSR_DEFAULT_DISTORTION_PER_TICK, BSR_DEFAULT_DECISECONDS_PER_TICK)

# ifdef BSR_DEBUGGING_ENABLED
# define BSR_DEBUG_LOG(X) to_world_log(X)
# else
# define BSR_DEBUG_LOG(X)
# endif