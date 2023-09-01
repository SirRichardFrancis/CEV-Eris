//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.

GLOBAL_DATUM_INIT(destroyed_event, /decl/observ/destroyed, new)

/decl/observ/destroyed
	name = "Destroyed"

GLOBAL_LIST_EMPTY(global_listen_count)
GLOBAL_LIST_EMPTY(event_sources_count)
GLOBAL_LIST_EMPTY(event_listen_count)

/datum/Destroy()
	GLOB.destroyed_event && GLOB.destroyed_event.raise_event(src)

	if(GLOB.global_listen_count && GLOB.global_listen_count[src])
		cleanup_global_listener(src, GLOB.global_listen_count[src])
	if(GLOB.event_sources_count && GLOB.event_sources_count[src])
		cleanup_source_listeners(src, GLOB.event_sources_count[src])
	if(GLOB.event_listen_count && GLOB.event_listen_count[src])
		cleanup_event_listener(src, GLOB.event_listen_count[src])

/proc/cleanup_global_listener(listener, listen_count)
	GLOB.global_listen_count -= listener
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		if(event.unregister_global(listener))
			log_debug("[event] - [listener] was deleted while still registered to global events.")
			if(!(--listen_count))
				return

/proc/cleanup_source_listeners(event_source, source_listener_count)
	GLOB.event_sources_count -= event_source
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		var/proc_owners = event.event_sources[event_source]
		if(proc_owners)
			for(var/proc_owner in proc_owners)
				if(event.unregister(event_source, proc_owner))
					log_debug("[event] - [event_source] was deleted while still being listened to by [proc_owner].")
					if(!(--source_listener_count))
						return

/proc/cleanup_event_listener(listener, listener_count)
	GLOB.event_listen_count -= listener
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		for(var/event_source in event.event_sources)
			if(event.unregister(event_source, listener))
				log_debug("[event] - [listener] was deleted while still listening to [event_source].")
				if(!(--listener_count))
					return
