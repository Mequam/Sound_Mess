extends Projectile

#this is a medusa projectile that turns what it hits to stone
#note that it can hit the player or an enemy
#the movement behavior of this projectile is to be pulled twoards a target point

#how strong we are pulled twoards the target point
var pull_force : float = 400
#how fast we can move max
var terminal_velocity : float = 500

func _ready():
	#speed actually has very little effect on this class as our dir
	#is non normalized
	#still it can be used to speed up the movement of the particle
	speed = 1
#we hit the player
func gen_col_mask():
	return col_math.Layer.PLAYER | .gen_col_mask()
func on_hit(col : KinematicCollision2D,delta : float) -> void:
	col.collider.set_statue_frozen(true)
	.on_hit(col,delta)
	queue_free()

#gets the point that we are pulled to
#in this class its just the player position, but in others we could
#overide to target other stuff
func get_target_point()->Vector2:
	return Globals.get_scene_root().get_node("player").position

func _process(delta):
	#the direction of force
	var force_dir = (get_target_point()-position).normalized()
	
	#in this class we use dir as velocity
	#so it doesnt spend all its days normalized
	#the parent classes _process actually applies dir as a velocity to the object
	dir += force_dir*pull_force*delta
	if dir.length_squared() > terminal_velocity*terminal_velocity:
		dir = dir.normalized()*terminal_velocity
