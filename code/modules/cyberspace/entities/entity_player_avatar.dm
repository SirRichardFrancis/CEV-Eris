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
	var/atom/movable/neohud/left_twix_stick
	var/atom/movable/neohud/right_twix_stick


/mob/cyber_avatar/proc/assume_direct_control(mob/user)
	if(!user.client)
		return

	SScyber.runners.Add(src) 

	user.client.create_UI(type)
	user.teleop = src // Don't mark realspace body as SSD
	original_mob = user // Note to what mob we should return the player
	ckey = user.ckey // Transfer player control to this mob
	client.eye = src
	client.fit_viewport()

//	original_mob_parallax = user.parallax.icon_state

	if(!parallax)
		parallax = new /obj/parallax(src)
	
	SSevent.all_parallaxes -= parallax // We don't need icon to be changed by events
	parallax.icon_state = "cyber"
	parallax.plane = CYBERSPACE_PLANE
	parallax.layer = CYBERSPACE_BACKGROUND_LAYER
	parallax.blend_mode = BLEND_DEFAULT

	parallax.maptext_width = 500
	parallax.maptext_height = 600
	parallax.maptext_x = 140
	parallax.maptext_y = 75

	var/static/icon/cursor
	if(!cursor)
		cursor = icon('icons/cyberspace/cursors/windows_95_middle_finger.dmi')

	client.mouse_pointer_icon = cursor

	if(!left_twix_stick)
		left_twix_stick = new
		right_twix_stick = new
		right_twix_stick.screen_loc = "18:-64,1"
		// For whatever reason, atom peaking off the right side of the view range will get cut off past 32 pixels
		// Left side experiences nothing like that. But if cut-off part moved further and then pixel-shifted back (-64 after the :), it would be rendered correctly
		// Edits of skin.dmf have not impacted this in any way. Appears to be a quirk of the renderer

	client.screen.Add(left_twix_stick)
	client.screen.Add(right_twix_stick)
	client.screen.Add(parallax)
	client.screen.Add(new /obj/cyber_plane_master)

	winset(client, null, "mapwindow.map.right-click=true") // Disable popup menu on right click
	// TODO: Account for admins having to do admin stuff, such as accessing variable edit and deleting


/mob/cyber_avatar/verb/update_text()
	set name = "Update text"
	SScyber.update_parallax_maptext()


/mob/cyber_avatar/verb/add_filter()
	set name = "Add filter"

	var/filter_type = input(usr, "Choose filter type", "") as null|anything in list(
		"alpha",
		"angular_blur",
		"bloom",
		"displace",
		"drop_shadow",
		"blur",
		"motion_blur",
		"outline",
		"radial_blur",
		"rays",
		"ripple",
		"wave")


	switch(filter_type)
		if("alpha")
			var/x = input(usr, "Horizontal offset of mask", "") as num
			var/y = input(usr, "Vertical offset of mask", "") as num
			var/i = input(usr, "Icon to use as mask", "") as icon
			var/r = input(usr, "Render_target to use as a mask", "") as text
			filters = filter(type = "alpha", x = x, y = y, icon = i, render_source = r)

		if("angular_blur")
			var/x = input(usr, "Horizontal center of effect, in pixels, relative to image center", "") as num
			var/y = input(usr, "Vertical center of effect, in pixels, relative to image center", "") as num
			var/s = input(usr, "Amount of blur", "") as num
			filters = filter(type = "angular_blur", x = x, y = y, size = s)

		if("bloom")
			var/t = input(usr, "Color threshold for bloom", "") as num
			var/s = input(usr, "Blur radius of bloom effect", "") as num
			var/o = input(usr, "Growth/outline radius of bloom effect before blur", "") as num
			var/a = input(usr, "Opacity of effect", "") as num
			filters = filter(type = "bloom", threshold = t, size = s, offset = o, alpha = a)

		// if("displace")
		// 	filters = filter(type = "displace", )

		// if("drop_shadow")
		// 	filters = filter(type = "drop_shadow", )

		// if("blur")
		// 	filters = filter(type = "blur", )

		// if("motion_blur")
		// 	filters = filter(type = "motion_blur", )

		// if("outline")
		// 	filters = filter(type = "outline", )

		// if("radial_blur")
		// 	filters = filter(type = "radial_blur", )

		// if("rays")
		// 	filters = filter(type = "rays", )

		// if("ripple")
		// 	filters = filter(type = "ripple", )

		// if("wave")
		// 	filters = filter(type = "wave", )
		else
			filters = null





/mob/cyber_avatar/verb/jack_out()
	set name = "Jack out"
	disconnect()


/mob/cyber_avatar/proc/disconnect()
	winset(client, null, "mapwindow.map.right-click=false")

	client.mouse_pointer_icon = initial(client.mouse_pointer_icon)
	client.screen.Remove(parallax)
	client.eye = original_mob

	original_mob.ckey = ckey // Implicitly moves 'client' from src to original_mob
	original_mob.client.create_UI()
	original_mob.client.fit_viewport()
	original_mob.teleop = null
	original_mob = null

	SScyber.runners.Remove(src)
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




