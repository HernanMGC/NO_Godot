extends CanvasLayer
class_name DebugLayer

@export var debug_layer_theme : Theme = null

func print_debug_line(debug_line : String, time_to_dissapear : float = 10.0, color : Color = Color.BLACK):
	print(debug_line)
	var label = Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.text = debug_line
	label.self_modulate = color
	$DebugLinesContainer.add_child(label)
	await get_tree().create_timer(time_to_dissapear).timeout
	label.queue_free()
