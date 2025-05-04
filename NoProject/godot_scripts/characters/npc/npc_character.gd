class_name NPCCharacter
extends CharacterBody2D

## Base class for NPCs. It will just play animations on events.

#region ONREADY PUBLIC VARS
## Animation Player reference.
@onready var animation_player : AnimationPlayer = $AnimatedSprite2D/AnimationPlayer
#endregion ONREADY PUBLIC VARS

#region PUBLIC METHOD
func play_animation(anim_name: String):
	animation_player.play(anim_name)
#endregion PUBLIC METHOD
