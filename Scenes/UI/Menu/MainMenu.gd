# Main menu Class.
# Show buttons for new, load, and continue game.
extends CenterContainer

# EXPORTED VARIABLES
@export var new_level_path : String = ""

# METHODS
# OVERRIDEN TO: Hide unneed buttons.
func _ready():
	var save_file_str = "user://saveslots.save"
	
	if not FileAccess.file_exists(save_file_str):
		$PanelContainer/VBoxContainer/ContinueButton.hide()
		#$PanelContainer/VBoxContainer/LoadGameButton.hide()

# Start new game.
func _on_new_game_button_pressed():
	var tmp_new_level_name : String = Time.get_datetime_string_from_system()
	tmp_new_level_name = tmp_new_level_name.replace(":","")
	tmp_new_level_name = tmp_new_level_name.replace("T","")
	tmp_new_level_name = tmp_new_level_name.replace("-","")
	PlayerLibFuncs.travel_to_level("", new_level_path, tmp_new_level_name)

# Continue game.
func _on_continue_button_pressed():
	var slotlist_file_str = "user://saveslots.save"
	var slotlists_data : Dictionary = GamePersistencySystem.get_data_from_file(slotlist_file_str)
	if slotlists_data.has("last_slot"):
		PlayerLibFuncs.travel_to_level("", slotlists_data["slot_list"][slotlists_data["last_slot"]]["current_level"], slotlists_data["last_slot"])
	pass # Replace with function body.

# METHODS - END

