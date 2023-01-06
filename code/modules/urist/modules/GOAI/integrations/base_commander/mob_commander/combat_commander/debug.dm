/mob/verb/PosessWithCombatCommander()
	set category = "Debug GOAI Commanders"

	set src in view()

	AttachCombatCommanderTo(src, null)


# ifdef GOAI_SS13_SUPPORT
/mob/living/simple_animal/hostile/verb/SetSpeed(speed as num)
	set category = "Debug GOAI Commanders"
	set src in view()

	if(isnull(speed) || (speed < 0))
		return

	src.speed = speed
	to_chat(usr, "Set speed of [src] to [src.speed]")

# endif
