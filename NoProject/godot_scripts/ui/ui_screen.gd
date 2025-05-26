class_name UIScreen
extends Control

## UI Screen base class.

#region VARIABLES
#region ONREADY PRIVATE VARIABLES
## Layer link node.
@onready var layer_link : Control = $LayerLink

## Content node.
@onready var content : Control = $Content
#endregion ONREADY PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS

## Returns parent UI screen.
func get_parent_ui() -> Node:
	return get_parent().get_parent()

## Pushes UI.
func push_ui(ui_node : UIScreen) -> void:
	layer_link.add_child(ui_node)
	content.hide()
	pass

## Pushes UI.
func pop_ui() -> void:
	layer_link.get_child(0).queue_free()
	content.show()
	pass
#endregion PUBLIC METHODS
#endregion METHODS
