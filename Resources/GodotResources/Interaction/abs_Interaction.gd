# Resource "abstract" class for Interaction definition.
# It provides the base template for interactions and a set of functions to be
# overriden.
@tool
extends Resource
class_name Interaction

# SIGNALS
# Send to interactuable to confirm that the this interaction has finishd.
signal interaction_finished
# SIGNALS - END

# VARIABLES
# Interactuable that this interaction is attached to.
var interactuable : Interactuable = null

# Flag to set if the interaction enabled or not.
var can_interact : bool = true
# VARIABLES - END

# METHODS
# Scene explicit inizialization. Set the interactuable this interation is
# attached to.
func initialize(new_interactuable: Interactuable) -> void:
	interactuable = new_interactuable
	return

# Base interact function. It is NOT meant to be overriden. It will call internal interact if can 
# interact is true.
func interact() -> void:
	# ToDo: Change this to an implementation that considers are_conditions_met
	if can_interact:
		internal_interact()
	return

# ToDo: Complete implementation
# Base condition met check function. It is NOT meant to be overriden. It will evaluate conditions
# and return if interaction is able to be performed.
func are_conditions_met() -> bool:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "are_conditions_met(): Implement function")
	return true

# ToDo: Complete implementation
# Base sub interaction check function. It is NOT meant to be overriden. It will evaluate if there
# are sub interactions to be performed.
func has_sub_interactions() -> bool:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "has_sub_interactions(): Implement function")
	return false

# Internal interact function. It is a "virtual" function to be overriden in every specific
# interaction type.
func internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.WARNING, "internal_interact(): Implement function")
	return
# METHODS - END
