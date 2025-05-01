class_name PlayerCharacter
extends CharacterBody2D

## Player Character Class.
## It handles all player interaction and movement.

#region ENUMS
## Player interaction intention state.
enum PLAYER_INTENTION_STATE {
	INVALID,
	STARTING,
	MOVING_TO,
	ONGOING,
	FINISHED
}
#endregion ENUMS

#region CLASSES
#region CLASS - PlayerIntention
## CLASS: PlayerIntention
## Player Intention class that stores the interactuable the player intents to
## interact with, the position the interactuable needs the player to be, and its
## current state.
class PlayerIntention:
	#region VARIABLES
	#region PRIVATE VARIABLES
	## Interactuable to interact with.
	var _interactuable : Interactuable = null
	
	## Interactuable desired position for player.
	var _go_to_position : Vector2 = Vector2(0.0, 0.0)
	
	## Interaction intention state.
	var _state : PLAYER_INTENTION_STATE = PLAYER_INTENTION_STATE.INVALID
	#region PRIVATE VARIABLES
	#region VARIABLES
		
	#region METHODS
	#region PUBLIC METHODS
	## Returns the Player Intention's Interactuable
	func get_interactuable() -> Interactuable:
		return _interactuable
		
	## Returns the Player Intention's go to position.
	func get_go_to_position() -> Vector2:
		return _go_to_position
		
	## Returns the Player Intention's current state.
	func get_state() -> PLAYER_INTENTION_STATE:
		return _state
	
	## Invalidates Player Intention, and resets Interactuable and Position.
	func invalidate() -> void:
		_interactuable = null
		_go_to_position = Vector2(0.0, 0.0)
		_state = PLAYER_INTENTION_STATE.INVALID
		
	## Setups the Player Intention by setting the Interactuable, the player's
	## desired Position and the Intention State.
	func setup(new_go_to_position : Vector2, new_interactuable : Interactuable) -> void:
		_interactuable = new_interactuable
		_go_to_position = new_go_to_position
		_state = PLAYER_INTENTION_STATE.STARTING

	## Sets Player Intention State to MOVING_TO.
	func start_moving() -> void:
		_state = PLAYER_INTENTION_STATE.MOVING_TO

	## Starts Interacntion, if there is a valid Interactuable set Player 
	## Intention State as ONGOING, otherwise set it as FINISHED.
	func start_interaction() -> void:
		if _interactuable:
			_state = PLAYER_INTENTION_STATE.ONGOING
		else:
			_state = PLAYER_INTENTION_STATE.FINISHED
	#endregion PUBLIC METHODS
	#endregion METHODS
#endregion CLASS - PlayerIntention
#endregion CLASSES

#region VARIABLES
#region EXPORT VARIABLES
## Player Character movement speed.
@export var speed = 100
#endregion EXPORT VARIABLES

#region PUBLIC VARIABLES
## Navigation 2D Agent.
var _navigation_2d_agent : NavigationAgent2D = null

## Current Player Intention.
var _current_player_intention : PlayerIntention = PlayerIntention.new()

## Input disabling count. As long as this value is greater than ZERO, the Player
## won't be able to move.
var _input_disabled_count : int = 0
#endregion PUBLIC VARIABLES

#region METHODS
#region PUBLIC METHODS
## Returns input_enabled state. If input_disabled_count is lesser or equal to
## ZERO, input is enabled. 
func is_input_enabled() -> bool:
	return _input_disabled_count <= 0
	
## Teleports player to Player Start position.
func move_to_player_start(player_start : PlayerStart) -> void:
	if player_start:
		global_position = player_start.global_position
		
## Adds/removes input disabling counter on input disabled/enabled.
func set_input_enable(new_input_enabled : bool) -> void:
	DebugManager.print_debug_line(DebugLayer.DEBUG_LEVEL.INFO, "ENTER CHAR_Player:set_input_enable(%s) input_disabled_count = %s" % [str(new_input_enabled), str(_input_disabled_count)])
	if new_input_enabled:
		_input_disabled_count = maxi(0, _input_disabled_count - 1)
	else:
		_input_disabled_count += 1
	DebugManager.print_debug_line(DebugLayer.DEBUG_LEVEL.INFO, "LEAVE CHAR_Player:set_input_enable(%s) input_disabled_count = %s" % [str(new_input_enabled), str(_input_disabled_count)])
#endregion PUBLIC METHODS

#region PRIVATE METHODS
## Called when the node enters the scene tree for the first time.
## OVERRIDEN TO: Store a reference to NavigationAgent2D Node.
func _ready() -> void:
	_navigation_2d_agent = $NavigationAgent2D
	pass ## Replace with function body.

## OVERRIDEN TO: Handle input. In this case get the click point in the screen and
## setups a player intention. If there is an Interactuable get the position from
## its configuration, otherwhise set the position as the closest one to the
## clicked point inside the navigation area. 
func _input(event: InputEvent) -> void:
	## If input is not enabled do an early return. 
	if (!is_input_enabled()):
		return
	
	if event.is_action("save_game"):
		GamePersistencySystem.save_game()
	
	elif event.is_action("load_game"):
		GamePersistencySystem.load_game()
	
	# Handles event for "go_to_position" action. 
	# ToDo: Maybe move this to isolate function
	elif event.is_action("go_to_position"):
		var go_to_position : Vector2 = global_position
		var interactuable : Interactuable = null
	
		# Finds the intersecting point for the click.
		var pp = PhysicsPointQueryParameters2D.new()
		pp.collide_with_areas = true 
		pp.position = event.position
		var intersectedNodes =  get_world_2d().direct_space_state.intersect_point(pp, 1)
		
		# ToDo: Check If's nesting. It seems that this may cause some issues if
		# it intersects with some node that is not an Interactuable
		# If there is an interacting Node and it is an Interactuable get its
		# player desired position and assigns it to go_to_position to setup
		# current PlayerIntention.
		if intersectedNodes:
			if intersectedNodes[0].collider is Interactuable:
				interactuable = intersectedNodes[0].collider
				DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "_input: interactuable position %s" % str(interactuable.get_relative_goto_location()))
				DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "_input: interactuable player marker position %s" % str(interactuable.get_relative_goto_location() + interactuable.position))
				go_to_position = (interactuable.get_relative_goto_location() + interactuable.position)

		# Else gets closest point in the map and assigns it to go_to_position
		else:
			var map = get_world_2d().navigation_map
			go_to_position = NavigationServer2D.map_get_closest_point(map, event.position)
	
		# Setups current Player Intention and start player's movement
		_current_player_intention.setup(go_to_position, interactuable)
		_start_player_move_to()

## OVERRIDEN TO: Update player position and state:
##	If Player is MOVING_TO, has reached its destination:
##		· Starts Interaction, connects Interactuable's all_interaction_finished 
##		signal to _on_interaction_finished and do an early return.
##	Ff Player is MOVING_TO and has NOT reached its destination:
##		· Moves it according to its current position, go_to_position, and 
##		_delta.
##	If Player Intention has FINISHED:
##		· Finishes Player's Interaction
func _physics_process(_delta: float) -> void:
	if (_current_player_intention.get_state() == PLAYER_INTENTION_STATE.MOVING_TO):
		if (_navigation_2d_agent.is_navigation_finished()):
			var interactuable : Interactuable = _current_player_intention.get_interactuable()
			$AnimatedSprite2D.animation_finished.connect(_on_walk_stop_finished)
			$AnimatedSprite2D.set_animation("walk_stop")
			$AnimatedSprite2D.play()
			if (interactuable):
				DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "_physics_process interactuable %s" % interactuable.name)
				interactuable.all_interaction_finished.connect(_on_current_interaction_finished)
				interactuable.interact()
			
			_start_player_interaction()
			return
		
		var diff : Vector2 = _navigation_2d_agent.get_next_path_position() - global_position
		var dir : Vector2 = diff.normalized()
		velocity = dir * speed
		move_and_slide()
		
	if (_current_player_intention.get_state() == PLAYER_INTENTION_STATE.FINISHED):
		_finish_player_interaction()

## Starts player movement to current Player Intention's Go To Position
func _start_player_move_to() -> void:
	# Gets relative Go To Position and uses it to determine sprite facing 
	# direction
	_navigation_2d_agent.target_position = _current_player_intention.get_go_to_position()
	var direction = global_position.x - _navigation_2d_agent.target_position.x
	if direction > 0:
		$AnimatedSprite2D.scale.x = 1
	elif direction < 0:
		$AnimatedSprite2D.scale.x = -1
	
	# Starts movement and plays movement animation
	_current_player_intention.start_moving()
	$AnimatedSprite2D.animation_finished.connect(_on_walk_start_finished)
	$AnimatedSprite2D.set_animation("walk_start")
	$AnimatedSprite2D.play()
	
func _on_walk_start_finished():
	$AnimatedSprite2D.animation_finished.disconnect(_on_walk_start_finished)
	$AnimatedSprite2D.animation = "walk"
	$AnimatedSprite2D.play()
	
func _on_walk_stop_finished():
	$AnimatedSprite2D.animation_finished.disconnect(_on_walk_stop_finished)
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()

## Stops sprite animation and starts interaction.
func _start_player_interaction() -> void:
	#$AnimatedSprite2D.stop()
	_current_player_intention.start_interaction()
		
## Finishes interaction by disconnection _on_interaction_finished to current
## Interactuable's all_interaction_finished signal and invalidate current Player
## Intention.
func _finish_player_interaction() -> void:
	if (_current_player_intention.get_interactuable()):
		_current_player_intention.get_interactuable().all_interaction_finished.disconnect(_on_current_interaction_finished)
	_current_player_intention.invalidate()

## Calls for finish player interaction on Interactuables all_interaction_finished
## signal.
func _on_current_interaction_finished() -> void:
	_finish_player_interaction()
#endregion METHODS - END
