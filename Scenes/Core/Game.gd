extends Node
class_name Game

@export var level_scenes : Array[PackedScene]

var current_level_index : int = 0

func _ready():
