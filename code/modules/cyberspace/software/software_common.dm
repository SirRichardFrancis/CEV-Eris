/datum/computer_file/cyber
	filename = "KERANG" // Doubles as icon_state of corresponding HUD element
	filetype = "HACK"
	size = 4

	var/boot_cost = 10	// How much processing power required to execute this program?
	var/idle_cost = 2	// If this program have loaded and stays in the thread, how much processing power it expends each SScyber tick?
	var/loading_time = 5 // Number of SScyber ticks (1 second) required for this program to load after paying boot_cost
	// "boot_cost = idle_cost * loading_time" is baseline, but some programs might be cheaper or more expensive to keep idle 

	var/activation_trigger = HACK_TRIGGER_SELECTION // What makes this program to fire after loading?
	var/program_type = HACK_TYPE_UTILITY // Intended purpose of the program. HACK_TYPE_FOCUS comes with special behavior


/datum/computer_file/cyber/clone(rename = 0)
	var/datum/computer_file/cyber/temp = new
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.filename = filename
	temp.filetype = filetype
	temp.size = size
	temp.boot_cost = boot_cost
	temp.idle_cost = idle_cost
	temp.loading_time = loading_time
	temp.activation_trigger = activation_trigger
	temp.program_type = program_type
	return temp


/datum/computer_file/cyber/proc/finished_loading(mob/cyber_avatar/user)
	return "placeholder"



















