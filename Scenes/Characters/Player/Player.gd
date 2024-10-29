extends CharacterBody2D

@export var speed = 400

#var currentDirection : Vector2 = Vector2.ZERO
var is_moving : bool = false
var navigation_2d_agent : NavigationAgent2D = null
var target_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_2d_agent = $NavigationAgent2D
	target_position = global_position
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action("go_to_position"):
		print("Is action go_to_position ")
		set_is_moving(true)
		var map = get_world_2d().navigation_map
		var go_to_position = NavigationServer2D.map_get_closest_point(map, event.position)
		navigation_2d_agent.target_position = go_to_position

func _physics_process(_delta: float) -> void:
	if (navigation_2d_agent.is_navigation_finished()):
		set_is_moving(false)
		return
	
	var diff : Vector2 = navigation_2d_agent.get_next_path_position() - global_position
	var dir : Vector2 = diff.normalized()
	velocity = dir * speed
	move_and_slide()
	pass

func set_is_moving(new_is_moving : bool) -> void:
	is_moving = new_is_moving
	if is_moving:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	pass
