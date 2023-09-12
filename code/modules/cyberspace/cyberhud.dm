
/datum/heohud_holder
	var/list/elements
	var/atom/movable/neohud/background

/datum/heohud_holder/cyberspace
	var/mob/cyber_avatar/owner
	var/atom/movable/neohud/cyberspace/power/power_indicator
	var/atom/movable/neohud/cyberspace/network/network_indicator

	// Holds related value's fullness(current_value/maximum_value) percentage increment after which indicator should take next icon_state
	// E.g. if indicator got 18 icon states, it will increment icon state's number for each 5.5% of related value's fullness percentage
	var/power_indicator_percent_step
	var/network_indicator_percent_step


/datum/heohud_holder/cyberspace/New(master, is_right_side)
	elements = list()
	owner = master

	background = new /atom/movable/neohud/cyberspace
	elements += background

	power_indicator = new
	power_indicator.icon_state = "power_[rand(0, power_indicator.icon_states_max)]"
	power_indicator_percent_step = round((100 / power_indicator.icon_states_max), 0.1)
	elements += power_indicator

	network_indicator = new
	network_indicator.icon_state = "network_[rand(0, network_indicator.icon_states_max)]"
	network_indicator_percent_step = round((100 / network_indicator.icon_states_max), 0.1)
	elements += network_indicator

	if(is_right_side)
		for(var/atom/movable/i as anything in elements)
			// For whatever reason, atom peeking off the right side of the view range will not render past 32 pixels
			// Left side experiences nothing like that. But if cut-off part moved further and then pixel-shifted back (-64 after the :), it would be rendered just fine
			i.screen_loc = "18:-64,1"


/datum/heohud_holder/cyberspace/proc/startup_flick()
	flick("power_animation", power_indicator)
	flick("network_animation", network_indicator)


/datum/heohud_holder/cyberspace/proc/update_power()
	var/power_fullness_percent = (owner.processing_power_count / owner.processing_power_limit) * 100
	if(power_fullness_percent > 95)
		power_indicator.icon_state = "power_[power_indicator.icon_states_max]"
		return
	if(power_fullness_percent < 5)
		power_indicator.icon_state = "power_0"
		return

	power_indicator.icon_state = "power_[round(power_fullness_percent / power_indicator_percent_step)]"


/atom/movable/neohud
	name = ""
	icon = 'icons/cyberspace/HUD/default.dmi'
	icon_state = "background"
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
























