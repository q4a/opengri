extends Object
class_name GameClass

var title: String
var cfg_key: String
var path: String

func _init(params = {}):
#	print("create game with title "+params["title"])
	title = params["title"]
	cfg_key = ("" if !params.has("cfg_key") else params["cfg_key"])
	path = ("" if !params.has("path") else params["path"])
