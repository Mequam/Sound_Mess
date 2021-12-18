extends Projectile
#this class is a projectile that spawns a node into the game on death

class_name SpawnProjectile
var to_spawn : Enemy = null

func gen_col_layer()->int:
	collision_layer = 0
	return 0
func gen_col_mask()->int:
	collision_mask = 0
	return 0

signal on_spawn

var spawn_animation : String = "Spawn"

func _ready():
	#start the death animation
	$DeathAnimation.play("emit")
	print(dir)
	speed = 400

#spawns the to_spawn node that is our child
func spawn_enemy()->void:
	if to_spawn:
		#tell the node to run its animation when it is ready
		if to_spawn.get_node("AnimationPlayer"):
			to_spawn.connect("ready",to_spawn.get_node("AnimationPlayer"),"play",[spawn_animation])
		if to_spawn is CorruptableEnemy:
			to_spawn.connect("ready",to_spawn,"corrupt")

		get_parent().add_child(to_spawn)
		to_spawn.position = position
		emit_signal("on_spawn",to_spawn)

#overload the queue_free function to spawn our child on death
func queue_free():
	if to_spawn:
		spawn_enemy()
	.queue_free()
#we spawn the entity when we hit an enemy
#func on_hit(col : KinematicCollision2D,delta : float) -> void:
#	.on_hit(col,delta)

#if we are playing our death animation finish when the animation finishes
func _on_DeathAnimation_animation_finished(anim_name):
	if anim_name == "emit":
		queue_free()

func _process(delta):
	print(dir)
