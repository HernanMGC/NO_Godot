# GameState Class.
# Handles Game State properties such as Inventory state.
extends Node
class_name GameState

# VARIABLES
# Picked Pickable so far.
var inventory : Array[Pickable]
# VARIABLES - END

# METHODS
# Adds a Pickable to the Inventory.
func add_item_to_inventory(pickable : Pickable) -> void:
	inventory.append(pickable)
# METHODS - END
