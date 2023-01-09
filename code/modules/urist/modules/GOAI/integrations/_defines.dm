// Keys for the needfuls
# define NEED_COVER "cover"
# define NEED_PATROL "patrol"
# define NEED_ENEMIES "enemies"
# define NEED_OBEDIENCE "obedience"
# define NEED_COMPOSURE "composure"
// We do o position here to avoid hash collisions; 'o' should be an atom
# define NEED_OBSTACLE_OPEN(o) "open [o] [ref(o)]"
// We do a position here to avoid hash collisions; 'a' should be an atom
// Need rather than State to allow 'incremental' plans,
//  e.g. Plan<Near<Z>> = (Goto<X>(), Open<Y>(Near<Y>), Goto<Z>(OpenAt<Y>))
# define NEED_NEAR_ATOM(a) "at [a] @ ([a.x], [a.y], [a.z])"

# define NEED_OBJ_UNLOCKED(o) "unlock [o] [ref(o)]"
# define NEED_OBJ_PRY(o) "pry [o] [ref(o)]"
# define NEED_OBJ_SCREW(o) "screw [o] [ref(o)]"
# define NEED_OBJ_BROKEN(o) "break [o] [ref(o)]"

# define STATE_HASCROWBAR "has_crowbar"
# define STATE_HASMULTITOOL "has_multitool"
# define STATE_HASSCREWDRIVER "has_screwdriver"
# define STATE_HASINSULGLOVES "has_insul_gloves"

// Keys for the states
# define STATE_INCOVER "in_cover"
# define STATE_DOWNTIME "no_orders"
# define STATE_HASGUN "has_gun"
# define STATE_HASWAYPOINT "has_waypoint"
# define STATE_CANFIRE "can_shoot"
# define STATE_PANIC "panik"

# define STATE_DISORIENTED "disoriented"

// Subsystem loop schedules
# define COMBATAI_SENSE_TICK_DELAY 4
# define COMBATAI_AI_TICK_DELAY 6
# define COMBATAI_MOVE_TICK_DELAY 5
# define COMBATAI_FIGHT_TICK_DELAY 25

// Lower bound on the tick rate to prevent sanic loops eating your CPU.
# define MINIMUM_ALLOWED_DELAY 1

// Memory system constants
# define MEM_TIME_LONGTERM 10000

// Keys for the memory dict
# define MEM_SHOTAT "ShotAt"
# define MEM_THREAT "Threat"
# define MEM_THREAT_SECONDARY "ThreatSecondary"
# define MEM_WAYPOINT_IDENTITY "WaypointRef"
# define MEM_WAYPOINT_LKP "WaypointLKP"
# define MEM_CURRLOC "MyCurrLocation"
# define MEM_PREVLOC "MyPrevLocation"
# define MEM_SAFESPACE "LastSafeSpace"
# define MEM_OBSTRUCTION "Obstruction"
# define MEM_BESTPOS_PANIC "BestPosPanic"
# define MEM_TRUST_BESTPOS "TrustFirstBestpos"

# define MEM_DIRLEAP_BESTPOS "DirectionalCoverleapBestpos"
# define MEM_CHARGE_BESTPOS "ChargeBestpos"

# define MEM_AIRLOCK_WIRES  "AirlockWires"

# define MEM_OBJ_LOCKED(o) "[o] [ref(o)] IsLocked"
# define MEM_OBJ_NOPOWER(o) "[o] [ref(o)] NoPower"
# define MEM_OBJ_SHOCKED(o) "[o] [ref(o)] IsShocked"
# define MEM_OBJ_PANELOPEN(o) "[o] [ref(o)] PanelOpen"

# define MEM_OBJ_NOACCESS(o) "NoAccess to [o] [ref(o)]"

// Penalty value that should entirely eliminate an option unless there's absolutely no alternatives:
# define MAGICNUM_DISCOURAGE_SOFT 10000

// How much getting shot decays the AI's COMPOSURE need.
# define MAGICNUM_COMPOSURE_LOSS_ONHIT 10

// How much failing a movement decays the AI's COMPOSURE need.
# define MAGICNUM_COMPOSURE_LOSS_FAILMOVE 1


# define PANIC_SENSE_THROTTLE (1 * COMBATAI_AI_TICK_DELAY)

// Various keys used by 'AI ghost' data (last-known-pos stuff)
# define KEY_GHOST_X "posX"
# define KEY_GHOST_Y "posY"
# define KEY_GHOST_Z "posZ"
# define KEY_GHOST_POS_TUPLE "posTuple"
# define KEY_GHOST_POS_TRIPLE "posTriple"
# define KEY_GHOST_ANGLE "posAngle"

# define KEY_ACTION_AIM "Aim"
# define KEY_AIM_TARGET "aimTarget"

# define WAYPOINT_FUZZ_X 5
# define WAYPOINT_FUZZ_Y 5

# define KEY_PERS_MINSAFEDIST "MinSafeDist"
# define KEY_PERS_FRUSTRATION_THRESH "FrustrationRepathMaxthresh"

// Formula to add a random +/- X% modifier to a value
// e.g. for X=10 Expected Value of this rand() is 0.1, so it's a +/- 10% discount (0.9-1.1)
# define RAND_PERCENT_MULT(X) ((1 - (X/100)) + ((rand(0, 20*X)/1000)))
