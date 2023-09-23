
/datum/heohud_holder
	var/mob/owner
	var/list/elements
	var/is_mirrored // Is on the right side of the screen?
	var/atom/movable/neohud/background
/datum/heohud_holder/cyberspace
	var/mob/cyber_avatar/cyber_owner

	// Gauge indicating how full processing power reserve is
	var/atom/movable/neohud/cyberspace/power/power_indicator

	// Basically a health bar
	var/atom/movable/neohud/cyberspace/network/network_indicator

	// screen_loc for background, power_indicator and network_indicator, which have same sprite dimensions
	var/main_screen_loc_left = "-2,1"
	var/main_screen_loc_right = "18:-64,1"

	// Holds related value's fullness(current_value/maximum_value) percentage increment after which indicator should move to next icon_state
	// E.g. if indicator got 18 icon states, it will increment icon state's number for each 5.5% of related value's fullness percentage
	var/power_indicator_percent_step
	var/network_indicator_percent_step

	// How much processing power is accumulated
	var/atom/movable/neohud/cyberspace/number/power_hundreeds
	var/power_hundreeds_screen_loc_left = "-2:36,1:420" // Null this if HUD skin not meant to have numerical power indicator 
	var/power_hundreeds_screen_loc_right = "18:-28,1:420"
	var/atom/movable/neohud/cyberspace/number/power_tens
	var/power_tens_screen_loc_left = "-2:46,1:420"
	var/power_tens_screen_loc_right = "18:-18,1:420"
	var/atom/movable/neohud/cyberspace/number/power_ones
	var/power_ones_screen_loc_left = "-2:56,1:420"
	var/power_ones_screen_loc_right = "18:-8,1:420"

	// How much processing power reserve replenish with each SScyber's tick
	var/atom/movable/neohud/cyberspace/number/income_tens
	var/income_tens_screen_loc_left = "-2:46,1:411" // Null for no income indicator
	var/income_tens_screen_loc_right = "18:-18,1:411"
	var/atom/movable/neohud/cyberspace/number/income_ones
	var/income_ones_screen_loc_left = "-2:51,1:411"
	var/income_ones_screen_loc_right = "18:-13,1:411"

	// Same as above, but for the expense of processing power
	var/atom/movable/neohud/cyberspace/number/drain_tens
	var/drain_tens_screen_loc_left = "-2:46,1:434" // Null for income and drain indicators being merged into one
	var/drain_tens_screen_loc_right = "18:-18,1:434"
	var/atom/movable/neohud/cyberspace/number/drain_ones
	var/drain_ones_screen_loc_left = "-2:51,1:434"
	var/drain_ones_screen_loc_right = "18:-13,1:434"

	// Note on screen_loc --KIROV
	// Neohud panels are three tiles wide and meant to be rendered outside of view range, as to not obstruct it
	// Screen location is counted from (0 coordinate, aka origin point) one tile South-West beyond the view range, meaning botton-left corner of the screen would be "1,1"
	// Number before the coma is X coordinate, meaning left-to-right position; Number after the coma is Y coordinate, top-to-bottom of the screen
	// Each 1 in screen_loc represents a tile offset, 32 pixels; This value cannot be decimal, however additive pixel offset could be specified after a colon
	// So "1:20,1" will result in 52 and 32 pixels offsets from origin point on their respective axis. Both tile-values and pixel-values could be negative
	// And for whatever reason, atom peeking off the right side of the view range will not render past 32 pixels
	// However, if cut-off part moved further by tile-value and then shifted back by pixel-value, atom would render just fine. Left side Just Works™ and doesn't need any voodoo magic

	var/list/hacks_datums // List of /datum/computer_file/cyber available for use

	// Sorted HUD elements, used to update their icons. Element's index is corresponding thread's number
	var/list/thread_indicators
	var/list/thread_hacks
	var/list/hacks_roster

	var/list/busy_threads // Indexes of threads that require processing


/datum/heohud_holder/New(master)
	owner = master
	background = new
	elements = list(background)
	

/datum/heohud_holder/cyberspace/New(master)
	cyber_owner = master
	owner = cyber_owner.original_mob // TODO: Account for a case when there is no original_mob

	hacks_datums = list()
	thread_indicators = list()
	thread_hacks = list()
	hacks_roster = list()
	busy_threads = list()
	

	background = new /atom/movable/neohud/cyberspace
	background.screen_loc = main_screen_loc_left
	elements = list(background)

	power_indicator = new
	power_indicator.icon_state = "power_[rand(0, power_indicator.icon_states_max)]"
	power_indicator.screen_loc = main_screen_loc_left
	power_indicator_percent_step = round((100 / power_indicator.icon_states_max), 0.1)
	elements += power_indicator

	network_indicator = new
	network_indicator.icon_state = "network_[rand(0, network_indicator.icon_states_max)]"
	network_indicator.screen_loc = main_screen_loc_left
	network_indicator_percent_step = round((100 / network_indicator.icon_states_max), 0.1)
	elements += network_indicator

	// Some skins do not have a numerical power indicator, null power_hundreeds_screen_loc_left is an indicator of such skin
	if(power_hundreeds_screen_loc_left)
		power_hundreeds = new
		power_hundreeds.screen_loc = power_hundreeds_screen_loc_left
		elements += power_hundreeds

		power_tens = new
		power_tens.screen_loc = power_tens_screen_loc_left
		elements += power_tens

		power_ones = new
		power_ones.screen_loc = power_ones_screen_loc_left
		elements += power_ones

	if(income_tens_screen_loc_left) // False if there is no income and drain indicators on a given skin
		income_tens = new
		income_tens.screen_loc = income_tens_screen_loc_left
		elements += income_tens

		income_ones = new
		income_ones.screen_loc = income_ones_screen_loc_left
		elements += income_ones

		if(drain_tens_screen_loc_left) // False if income and drain indicators merged into one
			drain_tens = new
			drain_tens.screen_loc = drain_tens_screen_loc_left
			elements += drain_tens

			drain_ones = new
			drain_ones.screen_loc = drain_ones_screen_loc_left
			elements += drain_ones



/datum/heohud_holder/proc/mirror() // Move HUD panel to opposite side of the screen
	if(is_mirrored)
		background.screen_loc = "-2,1"
		is_mirrored = FALSE
	else
		background.screen_loc = "18:-64,1"
		is_mirrored = TRUE


/datum/heohud_holder/cyberspace/mirror()
	if(is_mirrored)
		is_mirrored = FALSE
		background.screen_loc = main_screen_loc_left
		power_indicator.screen_loc = main_screen_loc_left
		network_indicator.screen_loc = main_screen_loc_left
		power_hundreeds.screen_loc = power_hundreeds_screen_loc_left
		power_tens.screen_loc = power_tens_screen_loc_left
		power_ones.screen_loc = power_ones_screen_loc_left
		if(income_tens)
			income_tens.screen_loc = income_tens_screen_loc_left
			income_ones.screen_loc = income_ones_screen_loc_left
		if(drain_tens)
			drain_tens.screen_loc = drain_tens_screen_loc_left
			drain_ones.screen_loc = drain_ones_screen_loc_left

		for(var/i in 1 to LAZYLEN(thread_hacks))
			var/atom/movable/atom = thread_hacks[i]
			atom.screen_loc = SScyber.threads_hack_screen_locs_left[i]

		for(var/i in 1 to LAZYLEN(thread_indicators))
			var/atom/movable/neohud/cyberspace/thread_indicator/indicator = thread_indicators[i]
			indicator.screen_loc = SScyber.threads_screen_locs_left[i]
			indicator.icon_state = "left_error"

		for(var/i in 1 to LAZYLEN(hacks_roster))
			var/atom/movable/neohud/cyberspace/hack/hack_ui_element = hacks_roster[i]
			hack_ui_element.screen_loc = SScyber.hacks_screen_locs_left[i]
	else
		is_mirrored = TRUE
		background.screen_loc = main_screen_loc_right
		power_indicator.screen_loc = main_screen_loc_right
		network_indicator.screen_loc = main_screen_loc_right
		power_hundreeds.screen_loc = power_hundreeds_screen_loc_right
		power_tens.screen_loc = power_tens_screen_loc_right
		power_ones.screen_loc = power_ones_screen_loc_right
		if(income_tens)
			income_tens.screen_loc = income_tens_screen_loc_right
			income_ones.screen_loc = income_ones_screen_loc_right
		if(drain_tens)
			drain_tens.screen_loc = drain_tens_screen_loc_right
			drain_ones.screen_loc = drain_ones_screen_loc_right

		for(var/i in 1 to LAZYLEN(thread_hacks))
			var/atom/movable/atom = thread_hacks[i]
			atom.screen_loc =SScyber.threads_hack_screen_locs_right[i]

		for(var/i in 1 to LAZYLEN(thread_indicators))
			var/atom/movable/neohud/cyberspace/thread_indicator/indicator = thread_indicators[i]
			indicator.screen_loc = SScyber.threads_screen_locs_right[i]
			indicator.icon_state = "right_error"

		for(var/i in 1 to LAZYLEN(hacks_roster))
			var/atom/movable/neohud/cyberspace/hack/hack_ui_element = hacks_roster[i]
			hack_ui_element.screen_loc = SScyber.hacks_screen_locs_right[i]


/datum/heohud_holder/cyberspace/proc/startup_flick()
//	flick("power_animation", power_indicator)
	flick("network_animation", network_indicator)


/datum/heohud_holder/cyberspace/proc/update_power()
	if(cyber_owner.processing_power_count < 1)
		power_indicator.icon_state = "power_0"
	else if(cyber_owner.processing_power_count == cyber_owner.processing_power_limit)
		power_indicator.icon_state = "power_[power_indicator.icon_states_max]"
	else
		var/power_fullness_percent = (cyber_owner.processing_power_count / cyber_owner.processing_power_limit) * 100
		if(power_fullness_percent > 95)
			power_indicator.icon_state = "power_[power_indicator.icon_states_max]"
		else if(power_fullness_percent < 5)
			power_indicator.icon_state = "power_0"
		else
			power_indicator.icon_state = "power_[round(power_fullness_percent / power_indicator_percent_step)]"

	var/power_count_text = (cyber_owner.processing_power_count < 1) ? "" : "[cyber_owner.processing_power_count]"
	switch(LAZYLEN(power_count_text))
		if(3)
			power_hundreeds.icon_state = copytext(power_count_text, 1, 2)
			power_tens.icon_state = copytext(power_count_text, 2, 3)
			power_ones.icon_state = copytext(power_count_text, 3, 4)
		if(2)
			power_hundreeds.icon_state = "0"
			power_tens.icon_state = copytext(power_count_text, 1, 2)
			power_ones.icon_state = copytext(power_count_text, 2, 3)
		if(1)
			power_hundreeds.icon_state = "0"
			power_tens.icon_state = "0"
			power_ones.icon_state = copytext(power_count_text, 1, 2)
		else
			power_hundreeds.icon_state = "0"
			power_tens.icon_state = "0"
			power_ones.icon_state = "0"


/datum/heohud_holder/cyberspace/proc/update_network()
	if(cyber_owner.network_integrity_count < 1)
		network_indicator.icon_state = "network_0"
		return

	if(cyber_owner.network_integrity_count == cyber_owner.network_integrity_limit)
		network_indicator.icon_state = "network_[network_indicator.icon_states_max]"
		return

	var/network_fullness_percent = (cyber_owner.network_integrity_count / cyber_owner.network_integrity_limit) * 100
	if(network_fullness_percent > 95)
		network_indicator.icon_state = "network_[network_indicator.icon_states_max]"

	else if(network_fullness_percent < 5)
		network_indicator.icon_state = "network_0"
	else
		network_indicator.icon_state = "network_[round(network_fullness_percent / network_indicator_percent_step)]"


/datum/heohud_holder/cyberspace/proc/update_income()
	if(!income_tens) // No indicators, nothing to update
		return

	if(drain_tens) // Separate indicators for income and expense
		var/income = "[cyber_owner.processing_power_regen]"
		var/drain = "[cyber_owner.processing_power_drain]"
		if(cyber_owner.processing_power_regen > 10)
			income_tens.icon_state = "green_[copytext(income, 1, 2)]"
			income_ones.icon_state = "green_[copytext(income, 2, 3)]"
		else
			income_tens.icon_state = "green_0"
			income_ones.icon_state = "green_[copytext(income, 1, 2)]"

		if(cyber_owner.processing_power_drain > 10)
			drain_tens.icon_state = "red_[copytext(drain, 1, 2)]"
			drain_ones.icon_state = "red_[copytext(drain, 2, 3)]"
		else
			drain_tens.icon_state = "red_0"
			drain_ones.icon_state = "red_[copytext(drain, 1, 2)]"

	else // Singular indicator with sum of income and expense
		var/net_gain = "[cyber_owner.processing_power_regen - cyber_owner.processing_power_drain]"
		if(cyber_owner.processing_power_regen - cyber_owner.processing_power_drain > 10)
			income_tens.icon_state = "green_[copytext(net_gain, 1, 2)]"
			income_ones.icon_state = "green_[copytext(net_gain, 2, 3)]"
		else
			income_tens.icon_state = "green_0"
			income_ones.icon_state = "green_[copytext(net_gain, 1, 2)]"


/datum/heohud_holder/cyberspace/proc/update_thread(thread_number)
	var/atom/movable/neohud/cyberspace/thread_hack/hack_ui_element = thread_hacks[thread_number]
	var/atom/movable/neohud/cyberspace/thread_indicator/indicator = thread_indicators[thread_number]
	if(!hack_ui_element.payload_is_idling)
		if(hack_ui_element.payload_step_current < hack_ui_element.payload_step_total)
			hack_ui_element.payload_step_current++
			indicator.icon_state = "[indicator.is_right_side ? "right" : "left"]_load_[round(hack_ui_element.payload_step_current * hack_ui_element.payload_step_ratio)]"
		else if(hack_ui_element.payload_step_current >= hack_ui_element.payload_step_total)
			var/datum/computer_file/cyber/payload = hack_ui_element.payload
			switch(payload.finished_loading(cyber_owner))
				if("placeholder")
					hack_ui_element.payload_is_idling = TRUE
					indicator.icon_state = indicator.is_right_side ? "right_loaded_passive" : "left_loaded_passive"
					cyber_owner.processing_power_drain += payload.idle_cost
				else
					indicator.icon_state = indicator.is_right_side ? "right_loaded_active" : "left_loaded_active"
					busy_threads -= thread_number // If program freed the thread
					cyber_owner.processing_power_drain -= payload.idle_cost // Should be elsewhere, a placeholder and a reminder
		else
			indicator.icon_state = indicator.is_right_side ? "right_error" : "left_error"


/datum/heohud_holder/cyberspace/proc/process_threads() // TODO: Account for delta
	for(var/i in busy_threads)
		update_thread(i)


/datum/heohud_holder/cyberspace/proc/generate_threads()
	for(var/i in 1 to cyber_owner.thread_limit)
		var/atom/movable/neohud/cyberspace/thread_hack/hack = new
		hack.screen_loc = is_mirrored ? SScyber.threads_hack_screen_locs_right[i] : SScyber.threads_hack_screen_locs_left[i]
		hack.icon_state = "IDLE"
		thread_hacks += hack
		elements += hack

		var/atom/movable/neohud/cyberspace/thread_indicator/indicator = new(src)
		indicator.screen_loc = is_mirrored ? SScyber.threads_screen_locs_right[i] : SScyber.threads_screen_locs_left[i]
		indicator.icon_state = is_mirrored ? "right_load_0" : "left_load_0"
		thread_indicators += indicator
		elements += indicator


/datum/heohud_holder/cyberspace/proc/generate_hack_list()
	if(LAZYLEN(hacks_roster))
		elements -= hacks_roster
		for(var/i in hacks_roster)
			qdel(i)
		hacks_roster.Cut()
		hacks_datums.Cut()

	var/hack_slot_count = 0
	for(var/datum/computer_file/cyber/hack_datum as anything in cyber_owner.available_programs)
		if(hack_slot_count > 11)
			break
		if(hacks_datums.Find(hack_datum))
			continue
		hack_slot_count++
		hacks_datums += hack_datum
		var/atom/movable/neohud/cyberspace/hack/hack_ui_element = new(src)
		hack_ui_element.name = hack_datum.filename
		hack_ui_element.icon_state = hack_datum.filename
		hack_ui_element.screen_loc = is_mirrored ? SScyber.hacks_screen_locs_right[hack_slot_count] : SScyber.hacks_screen_locs_left[hack_slot_count]
		elements += hack_ui_element
		hacks_roster += hack_ui_element


/datum/heohud_holder/cyberspace/proc/run_program(activated_hud_element, target_thread_index)
	if(!activated_hud_element)
		return FALSE // TODO: CRASH() call here

	if(LAZYLEN(busy_threads) >= LAZYLEN(thread_hacks))
		return FALSE

	var/datum/computer_file/cyber/hack_datum = hacks_datums[hacks_roster.Find(activated_hud_element)]

	if(hack_datum.boot_cost > cyber_owner.processing_power_count)
		return FALSE

	var/atom/movable/neohud/cyberspace/thread_hack/hack_ui_element

	if(target_thread_index)
		hack_ui_element = thread_hacks[target_thread_index]
		if(hack_ui_element.payload)
			hack_ui_element = null

	if(!hack_ui_element)
		for(var/i in 1 to LAZYLEN(thread_hacks))
			hack_ui_element = thread_hacks[i]
			if(hack_ui_element.payload)
				hack_ui_element = null
			else
				break

	if(hack_ui_element)
		var/thread = thread_hacks.Find(hack_ui_element)
		busy_threads += thread
		cyber_owner.processing_power_count -= hack_datum.boot_cost
		hack_ui_element.icon_state = hack_datum.filename
		hack_ui_element.payload = hack_datum
		hack_ui_element.payload_step_total = hack_datum.loading_time
		hack_ui_element.payload_step_current = 0
		hack_ui_element.payload_step_ratio = hack_ui_element.icon_states_max / hack_ui_element.payload_step_total
		hack_ui_element.payload_is_idling = FALSE
		update_power()
		update_thread(thread)
		return TRUE
	return FALSE




// TODO: Get hacks from modular computer
// TODO: Get hacks from runner chair/pod



// /datum/computer_file/cyber
// 	filename = "KERANG"
// 	filetype = "HACK"
// 	size = 4

// 	var/boot_cost = 10	// How much processing power required to execute this program?
// 	var/idle_cost = 2	// If this program have loaded and stays in the thread, how much processing power it expends each SScyber tick?
// 	var/loading_time = 5 // Number of SScyber ticks (1 second) required for this program to load after paying boot_cost
// 	// "boot_cost = idle_cost * loading_time" is baseline, but some programs might be cheaper or more expensive to keep idle 

// 	var/activation_trigger = HACK_TRIGGER_SELECTION // What makes this program to fire after loading?
// 	var/program_type = HACK_TYPE_UTILITY // Intended purpose of the program. HACK_TYPE_FOCUS comes with special behavior















/atom/movable/neohud
	name = ""
	icon = 'icons/cyberspace/HUD/default.dmi'
	icon_state = "empty"
	screen_loc = "-2,1"
	var/icon_states_max = 0

/atom/movable/neohud/cyberspace
	icon = 'icons/cyberspace/HUD/default.dmi'
	icon_state = "background"

/atom/movable/neohud/cyberspace/power
	icon_state = "power_0"
	icon_states_max = 18

/atom/movable/neohud/cyberspace/network
	icon_state = "network_0"
	icon_states_max = 34

/atom/movable/neohud/cyberspace/number
	icon = 'icons/cyberspace/HUD/default_font.dmi'
	icon_state = "0"

/atom/movable/neohud/cyberspace/thread_indicator
	icon = 'icons/cyberspace/HUD/default_thread_stat.dmi'
	icon_state = "right_error"
	icon_states_max = 10
	var/is_right_side = FALSE

/atom/movable/neohud/cyberspace/thread_indicator/New(loc, index)
	..()
	switch(index)
		if(1 to 8, 17, 18, 20)
			is_right_side = FALSE
		else
			is_right_side = TRUE
	

/atom/movable/neohud/cyberspace/thread_hack
	name = "thread"
	icon = 'icons/cyberspace/HUD/default_thread_program.dmi'
	icon_state = ""
	icon_states_max = 10
	var/payload // Index of related /datum/computer_file/cyber in 'hacks' list on /datum/heohud_holder/cyberspace
	var/payload_step_total
	var/payload_step_current
	var/payload_step_ratio // payload_step_total / 10
	var/payload_is_idling

/atom/movable/neohud/cyberspace/hack
	icon = 'icons/cyberspace/HUD/default_program.dmi'
	icon_state = ""
	var/datum/heohud_holder/cyberspace/holder


/atom/movable/neohud/cyberspace/hack/New(loc, ...)
	..()
	if(!loc)
		CRASH("New() is called by [usr] on /atom/movable/neohud/cyberspace/hack without arguments, which are required.")
	if(!istype(loc, /datum/heohud_holder/cyberspace))
		CRASH("New() is called by [usr] on /atom/movable/neohud/cyberspace/hack with improper arguments, passed instance of [loc] instead of /datum/heohud_holder/cyberspace.")
	holder = loc


/atom/movable/neohud/cyberspace/hack/Destroy()
	..()
	if(!QDELETED(holder))
		holder.hacks_roster -= src
		holder.elements -= src
		holder = null

/atom/movable/neohud/cyberspace/hack/Click(location, control, params)
	holder.run_program(src)
















