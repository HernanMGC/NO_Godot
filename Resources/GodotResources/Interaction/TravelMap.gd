@tool
extends Interaction
class_name TravelMap

@export var map_to_travel_path : String


func internal_interact() -> void:
	#DebugManager.print_debug_line("TravelMap.internal_interact(): Implement function")
	interaction_finished.emit()
	
	var from_level_path : String = ""
	var root_children = interactuable.get_tree().root.get_children()
	for child in root_children:
		if child is Level:
			from_level_path = child.scene_file_path
	
	PlayerLibFuncs.travel_to_level(from_level_path, map_to_travel_path)
	return
