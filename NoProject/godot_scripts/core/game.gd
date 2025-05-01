class_name Game
extends Node

## Game Class.
## Handles all core game features, such as Level traveling.

#region VARIABLES
#region EXPORT VARIABLES
## Default Level Resource Paths.
@export var level_scene_paths : Array[String]
#endregion EXPORT VARIABLES

#region PRIVATE VARIABLES
## Current Level Node reference.
var _current_level : Node

## Current Level Resource Path the player has travel from.
var _current_from_level_path : String = ""

## Current load string.
var _current_load_string : String = ""
#endregion PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Travels to new_level. Load PackedScen for the level if its valid, unloads
## current level if any, connects root's child_entered_tree to add_level function
## and adds new level to root. 
func travel_to_level(from_level_path : String, new_level_path : String, load_string : String) -> void:
	var level_scene_to_load : PackedScene = load(new_level_path)
	_current_from_level_path = from_level_path
	_current_load_string = load_string
	
	if (!level_scene_to_load):
		return
	
	if _current_level:
		get_tree().root.remove_child(_current_level)
	
	var level_node_to_load : Node = level_scene_to_load.instantiate()
	get_tree().root.child_entered_tree.connect(_add_level)
	get_tree().root.add_child.call_deferred(level_node_to_load)
	
## Returns current level.
func get_current_level() -> Node:
	return _current_level

## Returns current load string.
func current_load_string() -> String:
	return _current_load_string
#endregion PUBLIC METHODS

#endregion PRIVATE METHODS
## METHODS
## ToDo: THis needs to change once persistency is implemented to travel to the
## last level visit according to the save slot.
## OVERRIDEN TO: Do the initial travel to level.
func _ready() -> void:
	var scene_to_load_path : String = level_scene_paths[0]
	travel_to_level("", scene_to_load_path, "")
	pass
	
func _process(_delta : float) -> void:
	pass
	
## Disconnects root's child_entererd_tree from add_level and setup tha Player's
## Position according to the level needs by passing current_from_level_path.
func _add_level(level_node_to_load : Node) -> void:
	get_tree().root.child_entered_tree.disconnect(_add_level)
	
	if level_node_to_load is Level:
		level_node_to_load.setup_player(_current_from_level_path)
	_current_level = level_node_to_load
## METHODS - END
#endregion PRIVATE METHODS

#region STATIC METHODS
## Get current level node.
static func static_get_current_level() -> Node:
	var mainLoop = Engine.get_main_loop()
	var sceneTree = mainLoop as SceneTree;
	var root = sceneTree.root.get_node("Game")
	if (root as Game):
		return root.get_current_level()
	else:
		return null

## Get current load string.
static func static_get_current_load_string() -> String:
	var mainLoop = Engine.get_main_loop()
	var sceneTree = mainLoop as SceneTree;
	var root = sceneTree.root.get_node("Game")
	if (root as Game):
		return root.current_load_string()
	else:
		return ""
#endregion STATIC METHODS
#endregion METHODS
