/*
===================================
=                                 =
=       BLUESPACE REVENANTS       =
=                                 =
===================================


	==============  PROCGEN  ==============

	BSR are using a (fairly simple) form of procedural generation for Attributes.

	The system relies on prefabbed effects and a tag-based sampling algorithm
	(which is far simpler and far less scary than it might sound).

	We let coders create new Powers, Hungers and Distortions and put them... just
	about anywhere really. We use typesof() calls to pick them all up, instantiate
	them into a global variable (Repository Pattern, effectively; it's an assoc list
	of type: instance) and use the tags of each instance in the sampler.

	For generation, we preprocess all instantiated items in the repo of a desired type
	by turning them into a list of { tag1: [pow1, pow3], tag2: [pow2, pow3]... } etc.

	Then, we simply do a weighted sample of all tags selected for the target BSR, then
	sample (currently pick(), possibly weighted in the future) from the powers available
	for this tag.


	==============  API DOCS ==============

	/datum/antagonist/bluespace_revenant
		The Antag datum is purely there to wrap everything in all the gamemodey bits
		like goals, candidate selection, etc.

		Non-antag BSRs are valid; it's an administrative concern - treat them like any nonantag
		with special abilities, e.g. a Geneticist with Hulk.

		Adding this antag type to a player should always create a new /datum/bluespace_revenant
		for them unless they already have one.


	/datum/bluespace_revenant

		This is the main holder of Revenant data and the central integration point.

		Attaches to a Mind. Having this datum is the primary source of truth for being a BSR.

		Each BSR Mind has its own unique copy of this datum (i.e. it's not a Singleton).

		BSRs hold a weak reference to the owning mob (assigned on creation); this means
		you CAN access the mob from various procs, but you need to do mob_ref.resolve()
		and all the DM ceremony around nulls and typechecks.

		This cannot be a normal ref for Garbage Collection reasons
		(Mob holds Mind holds BSR - if we make BSR hold a Mob, we get a circular
		 reference so GC gets mad at us)


		-- TICKER: --

			The Revenant datum runs an infinite ticker to manage its own updates
			(it's an event loop, practically speaking).

			The ticker can be stopped using /datum/bluespace_revenant/proc/stop_ticker()
			and restarted using /datum/bluespace_revenant/proc/start_ticker().

			This is currently implemented as a straightforward self-contained DM code,
			because I didn't want to mess with Baycode APIs and them possibly changing
			every merge.

			The main responsibilities of the ticker are to:

			1) Handle Total Distortion generation
			2) Handle unlocks gated by Total Distortion (e.g. more tile range, more powers)
			3) Handle optional state dynamics over time dynamics using Callbacks

			BSR callbacks are expected to be '/datum/bluespace_revenant/proc's and take a
			number of ticks as an integer as an argument.


	/datum/power/revenant

		Abstract Base Class for all Attributes (i.e. Powers/Effects/Distortions).

		The /datum/power superclass is stolen from the Ling ABC (in case this ever moves
		and you need to reimplement it elsewhere for BSRs to work).

		You shouldn't use this directly; it's just to avoid code duplication across Attributes.


		!!! *THE POWER INSTANCES ARE SINGLETONS* !!!

		* This means that if you mess with one BSR's powers, it will mess with ALL BSRs' powers! *


		The flavor_tags attribute is VERY VERY important - it controls the procgen for Revenants.

		flavor_tags should be a straightforward list of strings; generally, using defines
		for these strings is recommended to avoid one-off typos messing stuff up.

		flavor_tags MUST be set for all powers or they will never be generated without adminbuse.


		.../proc/Activate(mind/M)

			Determines what happens when we *unlock* this Attribute (e.g. grant a Verb to mobs)


		.../proc/Deactivate(mind/M)

			Specifies how to clean up the Attribute if we lose it (e.g. remove a Verb if the mob has it)


	/datum/power/revenant/distortion

		Distortion effect; some kind of spoopy anomaly caused by BSRs' ambient reality-warping.

		The .../Apply(var/atom/A) proc defines the effect.

		Apply() should return a boolean. If FALSE or null, the handling system will assume
		we have failed to apply the effect and will NOT remove Distortion from the target atom.

		As of writing, this will currently only ever be called on Turfs, but this might change later.

		The Distortions should be universally uncontrollable and, if not negative, at least disruptive
		and/or significantly weird.


	/datum/power/revenant/bs_power

		Containers for metadata about BSR Powers.

		The actual effects of the Power is determined by the proc associated with verbpath.

		These procs are assumed to always be of type /mob/proc.

		If isVerb = FALSE, the mob proc gets called instantly on activation.

		Otherwise, the proc is granted to a mob as a verb; as such, 'set name' etc. should be in place for the proc.

		The procs should all take *no arguments* (unless you use alert()/input() or equivalents)

		Since the procs are all mob methods, you can access the Revenant datum through src.mind.bluespace_revenant
		as long as Mind and the Revenant datum both exist (you should validate that and/or use ?. operators at minimum)


	/datum/power/revenant/bs_hunger

		Nearly identical to Powers. The distinction is primarily due to
*/