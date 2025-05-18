/* --  LOD Levels  -- */

/*
// In this case, we're talking about AI LODs specifically.
//
// This is an instance of the general optimization technique of Don't Run Wot You Don't Need.
// AI is a fairly expensive part of any game, so we want to skip running it as much as possible.
// If the AI of a Thing currently cannot possibly affect what the players will see, we don't want to bother.
//
// GOAI AI APIs provide filters that run against the LOD levels below and trim down the AI logic accordingly.
// For example, individual mob AIs should only run at UNIT_LOW LOD or higher.
// The available Actions are also filtered by min and max LOD they are available on.
*/

// The LOD values are descending to make things more intuitive (higher number => higher detail).
// I hope I don't live to regret this decision when the time comes to add more levels lol.

// Disable the AI altogether. Like the Pause attribute, but toggled dynamically by a check.
#define GOAI_LOD_DONTRUN 0

// Elevated detail. Mostly headroom if we need higher-than-usual LOD somewhere. Could be used for boss type things.
#define GOAI_LOD_DETAILED 9

// Standard level of processing; all standard actions available, all things fully simulated.
// "Unit" - b/c for mob AIs, we'd simulate each unit fully.
#define GOAI_LOD_UNIT 8

// Still process units individually, but at reduced fidelity.
// Meant for things like mobs in an area/Z-level without players.
#define GOAI_LOD_UNIT_LOW 7

// Collapses the first level of abstraction ('Unit') entirely.
// For mobs, that would be moving *Squad* representations only - hence the name.
// The name is mostly a mnemonic, don't get too hung up about it.
#define GOAI_LOD_SQUAD 6

// Reduced-fidelity processing but still at 'Squad' level.
// Similar to UNIT_LOW - we're near enough that we still See The Thing, but 'zoomed out' enough it loses detail.
#define GOAI_LOD_SQUAD_LOW 5

// Collapses the second level of abstraction ('Squad') entirely.
// Where Squad level ignores individual Units by replacing them with whole-Squad logic,
// here we remove Squad-level autonomy and manipulate them all in one place.
// The name is an extension of the military metaphor.
// Most likely though, this will be Faction AI processing for active Faction operations.
#define GOAI_LOD_PLATOON 4

// You know the drill by now. Groups of Squads, with some further simplifications on top.
#define GOAI_LOD_PLATOON_LOW 3

// Ignore everything but the grand-strategic layer.
#define GOAI_LOD_FACTION 2

// This is so reduced it's almost looping back to DONTRUN.
// Only run top-level, Faction stuff, and don't bother with anything like resources or operations;
// just the coarsest facts like updating relationships to everyone else.
#define GOAI_LOD_FACTION_LOW 1

// Convenience aliases to simplify maintenance.
// Anything that just cares about max/min/default can use these
// so that even if we add more levels, we don't need to replace 'em everywhere.
#define GOAI_LOD_LOWEST GOAI_LOD_FACTION_LOW
#define GOAI_LOD_STANDARD GOAI_LOD_UNIT
#define GOAI_LOD_HIGHEST GOAI_LOD_DETAILED
