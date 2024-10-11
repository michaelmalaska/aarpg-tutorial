@tool
extends EditorPlugin

var juice_box
var juice_notifs : JuiceNotifs


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	#juice_box = preload("res://addons/juice_my_editor/juice_my_editor.tscn").instantiate()
	#get_tree().root.add_child( juice_box )
	#add_control_to_container( EditorPlugin.CONTAINER_TOOLBAR, juice_box )
	juice_notifs = preload("res://addons/juice_my_editor/juice_notifs.tscn").instantiate() as JuiceNotifs
	get_tree().root.add_child( juice_notifs )
	#add_control_to_container( EditorPlugin.CONTAINER_TOOLBAR, juice_notifs )
	scene_changed.connect( _on_scene_changed )
	pass


func _on_scene_changed( n ) -> void:
	#print("SceneChanged: ", n.name)
	juice_notifs.show_scene_notification( n )
	#juice_notifs.show_notification( get_editor_interface().get_edited_scene_root() )
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	#remove_control_from_container( EditorPlugin.CONTAINER_TOOLBAR, juice_box )
	#juice_box.queue_free()
	juice_notifs.queue_free()
	pass