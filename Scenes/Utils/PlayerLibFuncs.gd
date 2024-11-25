extends Node

func set_input_enabled(new_input_enabled : bool) -> void:
	get_tree().call_group("player", "set_input_enable", new_input_enabled)
