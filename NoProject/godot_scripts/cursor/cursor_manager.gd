extends CanvasLayer

## CursorManger Class
## Handles pixel perfect sprite mouth positioning.

#region VARIABLES
#region EXPORT VARIABLES
## Empty cursor sprite. It is used to "hide" cursor and can be set to debug
## cursor.
@export var empty_cursor : Texture = null
#endregion EXPORT VARIABLES
#endregion VARIABLES

#region METHODS
#region PRIVATE METHODS
## OVERRIDEN TO: "Hide" default cursor.
func _ready() -> void:
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)

## Updates software pixel perfect cursor position according to default
## cursor position and size.
func _process(_delta : float) -> void:
	var spriteSize : Vector2 = Vector2($Sprite2D.texture.get_width() * $Sprite2D.scale.x, -($Sprite2D.texture.get_height() * $Sprite2D.scale.y))
	var tempGlobalPosition = $Sprite2D.get_global_mouse_position()
	tempGlobalPosition.x += spriteSize.x/2
	tempGlobalPosition.y += spriteSize.y/2 + 3
	$Sprite2D.global_position = tempGlobalPosition
#region PRIVATE METHODS
#region METHODS
