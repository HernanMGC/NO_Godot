@tool
extends Interaction
class_name Pick

@export var pickables : Array[Pickable] 

func interact() -> void:
	DebugManager.print_debug_line("Pick.interact(): Implement function")
	for pickable : Pickable in pickables:
		var debugString : String = "Pickable[" + str(pickable.id) + "]: " + pickable.name + " - " + pickable.description
		DebugManager.print_debug_line(debugString)
	interactuable.queue_free()
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("Pick.are_conditions_met(): Implement function")
	return false

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("Pick.has_sub_interactions(): Implement function")
	return false
	
