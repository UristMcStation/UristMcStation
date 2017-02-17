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