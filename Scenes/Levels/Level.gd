extends Node
class_name  Level

@export var startup_interactuables : Array[Interactuable]
@export var player_start_definitions : Array[PlayerStartDefinition]
@export var default_player_start : PlayerStart

signal all_startup_interactuables_finished

var startup_interactuables_index : int = 0
var current_interactuable : Interactuable = null
var from_level_string = ""

func _ready() -> void:
	NavigationServer2D.set_debug_enabled(true)
	move_player()
	launch_startup_interactuables()
	
func launch_startup_interactuables() -> void:
	startup_interactuables_index = 0
	if startup_interactuables_index < startup_interactuables.size():
		launch_next_interactuable()
		
func launch_next_interactuable() -> void:
	current_interactuable = startup_interactuables[startup_interactuables_index]
	current_interactuable.all_interaction_finished.connect(_on_interaction_finished)
	current_interactuable.interact()
		
func _on_interaction_finished() -> void:
	current_interactuable.all_interaction_finished.disconnect(_on_interaction_finished)
	startup_interactuables_index += 1
	if startup_interactuables_index < startup_interactuables.size():
		launch_next_interactuable()
	else:
		startup_interactuables_index = 0
		current_interactuable = null
		all_startup_interactuables_finished.emit()

func setup_player(in_from_level_string : String):
	from_level_string = in_from_level_string

func move_player():
	if from_level_string == "":
		PlayerLibFuncs.setup_player(default_player_start)
	else:
		for player_start_def : PlayerStartDefinition in player_start_definitions:
			if player_start_def.level_from_path == from_level_string:
				var player_start_node = get_node(player_start_def.player_start)
				if player_start_node is PlayerStart:
					PlayerLibFuncs.setup_player(player_start_node)
				return
