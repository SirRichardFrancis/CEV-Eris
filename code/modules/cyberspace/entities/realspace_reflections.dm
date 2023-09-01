// Projection of something that exists in realspace. Might be interactable

/obj/cyber_plane_master
	name = ""
	icon = 'icons/mob/screen1.dmi'
	screen_loc = "CENTER"
	icon_state = "blank"
//	layer = ABOVE_HUD_LAYER
	plane = CYBERSPACE_PLANE
	unacidable = TRUE
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
//	blend_mode = BLEND_OVERLAY


// A lot of things present in realspace also "cast a shadow" in cyberspace, thus being visible and potentially interactable with
// This type of atoms represents them
/atom/movable/cyber_shadow
	name = ""
	icon = 'icons/cyberspace/cyberspace.dmi'
	icon_state = ""
	spawn_blacklisted = TRUE
//	appearance_flags = RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|NO_CLIENT_COLOR|KEEP_APART
	density = FALSE
	invisibility = INVISIBILITY_LEVEL_ONE
	plane = CYBERSPACE_PLANE
	layer = TURF_LAYER
	simulated = FALSE

	var/atom/movable/origin // Whatever casted this shadow

/atom/movable/cyber_shadow/attack_hand(mob/user)
	origin.attack_ai(user)


/atom/movable/cyber_shadow/floor
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "floor"

/atom/movable/cyber_shadow/wall
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "wall"

/atom/movable/cyber_shadow/low_wall
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "low"
	layer = BELOW_OBJ_LAYER

/atom/movable/cyber_shadow/low_wall_window
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = ""
	layer = OBJ_LAYER

/atom/movable/cyber_shadow/machine
	name = "machine"
	icon_state = ""
	layer = ABOVE_OBJ_LAYER

/atom/movable/cyber_shadow/door
	name = "airlock"
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "door"
	layer = CLOSED_DOOR_LAYER

/atom/movable/cyber_shadow/door/double
	icon = 'icons/cyberspace/64x64.dmi'

/atom/movable/cyber_shadow/apc
	name = "area controller"
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "apc"
	layer = ABOVE_OBJ_LAYER

/atom/movable/cyber_shadow/fire_alarm
	name = "fire alarm"
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "fire_green"
	layer = ABOVE_OBJ_LAYER

/atom/movable/cyber_shadow/air_alarm
	name = "air alarm"
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "air_green"
	layer = ABOVE_OBJ_LAYER

/atom/movable/cyber_shadow/camera
	name = "camera"
	icon = 'icons/cyberspace/turf.dmi'
	icon_state = "camera"
	layer = ABOVE_OBJ_LAYER


// // For some reason BYOND will ignore the plane, unless it is set in the constructor
// /obj/cyber_shadow/New()
// 	plane = CYBERSPACE_PLANE
// 	layer = CYBERSPACE_PLANE








