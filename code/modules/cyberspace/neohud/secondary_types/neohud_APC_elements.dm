/atom/movable/neohud_element/cyberspace/apc
	icon = 'icons/cyberspace/HUD/secondary/APC.dmi'
	name = "status of the APC"
	// TODO: Add a detailed description to all of these, also make them examine'able
	icon_state = "status_active"
	var/datum/heohud_holder/cyberspace_secondary/holder

/atom/movable/neohud_element/New(loc, ...)
	if(istype(loc, /datum/heohud_holder/cyberspace_secondary))
		holder = loc

/atom/movable/neohud_element/cyberspace/apc/control
	name = "your control over the area"
	icon_state = "control_none"

/atom/movable/neohud_element/cyberspace/apc/defences
	name = "strength of APC's own ICE"
	icon_state = "ice_lots"

/atom/movable/neohud_element/cyberspace/apc/sentries
	name = "quantity of prepared sentries"
	icon_state = "mobs_lots"



/atom/movable/neohud_element/cyberspace/apc/power
	name = "power switch"
	icon_state = "power_off"

/atom/movable/neohud_element/cyberspace/apc/charge
	name = "charge switch"
	icon_state = "charge_off"

/atom/movable/neohud_element/cyberspace/apc/equipement
	name = "power switch for equipement"
	icon_state = "equip"

/atom/movable/neohud_element/cyberspace/apc/light
	name = "power switch for lights"
	icon_state = "light"

/atom/movable/neohud_element/cyberspace/apc/environment
	name = "power switch for doors" // TODO: Check what this switch actually affects
	icon_state = "env"

/atom/movable/neohud_element/cyberspace/apc/lock
	name = "APC's physical panel lock"
	icon_state = "lock"

/atom/movable/neohud_element/cyberspace/apc/lock/Click(location, control, params)
	// TODO: Check for our control over the APC
	holder.apc.coverlocked = !holder.apc.coverlocked
	icon_state = holder.apc.coverlocked ? "lock_on" : "lock_off"



















