// Keys for the needfuls
# define NEED_COVER "cover"
# define NEED_PATROL "patrol"
# define NEED_ENEMIES "enemies"
# define NEED_OBEDIENCE "obedience"
# define NEED_COMPOSURE "composure"

// Subsystem loop schedules
# define COMBATAI_SENSE_TICK_DELAY 4
# define COMBATAI_AI_TICK_DELAY 6
# define COMBATAI_MOVE_TICK_DELAY 5
# define COMBATAI_FIGHT_TICK_DELAY 25

# define UTILITYAI_AI_TICK_DELAY 2  // utility goes brr
//# define UTILITYAI_AI_TICK_DELAY 10  // throttled version for debugging
# define FACTION_AI_TICK_DELAY 10

// Lower bound on the tick rate to prevent sanic loops eating your CPU.
# define MINIMUM_ALLOWED_DELAY 1

// Memory system constants
# define MEM_TIME_LONGTERM 1000000

# define MEM_AITICK_MULT_SHORTTERM 8
# define MEM_AITICK_MULT_MIDTERM 24

// Keys for the memory dict
# define MEM_SHOTAT "ShotAt"
# define MEM_FRIENDS "Friendlies"
# define MEM_FRIENDS_POSITIONS "FriendlyPositions"
# define MEM_ENEMIES "Enemies"
# define MEM_ENEMIES_POSITIONS "EnemyPositions"
# define MEM_ENEMIES_POSITIONS_LATEST "EnemyPositionsLatest"
# define MEM_ENEMIES_POSITIONS_RETAINED "EnemyPositionsRetained"
# define MEM_POS_THREATENED "OutInTheOpen"
# define MEM_THREAT "Threat"
# define MEM_THREAT_SECONDARY "ThreatSecondary"
# define MEM_WAYPOINT_IDENTITY "WaypointRef"
# define MEM_WAYPOINT_LKP "WaypointLKP"
# define MEM_CURRLOC "MyCurrLocation"
# define MEM_PREVLOC "MyPrevLocation"
# define MEM_SAFESPACE "LastSafeSpace"
# define MEM_OBSTRUCTION(X) "Obstruction [X]"
# define MEM_BESTPOS_PANIC "BestPosPanic"
# define MEM_TRUST_BESTPOS "TrustFirstBestpos"
# define MEM_PATH_TO_POS(Pos) "path_to_[Pos]"
# define MEM_PATH_ACTIVE "ai_active_path" // we can have multiple paths stored, but only one active
# define MEM_OCCUPIED_TURFS "OccupiedTurfs"

# define MEM_DIRLEAP_BESTPOS "DirectionalCoverleapBestpos"
# define MEM_CHARGE_BESTPOS "ChargeBestpos"

// Penalty value that should entirely eliminate an option unless there's absolutely no alternatives:
# define MAGICNUM_DISCOURAGE_SOFT 10000

// How much getting shot decays the AI's COMPOSURE need.
// this is the base rate; a personality trait can reduce this
# define MAGICNUM_COMPOSURE_LOSS_ONHIT_BASE 30

// How much failing a movement decays the AI's COMPOSURE need.
# define MAGICNUM_COMPOSURE_LOSS_FAILMOVE 1

// How much relaxing increases the AI's COMPOSURE need
# define MAGICNUM_COMPOSURE_GAIN_IDLE 5

// How much fleeing increases the AI's COMPOSURE need
# define MAGICNUM_COMPOSURE_GAIN_FLEED 30


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

# define SENSE_COVERLEAP_WAYFINDER "SenseCoverleapWayfinder"

# define HANDLERTYPE_SRCMETHOD 0
# define HANDLERTYPE_FUNC 1
