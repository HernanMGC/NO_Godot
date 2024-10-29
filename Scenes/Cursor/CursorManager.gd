extends CanvasLayer

@export var empty_cursor : Texture = null

func _ready():
	Input.set_custom_mouse_cursor(empty_cursor, Input.CURSOR_ARROW)

func _process(_delta : float) -> void:
	var spriteSize : Vector2 = Vector2($Sprite2D.texture.get_width() * $Sprite2D.scale.x, -($Sprite2D.texture.get_height() * $Sprite2D.scale.y))
	$Sprite2D.global_position = $Sprite2D.get_global_mouse_position() + spriteSize/2
