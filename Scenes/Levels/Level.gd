extends Node
class_name  Level

@export var startup_interactuables : Array[Interactuable]

signal all_startup_interactuables_finished

var startup_interactuables_index : int = 0
var current_interactuable : Interactuable = null

func _ready() -> void:
	NavigationServer2D.set_debug_enabled(true)
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
