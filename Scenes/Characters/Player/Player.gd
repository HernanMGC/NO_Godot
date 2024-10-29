extends Area2D

@export var speed = 400
@export var reachThreshold = 10

var goToPosition : Vector2 = Vector2.ZERO
var currentDirection : Vector2 = Vector2.ZERO
var isMoving : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (isMoving):
		update_position(delta)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("GoToPosition"):
		print("Is action GoToPosition ")
		set_is_moving(true)
		goToPosition = event.position
		currentDirection = (goToPosition - position).normalized()

func update_position(delta : float) -> void:
	var direction : Vector2 = (goToPosition - position).normalized()
	
	var velocity : Vector2 = direction * speed
	var newPosition : Vector2 = position + velocity * delta
	var distance : float = goToPosition.distance_squared_to(newPosition)
	if (distance <= reachThreshold):
		set_is_moving(false)
		newPosition = goToPosition
	
	position = newPosition
	pass

func set_is_moving(newIsMoving : bool) -> void:
	isMoving = newIsMoving
	if isMoving:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	pass
