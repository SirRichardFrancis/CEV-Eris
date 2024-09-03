
// /mob/ui_static_data(mob/user)
// /mob/update_static_data(mob/user, datum/tgui/ui)
// /mob/ui_assets(mob/user)

/mob/new_player/ui_data(mob/user)
	var/is_round_started = (SSticker.current_state > GAME_STATE_SETTING_UP)
	var/list/crew_manifest = SSjob.get_manifest(is_exhaustive_required = is_round_started)
	var/list/data = list(
		"mob_type" = "new_player",
		"is_player_ready" = ready,
		"is_round_started" = is_round_started,
		"roundstart_timer" = "[SSticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]",
		"crew_manifest" = crew_manifest,
		"ready_player_count" = SSjob.ready_player_count,
		"total_player_count" = SSjob.total_player_count,
	)
	return data

/mob/new_player/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	SHOULD_CALL_PARENT(FALSE)
	if(ui_act_parent_call_surrogate(action, ui))
		return TRUE

	switch(action)
		if("Observe")
		// Shameless copypasta
			if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able join the crew! But you can play as a mouse or drone immediately.","Player Setup","Yes","No") == "Yes")
				var/mob/observer/ghost/observer = new()
				sound_to(src, sound(null, repeat = FALSE, wait = FALSE, volume = 85, channel = GLOB.lobby_sound_channel))

				observer.started_as_observer = TRUE
				var/turf/T = pick_spawn_location("Observer")
				if(istype(T))
					to_chat(src, SPAN_NOTICE("You are now observing."))
					observer.forceMove(T)
				else
					to_chat(src, "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>")
				observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

				announce_ghost_joinleave(src)
				observer.icon = client.prefs.update_preview_icon()
				observer.alpha = 127

				if(client.prefs.be_random_name)
					client.prefs.real_name = random_name(client.prefs.gender)
				observer.real_name = client.prefs.real_name
				observer.name = observer.real_name
				if(!client.holder && !config.antag_hud_allowed) // For new ghosts we remove the verb from even showing up if it's not allowed.
					remove_verb(observer, /mob/observer/ghost/verb/toggle_antagHUD)
				observer.ckey = ckey
				observer.client.init_verbs()
				observer.initialise_postkey()
				observer.client.create_UI(observer.type)
			return TRUE

		if("Setup")
			client.prefs.ShowChoices(src)
			return TRUE

		if("Ready")
			if(SSticker.current_state > GAME_STATE_PREGAME)
				CRASH("Player [ckey] managed to set \"Ready\" status after the game started.")

			ready = !ready
			if(ready)
				// Warn the player if they are trying to spawn without a brain
				var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src, "Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
								If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
								"Player Setup", "Yes", "No") == "No")
						ready = FALSE
						return TRUE

				// Warn the player if they are trying to spawn without eyes
				mod = client.prefs.get_modification(BP_EYES)
				if(istype(mod, /datum/body_modification/limb/amputation))
					if(alert(src, "Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
								If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
								"Player Setup", "Yes", "No") == "No")
						ready = FALSE
						return TRUE
			return TRUE
		if("Join")
			// Warn the player if they are trying to spawn without a brain
			var/datum/body_modification/mod = client.prefs.get_modification(BP_BRAIN)
			if(istype(mod, /datum/body_modification/limb/amputation))
				if(alert(src,"Are you sure you wish to spawn without a brain? This will likely cause you to do die immediately. \
							If not, go to the Augmentation section of Setup Character and change the \"brain\" slot from Removed to the desired kind of brain.", \
							"Player Setup", "Yes", "No") == "No")
					return TRUE

			// Warn the player if they are trying to spawn without eyes
			mod = client.prefs.get_modification(BP_EYES)
			if(istype(mod, /datum/body_modification/limb/amputation))
				if(alert(src,"Are you sure you wish to spawn without eyes? It will likely be difficult to see without them. \
							If not, go to the Augmentation section of Setup Character and change the \"eyes\" slot from Removed to the desired kind of eyes.", \
							"Player Setup", "Yes", "No") == "No")
					return TRUE

			if(!check_rights(R_ADMIN, 0))
				var/datum/species/S = all_species[client.prefs.species]
				if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
					src << alert("You are currently not whitelisted to play [client.prefs.species].")
					return TRUE

				if(!(S.spawn_flags & CAN_JOIN))
					src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
					return TRUE

			LateChoices()

		if("Join_as")
			SSjob.UpdatePlayableJobs(client.ckey)
			AttemptLateSpawn(params["player_rank"], client.prefs.spawnpoint)
			return TRUE
