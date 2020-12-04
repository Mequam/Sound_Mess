extends Node2D

var willSpawn : PackedScene = null
var spawnRadius : int = 5
func setWillSpawn(path : String,radius : int = 5) -> void:
	#load the node path to spawn
	willSpawn = load(path)
	#the radius that things spawn around
	spawnRadius = radius
	#we can now start spawning things
	$spawnTimer.start()
func _on_spawnTimer_timeout():
	var dist = randf()*spawnRadius
	var angle = randf()*2*PI
	var willSpawnNode = willSpawn.instance()
	#spawn in the node at a random angle a random distance from the center
	#note that our position is the center of the radius
	willSpawnNode.position = Vector2(cos(angle),sin(angle))*dist+position
	get_parent().add_child(willSpawnNode)
