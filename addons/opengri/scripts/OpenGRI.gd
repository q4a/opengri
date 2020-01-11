tool
extends EditorPlugin

var doc = preload("res://addons/opengri/scenes/FileBrowser.tscn").instance()

func _enter_tree():
	get_editor_interface().get_editor_viewport().add_child(doc)
	doc.hide()

func _exit_tree():
#	doc.clean_editor()
	get_editor_interface().get_editor_viewport().remove_child(doc)

func has_main_screen():
	return true

func get_plugin_name():
	return "ResImporter"

func make_visible(visible):
	doc.visible = visible
