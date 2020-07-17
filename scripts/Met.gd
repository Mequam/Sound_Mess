extends Node2D

#this represents the time since our last beat
var delta_beat = 0
#stores a four meter beat for convienent use
var beat = 0
var Indicator = null

#used to set the sprite to the rotation that we want
func display_beat(beat):
	match beat:
		0.0 :
			Indicator.position.y = 0
			Indicator.rotation = PI
		1.0 :
			Indicator.rotation = PI - PI/4
		2.0 :
			Indicator.rotation = PI + PI/4
		3.0 :
			Indicator.position.y = -500*Indicator.scale.y
			Indicator.rotation = PI

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Met").connect("timeout",self,"_on_Met_timeout")
	Indicator = get_node("Indicator")

var max_beat_time = 0
var max_time_samples = 0
func _calc_max_time(delta_beat):
							#change this number to change the sample size for the max beat
	if (max_time_samples >= 100):
		return true
	if (delta_beat > max_beat_time):
		max_beat_time = delta_beat
	max_time_samples+=1
	return false

func start_max_beat_calc():
	max_time_samples = 0
	max_beat_time = 0

func _on_Met_timeout():
	delta_beat = 0
	beat += .5
	if (beat == 4):
		beat = 0.0
	display_beat(beat)

func _process(delta):
	delta_beat += delta
	_calc_max_time(delta_beat)
