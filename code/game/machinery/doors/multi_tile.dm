//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	width = 2
	cyberspace_reflection_type = /atom/movable/cyber_shadow/door/double

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/update_icon()
	set_light(0)
	if(overlays.len)
		cut_overlays()
	if(underlays.len)
		underlays.Cut()
	if(density)
		if(locked && lights && arePowerSystemsOn())
			icon_state = "door_locked"
			set_light(1.5, 0.5, COLOR_RED_LIGHT)
		else
			icon_state = "door_closed"
		if(p_open || welded)
			overlays = list()
			if(p_open)
				overlays += image(icon, "panel_open")
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					overlays += image(icon, "sparks_broken")
				else if (health < maxHealth * 3/4)
					overlays += image(icon, "sparks_damaged")
			if(welded)
				overlays += image(icon, "welded")
		else if (health < maxHealth * 3/4 && !(stat & NOPOWER))
			overlays += image(icon, "sparks_damaged")
	else
		icon_state = "door_open"
		if((stat & BROKEN) && !(stat & NOPOWER))
			overlays += image(icon, "sparks_open")
	if(wedged_item)
		generate_wedge_overlay()

	if(shadow_on_cyberspace)
		var/static/overlay_bolt_up
		var/static/overlay_bolt_up_open
		var/static/overlay_bolt_down
		var/static/overlay_bolt_down_open
		var/static/overlay_shock
		var/static/overlay_shock_open
		var/static/overlay_id
		var/static/overlay_id_open
		var/static/overlay_no_id
		var/static/overlay_no_id_open
		if(isnull(overlay_bolt_up))
			overlay_bolt_up = iconstate2appearance('icons/cyberspace/64x64.dmi', "bolt_up")
			overlay_bolt_up_open = iconstate2appearance('icons/cyberspace/64x64.dmi', "bolt_up_open")
			overlay_bolt_down = iconstate2appearance('icons/cyberspace/64x64.dmi', "bolt_down")
			overlay_bolt_down_open = iconstate2appearance('icons/cyberspace/64x64.dmi', "bolt_down_open")
			overlay_shock = iconstate2appearance('icons/cyberspace/64x64.dmi', "shock")
			overlay_shock_open = iconstate2appearance('icons/cyberspace/64x64.dmi', "shock_open")
			overlay_id = iconstate2appearance('icons/cyberspace/64x64.dmi', "id")
			overlay_id_open = iconstate2appearance('icons/cyberspace/64x64.dmi', "id_open")
			overlay_no_id = iconstate2appearance('icons/cyberspace/64x64.dmi', "no_id ")
			overlay_no_id_open = iconstate2appearance('icons/cyberspace/64x64.dmi', "no_id_open")

		shadow_on_cyberspace.icon_state = density ? "door" : "door_open"
		shadow_on_cyberspace.overlays.Cut()

		if(aiControlDisabled) // Can't get information about door settings from cyberspace
			return

		if(density)
			shadow_on_cyberspace.overlays.Add(locked ? overlay_bolt_down : overlay_bolt_up)
			shadow_on_cyberspace.overlays.Add(aiDisabledIdScanner ? overlay_no_id : overlay_id)
			if(electrified_until != 0)
				shadow_on_cyberspace.overlays.Add(overlay_shock)
		else
			shadow_on_cyberspace.overlays.Add(locked ? overlay_bolt_down_open : overlay_bolt_up_open)
			shadow_on_cyberspace.overlays.Add(aiDisabledIdScanner ? overlay_no_id_open : overlay_id_open)
			if(electrified_until != 0)
				shadow_on_cyberspace.overlays.Add(overlay_shock_open)



/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/Door2x1glass.dmi'
	opacity = FALSE
	glass = TRUE
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/metal
	name = "Airlock"
	icon = 'icons/obj/doors/Door2x1metal.dmi'
	assembly_type = /obj/structure/door_assembly/multi_tile

/obj/machinery/door/airlock/multi_tile/New()
	..()
	if(src.dir > 3)
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,EAST))
	else
		f5 = new/obj/machinery/filler_object(src.loc)
		f6 = new/obj/machinery/filler_object(get_step(src,NORTH))
	f5.density = FALSE
	f6.density = FALSE
	f5.set_opacity(opacity)
	f6.set_opacity(opacity)

/obj/machinery/door/airlock/multi_tile/metal/Destroy()
	qdel(f5)
	qdel(f6)
	. = ..()

/obj/machinery/filler_object
	name = ""
	icon = 'icons/obj/doors/rapid_pdoor.dmi'
	icon_state = ""
	density = FALSE
	anchored = TRUE
	cyberspace_reflection_type = null

/obj/machinery/door/airlock/multi_tile/metal/mait
	icon = 'icons/obj/doors/Door2x1_Maint.dmi'
