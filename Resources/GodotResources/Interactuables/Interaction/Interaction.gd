@tool
extends Resource
class_name Interaction

var interactuable : Interactuable = null

func _init(new_interactuable = null):
	interactuable = new_interactuable 
	
func initialize(newInteractuable: Interactuable) -> void:
	interactuable = newInteractuable
	return

func interact() -> void:
	DebugManager.print_debug_line("interact(): Implement function")
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("are_conditions_met(): Implement function")
	return true

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("has_sub_interactions(): Implement function")
	return false
	
