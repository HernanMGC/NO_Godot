@tool
class_name Interactuable
extends Area2D

## Interactuable class.
## Handles one or more interaction and setup a relative location the player needs
## to move to to start interaction.

#region SIGNALS
## Signal emitted once all interactions have finished.
signal all_interaction_finished
#endregion SIGNALS

#region VARIABLES
#region EXPORT VARIABLES
## Relative Go To Position for the player to move to if it wants to interact with
## the given Interactuable.
@export var exp_relative_goto_location : Vector2 = Vector2(0.0, 0.0):
	## OVERRIDEN TO: Provide a set function to be called editor to update the
	## relative position live.
	set(new_relative_goto_location):
		exp_relative_goto_location = Vector2(floor(new_relative_goto_location.x), floor(new_relative_goto_location.y))
		_relative_goto_location = exp_relative_goto_location 
		_update_location_sprite()

## Interaction list to be performed on Interactuable interaction.
@export var interactions : Array[AbsInteraction]
#endregion EXPORT VARIABLES - END

#region PRIVATE VARIABLES
## Relative Go To Position for the player to move to if it wants to interact with
## the given Interactuable.
var _relative_goto_location : Vector2 = Vector2(0.0, 0.0)

## Current Interaction index.
var _current_interaction_index : int = 0

## Current Interaction reference.
var _current_interaction : AbsInteraction = null

## Time to wait before enable the input on all interaction finished.
var _time_to_enable_input : float = 1.0

## Is the Interactuable marked to be destroyed.
var _marked_to_be_destroyed = false
#endregion PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Creates save serialization.
func save() -> Dictionary:
	var save_dict : Dictionary = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, ## Vector2 is not supported by JSON
		"pos_y" : position.y,
		"name" : name,
		"relative_goto_location" : var_to_str(_relative_goto_location),
		"interactions" : var_to_str(interactions),
		"current_interaction_index" : _current_interaction_index,
		"current_interaction" : _current_interaction,
		"time_to_enable_input" : _time_to_enable_input,
		"marked_to_be_destroyed" : _marked_to_be_destroyed,
	}
	return save_dict
		
## Starts interaction by performing the first interaction of the list and 
## disables Player input. 
func interact() -> void:
	_current_interaction_index = 0
	if _current_interaction_index < interactions.size():
		DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "Interactuable:interact() [%s/%s] " % [str(_current_interaction_index), str(interactions.size())])
		PlayerLibFuncs.set_input_enabled(false)
		_launch_next_interaction()
		
## Returns relative go to location.
func get_relative_goto_location() -> Vector2:
	return _relative_goto_location
	
## Hides interactuables
func hide_interactuable() -> void:
	hide()
	_marked_to_be_destroyed = true
#endregion PUBLIC METHODS

#region PRIVATE METHODS
## OVERRIDEN TO: Initialize the interaction on Node's ready event.
func _ready() -> void:
	_initialize()
	
## OVERRIDEN TO: Track property setting.
func _set(property, value):
	if property == "relative_goto_location":
		## Storing the value in the fake property.
		_relative_goto_location = str_to_var(value)
		_update_location_sprite()
		return true
	if property == "interactions":
		## Storing the value in the fake property.
		interactions = str_to_var(value)
		return true
	return false

## Initializa interactuable.
func _initialize() -> void:
	_update_location_sprite()
	for interaction : AbsInteraction in interactions:
		interaction.initialize(self)
		
## Updates location sprite according to relative_goto_location. It's a function
## used in editor to refreshed the information for the developepr.
func _update_location_sprite() -> void:
	var location_sprite : Sprite2D = get_node_or_null("LocationSprite")
	if (location_sprite):
		location_sprite.position = _relative_goto_location
		
## Launches next interaction using current_interaction_index and connect 
## Interaction interaction_finished signal to _on_interaction_finished.
func _launch_next_interaction() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "Interactuable:launch_next_interaction() [%s/%s] " % [str(_current_interaction_index), str(interactions.size())])
	
	_current_interaction = interactions[_current_interaction_index]
	_current_interaction.interaction_finished.connect(_on_interaction_finished)
	_current_interaction._interact()
		
func _on_interaction_finished() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "ENTER Interactuable:_on_interaction_finished() [%s/%s] " % [str(_current_interaction_index), str(interactions.size())])
	
	_current_interaction.interaction_finished.disconnect(_on_interaction_finished)
	_current_interaction_index += 1
	if _current_interaction_index < interactions.size():
		_launch_next_interaction()
	else:
		_current_interaction_index = 0
		_current_interaction = null
		all_interaction_finished.emit()
		
		await get_tree().create_timer(_time_to_enable_input).timeout
		PlayerLibFuncs.set_input_enabled(true)
		
		if _marked_to_be_destroyed:
			queue_free()
	
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "LEAVE Interactuable:_on_interaction_finished() [%s/%s] " % [str(_current_interaction_index), str(interactions.size())])

## Finishes load.
func _finish_loading() -> void:
	_initialize()
#endregion PRIVATE METHODS
#endregion METHODS
