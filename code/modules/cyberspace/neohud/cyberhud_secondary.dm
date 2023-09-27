/atom/movable/neohud_element/cyberspace/PLACEHOLDER

/datum/heohud_holder/cyberspace_secondary
	var/mob/cyber_avatar/cyber_owner

	var/atom/movable/neohud_element/cyberspace/PLACEHOLDER/target_type // E.g. Area, if nothing is selected
	var/atom/movable/neohud_element/cyberspace/PLACEHOLDER/target_stat // E.g. Is area on high alert or some such
	var/atom/movable/neohud_element/cyberspace/PLACEHOLDER/target_relation // E.g Is APC controlled by player

/datum/heohud_holder/cyberspace_secondary/New(mob/master)
	cyber_owner = master
	owner = cyber_owner.original_mob // TODO: Account for a case when there is no original_mob

	background = new /atom/movable/neohud_element
	background.screen_loc = main_screen_loc_left
	elements = list(background)


/datum/heohud_holder/cyberspace_secondary/mirror()


/datum/heohud_holder/cyberspace_secondary/proc/on_area_change(area/new_area)
	if(cyber_owner.selected_entity)
		return

	if(target_type)
		target_type.icon_state = "type_area"
		target_stat.icon_state = "stat_neutral"
		target_relation.icon_state = "relation_area_wild"













