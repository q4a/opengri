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

func _ready():
	update_version()
	fill_GameSelector()
	setup_FileList()
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

func fill_GameSelector():
	GameSelector.clear()
	var g = GameClass.new()
	g.constructor({title = "-- Select game --"})
	GameSelector.add_item(g.title, 0)
	
	add_item_GameSelector(1, {title = "GTA IV", cfg_key = "GTA_IV"})
	add_item_GameSelector(2, {title = "GTA IV: EFLC", cfg_key = "GTA_IV_EFLC"})

func setup_FileList():
	FileList.set_column_title(0, "Name")
	FileList.set_column_title(1, "Size")
	FileList.set_column_expand(1, false)
	FileList.set_column_min_width (1, 70)
	FileList.set_column_title(2, "Resource")
	FileList.set_column_expand(2, false)
	FileList.set_column_min_width (2, 100)
	
	FileList.set_column_titles_visible(true)

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
		var game_obj = GameSelector.get_item_metadata(id)
		var game_path
		print("game_key=" + game_obj.cfg_key)
		if game_obj.path != "":
			_on_OpenFileDialog_dir_selected(game_obj.path)
		else:
			show_OpenFileDialog()

func _on_OpenFileDialog_dir_selected(dir) -> void:
	var id = GameSelector.selected
	if id == -1:
		return
	var game_obj = GameSelector.get_item_metadata(id)
	if game_obj.path != dir:
		game_obj.path = dir
		save_to_config("games", game_obj.cfg_key, dir)
	
	GamePath.set_text(game_obj.path)
	load_tree(game_obj.path, game_obj.title)

func _on_SelectGamePath_pressed() -> void:
	var id = GameSelector.selected
	if id != -1 and id != 0:
		show_OpenFileDialog()

func _on_PathTree_cell_selected():
	var path = PathTree.get_selected().get_metadata(0)
	var dir = Directory.new()
	if dir.open(path) == OK:
		load_files(dir)
	else:
		push_error("An error occurred when trying to access the path.")
#
#	print("_on_PathTree_cell_selected")


########## PathTree methods ##########
func load_tree(path: String, title: String):
	var dir = Directory.new()
	if dir.open(path) == OK:
		PathTree.clear()
		FileList.clear()
#		load_files(dir)
		
		var root = PathTree.create_item()
		root.set_text(0, title)
		root.set_metadata(0, path)
		root.select(0)
		
		load_tree_recurs(dir, root)
	else:
		push_error("An error occurred when trying to access the path.")

func load_tree_recurs(dir: Directory, tree_item: TreeItem):
	dir.list_dir_begin(true, false)
	var dir_name = dir.get_next()

	while (dir_name != ""):
		var path = dir.get_current_dir() + "/" + dir_name
		
		if dir.current_is_dir():
#			print("directory: "+path)
			var sub_item = PathTree.create_item(tree_item)
			sub_item.set_text(0, dir_name)
			sub_item.set_metadata(0, path)
			
			var sub_dir = Directory.new()
			sub_dir.open(path)
			load_tree_recurs(sub_dir, sub_item)
		
		dir_name = dir.get_next()
	
	dir.list_dir_end()


########## FileList methods ##########
func load_files(dir: Directory):
	FileList.clear()
	var tree_root = FileList.create_item()
	
	dir.list_dir_begin(true, false)
	var file_name = dir.get_next()

	while (file_name != ""):
		var path = dir.get_current_dir() + "/" + file_name
		
		if !dir.current_is_dir():
			var file = File.new()
			file.open(path, File.READ)
			var size = file.get_len()
			file.close()
			
#			print("file: "+file_name+" size: "+str(size))
			var size_short = float(size)
			var dimension = 0
			while (size_short > 1024):
				dimension = dimension + 1
				size_short = size_short / 1024
			
			size_short = str(size_short).left(4)
#			var length = size_short.length()
#			while (length != 4):
#				length = length + 1
#				size_short = " "+size_short
			
			if size_short.right(3) == ".":
				size_short = size_short.left(3)
			if dimension == 0:
				dimension = " B"
			elif dimension == 1:
				dimension = " KB"
			elif dimension == 2:
				dimension = " MB"
			elif dimension == 3:
				dimension = " GB"
			elif dimension == 4:
				dimension = " TB"
			elif dimension > 4:
				dimension = " *B"
			size_short = size_short + dimension
			
			var item = FileList.create_item(tree_root)
			item.set_text(0, file_name)
			item.set_icon(0, IconLoader.load("file"))
			item.set_metadata(0, path)
			item.set_text(1, size_short)
			item.set_metadata(1, size)
			item.set_text(2, "Yes (to test)")
		file_name = dir.get_next()
	dir.list_dir_end()

########## Config file ##########

func load_config():
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err: # File is missing, create default config
		config.save(CONFIG_FILE)
	else:
		var game_obj
		for id in range(1, GameSelector.get_item_count()):
			game_obj = GameSelector.get_item_metadata(id)
			if config.has_section_key("games", game_obj.cfg_key):
				game_obj.path = config.get_value("games", game_obj.cfg_key)
#			print("game_key="+game_obj.cfg_key+" game_path="+game_obj.path)

func save_to_config(section, key, value):
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(CONFIG_FILE)


########## Additional methods ##########

func show_OpenFileDialog():
#	OpenFileDialog.invalidate()
	OpenFileDialog.popup()
	OpenFileDialog.set_position(OS.get_screen_size()/2 - OpenFileDialog.get_size()/2)


