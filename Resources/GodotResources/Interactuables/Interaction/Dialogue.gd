@tool
extends Interaction
class_name Dialogue

@export var dialogues : Array[DialogueResource] 

func interact() -> void:
	DebugManager.print_debug_line("Pick.interact(): Implement function")
	for dialogue : DialogueResource in dialogues:
		DialogueManager.show_dialogue_balloon(dialogue)
	interactuable.queue_free()
	return
	
func are_conditions_met() -> bool:
	DebugManager.print_debug_line("Pick.are_conditions_met(): Implement function")
	return false

func has_sub_interactions() -> bool:
	DebugManager.print_debug_line("Pick.has_sub_interactions(): Implement function")
	return false
	
