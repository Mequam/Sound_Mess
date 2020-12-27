extends Area2D

#this file is a pickup that gives the player health
func _ready():
	#check to see if we are not supposed to be here
	$save_state_node.load_data()
	add_to_group("pickup")
	connect("body_entered",self,"edit_body")

#inteanded to be overloaded, edits the incoming body
func edit_body(body) -> void:
	#save the fact that we are dead
	$save_state_node.save_death()
	#remove ourselfs from the tree
	queue_free()
