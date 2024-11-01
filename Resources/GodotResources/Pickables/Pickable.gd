extends Resource
class_name Pickable

@export var id : int = -1
@export var sprite : Texture = null
@export var name : String = ""
@export var description : String = ""
var is_valid = false


func _init(new_id = -1, new_sprite = null, new_name = "", new_description = ""):
	id = new_id
	sprite = new_sprite
	name = new_name
	description = new_description
	is_valid = id != -1

func get_is_valid() -> bool:
	return is_valid
