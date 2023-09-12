/mob/cyber_avatar
	name = "netrunner"
	desc = "Nothing here yet."
	icon = 'icons/cyberspace/cyberspace.dmi'
	icon_state = "le_frog"

	anchored = TRUE
	density = FALSE
	simulated = FALSE
	unacidable = TRUE
	stat = DEAD
	status_flags = GODMODE
	incorporeal_move = TRUE

	invisibility = INVISIBILITY_LEVEL_ONE
	see_invisible = SEE_INVISIBLE_LEVEL_ONE
	plane = CYBERSPACE_PLANE
	layer = MOB_LAYER
	sight = SEE_TURFS|SEE_MOBS|SEE_OBJS|SEE_SELF
	see_in_dark = 7

	movement_handlers = list(/datum/movement_handler/mob/incorporeal)
	// TODO: Create unique movement handler
	// TODO: Add visualnet here

	var/mob/original_mob
	var/datum/heohud_holder/cyberspace/HUD_left
	var/datum/heohud_holder/cyberspace/HUD_right

	var/thread_limit = 8
	var/processing_power_limit = 200
	var/processing_power_count = 0
	var/power_regeneration_speed = 10
	var/hack_damage_dealt_offset = 0
	var/hack_damage_taken_offset = 0

	var/list/active_threads
	var/list/available_programs

	var/last_update // Timestamp of last update_state() call


/mob/cyber_avatar/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)


/mob/cyber_avatar/proc/update_state(delta = 1)
	last_update = world.time
	if(processing_power_count < processing_power_limit)
		processing_power_count += power_regeneration_speed * delta
		processing_power_count = min(processing_power_count, processing_power_limit)
		HUD_right.update_power()


/mob/cyber_avatar/proc/reset_stats()
	thread_limit = initial(thread_limit)
	processing_power_limit = initial(processing_power_limit)
	power_regeneration_speed = initial(power_regeneration_speed)
	hack_damage_dealt_offset = initial(hack_damage_dealt_offset)
	hack_damage_taken_offset = initial(hack_damage_taken_offset)


/mob/cyber_avatar/proc/get_stats_from_cyberdeck(obj/item/cyberdeck/cyberdeck)
	processing_power_limit += cyberdeck.processing_power_offset
	power_regeneration_speed += cyberdeck.power_regeneration_offset
	hack_damage_dealt_offset += cyberdeck.hack_damage_dealt_offset
	hack_damage_taken_offset += cyberdeck.hack_damage_taken_offset

	thread_limit = cyberdeck.thread_limit


/mob/cyber_avatar/proc/get_stats_from_neuralink(obj/item/organ_module/neuralink/neuralink)
	processing_power_limit += neuralink.processing_power_offset
	power_regeneration_speed += neuralink.power_regeneration_offset
	hack_damage_dealt_offset += neuralink.hack_damage_dealt_offset
	hack_damage_taken_offset += neuralink.hack_damage_taken_offset


// TODO: Get stats from modular computer
// TODO: Get stats from runner chair/pod


/mob/cyber_avatar/proc/init_parallax()
	if(!parallax)
		parallax = new /obj/parallax(src)

	SSevent.all_parallaxes -= parallax // We don't need icon to be changed by events
	parallax.name = "cyberspace"
	parallax.icon_state = "cyber"
	parallax.plane = CYBERSPACE_PLANE
	parallax.layer = CYBERSPACE_BACKGROUND_LAYER
	parallax.blend_mode = BLEND_DEFAULT
	parallax.mouse_opacity = MOUSE_OPACITY_OPAQUE
	parallax.maptext_width = 500
	parallax.maptext_height = 600
	parallax.maptext_x = 140
	parallax.maptext_y = 75


/mob/cyber_avatar/proc/possess(mob/user)
	last_update = world.time
	START_PROCESSING(SScyber, src)

	user.client.destroy_UI()
	user.teleop = src // Don't mark realspace body as SSD

	original_mob = user // Note to what mob we should return the player
	ckey = user.ckey // Implicitly moves 'client' between mobs
	client.eye = src
	client.fit_viewport()

	var/static/icon/cursor
	if(!cursor)
		cursor = icon('icons/cyberspace/cursors/windows_95.dmi')
	client.mouse_pointer_icon = cursor

	if(!HUD_left)
		HUD_left = new(master = src, is_right_side = FALSE)

	if(!HUD_right)
		HUD_right = new(master = src, is_right_side = TRUE)

	HUD_right.startup_flick()

	client.screen.Add(HUD_left.elements)
	client.screen.Add(HUD_right.elements)
	client.screen.Add(parallax)
//	client.screen.Add(new /obj/cyber_plane_master)

	winset(client, null, "mapwindow.map.right-click=true") // Disable popup menu on right click
	// TODO: Account for admins having to do admin stuff, such as accessing variable edit and deleting


/mob/cyber_avatar/verb/jack_out()
	set name = "Jack out"
	set category = "IC"
	disconnect()


/mob/cyber_avatar/proc/disconnect()
	STOP_PROCESSING(SScyber, src)
	winset(client, null, "mapwindow.map.right-click=false")

	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	client.screen.Remove(parallax)
	client.screen.Remove(HUD_left.elements)
	client.screen.Remove(HUD_right.elements)
	client.eye = original_mob

	original_mob.ckey = ckey // Implicitly moves 'client' from src to original_mob
	original_mob.client.create_UI()
	original_mob.client.fit_viewport()
	original_mob.teleop = null
	original_mob = null

	qdel(src)


/mob/cyber_avatar/ClickOn(atom/A, params)
//	var/list/modifiers = params2list(params)
	// if(modifiers["shift"] && modifiers["ctrl"])
	// 	CtrlShiftClickOn(A)
	// 	return
	// if(modifiers["middle"])
	// 	MiddleClickOn(A)
	// 	return
	// if(modifiers["shift"])
	// 	ShiftClickOn(A)
	// 	return
	// if(modifiers["alt"]) // alt and alt-gr (rightalt)
	// 	AltClickOn(A)
	// 	return
	// if(modifiers["ctrl"])
	// 	CtrlClickOn(A)
	// 	return

	if(istype(A, /atom/movable/cyber_shadow))
		var/atom/movable/cyber_shadow/shadow = A
		if(!shadow.origin)
			CRASH("Warning: cyberspace reflection [shadow.type] at X:[shadow.x], Y:[shadow.y], Z:[shadow.z] is not linked to realspace turf or object!")
		shadow.origin.add_hiddenprint(src)
		shadow.origin.attack_ai(src)




