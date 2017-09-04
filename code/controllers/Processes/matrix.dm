/datum/controller/process/matrix/setup()
	name = "matrix"
	schedule_interval = 20 // two seconds

/datum/controller/process/sun/doWork()
	for(var/datum/matrix_software/processing/S in GLOB.processing_software)
		S.process()