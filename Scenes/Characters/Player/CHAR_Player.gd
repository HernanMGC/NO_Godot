extends CharacterBody2D

enum PLAYER_INTENTION_STATE {INVALID, STARTING, MOVING_TO, ONGOING, FINISHED}

class PlayerIntention:
	var go_to_position : Vector2 = Vector2(0.0, 0.0)
	var state : PLAYER_INTENTION_STATE = PLAYER_INTENTION_STATE.INVALID
	var interactuable : Interactuable = null
	
	func get_interactuable() -> Interactuable:
		return interactuable
		
	func get_state() -> PLAYER_INTENTION_STATE:
		return state
	
	func invalidate() -> void:
		go_to_position = Vector2(0.0, 0.0)
		interactuable = null
		state = PLAYER_INTENTION_STATE.INVALID
		
	func setup(new_go_to_position : Vector2, new_interactuable : Interactuable):
		go_to_position = new_go_to_position
		interactuable = new_interactuable
		state = PLAYER_INTENTION_STATE.STARTING

	func start_moving():
		state = PLAYER_INTENTION_STATE.MOVING_TO

	func start_interaction():
		if interactuable:
			state = PLAYER_INTENTION_STATE.ONGOING
		else:
			state = PLAYER_INTENTION_STATE.FINISHED

@export var speed = 400

#var currentDirection : Vector2 = Vector2.ZERO
var navigation_2d_agent : NavigationAgent2D = null
var current_player_intention : PlayerIntention = PlayerIntention.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_2d_agent = $NavigationAgent2D
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action("go_to_position"):
		var go_to_position : Vector2 = global_position
		var interactuable : Interactuable = null
		
		var pp = PhysicsPointQueryParameters2D.new()
		pp.collide_with_areas = true 
		pp.position = event.position
		var intersectedNodes =  get_world_2d().direct_space_state.intersect_point(pp, 1)
		if intersectedNodes:
			if intersectedNodes[0].collider is Interactuable:
				interactuable = intersectedNodes[0].collider
				print(interactuable.relative_goto_location)
				print((interactuable.relative_goto_location + interactuable.position))
				go_to_position = (interactuable.relative_goto_location + interactuable.position)

		else:
			var map = get_world_2d().navigation_map
			go_to_position = NavigationServer2D.map_get_closest_point(map, event.position)
	
		current_player_intention.setup(go_to_position, interactuable)
		start_player_move_to()
		
func start_player_move_to() -> void:
	navigation_2d_agent.target_position = current_player_intention.go_to_position
	current_player_intention.start_moving()
	$AnimatedSprite2D.play()
		
func start_player_interaction() -> void:
	$AnimatedSprite2D.stop()
	current_player_intention.start_interaction()
		
func finish_player_interaction() -> void:
	if (current_player_intention.interactuable):
		current_player_intention.interactuable.interaction_finished.disconnect(_on_interaction_finished)
	current_player_intention.invalidate()

func _physics_process(_delta: float) -> void:
	if (current_player_intention.get_state() == PLAYER_INTENTION_STATE.MOVING_TO):
		if (navigation_2d_agent.is_navigation_finished()):
			var interactuable : Interactuable = current_player_intention.get_interactuable()
			if (interactuable):
				print(interactuable.name)
				interactuable.interaction_finished.connect(_on_interaction_finished)
				interactuable.interact()
			
			start_player_interaction()
			return
		
		var diff : Vector2 = navigation_2d_agent.get_next_path_position() - global_position
		var dir : Vector2 = diff.normalized()
		velocity = dir * speed
		move_and_slide()
		
	if (current_player_intention.get_state() == PLAYER_INTENTION_STATE.FINISHED):
		finish_player_interaction()

func _on_interaction_finished() -> void:
	finish_player_interaction()
