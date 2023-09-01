
/obj/item/cyberdeck
	name = "cyberdeck"
	desc = "Your average consumer-grade deck."
	icon = 'icons/cyberspace/deck.dmi'
	icon_state = "common"
	var/layout = DECK_LAYOUT_REGULAR // Different layouts offer different amount of slots for chips and uprades

	var/list/encryption_keys
	var/list/preinstalled_software
	var/list/preinstalled_hardware

	var/processing_power_offset = 0
	var/power_regeneration_offset = 0
	var/thread_limit = 8


/obj/item/cyberdeck/cheap
	name = "cheap cyberdeck"
	desc = "For runners on the budget."
	icon_state = "cheap"

/obj/item/cyberdeck/cheaper
	name = "restored cheap cyberdeck"
	desc = "Blue duct tape always does the trick. Almost as bad as a new one."
	icon_state = "cheaper"

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


/obj/item/cyberdeck/proc/dive(mob/user)
	return

/obj/item/cyberdeck/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("Connecting to [station_name] intranet..."))
	var/mob/cyber_avatar/avatar = new(isturf(loc) ? loc : get_turf(loc))
	avatar.assume_direct_control(user)






