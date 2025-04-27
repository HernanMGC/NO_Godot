# Interaction for Pickables.
# It updates player's inventory and mark interactuable to be destroyed if
# needed.
# Pick Resource.
@tool
extends Interaction
class_name Pick

# EXPORT VARIABLES
# List of pickables to add to the inventory on interaction.
@export var pickables : Array[Pickable]

# Should the interactuable be destroyed on interaction end.
@export var destroy_interactuable_on_interact : bool = true
# EXPORT VARIABLES - END

# METHODS
# OVERRIDEN TO: Adds items to inventory, finishes interaction, and if
# destroy_interactuable_on_interact is set to true disables interaction, hides
# interactuable and marks it to be destroyed.
func internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "Pick:internal_interact(): Implement function")
	for pickable : Pickable in pickables:
		DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, pickable.to_string())
		PlayerLibFuncs.add_item_to_inventory(pickable)
	
	interaction_finished.emit()
	
	if destroy_interactuable_on_interact && interactuable:
		can_interact = false
		interactuable.hide()
		interactuable.marked_to_be_destroyed = true
	return
# METHODS - END
