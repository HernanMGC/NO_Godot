# Level Class.
# Handles startup interactions and Player Starts.
extends Node
class_name  Level

# SIGNALS
# Signal to be emitted on all startup Interactuables have finished.
signal all_startup_interactuables_finished
# SIGNALS - END

# EXPORT VARIABLES
# List of startup Interactuables, those that will be launched on Level loaded. 
@export var startup_interactuables : Array[Interactuable]

# List of Player Starts related to the level the Players cames from.
@export var player_start_definitions : Array[PlayerStartDefinition]

# Default Player Starts if came-from leven is not found on 
# player_start_definitions.
@export var default_player_start : PlayerStart
# EXPORT VARIABLES - END

# VARIABLES
# Current startup Interaction index.
var current_startup_interactuables_index : int = 0

# Current startup Interaction reference.
var current_interactuable : Interactuable = null

# Current from Level Resource Path
var from_level_string = ""
# VARIABLES - END

# METHODS
# OVERRIDEN TO: Enable navigation server for the player, move player to its
# player start and launch startup interactions.
func _ready() -> void:
	NavigationServer2D.set_debug_enabled(true)
	move_player()
	launch_startup_interactuables()

# Launches first startup interactions.
func launch_startup_interactuables() -> void:
	current_startup_interactuables_index = 0
	if current_startup_interactuables_index < startup_interactuables.size():
		launch_next_interactuable()

# Launches a startup interactions using current_startup_interactuables_index
# and connects its all_interaction_finished signal to _on_interaction_finished.
func launch_next_interactuable() -> void:
	current_interactuable = startup_interactuables[current_startup_interactuables_index]
	current_interactuable.all_interaction_finished.connect(_on_interaction_finished)
	current_interactuable.interact()
		
# Reacts to Interactuable's all_interaction_finished by disconnecting 
# on_interaction_finished, updating startup interaction counter, and launching
# a new interaction if any or emits all_startup_interactuables_finished
# otherwise.
func _on_interaction_finished() -> void:
	current_interactuable.all_interaction_finished.disconnect(_on_interaction_finished)
	current_startup_interactuables_index += 1
	if current_startup_interactuables_index < startup_interactuables.size():
		launch_next_interactuable()
	else:
		current_startup_interactuables_index = 0
		current_interactuable = null
		all_startup_interactuables_finished.emit()

# Setup from level string for the Player.
func setup_player(in_from_level_string : String) -> void:
	from_level_string = in_from_level_string

# Moves Player to the corresponding Player Start.
func move_player() -> void:
	if from_level_string == "":
		PlayerLibFuncs.setup_player(default_player_start)
	else:
		for player_start_def : PlayerStartDefinition in player_start_definitions:
			if player_start_def.level_from_path == from_level_string:
				var player_start_node = get_node(player_start_def.player_start)
				if player_start_node is PlayerStart:
					PlayerLibFuncs.setup_player(player_start_node)
				return
# METHODS - END
