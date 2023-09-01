// Cyberspace. A consensual hallucination experienced daily by billions of legitimate operators, in every nation, by children being taught mathematical concepts...
// A graphical representation of data abstracted from the banks of every computer in the human system. Unthinkable complexity.
// Lines of light ranged in the non-space of the mind, clusters and constellations of data. Like city lights, receding. — William Gibson, Neuromancer

PROCESSING_SUBSYSTEM_DEF(cyber)
	name = "Cyberspace"
	priority = SS_PRIORITY_CYBERSPACE
	flags = SS_POST_FIRE_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 0.5 SECOND

	process_proc = /datum/cyber_data_holder/proc/next_turn

	var/list/runners // List of player-controlled characters present in the cyberspace
	var/list/source_files // .dm file paths from cev_eris.dme


/datum/controller/subsystem/processing/cyber/SS_initialize()
	..()
	runners = list()
	source_files = file2list("cev_eris.dme")
	for(var/i in source_files)
		if(!LAZYLEN(i) || !findtext(i, "#include"))
			source_files.Remove(i)

	var/index = 0
	for(var/entry in source_files)
		index++
		entry = replacetext(entry, "#include \"", "")
//		entry = replacetext(entry, "\\\\", "\\") // Convert the escaped slashes into regular ones
		entry = copytext(entry, 1, LAZYLEN(entry)) // Remove " at the end
		source_files[index] = entry
		world << entry


/datum/controller/subsystem/processing/cyber/fire(resumed)
	if(LAZYLEN(SScyber.runners))
		update_parallax_maptext()
	..()




/datum/controller/subsystem/processing/cyber/proc/update_parallax_maptext()
	var/static/regex/html_remover
	var/static/list/file_string_list
	var/static/list/maptext_string_list
	var/static/maptext_updated
	var/static/file_line_total
	var/static/file_line_count

	if(!html_remover) // First iteration of this proc
		html_remover = regex(@"[<>]", "g")
		maptext_string_list = list("Hello there, and welcome to the future.")

	if(!file_string_list)
		file_string_list = file2list(pick(SScyber.source_files))
		file_line_total = LAZYLEN(file_string_list)
		file_line_count = 0

	if(file_line_count != file_line_total)
		file_line_count++
		if(LAZYLEN(file_string_list[file_line_count]))
			maptext_string_list += html_remover.Replace(file_string_list[file_line_count], "") 
	else
		qdel(file_string_list)
		file_string_list = null

	if(LAZYLEN(maptext_string_list) > 42)
		maptext_string_list -= maptext_string_list[1]

//	maptext_updated = "<span >[jointext(maptext_string_list, "\n")]</span>"

	maptext_updated = "<span style=\"-dm-text-outline: 1 #221d8a; font-family: 'Small Fonts'; font-size: 16px; color:#2b2e94\">[jointext(maptext_string_list, "\n")]</span>"

	for(var/mob/runner as anything in SScyber.runners)
		runner.parallax.maptext = maptext_updated



