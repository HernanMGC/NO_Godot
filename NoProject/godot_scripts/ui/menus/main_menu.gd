class_name MainMenuUIScreen
extends Control

## Main Menu UI screen Class.
## Show buttons for new, load, and continue game.

#region CONSTANTS
## Save file path string.
const SAVE_FILE_STR : String = "user://saveslots.save"
#endregion CONSTANTS

#region VARIABLES
#region EXPORT VARIABLES
## New level path.
@export var new_level_path : String = ""

## Load UI scene path.
@export var load_game_ui_path : String = ""
#endregion EXPORT VARIABLES
#endregion VARIABLES

#region METHODS
#region PRIVATE METHODS
## OVERRIDEN TO: Hide unneed buttons.
func _ready():
	if not FileAccess.file_exists(SAVE_FILE_STR):
		$PanelContainer/VBoxContainer/ContinueButton.hide()

## Start new game.
func _on_new_game_button_pressed():
	var load_string : String = Time.get_datetime_string_from_system()
	load_string = load_string.replace(":","")
	load_string = load_string.replace("T","")
	load_string = load_string.replace("-","")
	PlayerLibFuncs.travel_to_level("", new_level_path, load_string)

## Continue game.
func _on_continue_button_pressed():
	var slotlists_data : Dictionary = PersistencySystem.get_data_from_file(SAVE_FILE_STR)
	if slotlists_data.has("last_slot"):
		PlayerLibFuncs.travel_to_level("", slotlists_data["slot_list"][slotlists_data["last_slot"]]["current_level"], slotlists_data["last_slot"])
	pass 
	
func _on_load_game_button_pressed() -> void:
	PlayerLibFuncs.push_ui(load_game_ui_path)
	pass # Replace with function body.
#endregion PRIVATE METHODS
#endregion METHODS
