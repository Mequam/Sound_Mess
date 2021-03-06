extends Object
#this script contains all of the math and translation functions
#required to work with the Avatars enumerator and the code
#stored inside of each avatar
enum Avatars {
	ARCH, #lydian
	BUNNY, #major
	BIRD #mixolidian
}
static func isAvatarCode(avatar_enum : int)->bool:
	return 0 <= avatar_enum and avatar_enum < Avatars.size()
#converts an avatar enumerator into the path where that avatar is stored
static func avatar_enum2path(avatar_enum : int)-> String:
	if isAvatarCode(avatar_enum):
		return ["",
		"res://scenes/instance/avatars/bunny_avatar.tscn",
		"res://scenes/instance/avatars/bird_avatar.tscn"][avatar_enum]
	return "res://scenes/instance/avatars/bunny_avatar.tscn" #defualt to the bunny path to avoid errors
static func avatar_enum2transPath(avatar_enum : int) -> String:
	if isAvatarCode(avatar_enum):
		return ["",
		"res://scenes/assets/avatar_swapper_statues/bunnySwapperStatue.tscn",
		"res://scenes/assets/avatar_swapper_statues/birdTransformationStatue.tscn"][avatar_enum]
	#default to the bunny
	return "res://scenes/assets/avatar_swapper_statues/bunnySwapperStatue.tscn"
