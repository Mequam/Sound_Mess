extends KinematicBody2D
#this script runs the movement for the 
#carrots that fall from the sky and then become corrupted

#these carrots move in a constant direction,
#until they either hit an enviorment obsticle (e.g. world border)
#or the animation stops

#when the animation stops a carrot is spawned and this 
#instance is removed from the secene 

#emmited when we spawn the carrot and remove ourselfs from
#the scene, passes the instance of the carrot as an argument
signal spawning_carrot

#the direction that we move, encapsulated to be normalized
var move_vec : Vector2 setget set_move_vec,get_move_vec
func set_move_vec(val : Vector2) -> void:
	move_vec = val.normalized()
func get_move_vec() -> Vector2:
	return move_vec
#the speed that we move at
var speed = 40

var corruptableCarrot = preload("res://scenes/instance/entities/enemies/evil_carrot.tscn")  

func fall() -> void:
	$FallingCarrotSprite/AnimationPlayer.play("Fall",-1,0.75)
func _ready():
	$FallingCarrotSprite/AnimationPlayer.connect("animation_finished",self,"anim_finished")
#used to tell when we "hit the ground"
func anim_finished(anim):
	var carrot = corruptableCarrot.instance()
	emit_signal("spawning_carrot",carrot)
	#add them to the tree
	print("[falling carrot] " + get_tree().get_root().get_child(2).name)
	get_tree().get_root().get_child(2).add_child(carrot)
	#set their position to our position
	carrot.position = position
	#corrupt the carrot
	carrot.corrupt()
	#remove ourselfs
	queue_free()
func _process(delta):
	move_and_collide(move_vec*delta*speed)
