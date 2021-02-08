extends "res://scripts/abstracts/corruptable_enemy.gd"
var death_particles = preload("res://scenes/assets/BossParticles.tscn")

func die():
	#spawn in the death particles
	var d_inst = death_particles.instance()
	d_inst.position = position+Vector2(0,1)
	get_parent().add_child(d_inst)
	
	#do not remove us from the tree, instead set our mode to dead 
	mode = "dead"
	$Sprite/AnimationPlayer.play("Die")
	remove_from_group("enemies")
	emit_signal("die")
	#save our death
	$save_state_node.save_death()

func _ready():
	pass
