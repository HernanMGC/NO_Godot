# Interaction for Map Travel.
# It updates player's inventory and mark interactuable to be destroyed if
# needed.
# Pick Resource.
@tool
extends Interaction
class_name TravelMap

# EXPORT VARIABLES
# Level's resource path to travel.
@export var map_to_travel_path : String
# EXPORT VARIABLES - END

# METHOD
# OVERRIDEN TO: Pre-finishes interaction to avoid errors on child adding 
# process. Calls for PlayerLibFuncs.travel_to_level.
func internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "TravelMap.internal_interact(): Implemented function")
	GamePersistencySystem.save_game()
	interaction_finished.emit()
	
	var from_level_path : String = ""
	var temp_tree = interactuable.get_tree()
	var root_children = temp_tree.root.get_children()
	for child in root_children:
		if child is Level:
			from_level_path = child.scene_file_path
	
	PlayerLibFuncs.travel_to_level(from_level_path, map_to_travel_path, Game.get_current_load_string())
# METHOD - END
