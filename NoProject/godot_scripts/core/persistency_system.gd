class_name PersistencySystem
extends Node

## Persistency Class.
## Handles Game save and load.

#region METHODS
#region PUBLIC METHODS
## Note: This can be called from anywhere inside the tree. This function is
## path independent.
## Go through everything in the persist category and ask them to return a
## dict of relevant variables.
func save_game():
	var current_level_node = Game.static_get_current_level()
	if current_level_node == null:
		return
	var current_level_name = current_level_node.name
	
	var save_file_str = "user://"+Game.static_get_current_load_string()+".save"
	var nodes_data : Dictionary = {}
	var json_string : String = ""
	var save_file : FileAccess
	
	#if FileAccess.file_exists(save_file_str):
		#save_file = FileAccess.open(save_file_str, FileAccess.READ)
		#while save_file.get_position() < save_file.get_length():
			#json_string = save_file.get_line()
#
			# Creates the helper class to interact with JSON.
			#var json = JSON.new()
#
			# Check if there is any error while parsing the JSON string, skip in case of failure.
			#var parse_result = json.parse(json_string)
			#if not parse_result == OK:
				#print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				#continue
#
			# Get the data from the JSON object.
			#for jk in json.data.keys():
				#nodes_data[jk] = json.data[jk]
#
		##save_file.close()
	nodes_data = get_data_from_file(save_file_str)
	
	var slotlist_file_str = "user://saveslots.save"
	var slotlists_data : Dictionary = get_data_from_file(slotlist_file_str)
	slotlists_data["last_slot"] = Game.static_get_current_load_string()
	if !slotlists_data.has("slot_list"):
		slotlists_data["slot_list"] = {}

	if !slotlists_data["slot_list"].has(Game.static_get_current_load_string()):
		slotlists_data["slot_list"][Game.static_get_current_load_string()] = {}
		
	slotlists_data["slot_list"][Game.static_get_current_load_string()]["last_time"] = Time.get_time_string_from_system()
	slotlists_data["slot_list"][Game.static_get_current_load_string()]["current_level"] = Game.static_get_current_level().scene_file_path
	
	save_file = FileAccess.open(slotlist_file_str, FileAccess.WRITE)
	json_string = JSON.stringify(slotlists_data)
	save_file.store_line(json_string)
	save_file.close()

	save_file = FileAccess.open(save_file_str, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	var level_node_data : Array[Dictionary] = []
	for node in save_nodes:
		## Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		## Check the node has a save function.
		if !node.has_method("save"):
			DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		## Call the node's save function.
		var node_data = node.call("save")
		level_node_data.append(node_data)
	
	nodes_data[current_level_name] = level_node_data
	
	## JSON provides a static method to serialized JSON string.
	json_string = JSON.stringify(nodes_data)

	## Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	
## Note: This can be called from anywhere inside the tree. This function
## is path independent.
func load_game():
	var current_level_node = Game.static_get_current_level()
	if current_level_node == null:
		return
	var current_level_name = current_level_node.name
		
	var save_file_str = "user://"+Game.static_get_current_load_string()+".save"
	
	if not FileAccess.file_exists(save_file_str):
		return ## Error! We don't have a save to load.

	## Load the file line by line and process that dictionary to restore
	## the object it represents.
	var save_file = FileAccess.open(save_file_str, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		## Creates the helper class to interact with JSON.
		var json = JSON.new()

		## Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		## Get the data from the JSON object.
		var level_nodes_data : Dictionary = json.data
		var nodes_data : Array = []

		if level_nodes_data.has(current_level_name):
			if current_level_node as Level:
				current_level_node.startup_interactuables.clear()
			nodes_data = level_nodes_data[current_level_node.name]
			## We need to revert the game state so we're not cloning objects
			## during loading. This will vary wildly depending on the needs of a
			## project, so take care with this step.
			## For our example, we will accomplish this by deleting saveable objects.
			var save_nodes = get_tree().get_nodes_in_group("persist")
			for i in save_nodes:
				i.queue_free()
				await i.tree_exited
		
		for node_data in nodes_data:
			## Firstly, we need to create the object and add it to the tree and set its position.
			var new_object : Node = load(node_data["filename"]).instantiate()
			get_node(node_data["parent"]).add_child(new_object, true, INTERNAL_MODE_BACK)
			new_object.name = node_data["name"]
			new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

			## Now we set the remaining variables.
			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
					
				new_object._set(i, node_data[i])
			
			## Check the node has a save function.
			if !new_object.has_method("_finish_loading"):
				DebugManager.print_debug_line(DebugManager.DEBUG_LEVEL.INFO, "persistent node '%s' is missing a _finish_loading() function, skipped" % new_object.name)
				continue
			
			new_object.call("_finish_loading")
			
#endregion PUBLIC METHODS

#region STATIC METHODS
## Get data from file method.
static func get_data_from_file(file_str) -> Dictionary:
	var nodes_data : Dictionary = {}
	var save_file : FileAccess
	var json_string : String = ""
	if FileAccess.file_exists(file_str):
		save_file = FileAccess.open(file_str, FileAccess.READ)
		while save_file.get_position() < save_file.get_length():
			json_string = save_file.get_line()

			# Creates the helper class to interact with JSON.
			var json = JSON.new()

			# Check if there is any error while parsing the JSON string, skip in case of failure.
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue

			# Get the data from the JSON object.
			for jk in json.data.keys():
				nodes_data[jk] = json.data[jk]

		save_file.close()
	
	return nodes_data
#endregion STATIC METHODS
#endregion METHODS
