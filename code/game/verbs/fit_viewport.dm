/client/verb/fit_viewport()
	set name = "Fit Viewport"
	set category = "OOC"
	set desc = "Fit the width of the map window to match the viewport"

	// Fetch aspect ratio
	var/view_size = getviewsize(view)
	var/aspect_ratio = view_size[1] / view_size[2]

	// Calculate desired pixel width using window size and aspect ratio
	var/sizes = params2list(winget(src, "mainwindow.split;mapwindow;gamewindow.game", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	// Initial width is for 15x15 tiles map, account for 3x15 tile HUD also
	var/hud_width = (desired_width / 15) * 3
	desired_width += hud_width

	if (text2num(map_size[1]) == desired_width)
		// Nothing to do
		return

	var/right_split_size = splittext(sizes["mainwindow.split.size"], "x")
	var/right_split_width = text2num(right_split_size[1])

	// Calculate and apply a best estimate
	// +4 pixels are for the width of the splitter's handle
	var/map_to_chat_ratio = 100 * (desired_width + 4) / right_split_width
	winset(src, "mainwindow.split", "splitter=[map_to_chat_ratio]")


	var/left_split_size = splittext(sizes["gamewindow.game.size"], "x")
	var/left_split_width = text2num(left_split_size[1])
	var/hud_to_map_ratio = 100 * (hud_width + 4) / left_split_width
	winset(src, "gamewindow.game", "splitter=[hud_to_map_ratio]")
//	if(mob.left_panel)
//		mob.left_panel.window_size = list(left_split_width, view_size[2])

	// Apply an ever-lowering offset until we finish or fail
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if (got_width == desired_width)
			// success
			return
		else if (isnull(delta))
			// calculate a probable delta value based on the difference
			delta = 100 * (desired_width - got_width) / right_split_width
		else if ((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// if we overshot, halve the delta and reverse direction
			delta = -delta/2

		map_to_chat_ratio += delta
		winset(src, "mainwindow.mainvsplit", "splitter=[map_to_chat_ratio]")
