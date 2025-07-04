var/global/const/ENG = FLAG_01
var/global/const/SEC = FLAG_02
var/global/const/MED = FLAG_03
var/global/const/SCI = FLAG_04
var/global/const/CIV = FLAG_05
var/global/const/COM = FLAG_06
var/global/const/MSC = FLAG_07
var/global/const/SRV = FLAG_08
var/global/const/SUP = FLAG_09
var/global/const/SPT = FLAG_10
var/global/const/EXP = FLAG_11
var/global/const/ROB = FLAG_12

GLOBAL_VAR(antag_code_phrase)
GLOBAL_VAR(antag_code_response)

SUBSYSTEM_DEF(jobs)
	name = "Jobs"
	init_order = SS_INIT_JOBS
	flags = SS_NO_FIRE

	var/list/archetype_job_datums =    list()
	var/list/job_lists_by_map_name =   list()
	var/list/titles_to_datums =        list()
	var/list/types_to_datums =         list()
	var/list/primary_job_datums =      list()
	var/list/unassigned_roundstart =   list()
	var/list/positions_by_department = list()
	var/list/job_icons =               list()


/datum/controller/subsystem/jobs/UpdateStat(time)
	return


/datum/controller/subsystem/jobs/Initialize(start_uptime)

	// Create main map jobs.
	primary_job_datums.Cut()
	for(var/jobtype in (list(DEFAULT_JOB_TYPE) | GLOB.using_map.allowed_jobs))
		var/datum/job/job = get_by_path(jobtype)
		if(!job)
			job = new jobtype
		primary_job_datums += job

	// Create abstract submap archetype jobs for use in prefs, etc.
	archetype_job_datums.Cut()
	var/list/submap_archetypes = GET_SINGLETON_SUBTYPE_LIST(/singleton/submap_archetype)
	for (var/singleton/submap_archetype/arch in submap_archetypes)
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(!job && ispath(jobtype, /datum/job/submap))
				// Set this here so that we don't create multiples of the same title
				// before getting to the cache updating proc below.
				types_to_datums[jobtype] = new jobtype(abstract_job = TRUE)
				job = get_by_path(jobtype)
			if(job)
				archetype_job_datums |= job

	// Init skills.
	if(!length(GLOB.skills))
		GET_SINGLETON(/singleton/hierarchy/skill)
	if(!length(GLOB.skills))
		log_error(SPAN_WARNING("Error setting up job skill requirements, no skill datums found!"))

	// Update title and path tracking, submap list, etc.
	// Populate/set up map job lists.
	job_lists_by_map_name = list("[GLOB.using_map.full_name]" = list("jobs" = primary_job_datums, "default_to_hidden" = FALSE))

	for (var/singleton/submap_archetype/arch in submap_archetypes)
		var/list/submap_job_datums
		for(var/jobtype in arch.crew_jobs)
			var/datum/job/job = get_by_path(jobtype)
			if(job)
				LAZYADD(submap_job_datums, job)
		if(LAZYLEN(submap_job_datums))
			job_lists_by_map_name[arch.descriptor] = list("jobs" = submap_job_datums, "default_to_hidden" = TRUE)

	// Update global map blacklists and whitelists.
	for(var/mappath in GLOB.all_maps)
		var/datum/map/M = GLOB.all_maps[mappath]
		M.setup_job_lists()

	// Update valid job titles.
	titles_to_datums = list()
	types_to_datums = list()
	positions_by_department = list()
	for(var/map_name in job_lists_by_map_name)
		var/list/map_data = job_lists_by_map_name[map_name]
		for(var/datum/job/job in map_data["jobs"])
			types_to_datums[job.type] = job
			titles_to_datums[job.title] = job
			for(var/alt_title in job.alt_titles)
				titles_to_datums[alt_title] = job
			if(job.department_flag)
				for (var/I in 1 to length(GLOB.index_to_flag))
					if(job.department_flag & GLOB.index_to_flag[I])
						LAZYDISTINCTADD(positions_by_department["[GLOB.index_to_flag[I]]"], job.title)
						if (length(job.alt_titles))
							LAZYDISTINCTADD(positions_by_department["[GLOB.index_to_flag[I]]"], job.alt_titles)

	// Set up syndicate phrases.
	GLOB.antag_code_phrase = generate_code_phrase()
	GLOB.antag_code_response = generate_code_phrase()

	// Set up AI spawn locations
	spawn_empty_ai()


/datum/controller/subsystem/jobs/proc/guest_jobbans(job)
	for(var/dept in list(COM, MSC, SEC))
		if(job in titles_by_department(dept))
			return TRUE
	return FALSE

/datum/controller/subsystem/jobs/proc/reset_occupations()
	for(var/mob/new_player/player in GLOB.player_list)
		if((player) && (player.mind))
			player.mind.assigned_job = null
			player.mind.assigned_role = null
			player.mind.special_role = null
	for(var/datum/job/job in primary_job_datums)
		job.current_positions = 0
	unassigned_roundstart = list()

/datum/controller/subsystem/jobs/proc/get_by_title(rank)
	return titles_to_datums[rank]

/datum/controller/subsystem/jobs/proc/get_by_path(path)
	RETURN_TYPE(/datum/job)
	return types_to_datums[path]

/datum/controller/subsystem/jobs/proc/check_general_join_blockers(mob/new_player/joining, datum/job/job)
	if(!istype(joining) || !joining.client || !joining.client.prefs)
		return FALSE
	if(!istype(job))
		log_debug("Job assignment error for [joining] - job does not exist or is of the incorrect type.")
		return FALSE
	if(!job.is_position_available())
		to_chat(joining, SPAN_WARNING("Unfortunately, that job is no longer available."))
		return FALSE
	if(!config.enter_allowed)
		to_chat(joining, SPAN_WARNING("There is an administrative lock on entering the game!"))
		return FALSE
	if(SSticker.mode && SSticker.mode.explosion_in_progress)
		to_chat(joining, SPAN_WARNING("The [station_name()] is currently exploding. Joining would go poorly."))
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_latejoin_blockers(mob/new_player/joining, datum/job/job)
	if(!check_general_join_blockers(joining, job))
		return FALSE
	if(job.minimum_character_age && (joining.client.prefs.age < job.minimum_character_age))
		to_chat(joining, SPAN_WARNING("Your character's in-game age is too low for this job."))
		return FALSE
	if(!job.player_old_enough(joining.client))
		to_chat(joining, SPAN_WARNING("Your player age (days since first seen on the server) is too low for this job."))
		return FALSE
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(joining, SPAN_WARNING("The round is either not ready, or has already finished..."))
		return FALSE
	return TRUE

/datum/controller/subsystem/jobs/proc/check_unsafe_spawn(mob/living/spawner, turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] IU/s", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("spawned at spawn point with dangerous atmosphere.", spawner)
	return TRUE

/datum/controller/subsystem/jobs/proc/assign_role(mob/new_player/player, rank, latejoin = 0, datum/game_mode/mode = SSticker.mode)
	if(player && player.mind && rank)
		var/datum/job/job = get_by_title(rank)
		if(!job)
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		if(job.is_restricted(player.client.prefs))
			return 0
		if(job.title in mode.disabled_jobs)
			return 0

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			player.mind.assigned_job = job
			player.mind.assigned_role = rank
			player.mind.role_alt_title = job.get_alt_title_for(player.client)
			unassigned_roundstart -= player
			job.current_positions++
			return 1
	return 0

/datum/controller/subsystem/jobs/proc/find_occupation_candidates(datum/job/job, level, flag)
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned_roundstart)
		var/datum/preferences/prefs = player.client.prefs
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(prefs.use_slot_priority_list)
			for(var/datum/preferences_slot/slot in prefs.slot_priority_list)
				if(flag && !(flag in slot.be_special_role))
					continue
				if(job.minimum_character_age && (slot.age < job.minimum_character_age))
					continue
				if(slot.CorrectLevel(job, level))
					candidates += player
					break
		else if(prefs.CorrectLevel(job,level))
			if(flag && !(flag in prefs.be_special_role))
				continue
			if(job.minimum_character_age && (prefs.age < job.minimum_character_age))
				continue
			candidates += player
	return candidates

/datum/controller/subsystem/jobs/proc/give_random_job(mob/new_player/player, datum/game_mode/mode = SSticker.mode)
	var/datum/preferences/prefs = player.client.prefs
	for(var/datum/job/job in shuffle(primary_job_datums))
		if(!job)
			continue
		if(job.minimum_character_age && (prefs.age < job.minimum_character_age))
			continue
		if(istype(job, get_by_title(GLOB.using_map.default_assistant_title))) // We don't want to give him assistant, that's boring!
			continue
		if(job.is_restricted(prefs))
			continue
		if(job.title in titles_by_department(COM)) //If you want a command position, select it!
			continue
		if(jobban_isbanned(player, job.title))
			continue
		if(!job.player_old_enough(player.client))
			continue
		if(job.title in mode.disabled_jobs)
			continue
		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			assign_role(player, job.title, mode = mode)
			unassigned_roundstart -= player
			break

///This proc is called before the level loop of divide_occupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/jobs/proc/fill_head_position(datum/game_mode/mode)
	for (var/level = 1 to 3)
		for (var/command_position as anything in titles_by_department(COM))
			var/datum/job/job = get_by_title(command_position)
			if (!job)
				continue
			var/list/candidates = find_occupation_candidates(job, level)
			if (!length(candidates))
				continue
			var/list/weightedCandidates = list()
			for (var/mob/mob as anything in candidates)
				if (!mob.client)
					continue
				var/age = 0
				if(mob.client.prefs.use_slot_priority_list)
					for(var/datum/preferences_slot/slot in mob.client.prefs.slot_priority_list)
						if(slot.CorrectLevel(job, level))
							age = slot.age
							break
				else
					age = mob.client.prefs.age
				if (age < job.minimum_character_age)
					continue
				if (age < job.minimum_character_age + 10)
					weightedCandidates[mob] = 3
				else if (age < job.ideal_character_age - 10)
					weightedCandidates[mob] = 6
				else if (age < job.ideal_character_age + 10)
					weightedCandidates[mob] = 10
				else if (age < job.ideal_character_age + 20)
					weightedCandidates[mob] = 6
				else
					weightedCandidates[mob] = 3
			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if (assign_role(candidate, command_position, mode = mode))
				return TRUE
	return FALSE

///This proc is called at the start of the level loop of divide_occupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/jobs/proc/CheckHeadPositions(level, datum/game_mode/mode)
	for(var/command_position in titles_by_department(COM))
		var/datum/job/job = get_by_title(command_position)
		if(!job)	continue
		var/list/candidates = find_occupation_candidates(job, level)
		if(!length(candidates))	continue
		var/mob/new_player/candidate = pick(candidates)
		assign_role(candidate, command_position, mode = mode)

/** Proc divide_occupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/jobs/proc/divide_occupations(datum/game_mode/mode)
	if(GLOB.triai)
		for(var/datum/job/A in primary_job_datums)
			if(A.title == "AI")
				A.spawn_positions = 3
				break
	//Get the players who are ready
	for(var/mob/new_player/player in GLOB.player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned_roundstart += player
	if(length(unassigned_roundstart) == 0)	return 0
	//Shuffle players and jobs
	unassigned_roundstart = shuffle(unassigned_roundstart)
	//People who wants to be assistants, sure, go on.
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = find_occupation_candidates(assist, 3)
	for(var/mob/new_player/player in assistant_candidates)
		assign_role(player, GLOB.using_map.default_assistant_title, mode = mode)
		assistant_candidates -= player

	//Select one head
	fill_head_position(mode)

	//Other jobs are now checked
	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(primary_job_datums)
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level, mode)

		// Loop through all unassigned players
		var/list/deferred_jobs = list()
		for(var/mob/new_player/player in unassigned_roundstart)
			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(job && !mode.disabled_jobs.Find(job.title))
					if(job.defer_roundstart_spawn)
						deferred_jobs[job] = TRUE
					else if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break

		if(LAZYLEN(deferred_jobs))
			for(var/mob/new_player/player in unassigned_roundstart)
				for(var/datum/job/job in deferred_jobs)
					if(attempt_role_assignment(player, job, level, mode))
						unassigned_roundstart -= player
						break
			deferred_jobs.Cut()

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			give_random_job(player, mode)
	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned_roundstart)
		var/datum/preferences/prefs = player.client.prefs
		if(prefs.alternate_option == BE_ASSISTANT)
			var/datum/job/ass = DEFAULT_JOB_TYPE
			if((GLOB.using_map.flags & MAP_HAS_BRANCH) && prefs.branches[initial(ass.title)])
				var/datum/mil_branch/branch = GLOB.mil_branches.get_branch(prefs.branches[initial(ass.title)])
				ass = branch.assistant_job
			assign_role(player, initial(ass.title), mode = mode)
	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel()
			unassigned_roundstart -= player
	return TRUE

/datum/controller/subsystem/jobs/proc/attempt_role_assignment(mob/new_player/player, datum/job/job, level, datum/game_mode/mode)
	if(!jobban_isbanned(player, job.title) && job.is_position_available() && job.player_old_enough(player.client))
		if(player.client.prefs.use_slot_priority_list)
			for(var/datum/preferences_slot/prefs in player.client.prefs.slot_priority_list)
				if(prefs.CorrectLevel(job, level))
					player.client.prefs.load_character(prefs.slot)
					assign_role(player, job.title, mode = mode)
					return TRUE
		else if(player.client.prefs.CorrectLevel(job, level))
			assign_role(player, job.title, mode = mode)
			return TRUE
	return FALSE

/datum/controller/subsystem/jobs/proc/equip_custom_loadout(mob/living/carbon/human/H, datum/job/job)

	if(!H || !H.client)
		return

	// Equip custom gear loadout, replacing any job items
	var/list/spawn_in_storage = list()
	var/list/loadout_taken_slots = list()
	if(H.client.prefs.Gear() && job.loadout_allowed)
		for(var/thing in H.client.prefs.Gear())
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				var/feedback_message = "branch"
				if(G.allowed_branches)
					if(H.char_branch && (H.char_branch.type in G.allowed_branches))
						permitted = 1
				else
					permitted = 1

				if(permitted)
					if(G.allowed_roles)
						if(job.type in G.allowed_roles)
							permitted = 1
						else
							permitted = 0
							feedback_message = "job"
					else
						permitted = 1

				if (permitted && G.allowed_traits)
					permitted = FALSE
					feedback_message = "traits"
					for (var/required_trait in G.allowed_traits)
						if (H.HasTrait(required_trait))
							permitted = TRUE

				if(G.whitelisted && (!(H.species.name in G.whitelisted)))
					feedback_message = "whitelist status"
					permitted = 0

				if(!permitted)
					to_chat(H, SPAN_WARNING("Your current [feedback_message] does not permit you to spawn with \the [thing]!"))
					continue

				if(!G.slot || G.slot == slot_tie || (G.slot in loadout_taken_slots) || !G.spawn_on_mob(H, H.client.prefs.Gear()[G.display_name]))
					spawn_in_storage.Add(G)
				else
					loadout_taken_slots.Add(G.slot)

	// do accessories last so they don't attach to a suit that will be replaced
	if(H.char_rank && H.char_rank.accessory)
		for(var/accessory_path in H.char_rank.accessory)
			var/list/accessory_data = H.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					H.equip_to_slot_or_del(new accessory_path(arglist(accessory_args)), slot_tie)
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					H.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	return spawn_in_storage

/datum/controller/subsystem/jobs/proc/equip_rank(mob/living/carbon/human/H, rank, joined_late = 0)
	if(!H)
		return

	var/datum/job/job = get_by_title(rank)
	var/list/spawn_in_storage

	if(job)
		if(H.client)
			if(GLOB.using_map.flags & MAP_HAS_BRANCH)
				H.char_branch = GLOB.mil_branches.get_branch(H.client.prefs.branches[rank])
			if(GLOB.using_map.flags & MAP_HAS_RANK)
				H.char_rank = GLOB.mil_branches.get_rank(H.client.prefs.branches[rank], H.client.prefs.ranks[rank])

		// Transfers the skill settings for the job to the mob
		H.skillset.obtain_from_client(job, H.client)

		//Equip job items.
		job.setup_account(H)

		// EMAIL GENERATION
		if(rank != "Robot" && rank != "AI" && rank != "Stowaway")		//AI/Robot get their emails later. Stowaway gets their emails never.
			var/domain
			var/addr = H.real_name
			var/pass
			if(GLOB.using_map.flags & MAP_HAS_BRANCH)
				if(H.char_branch)
					if(H.char_branch.email_domain)
						domain = H.char_branch.email_domain
					if (H.char_branch.allow_custom_email && H.client.prefs.email_addr)
						addr = H.client.prefs.email_addr
			else
				if(job.email_domain)
					domain = job.email_domain
				if(job.allow_custom_email && H.client.prefs.email_addr)
					addr = H.client.prefs.email_addr

			if(!domain) //if at this point we don't have a domain set, we use the generic one
				domain = "freemail.net"

			if (H.client.prefs.email_pass)
				pass = H.client.prefs.email_pass
			if(domain)
				ntnet_global.create_email(H, addr, domain, rank, pass)
		// END EMAIL GENERATION

		job.equip(H, H.mind ? H.mind.role_alt_title : "", H.char_branch, H.char_rank)
		job.apply_fingerprints(H)
		spawn_in_storage = equip_custom_loadout(H, job)

		var/obj/item/clothing/under/uniform = H.w_uniform
		if(istype(uniform) && uniform.has_sensor)
			uniform.sensor_mode = SUIT_SENSOR_MODES[H.client.prefs.sensor_setting]
			if(H.client.prefs.sensors_locked)
				uniform.has_sensor = SUIT_LOCKED_SENSORS
	else
		to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	H.job = rank

	if(!joined_late || job.latejoin_at_spawnpoints)
		var/obj/S = job.get_roundstart_spawnpoint()

		if(istype(S, /obj/landmark/start) && isturf(S.loc))
			H.forceMove(S.loc)
		else
			var/datum/spawnpoint/spawnpoint = job.get_spawnpoint(H.client)
			H.forceMove(pick(spawnpoint.turfs))
			spawnpoint.after_join(H)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	// If they're head, give them the account info for their department
	if(H.mind && job.head_position)
		var/remembered_info = ""
		var/datum/money_account/department_account = department_accounts[job.department]

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> [GLOB.using_map.local_currency_name_short][department_account.money]<br>"

		H.StoreMemory(remembered_info, /singleton/memory_options/system)

	var/alt_title = null
	if(H.mind)
		H.mind.assigned_job = job
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

	var/mob/other_mob = job.handle_variant_join(H, alt_title)
	if(other_mob)
		job.post_equip_rank(other_mob, alt_title || rank)
		return other_mob

	if(spawn_in_storage)
		for(var/datum/gear/G in spawn_in_storage)
			G.spawn_in_storage_or_drop(H, H.client.prefs.Gear()[G.display_name])

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = H.get_organ(BP_R_FOOT)
		if(!l_foot || !r_foot)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			H.UpdateLyingBuckledAndVerbStatus()
			W.set_dir(H.dir)
			W.buckle_mob(H)
			W.add_fingerprint(H)

	to_chat(H, FONT_LARGE("<B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>"))

	if(job.supervisors)
		to_chat(H, "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")

	to_chat(H, "<b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b>")

	if(job.req_admin_notify)
		to_chat(H, "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>")

	if (H.disabilities & NEARSIGHTED) //Try to give glasses to the vision impaired
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/prescription(H), slot_glasses)

	SET_BIT(H.hud_updateflag, ID_HUD)
	SET_BIT(H.hud_updateflag, IMPLOYAL_HUD)
	SET_BIT(H.hud_updateflag, SPECIALROLE_HUD)

	job.post_equip_rank(H, alt_title || rank)

	H.client.show_location_blurb(3 SECONDS)

	return H

/datum/controller/subsystem/jobs/proc/titles_by_department(dept)
	return positions_by_department["[dept]"] || list()

/datum/controller/subsystem/jobs/proc/spawn_empty_ai()
	for(var/obj/landmark/start/S in landmarks_list)
		if(S.name != "AI")
			continue
		if(locate(/mob/living) in S.loc)
			continue
		empty_playable_ai_cores += new /obj/structure/AIcore/deactivated(get_turf(S))
	return 1

/client/proc/show_location_blurb(duration)
	set waitfor = FALSE

	var/location_name = station_name()
	var/star_name = GLOB.using_map.system_name

	var/obj/overmap/visitable/V = map_sectors["[mob.z]"]
	if(istype(V))
		location_name = V.name

	var/style = "font-family: 'Fixedsys'; -dm-text-outline: 1 black; font-size: 11px;"
	var/area/A = get_area(mob)
	var/text = "Earthdate [stationdate2text()]\n[A.name], [location_name]\n[star_name] system"
	text = uppertext(text)

	var/obj/effect/T = new()
	T.icon_state = "nothing"
	T.maptext_height = 64
	T.maptext_width = 512
	T.layer = FLOAT_LAYER
	T.plane = HUD_PLANE
	T.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	T.screen_loc = "LEFT+1,BOTTOM+2"

	screen += T
	animate(T, alpha = 255, time = 10)
	for(var/i = 1 to length_char(text) + 1)
		T.maptext = "<span style=\"[style]\">[copytext_char(text, 1, i)] </span>"
		sleep(1)

	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(fade_location_blurb), src, T), duration)


/proc/fade_location_blurb(client/C, obj/T)
	animate(T, alpha = 0, time = 5)
	sleep(5)
	if(C)
		C.screen -= T
	qdel(T)
