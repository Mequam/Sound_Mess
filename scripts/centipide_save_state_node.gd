extends BossSaveStateNode

#because of some quirks with the centipide tail we care about the parent of a parent
#and not just the parent in pathing
#so for geting the save path we have to use the parent parents name not the parents

class_name CentipideSaveState

#gets the path which we are going to store information at
func get_save_path() -> String:
	#cache the parent
	var parent = get_parent().get_parent()
	if (parent and parent.owner):
		print("returning path")
		#get the path that this particular node will save to
		return "user://game" + get_game_save_file() +"/"+ parent.owner.name +"-" + parent.name + ".dat"
	else:
		print("not returning path")
		return ""
func save_death()->void:
	print("saving death")
	.save_data()
