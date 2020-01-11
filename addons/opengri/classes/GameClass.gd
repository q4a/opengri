extends Node

var title
var cfg_key
var path

func _ready():
	pass

func constructor(params = {}):
	title = params["title"]
	cfg_key = ("" if !params.has("cfg_key") else params["cfg_key"])
	path = ("" if !params.has("path") else params["path"])
