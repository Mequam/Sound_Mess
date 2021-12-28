extends Node
#this node serves as the most generic form of a node designed
#to save the state of it's parent to the file system for later use

class_name SaveStateNode

#this function is inteanded to be overloaded by child classes of
#this class to get a dictionary of data that we care about from the parent
func serialize() -> Dictionary:
	return {}
#gets the path which we are going to store information at
func get_save_path() -> String:
	#cache the parent
	var parent = get_parent()
	if (parent and parent.owner):
		#get the path that this particular node will save to
		return "user://game" + get_game_save_file() +"/"+ parent.owner.name +"-" + parent.name + ".dat"
	else:
		return ""
func get_game_save_file() -> String:
	return str(Globals.game_save_id)
#saves the data at the custom created path
#syntactic sugar
func save_data() -> void:
	save_data_path(get_save_path())
#saves the data to the given path converted from the parent, syntactic sugar
func save_data_path(save_path : String) -> void:
	#the serialize function is supposed to be overloaded to convert
	#the parent to a dictionary
	save_data_path_dict(save_path,serialize())
#saves the data from the given dictionary at the given path
func save_data_path_dict(save_path : String, dict : Dictionary) -> void:
	var fileRes = File.new()
	if OK == fileRes.open(save_path,File.WRITE):
		#store the data as json
		fileRes.store_string(JSON.print(dict))
	else:
		print("[WARNING] save save_data_path_dict unable to open file! save path: " + str(save_path))
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
#syntactic sugar function that loads the data from the given path into the parent
func load_data_path(load_path : String) -> void:
	load_data_dictionary(read_data_path(load_path))
#loads the given dictionary into the parent
func load_data_dictionary(dict : Dictionary) -> void:
	load_data_dict_node(dict,get_parent())
#loads the given dictionary into the given node
func load_data_dict_node(dict : Dictionary, ref : Node) -> void:
	#store the properties in the dictionary in the parent
	for key in dict:
		ref.set(key,dict[key])
