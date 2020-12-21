extends Node
#this node serves as the most generic form of a node designed
#to save the state of it's parent to the file system for later use

#this function is inteanded to be overloaded by child classes of
#this class to get a dictionary of data that we care about from the parent
func serialize() -> Dictionary:
	return {}
#gets the path which we are going to store information at
func get_save_path() -> String:
	#get the path that this particular node will save to
	return "user://game" + get_game_save_file() +"/"+ owner.name +"-" + get_parent().name + ".dat"
func get_game_save_file() -> String:
	return str(Globals.game_save_id)
#saves the data at the custom created path
#syntactic sugar
func save_data() -> void:
	save_data_path(get_save_path())
#saves the data to the given path
func save_data_path(save_path : String) -> void:
	var fileRes = File.new()
	print("[save state node] opening at " + save_path)
	if OK == fileRes.open(save_path,File.WRITE):
		#store the data as json
		fileRes.store_string(JSON.print(serialize()))
	else:
		print("[save state node] not ok!")
#reads the data at the path from our get_save_path function
#syntactic sugar
func read_data() -> Dictionary:
	return read_data_path(get_save_path())
#reads the data at the given path
func read_data_path(load_path : String) -> Dictionary:
	var fileRes = File.new()
	if fileRes.file_exists(load_path):
		#attempt to open the file properly
		if OK == fileRes.open(load_path,File.READ):
			#parse the string stored inside the file
			var json_res = JSON.parse(fileRes.get_as_text())
			if json_res.error == OK and json_res.result is Dictionary:
				return json_res.result
	#TODO: this needs better error handling
	return {}
#loads the data into the parent from the parents calculated
#path, syntactic sugar
func load_data() -> void:
	load_data_path(get_save_path())
#loads the data into the parent from the given path
func load_data_path(load_path : String) -> void:
	var read_data = read_data_path(load_path)
	var parent = get_parent()
	#we paresed out a dictionary
	for key in read_data:
		parent.set(key,read_data[key])
