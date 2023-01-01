/mob/verb/PosessWithCombatCommander()
	set category = "Debug GOAI Commanders"

	set src in view()

	AttachCombatCommanderTo(src, null)
