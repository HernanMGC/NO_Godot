@tool
extends Interaction
class_name Dialogue

@export var dialogues : Array[DialogueResource] 
var current_dialogue_index : int = 0

func interact() -> void:
	DebugManager.print_debug_line("Dialogue.interact(): Implement function")
	current_dialogue_index = 0
	if dialogues.size() > 0:
		PlayerLibFuncs.set_input_enabled(false)
		show_next_dialogue()

func show_next_dialogue() -> void:
	if current_dialogue_index < dialogues.size():
		DialogueManager.show_dialogue_balloon(dialogues[current_dialogue_index])
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("Dialogue.are_conditions_met(): Implement function")
	return false

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("Dialogue.has_sub_interactions(): Implement function")
	return false
	
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	current_dialogue_index += 1
	
	if current_dialogue_index < dialogues.size():
		show_next_dialogue()
	else:
		PlayerLibFuncs.set_input_enabled(true)
		interaction_finished.emit()
