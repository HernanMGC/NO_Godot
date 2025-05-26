extends Node
class_name  Level

## Level Class.
## Handles startup interactions and Player Starts.

#region SIGNALS
## Signal to be emitted on all startup Interactuables have finished.
signal all_startup_interactuables_finished
#endregion SIGNALS

#region VARIABLES
#region EXPORT VARIABLES
## List of startup Interactuables, those that will be launched on Level loaded. 
@export var startup_interactuables : Array[Interactuable]

## List of Player Starts related to the level the Players cames from.
@export var player_start_definitions : Array[PlayerStartDefinition]

## Default Player Starts if came-from leven is not found on 
## player_start_definitions.
@export var default_player_start : PlayerStart

## UI screen related to the level that need to be added.
@export var ui_screen_to_add : String = ""

## Is game saving enabled for the level.
@export var save_game_enabled = true
#endregion EXPORT VARIABLES

#region PRIVATE VARIABLES
## Current startup Interaction index.
var _current_startup_interactuables_index : int = 0

## Current startup Interaction reference.
var _current_interactuable : Interactuable = null

## Current from Level Resource Path
var _from_level_string = ""
#endregion PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Setup from level string for the Player.
func setup_player(in_from_level_string : String) -> void:
	_from_level_string = in_from_level_string
#endregion PUBLIC METHODS
	
#region PRIVATE METHODS
## OVERRIDEN TO: Enable navigation server for the player, move player to its
## player start and launch startup interactions.
func _ready() -> void:
	NavigationServer2D.set_debug_enabled(true)
	GamePersistencySystem.load_game()
	await get_tree().process_frame
	_move_player()
	_launch_startup_interactuables()
	PlayerLibFuncs.load_ui(Game.static_get_current_load_string(), ui_screen_to_add)
	
	if save_game_enabled:
		GamePersistencySystem.save_game()

## Launches first startup interactions.
func _launch_startup_interactuables() -> void:
	if startup_interactuables.is_empty():
		return
		
	_current_startup_interactuables_index = 0
	if _current_startup_interactuables_index < startup_interactuables.size():
		_launch_next_interactuable()

## Launches a startup interactions using current_startup_interactuables_index
## and connects its all_interaction_finished signal to _on_interaction_finished.
func _launch_next_interactuable() -> void:
	_current_interactuable = startup_interactuables[_current_startup_interactuables_index]
	_current_interactuable.all_interaction_finished.connect(_on_interaction_finished)
	_current_interactuable.interact()
		
## Reacts to Interactuable's all_interaction_finished by disconnecting 
## on_interaction_finished, updating startup interaction counter, and launching
## a new interaction if any or emits all_startup_interactuables_finished
## otherwise.
func _on_interaction_finished() -> void:
	_current_interactuable.all_interaction_finished.disconnect(_on_interaction_finished)
	_current_startup_interactuables_index += 1
	if _current_startup_interactuables_index < startup_interactuables.size():
		_launch_next_interactuable()
	else:
		_current_startup_interactuables_index = 0
		_current_interactuable = null
		all_startup_interactuables_finished.emit()

## Moves Player to the corresponding Player Start.
func _move_player() -> void:
	if _from_level_string == "":
		PlayerLibFuncs.setup_player(default_player_start)
	else:
		for player_start_def : PlayerStartDefinition in player_start_definitions:
			if player_start_def.level_from_path == _from_level_string:
				var player_start_node = get_node(player_start_def.player_start)
				if player_start_node is PlayerStart:
					PlayerLibFuncs.setup_player(player_start_node)
				return
#region PRIVATE METHODS
#region METHODS
