@tool
class_name AbsDialogueActionResource
extends Resource

## Dialogue action base class. This class will define what kind of action can be
## excecuted in the middle of a dialogue.

#region VARIABLES
#region PRIVATE VARIABLES
## Interactuable that this action's parent interaction is attached to.
var interactuable : Interactuable = null
#endregion PRIVATE VARIABLES
#region VARIABLES

#region METHODS
#region PUBLIC METHODS
## Scene explicit inizialization. Set the interactuable this interation is
## attached to.
func initialize(new_interactuable: Interactuable) -> void:
	interactuable = new_interactuable

## Executes dialogue action. It is a "virtual" function to be overriden in every specific
## dialogue action type.
func _execute_action() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.WARNING, "AbsDialogueActionResource._execute_action(): Implement function")
	return 
#endregion PUBLIC METHODS
#endregion METHODS
