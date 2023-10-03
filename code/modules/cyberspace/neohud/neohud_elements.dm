/atom/movable/neohud_element
	name = ""
	icon = 'icons/cyberspace/HUD/default.dmi'
	icon_state = "empty"
	screen_loc = "-2,1"
	var/icon_states_max = 0

/atom/movable/neohud_element/cyberspace
	icon = 'icons/cyberspace/HUD/default.dmi'
	icon_state = "background"

/atom/movable/neohud_element/cyberspace/power
	icon_state = "power_0"
	icon_states_max = 18

/atom/movable/neohud_element/cyberspace/network
	icon_state = "network_0"
	icon_states_max = 34

/atom/movable/neohud_element/cyberspace/number
	icon = 'icons/cyberspace/HUD/default_font.dmi'
	icon_state = "0"

/atom/movable/neohud_element/cyberspace/thread_indicator
	icon = 'icons/cyberspace/HUD/default_thread_stat.dmi'
	icon_state = "right_error"
	icon_states_max = 10
	var/is_right_side = FALSE

/atom/movable/neohud_element/cyberspace/thread_indicator/New(loc, index)
	..()
	switch(index)
		if(1 to 8)
			is_right_side = FALSE
		if(17, 18, 20)
			is_right_side = FALSE
		else
			is_right_side = TRUE
	

/atom/movable/neohud_element/cyberspace/thread_hack
	name = "thread"
	icon = 'icons/cyberspace/HUD/default_thread_program.dmi'
	icon_state = ""
	icon_states_max = 10
	var/payload // Index of related /datum/computer_file/cyber in 'hacks' list on /datum/heohud_holder/cyberspace
	var/payload_step_total
	var/payload_step_current
	var/payload_step_ratio // payload_step_total / 10
	var/payload_is_idling


/atom/movable/neohud_element/cyberspace/hack
	icon = 'icons/cyberspace/HUD/default_program.dmi'
	icon_state = ""
	var/datum/heohud_holder/cyberspace_primary/holder

/atom/movable/neohud_element/cyberspace/hack/New(loc, ...)
	..()
	if(!loc)
		CRASH("New() is called by [usr] on /atom/movable/neohud_element/cyberspace/hack without arguments, which are required.")
	if(!istype(loc, /datum/heohud_holder/cyberspace_primary))
		CRASH("New() is called by [usr] on /atom/movable/neohud_element/cyberspace/hack with improper arguments, passed instance of [loc] instead of /datum/heohud_holder/cyberspace_primary.")
	holder = loc

/atom/movable/neohud_element/cyberspace/hack/Destroy()
	..()
	if(!QDELETED(holder))
		holder.hacks_roster -= src
		holder.elements -= src
		holder = null

/atom/movable/neohud_element/cyberspace/hack/Click(location, control, params)
	holder.run_program(src)























