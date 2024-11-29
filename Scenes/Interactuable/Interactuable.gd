# Interactuable class.
# Handles one or more interaction and setup a relative location the player needs
# to move to to start interaction.
@tool
extends Area2D
class_name Interactuable

# SIGNALS
# Signal emitted once all interactions have finished.
signal all_interaction_finished
# SIGNALS - END

# EXPORT VARIABLES
# Relative Go To Position for the player to move to if it wants to interact with
# the given Interactuable.
@export var relative_goto_location : Vector2 = Vector2(0.0, 0.0):
	# OVERRIDEN TO: Provide a set function to be called editor to update the
	# relative position live.
	set(new_relative_goto_location):
		relative_goto_location = Vector2(floor(new_relative_goto_location.x), floor(new_relative_goto_location.y))
		update_location_sprite()

# Interaction list to be performed on Interactuable interaction.
@export var interactions : Array[Interaction]
# EXPORT VARIABLES - END

# VARIABLES
# Current Interaction index.
var current_interaction_index : int = 0

# Current Interaction reference.
var current_interaction : Interaction = null

# Time to wait before enable the input on all interaction finished.
var time_to_enable_input : float = 1.0

# Is the Interactuable marked to be destroyed.
var marked_to_be_destroyed = false
# VARIABLES - END

# METHODS
# OVERRIDEN TO: Initialize the interaction on Node's ready event.
func _ready() -> void:
	update_location_sprite()
	for interaction : Interaction in interactions:
		interaction.initialize(self)
	
# Updates location sprite according to relative_goto_location. It's a function
# used in editor to refreshed the information for the developepr.
func update_location_sprite() -> void:
	var location_sprite : Sprite2D = get_node_or_null("LocationSprite")
	if (location_sprite):
		location_sprite.position = relative_goto_location
		
# Starts interaction by performing the first interaction of the list and 
# disables Player input. 
func interact() -> void:
	current_interaction_index = 0
	if current_interaction_index < interactions.size():
		PlayerLibFuncs.set_input_enabled(false)
		launch_next_interaction()
		
# Launches next interaction using current_interaction_index and connect 
# Interaction interaction_finished signal to _on_interaction_finished.
func launch_next_interaction() -> void:
	current_interaction = interactions[current_interaction_index]
	current_interaction.interaction_finished.connect(_on_interaction_finished)
	current_interaction.interact()
		
func _on_interaction_finished() -> void:
	current_interaction.interaction_finished.disconnect(_on_interaction_finished)
	current_interaction_index += 1
	if current_interaction_index < interactions.size():
		launch_next_interaction()
	else:
		current_interaction_index = 0
		current_interaction = null
		all_interaction_finished.emit()
		
		await get_tree().create_timer(time_to_enable_input).timeout
		PlayerLibFuncs.set_input_enabled(true)
		
		if marked_to_be_destroyed:
			queue_free()
# METHODS - END
