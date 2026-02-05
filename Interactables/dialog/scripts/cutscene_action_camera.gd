@tool
@icon( "res://GUI/dialog_system/icons/cutscene_camera.svg" )
class_name CutsceneActionCamera extends CutsceneAction

enum Method { DURATION, SPEED }

@export var timing_method : Method = Method.DURATION
@export var transition_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var easing_method : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export_range( 0.0, 10.0, 0.05, "s" ) var move_duration : float = 0.5
@export_range( 10, 1000, 1, "px/s" ) var move_speed : float = 200.0


var camera : Camera2D
var start_location : Vector2 = Vector2.ZERO
var target_location : Vector2 = Vector2.ZERO
var distance_to_target : float = 0.0


func _ready() -> void:
	target_location = global_position
	pass



func play() -> void:
	camera = get_viewport().get_camera_2d()
	
	if camera:
		camera.process_mode = Node.PROCESS_MODE_ALWAYS
		start_location = camera.global_position
		distance_to_target = start_location.distance_to( target_location )
		
		var follow_node : Node2D = Node2D.new()
		PlayerManager.player.add_sibling( follow_node )
		follow_node.global_position = start_location
		
		camera.reparent( follow_node )
		
		if timing_method == Method.SPEED:
			move_duration = distance_to_target / move_speed
		else:
			move_speed = distance_to_target / move_duration
		
		var tween : Tween = create_tween()
		tween.set_ease( easing_method )
		tween.set_trans( transition_type )
		tween.tween_property( follow_node, "global_position", target_location, move_duration )
		tween.tween_callback( _on_tween_finished )
		pass
	else:
		finished.emit()
	pass



func _on_tween_finished() -> void:
	camera.process_mode = Node.PROCESS_MODE_INHERIT
	finished.emit()
	pass


func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle( Vector2.ZERO, 3, Color.AQUA )
		draw_circle( Vector2.ZERO, 10, Color.DARK_TURQUOISE, false, 1.0 )
	pass
