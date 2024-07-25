/mob/proc/ui_act_parent_call_surrogate(action, datum/tgui/ui)
	SEND_SIGNAL(src, COMSIG_UI_ACT, usr, action)
	// If UI is not interactive or usr calling Topic is not the UI user, bail.
	if(!ui || ui.status != UI_INTERACTIVE)
		return TRUE

/mob/ui_status(mob/user)
	return UI_INTERACTIVE

/datum/tgui/hud


/datum/tgui/hud/Destroy()
	user.left_panel = null
	. = ..()


/datum/tgui/hud/open()
	if(!user.client)
		return FALSE
	if(window)
		return FALSE
	process_status()
	if(status < UI_UPDATE)
		return FALSE
	window = new(user.client, "hudwindow.hud")
	if(!window)
		return FALSE
	opened_at = world.time
	window.acquire_lock(src)
	if(!window.is_ready())
		window.initialize(
			strict_mode = TRUE,
			fancy = TRUE,
			assets = list(
				get_asset_datum(/datum/asset/simple/tgui),
			))
	else
		window.send_message("ping")

	var/flush_queue = window.send_asset(get_asset_datum(
		/datum/asset/simple/namespaced/fontawesome))
	flush_queue |= window.send_asset(get_asset_datum(
		/datum/asset/simple/namespaced/tgfont))
	for(var/datum/asset/asset in src_object.ui_assets(user))
		flush_queue |= window.send_asset(asset)
	if (flush_queue)
		user.client.browse_queue_flush()
	window.send_message("update", get_payload(
		with_data = TRUE,
		with_static_data = TRUE))
	if(mouse_hooked)
		window.set_mouse_macro()
	SStgui.on_open(src)

	return TRUE


/datum/tgui/hud/Process(delta_time, force = FALSE)
	if(closing)
		return
	var/datum/host = src_object.ui_host(user)
	// If the object or user died (or something else), abort.
	if(QDELETED(src_object) || QDELETED(host) || QDELETED(user) || QDELETED(window))
		close(can_be_suspended = FALSE)
		return
	// Validate ping
	if(!initialized && world.time - opened_at > TGUI_PING_TIMEOUT)
		log_tgui(user, "Error: Zombie window detected, closing.",
			window = window,
			src_object = src_object)
		close(can_be_suspended = FALSE)
		return
	// Update through a normal call to ui_interact
	if(status != UI_DISABLED && (autoupdate || force))
		src_object.ui_interact(src)
		return
	// Update status only
	var/needs_update = process_status()
	if(status <= UI_CLOSE)
		close()
		return
	if(needs_update)
		window.send_message("update", get_payload())
