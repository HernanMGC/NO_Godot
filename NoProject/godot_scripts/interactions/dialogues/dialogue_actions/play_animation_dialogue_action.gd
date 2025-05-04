class_name PlayAnimationDialogueAction
extends AbsDialogueActionResource

## Class for play animation for a node pass by export varaible.

#region VARIABLES
#region EXPORT PUBLIC VARIABLES
 ## Node path for the node that will play the animation.
@export var node_path : NodePath

## Animation name to play.
@export var animation_name : String
#endregion EXPORT PUBLIC VARIABLES
#endregion VARIABLES

#region METHODS
#region PUBLIC METHODS
## Executes dialogue action and play node_path animation.
func _execute_action() -> void:
	var anim_node : Node = interactuable.get_node(node_path)
	if anim_node:
		var child_nodes : Array[Node] = anim_node.find_children("*", "AnimationPlayer", true, true)
		if !child_nodes.is_empty():
			var anim_player : AnimationPlayer = child_nodes[0]
			anim_player.play(animation_name)
	return 
#endregion PUBLIC METHODS
#endregion METHODS
