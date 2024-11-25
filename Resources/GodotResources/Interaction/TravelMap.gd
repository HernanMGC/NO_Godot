@tool
extends Interaction
class_name TravelMap

@export var map_to_travel_path : String

func interact() -> void:
	DebugManager.print_debug_line("TravelMap.interact(): Implement function")
	interaction_finished.emit()
	
	PlayerLibFuncs.travel_to_level(map_to_travel_path)
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("TravelMap.are_conditions_met(): Implement function")
	return false

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("TravelMap.has_sub_interactions(): Implement function")
	return false
	
