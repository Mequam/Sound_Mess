extends Area2D

#this file is a pickup that gives the player health
func _ready():
	add_to_group("pickup")
	connect("body_entered",self,"edit_body")

#inteanded to be overloaded, edits the incoming body
func edit_body(body) -> void:
	print("picked up by " + body.name)
	queue_free()
