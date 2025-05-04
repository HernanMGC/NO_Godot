@tool
class_name AbsInteraction
extends Resource

## Resource "abstract" class for Interaction definition.
## It provides the base template for interactions and a set of functions to be
## overriden.

#region SIGNALS
## Send to interactuable to confirm that the this interaction has finished.
signal interaction_finished
#endregion SIGNALS

#region VARIABLES
#region PRIVATE VARIABLES
## Interactuable that this interaction is attached to.
var interactuable : Interactuable = null

## Flag to set if the interaction enabled or not.
var _can_interact : bool = true
#endregion PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Scene explicit inizialization. Set the interactuable this interation is
## attached to.
func initialize(new_interactuable: Interactuable) -> void:
	interactuable = new_interactuable
	_can_interact = true
	return
	
## Base interact function. It is NOT meant to be overriden. It will call internal interact if can 
## interact is true.
func _interact() -> void:
	## TODO: Change this to an implementation that considers are_conditions_met
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "AbsInteraction.abs_Interaction:interact(): can_interact %s" % str(_can_interact))
	
	if _can_interact:
		_internal_interact()
	return
#endregion PUBLIC METHODS

#region PRIVATE METHODS

## TODO: Complete implementation
## Base condition met check function. It is NOT meant to be overriden. It will evaluate conditions
## and return if interaction is able to be performed.
func _are_conditions_met() -> bool:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "AbsInteraction.are_conditions_met(): Implement function")
	return true

## TODO: Complete implementation
## Base sub interaction check function. It is NOT meant to be overriden. It will evaluate if there
## are sub interactions to be performed.
func _has_sub_interactions() -> bool:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "AbsInteraction.has_sub_interactions(): Implement function")
	return false

## Internal interact function. It is a "virtual" function to be overriden in every specific
## interaction type.
func _internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.WARNING, "AbsInteraction.internal_interact(): Implement function")
	return
#endregion PRIVATE METHODS
#endregion METHODS
