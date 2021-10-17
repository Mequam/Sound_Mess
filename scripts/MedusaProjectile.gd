extends Projectile

#this is a medusa projectile that turns what it hits to stone
#note that it can hit the player or an enemy
#the movement behavior of this projectile is to be pulled twoards a target point

#how strong we are pulled twoards the target point
var pull_force : float = 500
#how fast we can move max
var terminal_velocity : float = 600

func _ready():
	#speed actually has very little effect on this class as our dir
	#is non normalized
	#still it can be used to speed up the movement of the particle
	speed = 1
#we hit the player
func gen_col_mask():
	return 0
func gen_col_layer():
	return 0

func on_hit(col : KinematicCollision2D,delta : float) -> void:
	if not (col.collider as Node2D).is_in_group("CentipideBoss") and col.collider.has_method("set_statue_frozen"):
		col.collider.set_statue_frozen(true)
	.on_hit(col,delta)
	queue_free()

const BEATS_UNTOUCHABLE = 8
const BEATS_ALIVE = 40

var inner_beat : int = 0
func run(player_pos,beat):
	match inner_beat:
		BEATS_UNTOUCHABLE:
			#we hit the player and whatever the parent hits
			collision_mask = .gen_col_mask() | col_math.Layer.PLAYER
			collision_layer = .gen_col_layer()
			#indicate to the player we will now be able to hit them
			modulate = Color.white
		BEATS_ALIVE:
			queue_free()
		_:
			#this should never happen but just in case
			if inner_beat > BEATS_ALIVE:
				queue_free()
	inner_beat += 1
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
