extends "res://scripts/abstracts/generic_boss.gd"

#how fast we move
var movement_speed : float = 300

#the direction we move in
var velocity : Vector2 = Vector2(0,0) setget set_velocity,get_velocity
func set_velocity(val : Vector2):
	velocity = val.normalized()
func get_velocity()->Vector2:
	return velocity

#takes a mode and a velocity and updates the sprite
func update_sprite(mode : String,vel : Vector2):
	if abs(vel.x) > abs(vel.y):
		$YSort/Sprite/AnimationPlayer.play("IdleSide")
	else:
		$YSort/Sprite/AnimationPlayer.play("Idle")
#this script represents the behavior for the centipide statue boss
func main_ready():
	.main_ready()
	set_mode("Idle")

func set_mode(val : String)->void:
	.set_mode(val)
func run(player_pos : Vector2,beat):
	match mode:
		"Idle":
			#randomly assign accelleration
			_angular_accel = randf()*PI-PI/2
			if player_pos.distance_squared_to(position) > 250000:
				velocity = (player_pos-position).normalized()*movement_speed

#gets a cardinal direction from a vector
enum CARDINAL {UP,DOWN,LEFT,RIGHT}
func get_cardinal(dir : Vector2)->int:
	if abs(dir.x) >= abs(dir.y):
		if dir.x > 0:
			return CARDINAL.RIGHT
		return CARDINAL.LEFT
	if dir.y > 0:
		return CARDINAL.DOWN
	return CARDINAL.UP
#returns a string reminicent of a cardinal direction
#for use with animation names
func get_cardinal_str(card : int)->String:
	match card:
		CARDINAL.RIGHT:
			return "Side"
		CARDINAL.UP:
			return ""
		CARDINAL.DOWN:
			return "Back"
	return "Side"
#plays a given animation
func play_anim(player_pos : Vector2 = Vector2(0,0))->void:
	var cardStr : String = get_cardinal_str(get_cardinal(velocity))
	$Sprite/AnimationPlayer.play(mode + cardStr)
	$Sprite/AnimationPlayerHead.play(mode + cardStr)
	var cardinal : int = get_cardinal(velocity)
	if cardinal == CARDINAL.RIGHT or cardinal == CARDINAL.LEFT:
		$Sprite/assets/body/LegsSprite/AnimationPlayer.play("Side_Run")
	else:
		$Sprite/assets/body/LegsSprite/AnimationPlayer.play("Run")

	#orientate the sprite properly
	if get_cardinal(velocity) == CARDINAL.RIGHT:
		$Sprite/assets.scale.x = -1*abs($Sprite/assets.scale.x)
	else:
		$Sprite/assets.scale.x = abs($Sprite/assets.scale.x)

#the rate of change of our velocity angle
#used to meander around
var _angular_accel : float = 0
#the current rate of change of our velocity angle used to save state
#as apposed to time and squared velocity so we can rely on the delta in the 
#process function
var _angular_vel : float = 0 
const MAX_ANGULAR_VELOCITY_MAGNITUDE = PI/2


func _process(delta):
	match mode:
		"Idle":
			#get the angular velocity
			_angular_vel += _angular_accel*delta
			#cap our velocity
			if abs(_angular_vel) > MAX_ANGULAR_VELOCITY_MAGNITUDE:
				_angular_vel = MAX_ANGULAR_VELOCITY_MAGNITUDE*sign(_angular_vel)
			#get the angular position
			var new_angle : float = velocity.angle()+_angular_vel*delta
			
			#buffer the old velocity for comparisons
			var old_vel : Vector2 = velocity
			
			velocity = Vector2(cos(new_angle),sin(new_angle))
			
			#update our animation if necessary
			if get_cardinal(old_vel) != get_cardinal(velocity):
				play_anim()
		
			
			#move
			position += velocity*movement_speed*delta
