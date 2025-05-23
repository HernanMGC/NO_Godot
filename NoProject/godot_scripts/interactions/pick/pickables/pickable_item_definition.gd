class_name PickableItemDefinition
extends Resource

## Resource class for Pickable definition.
## It gives a definition for a pickable.

#region VARIABLES
#region EXPORT VARIABLES
## Pickable unique ID.
@export var id : int = -1

## Pickable sprite.
@export var sprite : Texture = null

## Pickable pretty name.
@export var name : String = ""

## Pickable description name.
@export var description : String = ""
#endregion EXPORT VARIABLES

#region PRIVATE VARIABLE
## Validation check for the resource
var _is_valid = false
#endregion PRIVATE VARIABLE
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## OVERRIDEN TO: Provides a string
func _to_string() -> String:
	return "Pickable[" + str(id) + "]: " + name + " - " + description

## Checks if Picakble resource is valid.
func get_is_valid() -> bool:
	return _is_valid
#endregion PUBLIC METHODS
	
#region PRIVATE METHODS
## OVERRIDEN TO: Provided an initialization method.
func _init(new_id = -1, new_sprite = null, new_name = "", new_description = "") -> void:
	id = new_id
	sprite = new_sprite
	name = new_name
	description = new_description
	_is_valid = id != -1
#endregion PRIVATE METHODS
#endregion METHODS
