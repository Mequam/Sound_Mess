extends Corrupter

#this script is a dummy tarantula that emits a signal when it is visible gives a huge corruption particles
#and then removes itself from the scene

signal super_corrupt

#hyjack the set mode functionality so we stay in idle mode forever
#we do NOT change modes from the corrupter AI except for Idle to start animations
func set_mode(val)->void:
	if val == "Idle":
		.set_mode("Idle")

#this is what starts the corruption the Alert mode will be hijacked in the run function and we will catch 
#its ending to remove ourselfs
func super_corrupt()->void:
	#set us to alert mode
	inner_beat = 0.0
	mode = "Alert"
	
func run(player_pos,beat)->void:
	.run(player_pos,beat)
	#the alert mode ends on beat 5, we hijack that ending to emit our CRAZY particles
	#our corruption signal and remove ourselfs from the scene
	if mode == "Alert" and inner_beat == 4:
		emit_signal("super_corrupt")
		$super_particles.emitting = true
		#we now queue_free but in a second so the particles can finish
		$death_timer.start()
	if LoadData.get_player_pos().distance_squared_to(position) < 500*500 and mode != "Alert":
		super_corrupt()

#remove ourselfs from the scene
func _on_death_timer_timeout():
	queue_free()
