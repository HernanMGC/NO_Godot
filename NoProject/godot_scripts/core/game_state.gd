extends Node
class_name GameState

## GameState Class.
## Handles Game State properties such as Inventory state.

#region VARIABLES
#region PUBLIC VARIABLES
## Picked Pickable so far.
var inventory : Array[PickableItemDefinition]
#endregion PUBLIC VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## METHODS
## Adds a Pickable to the Inventory.
func add_item_to_inventory(pickable : PickableItemDefinition) -> void:
	inventory.append(pickable)
#region PUBLIC METHODS
#region METHODS
