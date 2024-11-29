# Game Class.
# Handles all core game features, such as Level traveling.
extends Node
class_name Game

# EXPORT VARIABLES
# Default Level Resource Paths.
@export var level_scene_paths : Array[String]
# EXPORT VARIABLES - END

# VARIABLES
# Current Level Node reference.
var current_level : Node

# Current Level Resource Path the player has travel from.
var current_from_level_path : String = ""
# VARIABLES - END

# METHODS
# ToDo: THis needs to change once persistency is implemented to travel to the
# last level visit according to the save slot.
# OVERRIDEN TO: Do the initial travel to level.
func _ready() -> void:
	var scene_to_load_path : String = level_scene_paths[0]
	travel_to_level("", scene_to_load_path)
	pass

# Travels to new_level. Load PackedScen for the level if its valid, unloads
# current level if any, connects root's child_entered_tree to add_level function
# and adds new level to root. 
func travel_to_level(from_level_path : String, new_level_path : String) -> void:
	var level_scene_to_load : PackedScene = load(new_level_path)
	current_from_level_path = from_level_path
	
	if (!level_scene_to_load):
		return
	
	if current_level:
		get_tree().root.remove_child(current_level)
	
	var level_node_to_load : Node = level_scene_to_load.instantiate()
	get_tree().root.child_entered_tree.connect(add_level)
	get_tree().root.add_child.call_deferred(level_node_to_load)

# Disconnects root's child_entererd_tree from add_level and setup tha Player's
# Position according to the level needs by passing current_from_level_path.
func add_level(level_node_to_load : Node) -> void:
	get_tree().root.child_entered_tree.disconnect(add_level)
	
	if level_node_to_load is Level:
		level_node_to_load.setup_player(current_from_level_path)
	current_level = level_node_to_load
# METHODS - END
