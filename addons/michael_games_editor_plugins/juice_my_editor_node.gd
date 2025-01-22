@tool
extends Control

var file_system_dock : FileSystemDock
var editor_file_system : EditorFileSystem
var editor_plugin : EditorPlugin


func _ready() -> void:
	file_system_dock = EditorInterface.get_file_system_dock()
	editor_file_system = EditorInterface.get_resource_filesystem()
