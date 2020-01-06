tool
extends Control

#var ResTree : EditorPlugin
onready var Load_ResTreeBTN = $Load_ResTree

#Load_ResViewer
func _ready():
	Load_ResTreeBTN.connect("pressed", self, "clicked")

func clicked():
	print("You clicked me!")
#	ResTree = preload("res://addons/opengri/scripts/file-editor.gd").new()
#	ResTree._enter_tree()
