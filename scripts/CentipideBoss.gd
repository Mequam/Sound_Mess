extends "res://scripts/abstracts/generic_boss.gd"

#how fast we move
var movement_speed : float = 100

#the direction we move in
var velocity : Vector2 = Vector2(0,0) setget set_velocity,get_velocity
func set_velocity(val : Vector2):
	velocity = val.normalized()
func get_velocity()->Vector2:
	return velocity

#takes a mode and a velocity and updates the sprite
func update_sprite(mode : String,vel : Vector2):
	if abs(vel.x) > abs(vel.y):
		$Sprite/AnimationPlayer.play("IdleSide")
	else:
		$Sprite/AnimationPlayer.play("Idle")
#this script represents the behavior for the centipide statue boss
func main_ready():
	pass
func run(player_pos : Vector2,beat):
	set_velocity(player_pos-position)
func _process(delta):
	position += velocity*movement_speed
