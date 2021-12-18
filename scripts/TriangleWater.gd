extends Spatial

var linear_function_variables : Array = [[[0.5,1]], #x terms
										[[0.5,1]],#z terms
										[[0.25,1,0,0]]] #x,z distance terms [1,1,2.5,0]
var time : float = 0
var width : int = 4
var height : int = 4
var triangleWaterParticle : PackedScene = preload("res://scenes/instance/TriangleWaterParticle.tscn")

func update():
	for node in get_children():
		node.set_derivative_rotation(linear_function_variables,time,0)
		node.set_position_from_terms(linear_function_variables,time)
		(node as TriangleWaterParticle).set_color_from_derivative(linear_function_variables,time)
func _ready():
	for i in range(-width/2,width/2):
		for j in range(-height/2,height/2):
			var inst : TriangleWaterParticle = triangleWaterParticle.instance() as TriangleWaterParticle
			inst.transform.origin[0] = i*2.5
			inst.transform.origin[2] = j*2.5
			add_child(inst)
func _process(delta):
	time += delta
	update()
