extends CharacterBody2D

@export var speed = 400
@export var reachThreshold = 10

#var currentDirection : Vector2 = Vector2.ZERO
var isMoving : bool = false
var navigation2DAgent : NavigationAgent2D = null
var targetPosition : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation2DAgent = $NavigationAgent2D
	targetPosition = global_position
	pass # Replace with function body.

func _process(delta: float) -> void:
	if (isMoving):
		update_position(delta)
	pass

func _input(event: InputEvent) -> void:
	if event.is_action("GoToPosition"):
		print("Is action GoToPosition ")
		set_is_moving(true)
		var map = get_world_2d().navigation_map
		var goToPosition = NavigationServer2D.map_get_closest_point(map, event.position)
		navigation2DAgent.target_position = goToPosition

func update_position(delta : float) -> void:
	#var direction : Vector2 = (navigation2DAgent.get_next_path_position() - position).normalized()
	#
	#var velocity : Vector2 = direction * speed
	#var newPosition : Vector2 = position + velocity * delta
#
	#if (navigation2DAgent.navigation_finished):
		#set_is_moving(false)
	#
	#position = newPosition
	pass

func _physics_process(delta: float) -> void:
	if (navigation2DAgent.is_navigation_finished()):
		set_is_moving(false)
		return
	
	var diff : Vector2 = navigation2DAgent.get_next_path_position() - global_position
	var dir : Vector2 = diff.normalized()
	velocity = dir * speed
	move_and_slide()
	pass

func set_is_moving(newIsMoving : bool) -> void:
	isMoving = newIsMoving
	if isMoving:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	pass
