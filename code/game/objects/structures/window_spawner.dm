// Ported from Haine and WrongEnd with much gratitude!
/* ._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._. */
/*-=-=-=-=-=-=-=-=-=-=-=-=-=WHAT-EVER=-=-=-=-=-=-=-=-=-=-=-=-=-*/
/* '~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~'-._.-'~' */

/obj/effect/window_lwall_spawn
	name = "window spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "sp_full_window"
	density = TRUE
	anchored = TRUE
	var/win_path = /obj/structure/window/basic/full
	var/wall_path = /obj/structure/low_wall
	var/activated = FALSE


/obj/effect/window_lwall_spawn/smartspawn/onestar
	wall_path = /obj/structure/low_wall/onestar

// stops ZAS expanding zones past us, the windows will block the zone anyway
/obj/effect/window_lwall_spawn/CanPass()
	return FALSE

/obj/effect/window_lwall_spawn/attack_hand()
	return

/obj/effect/window_lwall_spawn/attack_ghost()
	return

/obj/effect/window_lwall_spawn/attack_generic()
	return

/obj/effect/window_lwall_spawn/Initialize()
	. = ..()
	if(!wall_path)
		CRASH("Warning: [src]([type]) at X:[x], Y:[y], Z:[z] does not have a wall path to spawn!")
	if(!win_path)
		CRASH("Warning: [src]([type]) at X:[x], Y:[y], Z:[z] does not have a window path to spawn!")
	if(activated)
		CRASH("Warning: [src]([type]) at X:[x], Y:[y], Z:[z] attempted to activate multiple times!")

	activated = TRUE
	new wall_path(loc)
	handle_window_spawn(src)

	if(SSticker.current_state < GAME_STATE_PLAYING)
		return INITIALIZE_HINT_QDEL
	else
		QDEL_IN(src, 10)


/obj/effect/window_lwall_spawn/proc/handle_window_spawn(var/obj/structure/window/W)
	new win_path(loc)


/obj/effect/window_lwall_spawn/reinforced
	name = "reinforced window low-wall spawner"
	icon_state = "sp_full_window_reinforced"
	win_path = /obj/structure/window/reinforced/full

/obj/effect/window_lwall_spawn/smartspawn
	name = "reinforced window low-wall smart spawner"
	icon_state = "sp_smart_full_window"

/obj/effect/window_lwall_spawn/smartspawn/handle_window_spawn(var/obj/structure/window/W)
	if (is_turf_near_space(loc))
		new /obj/structure/window/reinforced/full(loc)
	else
		for (var/a in cardinal_turfs(loc))
			var/turf/T = a
			if (is_turf_near_space(T))
				if ((locate(/obj/structure/window) in T) || (locate(/obj/effect/window_lwall_spawn) in T))
					new /obj/structure/window/reinforced/full(loc)
					return

		new /obj/structure/window/basic/full(loc)
		return

/obj/effect/window_lwall_spawn/plasma
	name = "plasma window low-wall spawner"
	icon_state = "sp_full_window_plasma"
	win_path = /obj/structure/window/plasmabasic/full

/obj/effect/window_lwall_spawn/plasma/reinforced
	name = "reinforced plasma window low-wall spawner"
	icon_state = "sp_full_window_plasma_reinforced"
	win_path = /obj/structure/window/reinforced/plasma/full

/obj/effect/window_lwall_spawn/smartspawnplasma
	name = "reinforced plasma window low-wall smart spawner"
	icon_state = "sp_smart_full_window_plasma"

/obj/effect/window_lwall_spawn/smartspawnplasma/handle_window_spawn(var/obj/structure/window/W)
	if (is_turf_near_space(loc))
		new /obj/structure/window/plasmabasic/full(loc)
	else
		for (var/a in cardinal_turfs(loc))
			var/turf/T = a
			if (is_turf_near_space(T))
				if ((locate(/obj/structure/window/reinforced/plasma/full) in T) || (locate(/obj/effect/window_lwall_spawn/plasma/reinforced) in T))
					new /obj/structure/window/plasmabasic/full(loc)
					return

		new /obj/structure/window/reinforced/plasma/full(loc)
		return

/obj/effect/window_lwall_spawn/reinforced/polarized
	name = "polarized window low-wall spawner"
	icon_state = "sp_full_window_tinted"
	win_path = /obj/structure/window/reinforced/polarized/full
	var/id

/obj/effect/window_lwall_spawn/reinforced/polarized/handle_window_spawn(var/obj/structure/window/reinforced/polarized/P)
	..()
	if(id)
		P.id = id
	return
