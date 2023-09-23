/obj/item/cyberdeck
	name = "cyberdeck"
	desc = "Your average consumer-grade deck."
	icon = 'icons/cyberspace/deck.dmi'
	icon_state = "common"
	var/layout = DECK_LAYOUT_REGULAR // Different layouts offer different amount of slots for chips and uprades

	var/list/encryption_keys
	var/list/preinstalled_software
	var/list/preinstalled_hardware

	var/thread_limit = 8
	var/processing_power_offset = 0
	var/power_regeneration_offset = 0

	var/hack_damage_dealt_offset = 0
	var/hack_damage_taken_offset = 0

	var/is_broken = FALSE

	var/obj/item/computer_hardware/hard_drive/cyberdeck/drive
	var/drive_capacity = 128


/obj/item/cyberdeck/Initialize()
	ATOM_INIT_ALL
	drive = new(src)
	drive.max_capacity = drive_capacity
	return INITIALIZE_HINT_NORMAL


/obj/item/computer_hardware/hard_drive/cyberdeck
	name = "cyberdeck data storage"
	desc = "You shouldn't be seeing this. Tell an admin."
	icon_state = "hdd_normal"
	max_capacity = 128
	spawn_blacklisted = TRUE
	var/obj/item/cyberdeck/cyberdeck


/obj/item/computer_hardware/hard_drive/cyberdeck/New(loc, ...)
	..()
	cyberdeck = loc
	if(cyberdeck)
		if(istype(cyberdeck))
			for(var/i in cyberdeck.preinstalled_software)
				store_file(new i)


/obj/item/computer_hardware/hard_drive/cyberdeck/Initialize()
	ATOM_INIT_CHECK
	return INITIALIZE_HINT_NORMAL

/obj/item/cyberdeck/cheap
	name = "cheap cyberdeck"
	desc = "For runners on the budget."
	icon_state = "cheap"

/obj/item/cyberdeck/cheaper
	name = "restored cheap cyberdeck"
	desc = "Blue duct tape always does the trick. Almost as bad as a new one."
	icon_state = "cheaper"
	thread_limit = 20
	preinstalled_software = list(
		/datum/computer_file/cyber
	)

/obj/item/cyberdeck/router
	name = "upgraded cheap cyberdeck"
	desc = "Now with cool green lights! Be like a real hacker."
	icon_state = "router"

/obj/item/cyberdeck/excelsior
	name = "white Excelsior cyberdeck"
	desc = "Seize the means of hacking."
	icon_state = "excelsior"
	layout = DECK_LAYOUT_WIDE

/obj/item/cyberdeck/excelsior/haven
	name = "red Excelsior cyberdeck"
	desc = "For when shit gets real." // Placeholder
	icon_state = "haven"

/obj/item/cyberdeck/tall
	name = "extended cyberdeck"
	desc = "Direct upgrade of common consumer-grade models, featuring extra large chip slot."
	icon_state = "tall"
	layout = DECK_LAYOUT_TALL

/obj/item/cyberdeck/advanced
	name = "advanced cyberdeck"
	desc = "Deck model not commonly found on an open market; widely used by government agencies and large corporations across the world."
	icon_state = "advanced"

/obj/item/cyberdeck/moebius
	name = "Moebius cyberdeck"
	desc = "Moebius Laboratories attempt on making very robust, yet not prohibitively expensive cyberdeck for internal use. Arguably a successful one."
	icon_state = "moebius"
	layout = DECK_LAYOUT_WIDE

/obj/item/cyberdeck/legendary
	name = "Syndicate cyberdeck"
	desc = "Remnant of Corporate Wars, this cyberdeck model is so costly and hard to manufacture, that none were produced since NanoTrasen's fall."
	icon_state = "legendary"


/obj/item/cyberdeck/attack_self(mob/user)
	SScyber.chip_in(user, src)








