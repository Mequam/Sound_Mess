extends Control

#TODO: this scene is a quick sketch up designed to let me
#get right into running the game, in the future
#we will need to add a LOT to this first scene
#as it is the first thing that every player is going to see
#OFTEN if they play again, we need to make sure it looks right

func _ready():
	$Button.connect("button_down",self,"load_game")
func load_game():
	#load the player globaly
	LoadData.load_player()
	#TODO: I am faily certain that the previous scene does not do anything
	
	#load the beginner scene of the player, the vector here is the center of the mushroom circle in the bunny forest
	#Vector2(417.919,365.21) this is the position that the player starts when first loading the game
	#commented and moved so debugging rabbit starts not there
	LoadData.load_scene("res://scenes/main/bunny/bunny_forest.tscn","",null)
