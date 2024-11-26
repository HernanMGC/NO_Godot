extends Node

func set_input_enabled(new_input_enabled : bool) -> void:
	get_tree().call_group("player", "set_input_enable", new_input_enabled)

func travel_to_level(from_level_path : String, new_level_path : String):
	get_tree().call_group("game", "travel_to_level", from_level_path, new_level_path)

func add_item_to_inventory(pickable : Pickable):
	get_tree().call_group("gamestate", "add_item_to_inventory", pickable)

func setup_player(player_start : PlayerStart):
	get_tree().call_group("player", "move_to_player_start", player_start)
