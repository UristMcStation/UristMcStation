// Vampire power defines
#define VAMP_REJUV   1
#define VAMP_GLARE   2
#define VAMP_HYPNO   4
#define VAMP_SHAPE   8
#define VAMP_VISION  16
#define VAMP_DISEASE 32
#define VAMP_CLOAK   64
#define VAMP_BATS    128
#define VAMP_SCREAM  256
#define VAMP_JAUNT   512
#define VAMP_SLAVE   1024
#define VAMP_BLINK   2048
#define VAMP_FULL    4096

#define MODE_VAMPIRE "vampire"
#define MODE_PARANOIA "agent"

//which Z-level SCOM base is on
#define SCOM_ZLEVEL 2

//item_icons redirect to urist shit, but only for hands
#define DEF_URIST_INHANDS list(slot_l_hand_str = 'icons/uristmob/items_lefthand.dmi', slot_r_hand_str = 'icons/uristmob/items_righthand.dmi')

//the opposite - everything *but* inhands is Urist. Intended for guns, mostly.
#define USE_BAY_INHANDS list(slot_back_str = 'icons/uristmob/back.dmi', slot_w_uniform_str = 'icons/uristmob/clothes.dmi', \
slot_wear_suit_str = 'icons/uristmob/clothes.dmi', slot_head_str = 'icons/uristmob/head.dmi', \
slot_belt_str = 'icons/uristmob/belt_mirror.dmi', slot_shoes_str = 'icons/uristmob/shoes.dmi', \
slot_wear_mask_str = 'icons/uristmob/mask.dmi', slot_gloves_str = 'icons/uristmob/gloves.dmi', \
slot_glasses_str = 'icons/uristmob/glasses.dmi', slot_tie_str = 'icons/uristmob/ties.dmi')

//and now the xbox hueg one for full override, thank god for escaping EOL; effectively old urist_only
#define URIST_ALL_ONMOBS list(slot_l_hand_str = 'icons/uristmob/items_lefthand.dmi', slot_r_hand_str = 'icons/uristmob/items_righthand.dmi', \
slot_back_str = 'icons/uristmob/back.dmi', slot_w_uniform_str = 'icons/uristmob/clothes.dmi', \
slot_wear_suit_str = 'icons/uristmob/clothes.dmi', slot_head_str = 'icons/uristmob/head.dmi', \
slot_belt_str = 'icons/uristmob/belt_mirror.dmi', slot_shoes_str = 'icons/uristmob/shoes.dmi', \
slot_wear_mask_str = 'icons/uristmob/mask.dmi', slot_gloves_str = 'icons/uristmob/gloves.dmi', \
slot_glasses_str = 'icons/uristmob/glasses.dmi', slot_tie_str = 'icons/uristmob/ties.dmi', \
slot_l_ear_str = 'icons/uristmob/l_ear.dmi', slot_r_ear_str = 'icons/uristmob/l_ear.dmi')

//genetics:
#define M_NOIR 205

//macro

#define isstorage(A)	istype(A, /obj/item/storage)

// used to mark/gate Urist changes from upstream code where we couldn't have a clean module
// (e.g. Uristcode hooks into preexisting items, mob code, etc.)
# define INCLUDE_URIST_CODE 1

// Works like FAKEDEATH, but does NOT paralyze the user
# define STATUS_UNDEAD 0x1000

