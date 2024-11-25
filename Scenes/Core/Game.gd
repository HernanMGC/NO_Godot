extends Node
class_name Game

@export var level_scene_path : Array[String]

var current_level : Node

func _ready():
	var scene_to_load_path : String = level_scene_path[0]
	travel_to_level(scene_to_load_path)
	pass

func travel_to_level(new_level_path : String):
	var level_scene_to_load : PackedScene = load(new_level_path)
	
	if (!level_scene_to_load):
		return
	
	if current_level:
		get_tree().root.remove_child(current_level)
	
	var level_node_to_load : Node = level_scene_to_load.instantiate()
	get_tree().root.add_child.call_deferred(level_node_to_load)
	current_level = level_node_to_load

