//Used with the ticker to help choose the gamemode.
#define CHOOSE_GAMEMODE_SUCCESS     1 // A gamemode was successfully chosen.
#define CHOOSE_GAMEMODE_RETRY       2 // The gamemode could not be chosen; we will use the next most popular option voted in, or the default.
#define CHOOSE_GAMEMODE_REVOTE      3 // The gamemode could not be chosen; we need to have a revote.
#define CHOOSE_GAMEMODE_RESTART     4 // The gamemode could not be chosen; we will restart the server.
#define CHOOSE_GAMEMODE_SILENT_REDO 5 // The gamemode could not be chosen; we request to have the the proc rerun on the next tick.

//End game state, to manage round end.
#define END_GAME_NOT_OVER         1
#define END_GAME_MODE_FINISH_DONE 2
#define END_GAME_AWAITING_MAP     3
#define END_GAME_READY_TO_END     4
#define END_GAME_ENDING           5
#define END_GAME_AWAITING_TICKETS 6
#define END_GAME_DELAYED          7

#define BE_PAI   "BE_PAI"

// Antagonist datum flags.
#define ANTAG_OVERRIDE_JOB       FLAG_01  // Assigned job is set to MODE when spawning.
#define ANTAG_OVERRIDE_MOB       FLAG_02  // Mob is recreated from datum mob_type var when spawning.
#define ANTAG_CLEAR_EQUIPMENT    FLAG_03  // All preexisting equipment is purged.
#define ANTAG_CHOOSE_NAME        FLAG_04  // Antagonists are prompted to enter a name.
#define ANTAG_IMPLANT_IMMUNE     FLAG_05  // Cannot be loyalty implanted.
#define ANTAG_SUSPICIOUS         FLAG_06  // Shows up on roundstart report.
#define ANTAG_HAS_LEADER         FLAG_07  // Generates a leader antagonist.
#define ANTAG_RANDSPAWN          FLAG_08  // Potentially randomly spawns due to events.
#define ANTAG_VOTABLE            FLAG_09  // Can be voted as an additional antagonist before roundstart.
#define ANTAG_SET_APPEARANCE     FLAG_10  // Causes antagonists to use an appearance modifier on spawn.
#define ANTAG_RANDOM_EXCEPTED    FLAG_11 // If a game mode randomly selects antag types, antag types with this flag should be excluded.

// Mode/antag template macros.
#define MODE_BORER         "borer"
#define MODE_LOYALIST      "loyalist"
#define MODE_COMMANDO      "commando"
#define MODE_DEATHSQUAD    "deathsquad"
#define MODE_ERT           "ert"
#define MODE_ACTOR         "actor"
#define MODE_MERCENARY     "mercenary"
#define MODE_NINJA         "operatives"
#define MODE_RAIDER        "raider"
#define MODE_WIZARD        "wizard"
#define MODE_CHANGELING    "changeling"
#define MODE_CULTIST       "cultist"
#define MODE_MONKEY        "monkey"
#define MODE_RENEGADE      "renegade"
#define MODE_XENOMORPH "xeno"
#define MODE_REVOLUTIONARY "revolutionary"
#define MODE_MALFUNCTION   "malf"
#define MODE_TRAITOR       "traitor"
#define MODE_THRALL        "mind thrall"
#define MODE_PARAMOUNT     "paramount"
#define MODE_FOUNDATION    "foundation agent"
#define MODE_MISC_AGITATOR "provocateur"
#define MODE_HUNTER        "hunter"
#define MODE_VOXRAIDER     "vox raider"
#define MODE_SCOM_GD       "scom operative"
#define MODE_BSREVENANT "bluespace revenant"

#define DEFAULT_TELECRYSTAL_AMOUNT 130
#define IMPLANT_TELECRYSTAL_AMOUNT(x) (round(x * 0.49)) // If this cost is ever greater than half of DEFAULT_TELECRYSTAL_AMOUNT then it is possible to buy more TC than you spend

/////////////////
////WIZARD //////
/////////////////

/*		WIZARD SPELL FLAGS		*/
#define GHOSTCAST		FLAG_01		//can a ghost cast it?
#define NEEDSCLOTHES	FLAG_02		//does it need the wizard garb to cast? Nonwizard spells should not have this
#define NEEDSHUMAN		FLAG_03		//does it require the caster to be human?
#define Z2NOCAST		FLAG_04		//if this is added, the spell can't be cast at centcomm
#define NO_SOMATIC		FLAG_05	//spell will go off if the person is incapacitated or stunned
#define IGNOREPREV		FLAG_06	//if set, each new target does not overlap with the previous one
//The following flags only affect different types of spell, and therefore overlap
//Targeted spells
#define INCLUDEUSER		FLAG_07	//does the spell include the caster in its target selection?
#define SELECTABLE		FLAG_08	//can you select each target for the spell?
#define NOFACTION		FLAG_13  //Don't do the same as our faction
#define NONONFACTION	FLAG_14  //Don't do people other than our faction
//AOE spells
#define IGNOREDENSE		FLAG_07	//are dense turfs ignored in selection?
#define IGNORESPACE		FLAG_08	//are space turfs ignored in selection?
//End split flags
#define CONSTRUCT_CHECK	FLAG_09	//used by construct spells - checks for nullrods
#define NO_BUTTON		FLAG_10	//spell won't show up in the HUD with this

//invocation
#define SpI_SHOUT	"shout"
#define SpI_WHISPER	"whisper"
#define SpI_EMOTE	"emote"
#define SpI_NONE	"none"

//upgrading
#define Sp_SPEED	"speed"
#define Sp_POWER	"power"
#define Sp_TOTAL	"total"

//casting costs
#define Sp_RECHARGE	"recharge"
#define Sp_CHARGES	"charges"
#define Sp_HOLDVAR	"holdervar"

//changeling cost
#define CHANGELING_STASIS_COST 20

//Voting-related
#define VOTE_PROCESS_ABORT    1
#define VOTE_PROCESS_COMPLETE 2
#define VOTE_PROCESS_ONGOING  3

#define VOTE_STATUS_PREVOTE   1
#define VOTE_STATUS_ACTIVE    2
#define VOTE_STATUS_COMPLETE  3

/*
Changeling Defines
*/
#define CHANGELING_POWER_INHERENT "Inherent"
#define CHANGELING_POWER_ARMOR "Armor"
#define CHANGELING_POWER_STINGS "Stings"
#define CHANGELING_POWER_SHRIEKS "Shrieks"
#define CHANGELING_POWER_HEALTH "Health"
#define CHANGELING_POWER_ENHANCEMENTS "Enhancements"
#define CHANGELING_POWER_WEAPONS "Weapons"
