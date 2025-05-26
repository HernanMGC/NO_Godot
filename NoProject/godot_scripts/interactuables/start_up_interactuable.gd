@tool
extends Interactuable
class_name StartUpInteractuable

## Interactuable class.
## Handles one or more interaction and setup a relative location the player needs
## to move to to start interaction.

#region METHODS
#region PRIVATE METHODS
## Finishes load.
func _finish_loading() -> void:
	super()
	if !Game.static_get_current_level():
		return
	
	var node_path = NodePath(String("/root/" + Game.static_get_current_level().name))
	var current_level : Node = get_node(node_path)
	if current_level as Level:
		current_level.startup_interactuables.append(self)
#region PRIVATE METHODS
#endregion METHODS
