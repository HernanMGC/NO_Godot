extends Node
class_name Interaction

var interactuable : Interactuable = null

func initialize(newInteractuable: Interactuable) -> void:
	interactuable = newInteractuable
	return

func interact() -> void:
	print("interact(): Implement function")
	return
	
func are_conditions_met() -> bool:
	print("are_conditions_met(): Implement function")
	return false

func has_sub_interactions() -> bool:
	print("has_sub_interactions(): Implement function")
	return false
	
