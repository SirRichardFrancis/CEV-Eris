/mob/new_player/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "KirovHud")
		ui.open()

// /mob/new_player/ui_data(mob/user)
// /mob/new_player/ui_static_data(mob/user)
// /mob/new_player/update_static_data(mob/user, datum/tgui/ui)
// /mob/new_player/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
// /mob/new_player/ui_assets(mob/user)

















