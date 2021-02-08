extends Node2D
#this script pulls the players camara to it's position and emits a signal when
#finished

#the speed at which we pull the camara
var speed : float = 400
#reference to the camara we pull, null means not pulling
var cam : Camera2D = null

signal camara_arrived
signal pulling_camara

#pull the camara to the given position
func pull_camara(toPull : Camera2D):
	#store a reference to the camara that we are going to move
	cam = toPull
	emit_signal("pulling_camara",cam)
#syntactic sugar to pull the players camara to the desired position
func pull_player():
	pull_camara(get_tree().get_nodes_in_group("player")[0].get_node("Camera2D"))
func _process(delta):
	if cam != null:
		cam.global_position += (global_position-cam.global_position)/2
		var distance_squared = cam.global_position.distance_squared_to(global_position)
		if distance_squared < 0.04:
			#clear out the reference
			emit_signal("camara_arrived",cam)
			cam = null
