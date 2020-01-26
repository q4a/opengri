tool
extends Control

# Constants
const CONFIG_FILE = "user://OpenGRI.cfg"

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
	
	#begin tests
	var game_obj = GameSelector.get_item_metadata(1)
	LoadGameDirectory(game_obj)
	
#	push_error("Test error")
	print("get_base_dir="+game_obj.path.get_base_dir())
	var test_path = game_obj.path + ".txt"
	print("get_file="+test_path.get_file())
	
	var my = FSDirectory.new()
	my.Name = "test_N"
	var ter = my.IsDirectory()
	print("is="+str(ter))
#	print("is="+str(ter)+" Name="+str(my.Name))
	for i in my:
		#empty
		print("my_Name="+i.Name)
	
	var sub_dir = FSDirectory.new()
	sub_dir.Name = "sub_dir"
	sub_dir.ParentDirectory = my;
	
	var sub_dir2 = FSDirectory.new()
	sub_dir2.Name = "sub_dir2"
	sub_dir2.ParentDirectory = my;
	
	my.AddObject(sub_dir)
	my.AddObject(sub_dir2)
	print("my size="+str(my._fsObjects.size()))
	for i in my:
		print("sub_Name="+i.Name)
		print("sub_FullName="+i.FullName())
	print("my_FullName="+my.FullName())
	print("s2_FullName="+my["1"].FullName())

#	var Flags = 3562536976
#	var i = int(Flags & 0x7FF) << int(((Flags >> 11) & 0xF) + 8)
#	print("Flags="+str(i)+" F="+str(16 << 8)+" i="+str(int(Flags & 0x7FF))+" 2="+str(int(((Flags >> 11) & 0xF) + 8)))
	
	#end tests

func clean_editor() -> void :
	GamePath.clear()
	PathTree.clear()
	FileList.clear()

func update_version() -> void:
	var plugin_version = ""
	var config =  ConfigFile.new()
	var err = config.load("res://addons/OpenGRI/plugin.cfg")
	if err == OK:
		plugin_version = config.get_value("plugin","version")
	Version.set_text("v"+plugin_version)

func fill_GameSelector() -> void:
	GameSelector.clear()
	var g = GameClass.new({title = "-- Select game --"})
	GameSelector.add_item(g.title, 0)
	
	add_item_GameSelector(1, {title = "GTA IV", cfg_key = "GTA_IV"})
	add_item_GameSelector(2, {title = "GTA IV: EFLC", cfg_key = "GTA_IV_EFLC"})
	add_item_GameSelector(3, {title = "Custom folder", cfg_key = "Custom"})

func setup_FileList() -> void:
	FileList.set_column_title(0, "Name")
	FileList.set_column_title(1, "Size")
	FileList.set_column_expand(1, false)
	FileList.set_column_min_width (1, 70)
	FileList.set_column_title(2, "Resource")
	FileList.set_column_expand(2, false)
	FileList.set_column_min_width (2, 100)
	
	FileList.set_column_titles_visible(true)

func add_item_GameSelector(id, params = {}) -> void:
	var g = GameClass.new(params)
	GameSelector.add_item(g.title, id)
	GameSelector.set_item_metadata(id, g)


########## Signals ##########

func _on_GameSelector_item_selected(id) -> void:
#	print("_on_GameSelector_item_selected")
	if id == 0: 
		clean_editor()
	else:
		var game_obj = GameSelector.get_item_metadata(id)
		var game_path
#		print("game_key=" + game_obj.cfg_key)
		if game_obj.path != "":
			_on_OpenFileDialog_dir_selected(game_obj.path)
		else:
			show_OpenFileDialog()

func _on_OpenFileDialog_dir_selected(dir) -> void:
#	print("_on_OpenFileDialog_dir_selected")
	var id = GameSelector.selected
	if id == -1:
		return
	var game_obj = GameSelector.get_item_metadata(id)
	if game_obj.path != dir:
		game_obj.path = dir
		save_to_config("games", game_obj.cfg_key, dir)
	
	GamePath.set_text(game_obj.path)
	load_tree(game_obj.path, game_obj.title)
	if (game_obj.cfg_key == "GTA_IV" or
		game_obj.cfg_key == "GTA_IV_EFLC"):
			LoadGameDirectory(game_obj)

func _on_SelectGamePath_pressed() -> void:
	var id = GameSelector.selected
	if id != -1 and id != 0:
		show_OpenFileDialog()

func _on_PathTree_cell_selected() -> void:
#	print("_on_PathTree_cell_selected")
	var path = PathTree.get_selected().get_metadata(0)
	var dir = Directory.new()
	if dir.open(path) == OK:
		load_files(dir)
	else:
		push_error("An error occurred when trying to access the path.")


########## PathTree methods ##########
func load_tree(path: String, title: String) -> void:
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

func load_tree_recurs(dir: Directory, tree_item: TreeItem) -> void:
	dir.list_dir_begin(true, false)
	var dir_name = dir.get_next()
	
	var path
	while dir_name != "":
		path = dir.get_current_dir() + "/" + dir_name
		
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
func load_files(dir: Directory) -> void:
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

func load_config() -> void:
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

func save_to_config(section, key, value) -> void:
	var config = ConfigFile.new()
	var err = config.load(CONFIG_FILE)
	if err:
		print("Error code when loading config file: ", err)
	else:
		config.set_value(section, key, value)
		config.save(CONFIG_FILE)


########## Dialogs methods ##########

func show_OpenFileDialog() -> void:
#	OpenFileDialog.invalidate()
	OpenFileDialog.popup()
	OpenFileDialog.set_position(OS.get_screen_size()/2 - OpenFileDialog.get_size()/2)

########## GTA specific methods ##########
func LoadGameDirectory(game_obj: GameClass) -> void:
	var fs = RealFileSystem.new()
	print("Load "+game_obj.cfg_key+" with path="+game_obj.path)
#	string gamePath = keyUtil.FindGameDirectory();
	
#	byte[] key = keyUtil.FindKey( gamePath );
#	if (key == null)
#	{
#		string message = "Your " + keyUtil.ExecutableName + " seems to be modified or is a newer version than this tool supports. " +
#		"SparkIV can not run without a supported " + keyUtil.ExecutableName + " file." + "\n" + "Would you like to check for updates?";
#		string caption = "Newer or Modified " + keyUtil.ExecutableName;
#
#		if (MessageBox.Show(message, caption, MessageBoxButtons.YesNo, MessageBoxIcon.Error) == DialogResult.Yes)
#		{
#			Updater.CheckForUpdate();
#		}
#
#		return;
#	}
#
#	KeyStore.SetKeyLoader(() => key);
	fs.Open(game_obj.path);
