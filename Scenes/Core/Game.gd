extends Node
class_name Game

@export var level_scene_path : Array[String]

var current_level : Node

func _ready():
	var scene_to_load_path : String = level_scene_path[0]
	travel_to_level("", scene_to_load_path)
	pass

func travel_to_level(from_level_path : String, new_level_path : String):
	var level_scene_to_load : PackedScene = load(new_level_path)
	
	if (!level_scene_to_load):
		return
	
	if current_level:
		get_tree().root.remove_child(current_level)
	
	var level_node_to_load : Node = level_scene_to_load.instantiate()
	get_tree().root.add_child.call_deferred(level_node_to_load)
	child_entered_tree.bind(add_level)
	#get_tree().root.call_deferred("add_level", level_node_to_load, from_level_path)
	
	
func add_level(level_node_to_load : Node, from_level_path):
	get_tree().root.add_child(level_node_to_load)
	if level_node_to_load is Level:
		level_node_to_load.setup_player(from_level_path)
	current_level = level_node_to_load

