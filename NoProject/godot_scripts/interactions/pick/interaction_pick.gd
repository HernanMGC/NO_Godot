@tool
class_name Interaction_Pick
extends AbsInteraction

## Interaction for PickableItems.
## It updates player's inventory and mark interactuable to be destroyed if
## needed.
## Pick Resource.

#region VARIABLES
#region EXPORT VARIABLES
## List of pickables to add to the inventory on interaction.
@export var pickables : Array[PickableItemDefinition]

## Should the interactuable be destroyed on interaction end.
@export var destroy_interactuable_on_interact : bool = true
#endregion EXPORT VARIABLES
#endregion VARIABLES

#region METHODS
#region PRIVATE METHODS
## OVERRIDEN TO: Adds items to inventory, finishes interaction, and if
## destroy_interactuable_on_interact is set to true disables interaction, hides
## interactuable and marks it to be destroyed.
func _internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "Pick:internal_interact(): Implement function")
	for pickable : PickableItemDefinition in pickables:
		DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, pickable.to_string())
		PlayerLibFuncs.add_item_to_inventory(pickable)
	
	interaction_finished.emit()
	
	if destroy_interactuable_on_interact && interactuable:
		_can_interact = false
		interactuable.hide_interactuable()
	return
#region PRIVATE METHODS
#region METHODS
