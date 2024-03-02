/*
Temporary disable - gets in the way in the dropdown

/turf/verb/TestLinRegTo()
	set src in view()

	usr << " "
	usr << "SRC: [src], USR: [usr]"
	var/result = LinRegress(AtomToVector2d(usr), AtomToVector2d(src))
	usr << "LinReg result to [src]: [result]"
	usr << " "
	return result
*/

/turf/verb/TestAngleTo()
	set src in view()

	usr << " "
	usr << "SRC: [src], USR: [usr]"
	var/coeff = LinRegress(AtomToVector2d(usr), AtomToVector2d(src))
	var/angle = arctan(coeff)
	usr << "AngleTo result to [src]: [angle]"
	usr << " "
	return angle


/turf/verb/TestEuclidOffsetTo(dist as num)
	set src in view()

	usr << " "
	usr << "SRC: [src], USR: [usr]"
	var/Vector2d/result = GetEuclidStepOffset(AtomToVector2d(usr), AtomToVector2d(src), dist)
	usr << "GetEuclidStepOffset result to [src]: [result] ([result.x], [result.y])"
	return result


/turf/verb/TestEuclidStepToRaw(dist as num)
	set src in view()

	usr << " "
	usr << "SRC: [src], USR: [usr]"
	var/Vector2d/result = GetEuclidStepPos(AtomToVector2d(usr), AtomToVector2d(src), dist)
	usr << "GetEuclidStepPos result to [src]: [result] ([result.x], [result.y])"
	usr << " "
	return result


/turf/verb/TestEuclidStepToTurf(dist as num)
	set src in view()

	usr << " "
	usr << "SRC: [src], USR: [usr]"
	var/Vector2d/result = GetEuclidStepPos(AtomToVector2d(usr), AtomToVector2d(src), dist)
	var/atom/out_pos = CoordsToTurf(result, src.z)

	usr << "CoordsToTurf result: [out_pos]"
	usr << " "
	return out_pos


/turf/verb/TestEuclidWalkToPos(steps as num)
	set src in view()

	var/total_dist = EuclidDistance(usr, src)
	usr << " "
	usr << "SRC: [src], USR: [usr], DIST: [total_dist]"

	var/true_steps = max(1, abs(steps))
	var/stepsize = total_dist / true_steps
	usr << "STEPSIZE: [stepsize]"
	usr << ""

	var/starting_z = usr.z  // in case usr changes z-levels during calculation, we copy by value here

	var/Vector2d/curr_pos = AtomToVector2d(usr)
	var/Vector2d/targ_pos = AtomToVector2d(src)

	var/atom/curr_turf = CoordsToTurf(curr_pos, starting_z)

	var/terminated = FALSE

	for(var/i = 1, i <= true_steps, i++)
		var/curr_step_size = stepsize * i

		if (curr_step_size >= total_dist)
			curr_step_size = total_dist
			terminated = TRUE

		var/Vector2d/step_result = GetEuclidStepPos(curr_pos, targ_pos, curr_step_size)
		usr << "GetEuclidStepPos result TO [targ_pos] ([targ_pos.x], [targ_pos.y]) @ STEP [curr_step_size]: [step_result] ([step_result.x], [step_result.y])"

		curr_turf = CoordsToTurf(step_result, starting_z)

		usr << "CoordsToTurf result FROM [step_result] ([step_result.x], [step_result.y]) TO [targ_pos] ([targ_pos.x], [targ_pos.y]): [curr_turf]"
		usr << " "

		if(terminated)
			break

	usr << " "
	return


/atom/verb/TestRaytrace()
	set src in world

	var/atom/result = AtomDensityRaytrace(usr, src, list(usr))

	if(result && istype(result))
		result.pDrawVectorbeam(usr, result)
		result.pDrawVectorbeam(usr, src, "n_beam")

	usr << "Hit [result]"

	usr << " "
	return


/mob/verb/CheckAtan(var/x as num)
	usr << "Atan [x] == [arctan(x)]"