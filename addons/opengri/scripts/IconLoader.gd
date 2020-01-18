tool
extends Node

var imgBuffer

func _ready():
	pass

func load(icon_name : String) -> ImageTexture:
	var file = File.new()
	var image = Image.new()
	var texture = ImageTexture.new()
	
	file.open("res://addons/opengri/icons/"+icon_name+".png", File.READ)
	var buffer = file.get_buffer(file.get_len())
	file.close()
	
	image.load_png_from_buffer(buffer)
	texture.create_from_image(image)
	return texture
