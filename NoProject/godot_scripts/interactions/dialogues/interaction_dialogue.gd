@tool
class_name Interaction_Dialogue
extends AbsInteraction

## Interaction for Dialogues.
## It provides an access point to the dialogue plugin.
## Handles the start and stop of a dialogue, and it may contain more than one 
## Dialogue Resource.

#region VARIABLES
#region EXPORT VARIABLES
## Dialogues resources to be launched. The orden of the array will determined the
## order in which they are displayed.
@export var dialogues : Array[DialogueResource]

@export var dialogue_actions : Dictionary[String, AbsDialogueActionResource]
#endregion EXPORT VARIABLES

#region PRIVATE VARIABLES
## Counter for current dialogue in display.
var _current_dialogue_index : int = 0
#endregion PRIVATE VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Scene explicit inizialization. Set the interactuable this interation is
## attached to.
func initialize(new_interactuable: Interactuable) -> void:
	super(new_interactuable)
	for key in dialogue_actions:
		var dialogue_action : AbsDialogueActionResource = dialogue_actions[key]
		if dialogue_action is AbsDialogueActionResource:
			dialogue_action.initialize(new_interactuable) 
	return
#region PUBLIC METHODS
	
#region PRIVATE METHODS
## OVERRIDEN TO: Starts dialogue sequence. It disables player input until 
## dialogues end. 
func _internal_interact() -> void:
	DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "Dialogue.internal_interact(): Implemented function")
	_current_dialogue_index = 0
	if dialogues.size() > 0:
		PlayerLibFuncs.set_input_enabled(false)
		_show_next_dialogue()

## Displays next dialogue resource if any and connect dialogue's end signal to
## _on_dialogue_ended function.
func _show_next_dialogue() -> void:
	if _current_dialogue_index < dialogues.size():
		DialogueManager.show_dialogue_balloon(dialogues[_current_dialogue_index], "", [self])
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	return

## Update current dialogue index, disconcects it self from dialogue's end signal
## and call for a next dialogue if any. Otherwise emit interaction_finished 
## signal.
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	_current_dialogue_index += 1
	
	if _current_dialogue_index < dialogues.size():
		_show_next_dialogue()
	else:
		PlayerLibFuncs.set_input_enabled(true)
		interaction_finished.emit()
		
func execute_dialogue_action(action_key : String) -> void:
	var dialogue_action : AbsDialogueActionResource = dialogue_actions[action_key]
	if dialogue_action:
		dialogue_action._execute_action()
#endregion PRIVATE METHODS
#endregion METHODS
