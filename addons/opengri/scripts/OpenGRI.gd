tool
extends EditorPlugin

var doc = preload("../scenes/FileEditor.tscn").instance()

var IconLoader = preload("IconLoader.gd").new()

func _enter_tree():
	add_autoload_singleton("IconLoader","res://addons/opengri/scripts/IconLoader.gd")
	add_autoload_singleton("LastOpenedFiles","res://addons/opengri/scripts/LastOpenedFiles.gd")
	get_editor_interface().get_editor_viewport().add_child(doc)
	doc.hide()

func _exit_tree():
	doc.clean_editor()
	get_editor_interface().get_editor_viewport().remove_child(doc)
	remove_autoload_singleton("IconLoader")
	remove_autoload_singleton("LastOpenedFiles")

func has_main_screen():
	return true

func get_plugin_name():
	return "ResImporter"

func get_plugin_icon():
	return IconLoader.load_icon_from_name("file")

func make_visible(visible):
	doc.visible = visible
