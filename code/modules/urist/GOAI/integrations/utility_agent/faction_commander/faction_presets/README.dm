/*
// This module defines lightweigh subclasses that grant preset ActionSets to factions.
//
// Factions generally share a common core;
// their AI logic is differentiated mainly by the ActionSets they come bundled with.
//
// As such, the overrides here should be minimal, limited to just the innate_actions_filepaths list declaration.
//
// This way, you could swap the actionsets of a corporation and a pirate band,
// and it would *work*, roughly the same as if some pirates seized all assets of the corporation
// (and inherited its relationships somehow, but that's getting into the weeds unnecessarily).
//
// For that matter, nothing is stopping you from giving a faction *both* the ActionSets of a pirate
// and that of a corporation (for instance); this could be handy to model shadier public organizations,
// like SS13's Syndicate.
*/
