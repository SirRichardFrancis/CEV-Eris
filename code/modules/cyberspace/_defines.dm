
#define DECK_LAYOUT_REGULAR 1
#define DECK_LAYOUT_TALL 2
#define DECK_LAYOUT_WIDE 3

#define HACK_TRIGGER_SELECTION			1 // Target selected entity, if there is any and hack is applicable
#define HACK_TRIGGER_ON_CLICK			2 // Target whatever player clicked on, if valid target
#define HACK_TRIGGER_SELF				3 // Target self, if effect makes sense to apply (e.g. if there is nothing to heal - healing program stays idle)
#define HACK_TRIGGER_MELEE_RANGE		4 // Activate when valid target enters melee range
#define HACK_TRIGGER_AOE_RANGE			5 // Activate right away, look for valid targets in range from user, used up even if no valid targets found
#define HACK_TRIGGER_AOE_ON_CLICK		6 // As previous one, but activates on click and looks for target in range from clicked tile, might affect user too
#define HACK_TRIGGER_COUNTERMEASURE		7 // Stays idle and fires up in responce to an attack, often 
#define HACK_TRIGGER_SITUATIONAL		8 // Snowflake. Triggers right after loading, but requires some specific conditions to activate. Does not stay idle

#define HACK_TYPE_ATTACK		1 // Deals damage
#define HACK_TYPE_DEFENCE		2 // Protects user from damage
#define HACK_TYPE_HEAL			3 // Helps tp recover from damage
#define HACK_TYPE_UTILITY		4 // Anything that does not fall in categories above
#define HACK_TYPE_FOCUS			5 // Computation-intensive stuff, occupies all threads, purpose varies



