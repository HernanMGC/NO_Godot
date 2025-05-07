class_name SaveSlotsItemList
extends ItemList

 ## Base class for listing save slot item lists.

#region CONSTANTS
## Save file path string.
const SAVE_FILE_STR : String = "user://saveslots.save"
#endregion CONSTANTS

#region METHODS
#region PRIVATE METHODS

## Load slot items on ready.
func _ready() -> void:
	clear()
	var save_file_data : Dictionary = PersistencySystem.get_data_from_file(SAVE_FILE_STR)
	if !save_file_data.has("slot_list"):
		pass
	
	var slotlists_data : Dictionary = save_file_data["slot_list"]
	if !slotlists_data :
		pass
		
	for slot_key in slotlists_data.keys():
		add_item(slot_key)
	pass
#endregion PRIVATE METHODS
#endregion METHODS
