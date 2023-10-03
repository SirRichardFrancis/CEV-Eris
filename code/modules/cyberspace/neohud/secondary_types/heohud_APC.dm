/datum/heohud_holder/cyberspace_secondary/apc
	icon = 'icons/cyberspace/HUD/secondary/APC.dmi'

	var/obj/machinery/power/apc/apc

	var/atom/movable/neohud_element/cyberspace/apc/status
	var/atom/movable/neohud_element/cyberspace/apc/control/control
	var/atom/movable/neohud_element/cyberspace/apc/defences/defences
	var/atom/movable/neohud_element/cyberspace/apc/sentries/sentries

	var/atom/movable/neohud_element/cyberspace/apc/power/power
	var/atom/movable/neohud_element/cyberspace/apc/charge/charge
	var/atom/movable/neohud_element/cyberspace/apc/equipement/equipement
	var/atom/movable/neohud_element/cyberspace/apc/light/light
	var/atom/movable/neohud_element/cyberspace/apc/environment/environment
	var/atom/movable/neohud_element/cyberspace/apc/lock/panel_lock

	// TODO: 3 cell charge elements

	// TODO: 5 power load elements




/datum/heohud_holder/cyberspace_secondary/apc/New(mob/master)
	cyber_owner = master
	owner = cyber_owner.original_mob // TODO: Account for a case when there is no original_mob

	background.screen_loc = main_screen_loc_left
	elements = list(
		background,
		status,
		control,
		defences,
		sentries,
		power,
		charge,
		equipement,
		light,
		environment,
		panel_lock)

	for(var/i in elements)
		i = new

	var/area/area = get_area(cyber_owner)
	apc = area.apc



/datum/heohud_holder/cyberspace_secondary/apc/on_area_change(area/new_area)
	if(cyber_owner.selected_entity)
		return



























