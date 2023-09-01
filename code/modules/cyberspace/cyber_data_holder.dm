
/datum/cyber_data_holder
	var/thread_limit = 8
	var/thread_count = 0
	var/processing_power_limit = 200
	var/processing_power_count = 0
	var/power_regeneration_speed = 10

	var/list/active_threads
	var/list/available_programs



















/datum/cyber_data_holder/proc/next_turn() // Processing proc, called by SScyber
