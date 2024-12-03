/*
// Defines the constant-ish keys for use by the Commodity API.
// These are expected to be too heterogenous across AIs to be done as simple bitflags, so we'll do strings vOv.
// Some categories are split by prefix; the intent is to signal you could sum them all up for a more abstract score.
*/


/* Dolla bills */

// How much this works as money or a money-equivalent good (e.g. gold bar, letter of credit).
// Useful for pretty much anyone able to trade, though some are more money-oriented than others.
#define NEED_WEALTH "wealth"

// Ostentatious wealth; status signal, more or less tasteful - doesn't matter.
#define NEED_PRESTIGE "prestige"


/* Food */

// General-purpose calories
// A concern for anyone with biotic personnel.
#define NEED_FOOD_GENERIC "food_generic"


/* Materials */

// Unprocessed metal ores
#define NEED_ORE_GENERIC "ore"

// Raw steel, e.g. for construction
#define NEED_STEEL "steel"

// Raw glass, e.g. for construction
#define NEED_GLASS "glass"


/* Security */

// Security is split in two subcategories to let AIs act more aggro or more turtley.
// Defensive focuses on not feeling when someone punches us.
// Offensive focuses on being able to punch harder than any potential threat.
// These are, very deliberately, NOT uncorrelated!
// If you want a total generic Security score, you can add them together.

// "Strength", in very abstract sense, or "power projection capability".
// Meant for things like buying guns and cannons or hiring goons.
#define NEED_SECURITY_OFFENSIVE "security_offensive"

// How much we can stop threats from bothering us.
// This can be weaponds, but also fortifications or defensive alliances.
#define NEED_SECURITY_DEFENSIVE "security_defensive"


/* Science */

// Mainstream STEMy research topics - physics, bio/med, astronomy, whatever.
// Primary concern of vanilla research groups, whether academic or corporate.
// The 'Lawful Good' knowledge.
#define NEED_KNOWLEDGE_SCIENCE "knowledge_science"

// Science's evil black market twin. Bioterror, designer drugs, unconventional weapons, etc.
// Pursued by straight-up criminals or shadier corporate research groups (spess Umbrella types)
// The 'Chaotic Evil' knowledge.
#define NEED_KNOWLEDGE_MADSCI "knowledge_madscience"

// Science of 2spoopy. Ghosts, cults, wizards, anomalies, artifacts.
// Concerns occult organisations and those who hunt them.
// To a lesser extent, more fringe scientists may be interested as well.
// The 'Chaotic Neutral' knowledge.
#define NEED_KNOWLEDGE_ANOMALOUS "knowledge_anomalous"

// What you hire spies for. Someone else's secrets, whether personal, business, or national.
// Obviously, concerns intelligence and counterintelligence operations.
// Less obviously, may be dealt in by criminals as well.
// The 'Neutral Evil' knowledge.
#define NEED_KNOWLEDGE_INTEL "knowledge_intelligence"
