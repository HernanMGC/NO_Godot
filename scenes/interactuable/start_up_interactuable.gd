# Interactuable class.
# Handles one or more interaction and setup a relative location the player needs
# to move to to start interaction.
@tool
extends Interactuable
class_name StartUpInteractuable

# METHODS
# Finishes load.
func finish_loading() -> void:
	super()
	var current_level : Node = get_node(NodePath(String("/root/" + Game.get_current_level().name)))
	if current_level as Level:
		current_level.startup_interactuables.append(self)
# METHODS - END
