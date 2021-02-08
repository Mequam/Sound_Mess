extends "res://scripts/abstracts/save_state_node.gd"
#this script adds a death removal behavior to the parent, removing the parent
#from the game if they are saved as dead

#it is inteanded to be added to a node independent of it's other actions

#the default behavior is to serialize with existence
#so we add a true exists to our serialize behavoir
func serialize()-> Dictionary:
	var dict = .serialize()
	dict["exists"] = true
	return dict
#non default behavior inteanded to be called before death by the parent
#this function saves the state of the node as not existing and only not existing
#all other data is lost and the node is removed from the tree at the start of the next
#load
func save_death()->void:
	#saves at the path of the parent node, the fact that
	#the node no longer exists
	save_data_path_dict(get_save_path(),{"exists":false})

func load_data() -> void:
	#get the path that we are going to read from
	var path = get_save_path()
	var f = File.new()
	if (f.file_exists(path)):
		var loaded_dict = read_data_path(path)
		if (not loaded_dict.has("exists")) or not loaded_dict["exists"]:
			#if we are not supposed to exist, remove us from the tree
			get_parent().queue_free()
		else:
			#we do exist, pass behavior back to the parent class
			.load_data()

#when we are ready load the data
func _ready():
	load_data()
