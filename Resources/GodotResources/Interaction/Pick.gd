@tool
extends Interaction
class_name Pick

@export var pickables : Array[Pickable]
@export var destroy_interactuable_on_interact : bool = true

func internal_interact() -> void:
	#DebugManager.print_debug_line("Pick.internal_interact(): Implement function")
	for pickable : Pickable in pickables:
		#DebugManager.print_debug_line(pickable.to_string())
		PlayerLibFuncs.add_item_to_inventory(pickable)
	
	interaction_finished.emit()
	
	if destroy_interactuable_on_interact && interactuable:
		can_interact = false
		interactuable.hide()
		interactuable.marked_to_be_destroyed = true
	return
