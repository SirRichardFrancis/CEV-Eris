/mob
	density = TRUE
	layer = MOB_LAYER
	animate_movement = SLIDE_STEPS
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	flags = PROXMOVE
	datum_flags = DF_USE_TAG
	movement_handlers = list(
	/datum/movement_handler/mob/relayed_movement,
	/datum/movement_handler/mob/death,
	/datum/movement_handler/mob/conscious,
	/datum/movement_handler/mob/eye,
	/datum/movement_handler/mob/delay,
	/datum/movement_handler/move_relay,
	/datum/movement_handler/mob/buckle_relay,
	/datum/movement_handler/mob/stop_effect,
	/datum/movement_handler/mob/physically_capable,
	/datum/movement_handler/mob/physically_restrained,
	/datum/movement_handler/mob/space,
	/datum/movement_handler/mob/movement
	)
	bad_type = /mob

	var/stat = CONSCIOUS //Whether a mob is alive or dead. TODO: Move this to living - Nodrak
	var/targeted_organ = BP_CHEST
	var/a_intent = I_HELP//Living
	var/can_pull_size = ITEM_SIZE_TITANIC // Maximum w_class the mob can pull.
	var/can_pull_mobs = MOB_PULL_LARGER       // Whether or not the mob can pull other mobs.
	var/mob_size = MOB_MEDIUM
	var/mob_classification = CLASSIFICATION_ORGANIC //Bitfield. Uses TYPE_XXXX defines in defines/mobs.dm.
	var/hand // A define number, either 4 (slot_l_hand) or 5 (slot_r_hand)
	var/facing_dir // Used for the ancient art of moonwalking.

	var/static/next_mob_id = 0
	var/lastKnownIP
	var/computer_id
	var/dna_trace // sha1(real_name)
	var/fingers_trace // md5(real_name)

	var/use_me = TRUE //Allows all mobs to use the me verb by default, will have to manually specify they cannot
	var/blinded = FALSE
	var/shakecamera = FALSE
	var/in_throw_mode = FALSE
	var/update_icon = TRUE //Set to TRUE to trigger update_icons() at the next life() call
	var/universal_speak = FALSE // Set to TRUE to enable the mob to speak to everyone -- TLE
	var/universal_understand = FALSE // Whether or not mobs can understand other mobtypes. These stay in /mob so that ghosts can hear everything.
	var/hud_override = FALSE //Override so a mob no longer calls their own HUD
	var/can_be_fed = TRUE //Can be feeded by reagent_container or other things
	var/moving = FALSE
	var/hud_typing = FALSE //set when typing in an input window instead of chatline
	var/typing = FALSE
	var/get_rig_stats = FALSE
	var/transforming = FALSE //Carbon
	var/unacidable = FALSE
	var/canmove = TRUE

	var/status_flags = CANSTUN|CANWEAKEN|CANPARALYSE|CANPUSH	//bitflags defining which status effects can be inflicted (replaces canweaken, canstun, etc)
	var/sdisabilities = 0	//Carbon
	var/disabilities = 0	//Carbon

	var/last_move_attempt = 0 //Last time the mob attempted to move, successful or not
	var/last_typed_time // A timestamp
	var/next_move // A timestamp
	var/timeofdeath = 0 // A timestamp

	var/damageoverlaytemp = 0
	var/bloody_hands = 0
	var/bhunger = 0			//Carbon
	var/ajourn = 0
	var/seer = 0 //for cult//Carbon, probably Human
	var/druggy = 0			//Carbon
	var/confused = 0		//Carbon
	var/sleeping = 0		//Carbon
	var/resting = 0			//Carbon
	var/lying = 0
	var/lying_prev = 0
	var/track_blood = 0
	var/mutation_index = 0 // A number; sum of active mutation tiers, approximation of how much of a mutant this mob are
	var/radiation = 0//Carbon
	var/ear_deaf = 0
	var/digitalcamo = 0 // A number, prevents tracking by AI if > 0
	var/paralysis = 0
	var/stunned = 0
	var/weakened = 0
	var/drowsyness = 0//Carbon
	var/speed_factor = 1
	var/registered_z // The z level this mob is currently registered in
	var/default_pixel_x = 0
	var/default_pixel_y = 0
	var/old_x = 0
	var/old_y = 0
	var/nutrition = 400  //carbon
	var/max_nutrition = 400
	var/bodytemperature = 310.055	//98.7 F
	var/emote_type = 1		// Define emote default type, 1 for seen emotes, 2 for heard emotes

	var/last_typed = ""
	var/real_name
	var/name_archive //For admin things like possession
	var/memory = ""
	var/flavor_text = ""
	var/defaultHUD = "" //Default mob hud
	var/faction = "neutral" //Used for checking whether hostile simple animals will attack you, possibly more stuff later
	var/voice_name = "unidentifiable voice"
	var/tts_seed
	var/b_type // GLOB.blood_types // list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+")
	var/feet_blood_color // RGB string, e.g. "#FF0718"

	var/atom/movable/pulling
	var/area/lastarea
	var/turf/listed_turf  	//the current turf being examined in the stat panel
	var/obj/machinery/machine
	var/obj/effect/decal/typing_indicator
	var/obj/parallax/parallax
	var/obj/buckled //Living
	var/obj/item/l_hand //Living
	var/obj/item/r_hand //Living
	var/obj/item/back //Human/Monkey
	var/obj/item/storage/s_active //Carbon
	var/obj/item/clothing/mask/wear_mask //Carbon
	var/obj/control_object //Used by admins to possess objects. All mobs should have this var
	var/mob/living/carbon/LAssailant // The last mob/living/carbon to push/drag/grab this mob (mostly used by slimes friend recognition)
	var/mob/observer/eye/eyeobj
	var/mob/living/carbon/human/bloody_hands_mob
	var/mob/teleop // Indicates client "belonging" to this (clientless) mob is currently controlling some other mob, so don't treat them as being SSD

	var/datum/vertical_travel_method/current_vertical_travel_method // Link currently used VTM if we moving between Z-levels
	var/datum/mind/mind
	var/datum/tgui/hud/left_panel
	var/datum/stat_holder/stats
	var/datum/hud/hud_used

	var/list/HUDneed = list() // What HUD object need see
	var/list/HUDinventory = list()
	var/list/HUDfrippery = list()//flavor
	var/list/HUDprocess = list() //What HUD object need process
	var/list/HUDtech = list()
	var/list/feet_blood_DNA
	var/list/pinned = list()            // List of things pinning this creature to walls (see living_defense.dm)
	var/list/embedded = list()          // Embedded items, since simple mobs don't have organs.
	var/list/languages = list()         // For speaking/listening.
	var/list/speak_emote = list("says") // Verbs used when speaking. Defaults to 'say' if speak_emote is null.
	var/list/eat_sounds = list('sound/items/eatfood.ogg')
	var/list/grabbed_by = list()
	var/list/requests = list()
	var/list/progressbars
	var/list/shouldnt_see = list()	//list of objects that this mob shouldn't see in the stat panel. this silliness is needed because of AI alt+click and cult blood runes
	var/list/update_on_move = list() // Call entered_with_container() on atoms inside when the mob moves
	var/list/move_intents = list(/decl/move_intent/run, /decl/move_intent/walk)
	var/list/dormant_mutations = list()
	var/list/active_mutations = list()
	var/list/mutation_count_by_tier = list(
		"0" = 0, // Nero
		"1" = 0, // Vespasian
		"2" = 0, // Tacitus
		"3" = 0, // Hadrian
		"4" = 0) // Aurelien

	var/decl/move_intent/move_intent = /decl/move_intent/run

/*
Allows mobs to move through dense areas without restriction. For instance, in space or out of holder objects.
This var is no longer actually used for incorporeal moving, this is handled by /datum/movement_handler/mob/incorporeal
However this var is still kept as a quick way to check if the mob is incorporeal. This is used in several performance intensive applications
While it would be entirely possible to check the mob's move handlers list for the existence of the incorp handler, that is less optimal for intensive use
*/
	var/incorporeal_move = 0 //0 is off, 1 is normal, 2 is for ninjas.
