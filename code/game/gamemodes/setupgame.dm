/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Randomize block, assign a reference name, and optionally define difficulty (by making activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
//  and for the DNA panel in the player panel.
/proc/getAssignedBlock(var/name,var/list/blocksLeft, var/activity_bounds=DNA_DEFAULT_BOUNDS, var/good=0)
	if(blocksLeft.len==0)
		warning("[name]: No more blocks left to assign!")
		return 0
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	if(good)
		good_blocks += assigned
	else
		bad_blocks += assigned
	assigned_blocks[assigned]=name
	dna_activity_bounds[assigned]=activity_bounds
	//testing("[name] assigned to block #[assigned].")
	return assigned

/proc/setupgenetics()

	if (prob(50))
		// Currently unused.  Will revisit. - N3X
		BLOCKADD = rand(-300,300)
	if (prob(75))
		DIFFMUT = rand(0,20)

	var/list/numsToAssign=new()
	for(var/i=1;i<DNA_SE_LENGTH;i++)
		numsToAssign += i

	//testing("Assigning DNA blocks:")

	// Standard muts, imported from older code above.
	BLINDBLOCK         = getAssignedBlock("BLIND",         numsToAssign)
	DEAFBLOCK          = getAssignedBlock("DEAF",          numsToAssign)
	HULKBLOCK          = getAssignedBlock("HULK",          numsToAssign, DNA_HARD_BOUNDS, good=1)
	TELEBLOCK          = getAssignedBlock("TELE",          numsToAssign, DNA_HARD_BOUNDS, good=1)
	FIREBLOCK          = getAssignedBlock("FIRE",          numsToAssign, DNA_HARDER_BOUNDS, good=1)
	XRAYBLOCK          = getAssignedBlock("XRAY",          numsToAssign, DNA_HARDER_BOUNDS, good=1)
	CLUMSYBLOCK        = getAssignedBlock("CLUMSY",        numsToAssign)
	FAKEBLOCK          = getAssignedBlock("FAKE",          numsToAssign)
	COUGHBLOCK         = getAssignedBlock("COUGH",         numsToAssign)
	GLASSESBLOCK       = getAssignedBlock("GLASSES",       numsToAssign)
	EPILEPSYBLOCK      = getAssignedBlock("EPILEPSY",      numsToAssign)
	TWITCHBLOCK        = getAssignedBlock("TWITCH",        numsToAssign)
	NERVOUSBLOCK       = getAssignedBlock("NERVOUS",       numsToAssign)

	// Bay muts
	HEADACHEBLOCK      = getAssignedBlock("HEADACHE",      numsToAssign)
	//NOBREATHBLOCK      = getAssignedBlock("NOBREATH",      numsToAssign, DNA_HARD_BOUNDS, good=1)
	REMOTEVIEWBLOCK    = getAssignedBlock("REMOTEVIEW",    numsToAssign, DNA_HARDER_BOUNDS, good=1)
	REGENERATEBLOCK    = getAssignedBlock("REGENERATE",    numsToAssign, DNA_HARDER_BOUNDS, good=1)
	INCREASERUNBLOCK   = getAssignedBlock("INCREASERUN",   numsToAssign, DNA_HARDER_BOUNDS, good=1)
	REMOTETALKBLOCK    = getAssignedBlock("REMOTETALK",    numsToAssign, DNA_HARDER_BOUNDS, good=1)
	MORPHBLOCK         = getAssignedBlock("MORPH",         numsToAssign, DNA_HARDER_BOUNDS, good=1)
	//COLDBLOCK          = getAssignedBlock("COLD",          numsToAssign, good=1)
	HALLUCINATIONBLOCK = getAssignedBlock("HALLUCINATION", numsToAssign)
	NOPRINTSBLOCK      = getAssignedBlock("NOPRINTS",      numsToAssign, DNA_HARD_BOUNDS, good=1)
	SHOCKIMMUNITYBLOCK = getAssignedBlock("SHOCKIMMUNITY", numsToAssign, good=1)
	SMALLSIZEBLOCK     = getAssignedBlock("SMALLSIZE",     numsToAssign, DNA_HARD_BOUNDS, good=1)

	//goon>vg>urist muts

	//disabilities
//	LISPBLOCK      = getAssignedBlock("LISP",       numsToAssign)
//	MUTEBLOCK      = getAssignedBlock("MUTE",       numsToAssign)
	RADBLOCK       = getAssignedBlock("RAD",        numsToAssign)
	FATBLOCK       = getAssignedBlock("FAT",        numsToAssign)
//	CHAVBLOCK      = getAssignedBlock("CHAV",       numsToAssign)
//	SWEDEBLOCK     = getAssignedBlock("SWEDE",      numsToAssign)
//	SCRAMBLEBLOCK  = getAssignedBlock("SCRAMBLE",   numsToAssign)
	HORNSBLOCK     = getAssignedBlock("HORNS",      numsToAssign)

	// Powers
	SOBERBLOCK     = getAssignedBlock("SOBER",      numsToAssign, good=1)
	PSYRESISTBLOCK = getAssignedBlock("PSYRESIST",  numsToAssign, DNA_HARD_BOUNDS, good=1)
	SHADOWBLOCK    = getAssignedBlock("SHADOW",     numsToAssign, DNA_HARDER_BOUNDS, good=1)
	//CHAMELEONBLOCK = getAssignedBlock("CHAMELEON",  numsToAssign, DNA_HARDER_BOUNDS, good=1)
	CRYOBLOCK      = getAssignedBlock("CRYO",       numsToAssign, DNA_HARD_BOUNDS, good=1)
	EATBLOCK       = getAssignedBlock("EAT",        numsToAssign, DNA_HARD_BOUNDS, good=1)
	JUMPBLOCK      = getAssignedBlock("JUMP",       numsToAssign, DNA_HARD_BOUNDS, good=1)
	//MELTBLOCK      = getAssignedBlock("MELT",       numsToAssign, good=1)
	//IMMOLATEBLOCK  = getAssignedBlock("IMMOLATE",   numsToAssign, good=1)
	EMPATHBLOCK    = getAssignedBlock("EMPATH",     numsToAssign, DNA_HARD_BOUNDS, good=1)
	//POLYMORPHBLOCK = getAssignedBlock("POLYMORPH",  numsToAssign, DNA_HARDER_BOUNDS, good=1)

	//
	// Static Blocks
	/////////////////////////////////////////////.

	// Monkeyblock is always last.
	MONKEYBLOCK = DNA_SE_LENGTH

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[DNA_SE_LENGTH]
	for(var/gene_type in typesof(/datum/dna/gene))
		var/datum/dna/gene/G = new gene_type
		if(G.block)
			if(G.block in blocks_assigned)
				warning("DNA2: Gene [G.name] trying to use already-assigned block [G.block] (used by [english_list(blocks_assigned[G.block])])")
			dna_genes.Add(G)
			var/list/assignedToBlock[0]
			if(blocks_assigned[G.block])
				assignedToBlock=blocks_assigned[G.block]
			assignedToBlock.Add(G.name)
			blocks_assigned[G.block]=assignedToBlock
