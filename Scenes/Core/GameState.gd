extends Node
class_name GameState

var inventory : Array[Pickable]

func add_item_to_inventory(pickable : Pickable):
	inventory.append(pickable)
