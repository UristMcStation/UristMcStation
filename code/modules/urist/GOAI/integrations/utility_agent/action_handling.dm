
/datum/utility_ai/proc/HandleAction(var/datum/utility_action/action, var/datum/ActionTracker/tracker)
	MAYBE_LOG("Tracker: [tracker]")
	var/running = 1

	while (tracker && running)
		// TODO: Interrupts
		running = tracker.IsRunning()

		MAYBE_LOG("[src]: Tracker: [tracker] running @ [running]")

		spawn(0)
			// task-specific logic goes here
			MAYBE_LOG("[src]: HandleAction action is: [action]")

			var/actionproc = action.handler
			var/handlertype = action.handlertype

			var/list/action_args = list()
			action_args["tracker"] = tracker

			if(action?.arguments?.len)
				if(handlertype == HANDLERTYPE_SRCMETHOD)
					action_args += action.arguments

				if(handlertype == HANDLERTYPE_FUNC)
					var/list/funcargs = list()

					for(var/passed_arg in action.arguments)
						var/passed_val = action.arguments[passed_arg]

						if(passed_arg == "func_proc")
							action_args["func_proc"] = passed_val
							continue

						funcargs[passed_arg] = passed_val

					action_args["func_args"] = funcargs

			if(isnull(actionproc))
				MAYBE_LOG("Failed to call [actionproc]([json_encode(action_args)])!")
				tracker.SetFailed()
				return

			else
				if(tracker.IsStopped())
					if(action._terminates_plan && tracker.is_done)
						var/list/smart_plans = src.brain?.GetMemoryValue("SmartPlans", null) || list()
						var/plan_len = smart_plans?.len || 0

						var/target_plan = smart_plans[action._terminates_plan]
						var/target_plan_hash = isnull(target_plan) ? null : ref(target_plan)

						if(plan_len >= action._terminates_plan && target_plan_hash == action._terminates_plan_hash)
							smart_plans[action._terminates_plan] = null
							src.brain?.SetMemory("SmartPlans", smart_plans)
					return

				MAYBE_LOG("Calling [actionproc]([json_encode(action_args)])!")

				call(src, actionproc)(arglist(action_args))

				if(action.instant || tracker.IsStopped())
					if(action._terminates_plan && tracker.is_done)
						var/list/smart_plans = src.brain?.GetMemoryValue("SmartPlans", null) || list()
						var/plan_len = smart_plans?.len || 0
						if(plan_len >= action._terminates_plan)
							smart_plans[action._terminates_plan] = null
							src.brain?.SetMemory("SmartPlans", smart_plans)
					return

		var/safe_ai_delay = max((src?.ai_tick_delay || 0), 1)
		var/sleeptime = min(MAX_AI_SLEEPTIME, safe_ai_delay)

		src.waketime = (world.time + safe_ai_delay)

		while(world.time < src.waketime)
			sleep(sleeptime)


/datum/utility_ai/proc/HandleInstantAction(var/datum/goai_action/action, var/datum/ActionTracker/tracker)
	MAYBE_LOG("Tracker: [tracker]")

	var/list/action_lookup = actionlookup // abstract maybe
	if(isnull(action_lookup))
		return

	MAYBE_LOG("[src]: Tracker: [tracker] running @ [tracker?.IsRunning()]")
	MAYBE_LOG("[src]: HandleInstantAction action is: [action]")

	var/actionproc = action_lookup[action.name]

	var/list/action_args = list()
	action_args["tracker"] = tracker
	action_args += action.arguments

	if(isnull(actionproc))
		tracker.SetFailed()

	else
		call(src, actionproc)(arglist(action_args))

	return
