tool
extends Control

# Constants
const CONFIG_FILE = "user://opengri.cfg"

onready var GameSelector = $FileBrowserContainer/GameSelectorContainer/GameSelector
onready var GamePath = $FileBrowserContainer/GameSelectorContainer/GamePath
onready var Version = $FileBrowserContainer/GameSelectorContainer/Version

onready var PathTree = $FileBrowserContainer/SplitContainer/TreeContainer/PathTree
onready var FileList = $FileBrowserContainer/SplitContainer/FileContainer/FileList

onready var OpenFileDialog = $OpenFileDialog

onready var NewFileDialog = $NewFileDialog
onready var NewFileDialog_name = $NewFileDialog/NewFileContainer/Filename

func _ready():
	clean_editor()
	update_version()
	connect_signals()

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

########## Signals ##########

func _on_GameSelector_item_selected(id):
	if id == 0: 
		clean_editor()
	elif id == 1:
		open_filelist()
	elif id == 2:
		clean_editor()

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


