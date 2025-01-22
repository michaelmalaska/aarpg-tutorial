@tool
extends EditorPlugin

var juice_box
var juice_notifs : JuiceNotifs
var profile_control : Control

func _enter_tree() -> void:
	juice_notifs = preload("res://addons/michael_games_editor_plugins/juice_notifs.tscn").instantiate() as JuiceNotifs
	get_tree().root.add_child( juice_notifs )
	scene_changed.connect( _on_scene_changed )
	profile_control = load("res://addons/michael_games_editor_plugins/stream_image_backdrop.tscn").instantiate() as Control
	add_control_to_dock( EditorPlugin.DOCK_SLOT_RIGHT_BL, profile_control )
	pass


func _on_scene_changed( n ) -> void:
	juice_notifs.show_scene_notification( n )
	pass


func _exit_tree() -> void:
	juice_notifs.queue_free()
	remove_control_from_docks( profile_control )
	profile_control.queue_free()
	pass
