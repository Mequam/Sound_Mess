extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func anim_look_top_right():
	get_node("eye_top_right").position.x += 8.7
	get_node("eye_top_left").position.x += 8.7
func anim_look_top_left():
	get_node("eye_top_left").position.x -= 8.7
	get_node("eye_top_right").position.x -= 8.7
func anim_look_bottom_right():
	get_node("eye_bottom_right").position.x += 8.7
	get_node("eye_bottom_left").position.x += 8.7
func anim_look_bottom_left():
	get_node("eye_bottom_right").position.x -= 8.7
	get_node("eye_bottom_left").position.x -= 8.7

func anim_look_center():
	get_node("eye_bottom_left").position.x = -10.26
	get_node("eye_bottom_right").position.x = 10.792
	get_node("eye_top_right").position.x = 10.941
	get_node("eye_top_left").position.x = -12.577

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
