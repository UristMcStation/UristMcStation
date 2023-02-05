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

# define TRACKER_KEY_WARDS "wards"
