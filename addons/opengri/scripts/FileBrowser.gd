tool
extends Control

# Constants
const CONFIG_FILE = "user://opengri.cfg"
const GameClass = preload("res://addons/opengri/classes/GameClass.gd")

onready var GameSelector = $FileBrowserContainer/GameSelectorContainer/GameSelector
onready var GamePath = $FileBrowserContainer/GameSelectorContainer/GamePath
onready var Version = $FileBrowserContainer/GameSelectorContainer/Version

onready var PathTree = $FileBrowserContainer/SplitContainer/TreeContainer/PathTree
onready var FileList = $FileBrowserContainer/SplitContainer/FileContainer/FileList

onready var OpenFileDialog = $OpenFileDialog

onready var NewFileDialog = $NewFileDialog
onready var NewFileDialog_name = $NewFileDialog/NewFileContainer/Filename

var games_path : Dictionary 

func _ready():
	update_version()
	connect_signals()
	fill_GameSelector()
	load_config()

func clean_editor() -> void :
	GamePath.clear()
	PathTree.clear()
	FileList.clear()

func update_version():
	var plugin_version = ""
	var config =  ConfigFile.new()
	var err = config.load("res://addons/opengri/plugin.cfg")
	if err == OK:
		plugin_version = config.get_value("plugin","version")
	Version.set_text("v"+plugin_version)

func connect_signals():
	OpenFileDialog.connect("confirmed", self, "update_list")
	OpenFileDialog.connect("file_selected", self, "open_file")
#	FileList.connect("item_selected", self, "_on_fileitem_pressed") # double click

func fill_GameSelector():
#	GameSelector.clear()
	var g = GameClass.new()
	g.constructor({title = "-- Select game --"})
	GameSelector.add_item(g.title, 0)
	
	add_item_GameSelector(1, {title = "GTA IV", cfg_key = "GTA_IV"})
	add_item_GameSelector(2, {title = "GTA IV: EFLC", cfg_key = "GTA_IV_EFLC"})

func add_item_GameSelector(id, params = {}):
	var g = GameClass.new()
	g.constructor(params)
	GameSelector.add_item(g.title, id)
	GameSelector.set_item_metadata(id, g)

########## Signals ##########

func _on_GameSelector_item_selected(id):
	if id == 0: 
		clean_editor()
	else:
#		var game_name = GameSelector.get_item_text(id)
		var game_obj = GameSelector.get_item_metadata(id)
		print("game_key=" + game_obj.cfg_key)
#		var game_path
#		if games_path.has(game_name):
#			game_path = games_path[game_name]
#			print("game_path1="+game_path)
#		else:
#			game_path = "f_game_path"
#			save_to_config("games", game_name, game_path)
#			print("game_path2="+game_path)
#
		GamePath.set_text(game_obj.cfg_key)
#		print(game_name)

########## Config file ##########

func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err: # File is missing, create default config
		config.save(CONFIG_FILE)
	else:
		for game_name in config.get_section_keys("games"):
			var game_path = config.get_value("games", game_name)
			games_path[game_name] = game_path

func save_to_config(section, key, value):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(CONFIG_FILE)


########## Additional methods ##########

func open_filelist():
#	OpenFileDialog.invalidate()
	OpenFileDialog.popup()
	OpenFileDialog.set_position(OS.get_screen_size()/2 - OpenFileDialog.get_size()/2)


#func open_selected_file():
##	FileList.mode = FileDialog.MODE_OPEN_ANY
##	FileList.access = FileDialog.ACCESS_FILESYSTEM
##	FileList.set_title("Select game folder or resource file")
#	open_filelist()
#
#func open_file(path : String):
#	if current_file_path != path:
#		current_file_path = path
#
##		LastOpenedFiles.store_opened_files(OpenFileList)
#	current_editor.show()
#
#func open_newfiledialogue():
#	NewFileDialog.popup()
#	NewFileDialog.set_position(OS.get_screen_size()/2 - NewFileDialog.get_size()/2)
#
#func open_filelist():
#	update_list()
#	OpenFileDialog.popup()
#	OpenFileDialog.set_position(OS.get_screen_size()/2 - OpenFileDialog.get_size()/2)
#
#func _on_vanillaeditor_text_changed():
#	if not OpenFileList.get_item_text(current_file_index).ends_with("(*)"):
#		OpenFileList.set_item_text(current_file_index,OpenFileList.get_item_text(current_file_index)+"(*)")
#
#
#func update_list():
#	OpenFileDialog.invalidate()
#
#func on_wrap_button(index:int):
#	match index:
#		0:
#			current_editor.set_wrap_enabled(false)
#		1:
#			current_editor.set_wrap_enabled(true)
#
#func on_minimap_button(index:int):
#	match index:
#		0:
#			current_editor.draw_minimap(false)
#		1:
#			current_editor.draw_minimap(true)


