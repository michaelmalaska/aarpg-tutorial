@tool
@icon( "res://GUI/dialog_system/icons/cutscene_player.svg" )
class_name CutsceneActionPlayer extends CutsceneAction

enum Method { DURATION, SPEED }


@export var animation_name : String = "walk"
@export_enum( "up", "down", "left", "right" ) var finish_direction : String = "up"
@export var reset_camera_to_player : bool = true
@export var timing_method : Method = Method.DURATION
@export var transition_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var easing_method : Tween.EaseType = Tween.EaseType.EASE_IN_OUT

@export_range( 0.0, 10.0, 0.05, "s" ) var move_duration : float = 0.5
@export_range( 10, 1000, 1, "px/s" ) var move_speed : float = 200.0
@export var scale_animation_with_movement : bool = true
@export var animation_speed_factor : float = 200.0

var start_location : Vector2 = Vector2.ZERO
var target_location : Vector2 = Vector2.ZERO
var move_direction : Vector2 = Vector2.ZERO
var distance_to_target : float = 0.0


func _ready() -> void:
	target_location = global_position
	pass



func play() -> void:
	var player : Player = PlayerManager.player
	var camera : Camera2D = get_viewport().get_camera_2d()
	camera.process_mode = Node.PROCESS_MODE_ALWAYS
	
	start_location = player.global_position
	distance_to_target = start_location.distance_to( target_location )
	move_direction = start_location.direction_to( target_location )
	
	player.direction = move_direction
	player.set_direction()
	player.update_animation( animation_name )
	
	if reset_camera_to_player:
		PlayerManager.reset_camera_on_player()
	
	if timing_method == Method.SPEED:
		move_duration = distance_to_target / move_speed
	else:
		move_speed = distance_to_target / move_duration
	
	if scale_animation_with_movement:
		var anim_speed_scale : float = move_speed / animation_speed_factor
		player.animation_player.speed_scale = anim_speed_scale
	
	var tween : Tween = create_tween()
	tween.set_ease( easing_method )
	tween.set_trans( transition_type )
	tween.tween_property( player, "global_position", target_location, move_duration )
	tween.tween_callback( _on_tween_finished )
	
	pass



func _on_tween_finished() -> void:
	var player: Player = PlayerManager.player
	player.animation_player.speed_scale = 1.0
	player.direction = get_facing_direction()
	player.set_direction()
	player.update_animation( "idle" )
	
	finished.emit()
	pass


func get_facing_direction() -> Vector2:
	match finish_direction:
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		"left":
			return Vector2.LEFT
		"right":
			return Vector2.RIGHT
		_:
			return Vector2.UP



func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle( Vector2.ZERO, 3, Color.GREEN_YELLOW )
		draw_circle( Vector2.ZERO, 10, Color.LIME_GREEN, false, 1.0 )
	pass
