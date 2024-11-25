@tool
extends Interaction
class_name TravelMap

@export var map_to_travel_path : String

func internal_interact() -> void:
	#DebugManager.print_debug_line("TravelMap.internal_interact(): Implement function")
	interaction_finished.emit()
	
	PlayerLibFuncs.travel_to_level(map_to_travel_path)
	return
