/*
// Bluespace Revenant
//
// This is meant to be a re-imagining of Vampire mode with a sprinkle of Wizard/Ling gameplay and possibly some Cult aesthetics.
//
// Like Vamp/Wiz/Ling, this is meant to be a lowpop-friendly threat, largely flying solo.
//
// From Vamp, we take a spoonful of 2spoopiness and the Horror Hunger trope.
// From Ling, we steal the idea of modular powers and a strange sci-fi nonsense beings.
// From Wiz, we borrow the 'flavor' system for powers to provide variety.
//
// Unlike most solo antags, it's designed to punish stealthantagging/SSDing and disincentivize too much peaceantagging.
//
// This is achieved by a 'radiation' system. The Revenants are a walking anomaly and slowly passively distort reality around themselves ('Distortion').
// They can counter that by indulging their Hungers - semi-random powers that require doing something spooky and/or mildly antagonistic.
// This can range from classic Vamp's bloodthirst, through anomaly-like need for extreme atmospheres, to devouring the station infrastructure itself.
//
// If not met, the increasing Distortion will cause even worse havoc in its own right.
// Depending on the random flavor, this can mean anything from spawning AI hostiles, messing with physics or causing assorted spookiness.
//
// The Revenant powers and Hungers are meant to be randomized to make it harder to metagame - this is supposed to be a bizarre, unknown spess threat,
// possibly sci-fi, possibly occult, *definitely* breaking all known laws of the universe as we know it.
//
// Unlike Vamp/Ling, this antag is deliberately designed to *not* have to murder people to progress their powers.
//
// Also unlike them, this is generic enough to allow players to fluff what exactly they are themselves - and even allow for IC
// disagreements on that matter. They can be viewed as Weird Space Vampires, Space Wizards' version of DnD Sorcerers, superpowered
// mutants with leaky batteries, or any other perspective that fits the rolled powerset.
*/

GLOBAL_DATUM_INIT(bluespace_revenants, /datum/antagonist/bluespace_revenant, new)
GLOBAL_LIST(revenant_powerinstances)


/proc/isbsrevenant(var/mob/player, var/include_nonantags = TRUE)
	if(!GLOB.bluespace_revenants || !player.mind)
		return FALSE

	if(player.mind in GLOB.bluespace_revenants.current_antagonists)
		return TRUE

	if(include_nonantags && player.mind.bluespace_revenant)
		return TRUE


/datum/antagonist/bluespace_revenant
	welcome_text = "Whether it is by hanging out with the wrong crowd after dark or a mishap of Space Science, you've been... altered. You're not quite *alive*, and by the laws of ordinary physics are not meant to exist. Indulge your horrible compulsions - or face Distortion - a breakdown of reality that will give you away."

	id = MODE_BSREVENANT
	role_text = "Bluespace Revenant"
	role_text_plural = "Bluespace Revenants"
	restricted_jobs = list(/datum/job/captain, /datum/job/hos)
	protected_jobs = list(/datum/job/officer, /datum/job/warden, /datum/job/detective)
	blacklisted_jobs = list(/datum/job/ai, /datum/job/cyborg, /datum/job/submap)
	feedback_tag = "revenant_objective"

	antag_indicator = ""
	antaghud_indicator = "vampire" // todo

	victory_text = "The revenants survived - and will continue to corrupt reality itself!"
	loss_text = "The crew managed to eliminate the paranormal threat!"
	victory_feedback_tag = "win - revenant win"
	loss_feedback_tag = "loss - staff eliminated the revenants"
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 8
	hard_cap_round = 12
	initial_spawn_req = 1
	initial_spawn_target = 2
	skill_setter = /datum/antag_skill_setter/station

