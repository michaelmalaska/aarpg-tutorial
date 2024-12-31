class_name PersistentDataHandler extends Node

signal data_loaded
var value : bool = false


func _ready() -> void:
	get_value()
	pass


func set_value() -> void:
	SaveManager.add_persistent_value( _get_name() )
	pass


func get_value() -> void:
	value = SaveManager.check_persistent_value( _get_name() )
	data_loaded.emit()
	pass


func remove_value() -> void:
	SaveManager.remove_persistent_value( _get_name() )
	pass


func _get_name() -> String:
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
