# Resource class for Player Start Definition.
# It relates a Level Resource Path the player cames from to a PlayerStart the
# player travels to.
extends Resource
class_name PlayerStartDefinition

# EXPORT VARIABLES
# Level Resource Path the player cames from. DISCLAIMER. There is NO path 
# validation check.
@export var level_from_path : String = ""

# Node Path for the Player Start Node. DISCLAIMER. There is NO Node type check.
@export var player_start : NodePath
# EXPORT VARIABLES - END
