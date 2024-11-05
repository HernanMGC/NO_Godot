@tool
extends Area2D
class_name Interactuable

signal all_interaction_finished

@export var relative_goto_location : Vector2 = Vector2(0.0, 0.0):
	set(new_relative_goto_location):
		relative_goto_location = Vector2(floor(new_relative_goto_location.x), floor(new_relative_goto_location.y))
		update_location_sprite()
@export var interactions : Array[Interaction]
		
var interaction_index : int = 0
var current_interaction : Interaction = null
var time_to_enable_input : float = 1.0

func update_location_sprite() -> void:
	var location_sprite : Sprite2D = get_node_or_null("LocationSprite")
	if (location_sprite):
		location_sprite.position = relative_goto_location
		
func _ready() -> void:
	update_location_sprite()
	for interaction : Interaction in interactions:
		interaction.initialize(self)
	
func interact() -> void:
	interaction_index = 0
	if interaction_index < interactions.size():
		CharacterLibFuncs.set_input_enabled(false)
		launch_next_interaction()
		
func launch_next_interaction() -> void:
	current_interaction = interactions[interaction_index]
	current_interaction.interaction_finished.connect(_on_interaction_finished)
	current_interaction.interact()
		
func _on_interaction_finished() -> void:
	current_interaction.interaction_finished.disconnect(_on_interaction_finished)
	interaction_index += 1
	if interaction_index < interactions.size():
		launch_next_interaction()
	else:
		interaction_index = 0
		current_interaction = null
		all_interaction_finished.emit()
		
		await get_tree().create_timer(time_to_enable_input).timeout
		CharacterLibFuncs.set_input_enabled(true)
