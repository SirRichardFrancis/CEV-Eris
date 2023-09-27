/datum/heohud_holder
	var/mob/owner
	var/list/elements
	var/is_mirrored // Is on the right side of the screen?
	var/atom/movable/neohud_element/background

	// screen_loc for background and other elements with same sprite dimensions
	var/main_screen_loc_left = "-2,1"
	var/main_screen_loc_right = "18:-64,1"


/datum/heohud_holder/New(mob/master)
	owner = master
	background = new
	elements = list(background)


/proc/num2iconstate(input, desired_length = 3)
	. = list()

	ASSERT(input)

	if(isnum(input))
		input = num2text(input)
	
	ASSERT(istext(input))

	if(LAZYLEN(input) > desired_length)
		input = copytext(input, LAZYLEN(input) - desired_length, LAZYLEN(input)) // Trim left part of the string if it's too long

	for(var/i in 1 to desired_length) // Add zeroes to return list if string is too short
		if(LAZYLEN(input) < desired_length)
			desired_length--
			. += "0"
			continue
		break

	for(var/i in 1 to LAZYLEN(input)) // Actually read numbers from the input
		. += copytext(input, i, i + 1)



