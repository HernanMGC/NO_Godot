@tool
class_name Interaction_TravelMap
extends AbsInteraction

## Interaction for Map Travel.
## It updates player's inventory and mark interactuable to be destroyed if
## needed.
## Travel Map Resource.

#region VARIABLES
#region EXPORT VARIABLES
## Level's resource path to travel.
@export var map_to_travel_path : String
#endregion EXPORT VARIABLES
#endregion VARIABLES

#region METHODS
#region PRIVATE METHODS
## OVERRIDEN TO: Pre-finishes interaction to avoid errors on child adding 
## process. Calls for PlayerLibFuncs.travel_to_level.
func _internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "TravelMap.internal_interact(): Implemented function")
	GamePersistencySystem.save_game()
	interaction_finished.emit()
	
	var from_level_path : String = ""
	var temp_tree = interactuable.get_tree()
	var root_children = temp_tree.root.get_children()
	for child in root_children:
		if child is Level:
			from_level_path = child.scene_file_path
	
	PlayerLibFuncs.travel_to_level(from_level_path, map_to_travel_path, Game.static_get_current_load_string())
#endregion PRIVATE METHODS
#endregion METHODS
