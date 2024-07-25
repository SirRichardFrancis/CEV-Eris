/mob/ui_interact(datum/tgui/hud/ui)
	ui = SStgui.try_update_ui(src, src, ui)
	if(!ui)
		ui = new(src, src, "KirovHud")
		ui.open()
		left_panel = ui

/mob/ui_state(mob/user)
	return GLOB.always_state






