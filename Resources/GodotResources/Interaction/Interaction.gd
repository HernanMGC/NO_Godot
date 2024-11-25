@tool
extends Resource
class_name Interaction

signal interaction_finished

var interactuable : Interactuable = null
var can_interact : bool = true

func _init(new_interactuable = null):
	interactuable = new_interactuable 
	
func initialize(newInteractuable: Interactuable) -> void:
	interactuable = newInteractuable
	return

func interact() -> void:
	if can_interact:
		internal_interact()
	#DebugManager.print_debug_line("interact(): Implement function")
	return
	
func internal_interact() -> void:
	#DebugManager.print_debug_line("interact(): Implement function")
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("are_conditions_met(): Implement function")
	return true

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("has_sub_interactions(): Implement function")
	return false
	
