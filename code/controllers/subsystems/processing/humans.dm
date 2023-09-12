PROCESSING_SUBSYSTEM_DEF(humans)
	name = "Humans"
	priority = SS_PRIORITY_HUMAN
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

	process_proc = /mob/proc/Life

	var/list/mob_list

/datum/controller/subsystem/processing/humans/PreInit()
	mob_list = processing // Simply setups a more recognizable var name than "processing"
	// Only needed for testing via VSC, as host in that case always present on the server and does not trigger /Login() on startup
	for(var/mob/i as anything in mob_list)
		if(i.client)
			i.fullscreen_check()
