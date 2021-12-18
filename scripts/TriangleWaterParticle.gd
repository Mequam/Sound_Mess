extends Spatial

class_name TriangleWaterParticle

#takes the terms of a wave function in the form A*sin(x+bt) and returns the derivative
#where the terms are encoded [[A,b],[A2,b2]...[An,bn]],[A,b],[A2,b2]...[An,bn]],[[a,b,h,k],[a2,b2,h2,k2]...[an,bn,hn,kn]]

func linear_deriv(terms : Array,time : float,dir : int = 0)->float:
	var ret_val : float = 0.0
	for t in terms:
		ret_val += t[0]*cos(transform.origin[dir]+time*t[1])
	return ret_val
#[a,b,h,k]
func distance_deriv(terms : Array,time : float,chord_a : int = 0,chord_b : int = 0,first : bool = true)->float:
	var ret_val : float = 0.0
	for t in terms:
		var dist : float = distance(chord_a-t[2],chord_b-t[3])
		if dist == 0.0:
			return 0.0
		var term : float = (chord_a-t[2]) if first else (chord_b-t[3])
		ret_val += t[0]*cos(dist+time*t[1])*term/dist
	return ret_val

func distance(a : float,b : float)->float:
	return sqrt(a*a+b*b)
func clear_rotation()->void:
	transform.basis.x = Vector3(1,0,0)
	transform.basis.y = Vector3(0,1,0)
	transform.basis.z = Vector3(0,0,1)
func eval_linear_term(term : Array,chord : float,time : float)->float:
	return term[0]*sin(chord + term[1]*time)
func eval_linear_term_set(terms : Array,chord : float,time : float)->float:
	var ret_val : float = 0.0
	for t in terms:
		ret_val += eval_linear_term(t,chord,time)
	return ret_val
func eval_distance(term : Array,chord_a : float, chord_b : float,time : float)->float:
	return term[0]*sin(distance(chord_a-term[2],chord_b-term[3])+time*term[1])
func eval_distance_terms(terms : Array,chord_a : float, chord_b : float,time : float)->float:
	var ret_val : float = 0.0
	for term in terms:
		ret_val += eval_distance(term,chord_a,chord_b,time)
	return ret_val
#returns the y value for the given time of the given terms
func get_position(terms : Array,time : float)->float:
	return eval_linear_term_set(terms[0],transform.origin[0],time) + eval_linear_term_set(terms[1],transform.origin[2],time)+eval_distance_terms(terms[2],transform.origin[0],transform.origin[1],time)
func set_position_from_terms(terms : Array,time : float):
	transform.origin[1] = get_position(terms,time)
func set_derivative_rotation(terms : Array,time : float,dir : int = 0):
	transform.basis.x = Vector3(1,linear_deriv(terms[0],time,0)+distance_deriv(terms[2],time,transform.origin[0],transform.origin[2]),0).normalized()
	transform.basis.z = Vector3(0,linear_deriv(terms[1],time,2)+distance_deriv(terms[2],time,transform.origin[0],transform.origin[2],false),1).normalized()
	transform.basis.y = transform.basis.z.cross(transform.basis.x)
func set_color_from_derivative(terms : Array,time : float)->void:
	var angle = atan2(1,linear_deriv(terms[1],time,2)+distance_deriv(terms[2],time,transform.origin[0],transform.origin[2],false))/(2*PI)
	var angle2 = angle*angle*angle*angle*angle
	angle = 1-angle
	angle = angle*angle*angle*angle*angle
	$equil_triangle/Torus.material_override.albedo_color = Color(0,255,255)*angle2+Color(0,0,255)*angle
	print(Color(0,255,255)*angle2+Color(0,0,255)*angle)
func _ready():
	#set our new spatial material
	$equil_triangle/Torus.material_override = SpatialMaterial.new()
	$equil_triangle/Torus.material_override.albedo_color = Color.blue
	($equil_triangle/Torus.material_override as SpatialMaterial).flags_unshaded = true
