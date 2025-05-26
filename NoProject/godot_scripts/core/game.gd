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

## Current active UI screen.
var _current_ui_screen : UIScreen
#endregion PRIVATE VARIABLES

#region ONREADY PRIVATE VARIABLES
## Level node path.
@onready var level_node : Node = $Level

## UI node path.
@onready var ui_node : Node = $UI
#endregion ONREADY PRIVATE VARIABLES
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
		level_node.remove_child(_current_level)
	
	var level_node_to_load : Node = level_scene_to_load.instantiate()
	level_node.child_entered_tree.connect(_add_level)
	level_node.add_child.call_deferred(level_node_to_load)
	
## Returns current level.
func get_current_level() -> Node:
	return _current_level

## Returns current load string.
func current_load_string() -> String:
	return _current_load_string

## Load UIs.
func load_ui(_level_path : String, ui_scene : String) -> void:
	var ui_node_children = ui_node.get_children()
	for ui_child in ui_node_children:
		ui_child.queue_free()
	
	_current_ui_screen = null
	
	var ui_screen_to_load : PackedScene = load(ui_scene)
	if !ui_screen_to_load:
		return
		
	var ui_node_to_load : Node = ui_screen_to_load.instantiate()
	ui_node.add_child(ui_node_to_load)
	_current_ui_screen = ui_node_to_load
	pass
	
## Remove current UI and show parent UI.
func pop_ui() -> void:
	var tmp_current_ui_screen = _current_ui_screen
	if tmp_current_ui_screen.get_parent_ui() && tmp_current_ui_screen.get_parent_ui() is UIScreen:
		tmp_current_ui_screen.get_parent_ui().pop_ui()
		_current_ui_screen = tmp_current_ui_screen.get_parent_ui()
	else:
		var ui_node_children = ui_node.get_children()
		for ui_child in ui_node_children:
			ui_child.free()
		_current_ui_screen = null
	
## Push UI and hide parent UI.
func push_ui(screen_ui_res_path : String) -> void:
	var ui_screen_to_load : PackedScene = load(screen_ui_res_path)
	if !ui_screen_to_load:
		return
		
	var ui_node_to_load : Node = ui_screen_to_load.instantiate()
	
	if _current_ui_screen && _current_ui_screen is UIScreen:
		_current_ui_screen.push_ui(ui_node_to_load)
	else:
		ui_node.add_child(ui_node_to_load)
	
	_current_ui_screen = ui_node_to_load
		
#endregion PUBLIC METHODS

#endregion PRIVATE METHODS
## METHODS
## ToDo: THis needs to change once persistency is implemented to travel to the
## last level visit according to the save slot.
## OVERRIDEN TO: Do the initial travel to level.
func _ready() -> void:
	var scene_to_load_path : String = level_scene_paths[0]
	# TODO: Change this to alter UI instead of Level and add a way to handle UI Layers
	travel_to_level("", scene_to_load_path, "")
	pass
	
func _process(_delta : float) -> void:
	pass
	
## Disconnects root's child_entererd_tree from add_level and setup tha Player's
## Position according to the level needs by passing current_from_level_path.
func _add_level(level_node_to_load : Node) -> void:
	level_node.child_entered_tree.disconnect(_add_level)
	
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
	var root = sceneTree.root.get_node("Game/Level")
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
