extends Node

## Player Library Functions.

#region METHODS
## Call set_input_enable function on player. 
func set_input_enabled(new_input_enabled : bool) -> void:
	get_tree().call_group("player", "set_input_enable", new_input_enabled)

## Call travel_to_level function on game. 
func travel_to_level(from_level_path : String, new_level_path : String, load_string : String) -> void:
	get_tree().call_group("game", "travel_to_level", from_level_path, new_level_path, load_string)

## Call travel_to_level function on game. 
func load_ui(level_path : String, ui_scenes : Array[String]) -> void:
	get_tree().call_group("game", "load_ui", level_path, ui_scenes)

## Call add_item_to_inventory function on gamestate. 
func add_item_to_inventory(pickable : PickableItemDefinition) -> void:
	get_tree().call_group("gamestate", "add_item_to_inventory", pickable)

## Call move_to_player_start function on player. 
func setup_player(player_start : PlayerStart) -> void:
	get_tree().call_group("player", "move_to_player_start", player_start)
#endregion METHODS
