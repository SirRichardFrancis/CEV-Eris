// Cyberspace. A consensual hallucination experienced daily by billions of legitimate operators, in every nation, by children being taught mathematical concepts...
// A graphical representation of data abstracted from the banks of every computer in the human system. Unthinkable complexity.
// Lines of light ranged in the non-space of the mind, clusters and constellations of data. Like city lights, receding. — William Gibson, Neuromancer

PROCESSING_SUBSYSTEM_DEF(cyber)
	name = "Cyberspace"
	priority = SS_PRIORITY_CYBERSPACE
	flags = SS_POST_FIRE_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 0.5 SECOND

	process_proc = /mob/cyber_avatar/proc/update_state


	var/list/source_files // .dm file paths from cev_eris.dme
	var/avatar_update_delay = 1 SECOND

	// Following lists store 'screen_loc' variables for certain cyberspace HUD elements
	// Doesn't look all that pretty and it's simple enough to calculate these instead
	// But doing math inside strings would be both less effective and more confusing to future coders -- KIROV
	var/list/threads_screen_locs_left // Thread loading indicator
	var/list/threads_screen_locs_right

	var/list/threads_hack_screen_locs_left // Program thread runs
	var/list/threads_hack_screen_locs_right

	var/list/hacks_screen_locs_left // Program roster
	var/list/hacks_screen_locs_right


/datum/controller/subsystem/processing/cyber/SS_initialize()
	..()
	source_files = file2list("cev_eris.dme")
	for(var/i in source_files)
		if(!LAZYLEN(i) || !findtext(i, "#include"))
			source_files.Remove(i)

	var/index = 0
	for(var/entry in source_files)
		index++
		entry = replacetext(entry, "#include \"", "")
		entry = copytext(entry, 1, LAZYLEN(entry)) // Remove " at the end
		source_files[index] = entry

	// If you don't know what these numbers mean - see 'Note on screen_loc' and other comments in cyberhud.dm
	threads_screen_locs_left = list(
		// Main threads, left-side row, from top to bottom
		"-2:4,1:259", // 1
		"-2:4,1:247", // 2
		"-2:4,1:235", // 3
		"-2:4,1:223", // 4
		"-2:4,1:211", // 5
		"-2:4,1:199", // 6
		"-2:4,1:187", // 7
		"-2:4,1:175", // 8
		// Right-side row of main threads
		"-2:86,1:259", // 9
		"-2:86,1:247", // 10
		"-2:86,1:235", // 11
		"-2:86,1:223", // 12
		"-2:86,1:211", // 13
		"-2:86,1:198", // 14
		"-2:86,1:186", // 15
		"-2:86,1:174", // 16
		// Expansion slot, left side
		"-2:4,1:299", // 17
		"-2:4,1:287", // 18
		// Expansion slot, right side
		"-2:86,1:299", // 19
		"-2:86,1:287", // 20
		// Extra threads from the Covenant, left to right
		"-2:4,1:311", // 21
		"-2:86,1:311") // 22

	// Same as above, but for the right side of the screen
	threads_screen_locs_right = list(
		// Main threads, left-side row, from top to bottom
		"18:-60,1:259", // 1
		"18:-60,1:247", // 2
		"18:-60,1:235", // 3
		"18:-60,1:223", // 4
		"18:-60,1:211", // 5
		"18:-60,1:199", // 6
		"18:-60,1:187", // 7
		"18:-60,1:175", // 8
		// Right-side row of main threads
		"18:22,1:259", // 9
		"18:22,1:247", // 10
		"18:22,1:235", // 11
		"18:22,1:223", // 12
		"18:22,1:211", // 13
		"18:22,1:198", // 14
		"18:22,1:186", // 15
		"18:22,1:174", // 16
		// Expansion slot, left side
		"18:-60,1:299", // 17
		"18:-60,1:287", // 18
		// Expansion slot, right side
		"18:22,1:299", // 19
		"18:22,1:287", // 20
		// Extra threads from the Covenant, left to right
		"18:-60,1:311", // 21
		"18:22,1:311") // 22

	threads_hack_screen_locs_left = list(
		// Main threads, left-side row, from top to bottom
		"-2:11,1:261", // 1
		"-2:11,1:249", // 2
		"-2:11,1:237", // 3
		"-2:11,1:225", // 4
		"-2:11,1:213", // 5
		"-2:11,1:200", // 6
		"-2:11,1:189", // 7
		"-2:11,1:177", // 8
		// Right-side row of main threads
		"-2:51,1:261", // 9
		"-2:51,1:249", // 10
		"-2:51,1:237", // 11
		"-2:51,1:225", // 12
		"-2:51,1:213", // 13
		"-2:51,1:201", // 14
		"-2:51,1:189", // 15
		"-2:51,1:177", // 16
		// Expansion slot, left side
		"-2:11,1:301", // 17
		"-2:11,1:289", // 18
		// Expansion slot, right side
		"-2:51,1:301", // 19
		"-2:51,1:289", // 20
		// Extra threads from the Covenant, left to right
		"-2:11,1:313", // 21
		"-2:51,1:313") // 22

	threads_hack_screen_locs_right = list(
		// Main threads, left-side row, from top to bottom
		"18:-53,1:261", // 1
		"18:-53,1:249", // 2
		"18:-53,1:237", // 3
		"18:-53,1:225", // 4
		"18:-53,1:213", // 5
		"18:-53,1:201", // 6
		"18:-53,1:189", // 7
		"18:-53,1:177", // 8
		// Right-side row of main threads
		"18:-13,1:261", // 9
		"18:-13,1:249", // 10
		"18:-13,1:237", // 11
		"18:-13,1:225", // 12
		"18:-13,1:213", // 13
		"18:-13,1:201", // 14
		"18:-13,1:189", // 15
		"18:-13,1:177", // 16
		// Expansion slot, left side
		"18:-53,1:301", // 17
		"18:-53,1:289", // 18
		// Expansion slot, right side
		"18:-13,1:301", // 19
		"18:-13,1:289", // 20
		// Extra threads from the Covenant, left to right
		"18:-53,1:313", // 21
		"18:-13,1:313") // 22

	hacks_screen_locs_left = list(
		"-2,1:148", // 1
		"-2,1:137", // 2
		"-2,1:126", // 3
		"-2,1:115", // 4
		"-2,1:104", // 5
		"-2,1:93", // 6
		"-2,1:82", // 7
		"-2,1:71", // 8
		"-2,1:60", // 9
		"-2,1:49", // 10
		"-2,1:38", // 11
		"-2,1:27") // 12

	hacks_screen_locs_right = list(
		"18:-64,1:148", // 1
		"18:-64,1:137", // 2
		"18:-64,1:126", // 3
		"18:-64,1:115", // 4
		"18:-64,1:104", // 5
		"18:-64,1:93", // 6
		"18:-64,1:82", // 7
		"18:-64,1:71", // 8
		"18:-64,1:60", // 9
		"18:-64,1:49", // 10
		"18:-64,1:38", // 11
		"18:-64,1:27") // 12


/datum/controller/subsystem/processing/cyber/fire(resumed)
	if(LAZYLEN(processing))
		update_parallax_maptext()

	if(!resumed)
		currentrun = processing.Copy()

	var/list/current_run = currentrun
	var/delta = 1

	while(LAZYLEN(current_run))
		var/mob/cyber_avatar/avatar = current_run[current_run.len]
		current_run.len--
		if(QDELETED(avatar))
			processing -= avatar
		delta = (world.time - avatar.last_update) / avatar_update_delay
		delta = round(delta)
		if(delta < 1)
			continue
		avatar.update_state(delta)
		if(MC_TICK_CHECK)
			return


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

	for(var/mob/runner as anything in processing)
		runner.parallax.maptext = maptext_updated


/datum/controller/subsystem/processing/cyber/proc/chip_in(mob/user, medium)
	ASSERT(user) // CRASH("Chip_in() proc called without 'user' argument by [usr].")
	ASSERT(user.client) // CRASH("Chip_in() proc called by [usr] on a mob([user]) that does not have a 'client'.")
	ASSERT(medium) // CRASH("Chip_in() proc called by [usr] on a mob([user]), but no means of entering cyberspace is provided.")

	// TODO: Check if cyberspace is globally disabled

	// TODO: Check if user's health is satisfactory

	var/turf/entry_point = isturf(user.loc) ? user.loc : get_turf(user.loc)

	// TODO: Check if entering cyberspace from this location is blocked

	var/obj/item/cyberdeck/cyberdeck

	if(istype(medium, /obj/item/cyberdeck))
		cyberdeck = medium
		if(cyberdeck.is_broken)
			to_chat(user, SPAN_NOTICE("You attempt to boot up your cyberdeck, but it is unresponsive."))
			return
		// TODO: Check for brain implant

	// TODO: Check for other ways of entering cyberspace, a runner chair and a modular computer

	to_chat(user, SPAN_NOTICE("Connecting to [station_name]..."))

	var/mob/cyber_avatar/avatar = new(entry_point)
	if(cyberdeck)
		avatar.get_stats_from_cyberdeck(cyberdeck)
		avatar.get_hacks_from_cyberdeck(cyberdeck)
	avatar.init_parallax()
	avatar.possess(user)
	avatar.update_state()









