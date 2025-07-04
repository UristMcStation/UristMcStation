/*
 *
 *  Zas Unit Tests.
 *  Shuttle Pressurized.
 *
 *
 */

#define UT_NORMAL 1                   // Standard one atmosphere 20celsius
#define UT_VACUUM 2                   // Vacume on simulated turfs
#define UT_NORMAL_COLD 3              // Cold but standard atmosphere.

#define FAILURE 0
#define SUCCESS 1
#define SKIP 2

//
// Generic check for an area.
//

/datum/unit_test/zas_area_test
	name = "ZAS: Area Test Template"
	template = /datum/unit_test/zas_area_test
	var/area_path = null                    // Put the area you are testing here.
	var/expectation = UT_NORMAL             // See defines above.

/datum/unit_test/zas_area_test/start_test()
	var/list/test = test_air_in_area(area_path, expectation)

	if(isnull(test))
		fail("Check Runtimed")

	switch(test["result"])
		if(SUCCESS) pass(test["msg"])
		if(SKIP)    skip(test["msg"])
		else        fail(test["msg"])
	return 1

// ==================================================================================================

//
//	The primary helper proc.
//
/proc/test_air_in_area(test_area, expectation = UT_NORMAL)
	RETURN_TYPE(/list)
	var/test_result = list("result" = FAILURE, "msg"    = "")

	var/area/A = locate(test_area)

	// BYOND creates an instance of every area, so this can't be !A or !istype(A, test_area)
	if(!(A.x || A.y || A.z))
		test_result["msg"] = "Unable to get [test_area]"
		test_result["result"] = FAILURE
		return test_result

	// Airless areas are skipped
	if (initial(A.turfs_airless))
		test_result["result"] = SUCCESS
		test_result["msg"] = "Area flagged airless. Skipped."

	var/list/GM_checked = list()

	for(var/turf/simulated/T in A)

		if(!istype(T) || isnull(T.zone))
			continue
		if(T.zone.air in GM_checked)
			continue
		var/turf/simulated/floor/floor = T
		if (istype(floor) && floor.map_airless)
			continue


		var/t_msg = "Turf: [T] |  Location: [T.x] // [T.y] // [T.z]"

		var/datum/gas_mixture/GM = T.return_air()
		var/pressure = GM.return_pressure()
		var/temp = GM.temperature

		switch(expectation)

			if(UT_VACUUM)
				if(pressure > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result


			if(UT_NORMAL, UT_NORMAL_COLD)
				if(abs(pressure - ONE_ATMOSPHERE) > 10)
					test_result["msg"] = "Pressure out of bounds: [pressure] | [t_msg]"
					return test_result

				if(expectation == UT_NORMAL)

					if(abs(temp - T20C) > 10)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

				if(expectation == UT_NORMAL_COLD)

					if(temp > 120)
						test_result["msg"] = "Temperature out of bounds: [temp] | [t_msg]"
						return test_result

		GM_checked.Add(GM)

	if(length(GM_checked))
		test_result["result"] = SUCCESS
		test_result["msg"] = "Checked [length(GM_checked)] zones"
	else
		test_result["msg"] = "No zones checked."

	return test_result


// ==================================================================================================


// Here we move a shuttle then test it's area once the shuttle has arrived.

/datum/unit_test/zas_supply_shuttle_moved
	name = "ZAS: Supply Shuttle (When Moved)"
	async=1				// We're moving the shuttle using built in procs.

	var/datum/shuttle/autodock/ferry/supply/shuttle = null

	var/testtime = 0	//Used as a timer.

/datum/unit_test/zas_supply_shuttle_moved/start_test()

	if(!SSshuttle)
		fail("Shuttle Controller not setup at time of test.")
		return 1
	if(!length(SSshuttle.shuttles))
		skip("No shuttles have been setup for this map.")
		return 1

	shuttle = SSsupply.shuttle
	if(isnull(shuttle))
		return 1

	// Initiate the Move.
	SSsupply.movetime = 5 // Speed up the shuttle movement.
	shuttle.short_jump(shuttle.get_location_waypoint(!shuttle.location)) //TODO

	return 1

/datum/unit_test/zas_supply_shuttle_moved/check_result()
	if(!shuttle)
		skip("This map has no supply shuttle.")
		return 1

	if(GLOB.using_map.using_new_cargo)
		skip("This map is using the new cargo system, supply shuttle must be manually verified.")
		return 1

	if(shuttle.moving_status == SHUTTLE_IDLE && !shuttle.at_station())
		fail("Shuttle Did not Move")
		return 1

	if(!shuttle.at_station())
		return 0

	if(!testtime)
		testtime = world.time+40                // Wait another 2 ticks then proceed.

	if(world.time < testtime)
		return 0
	for(var/area/A in shuttle.shuttle_area)
		var/list/test = test_air_in_area(A.type)
		if(isnull(test))
			fail("Check Runtimed")
			return 1

		switch(test["result"])
			if(SUCCESS) pass(test["msg"])
			if(SKIP)    skip(test["msg"])
			else        fail(test["msg"])
	return 1

#undef UT_NORMAL
#undef UT_VACUUM
#undef UT_NORMAL_COLD
#undef SUCCESS
#undef FAILURE
