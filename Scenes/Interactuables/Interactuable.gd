@tool
extends Area2D
class_name Interactuable

signal interaction_finished

@export var relative_goto_location : Vector2 = Vector2(0.0, 0.0):
	set(new_relative_goto_location):
		relative_goto_location = Vector2(floor(new_relative_goto_location.x), floor(new_relative_goto_location.y))
		update_location_sprite()
		
func update_location_sprite() -> void:
	var location_sprite : Sprite2D = get_node_or_null("LocationSprite")
	if (location_sprite):
		location_sprite.position = relative_goto_location
		
func _ready() -> void:
	update_location_sprite()
	
func _on_tree_entered() -> void:
	pass # Replace with function body.

func interact() -> void:
	interaction_finished.emit()
