# CanvasLayer autoloaded class for debug print handle.
# It provides a static function to print debug lines both on log and screen.
extends CanvasLayer
class_name DebugLayer

# ENUMS
# Debug levels.
enum DEBUG_LEVEL {
	VERBOSE,
	INFO,
	WARNING,
	ERROR
}
# ENUMS - END

# EXPORT VARIABLES
# Debut layer theme for font and font size definitions among other settings.
@export var debug_layer_theme : Theme = null
# EXPORT VARIABLES - END

# VARIABLES
# Default debug level.
var default_debug_level = DEBUG_LEVEL.ERROR

# Current debug level.
var current_debug_level = DEBUG_LEVEL.ERROR
# VARIABLES - END

# METHODS
# Print debug line both in the log and screen if current debug level allows it
func print_debug_line(debug_level: DEBUG_LEVEL, debug_line : String, time_to_dissapear : float = 10.0, color : Color = Color.BLACK) -> void:
	if current_debug_level <= debug_level:
		print(debug_line)
		var label = Label.new()
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.text = debug_line
		label.self_modulate = color
		$DebugLinesContainer.add_child(label)
		await get_tree().create_timer(time_to_dissapear).timeout
		label.queue_free()
# METHODS - END
