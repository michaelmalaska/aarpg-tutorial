class_name State_Grapple extends State

@onready var idle: State_Idle = $"../Idle"
@onready var grapple_hook: Node2D = %GrappleHook
@onready var nine_patch_rect: NinePatchRect = $"../../GrappleHook/NinePatchRect"
@onready var chain_audio_player: AudioStreamPlayer2D = $"../../GrappleHook/AudioStreamPlayer2D"
@onready var grapple_ray_cast_2d: RayCast2D = %GrappleRayCast2D
@onready var grapple_hurt_box: HurtBox = %GrappleHurtBox


@export var grapple_distance : float = 100.0
@export var grapple_speed : float = 200.0

@export_group("Audio SFX")
@export var grapple_fire_audio : AudioStream
@export var grapple_stick_audio : AudioStream
@export var grapple_bounce_audio : AudioStream

var collision_distance : float
var collision_type : int = 0 # 0 = none, 1 = wall, 2 = grapple point
var nine_patch_size : float = 25.0

var tween : Tween

var next_state : State = null

var positions : Array[ Vector3 ] = [
	Vector3( 0.0, -20.0, 180.0 ), # UP
	Vector3( 0.0, -10.0, 0.0 ), # DOWN
	Vector3( -10.0, -15.0, 90.0 ), # LEFT
	Vector3( 10.0, -15.0, -90.0 ), # RIGHT
]
var pos_map : Dictionary = {
	Vector2.UP: 0,
	Vector2.DOWN: 1,
	Vector2.LEFT: 2,
	Vector2.RIGHT: 3
}


## What happens when we initialize this state?
func init() -> void:
	grapple_hook.visible = false
	grapple_ray_cast_2d.enabled = false
	grapple_ray_cast_2d.target_position.y = grapple_distance
	grapple_hurt_box.monitoring = false
	pass


## What happens when the player enters this State?
func enter() -> void:
	player.update_animation( "idle" )
	grapple_hook.visible = true
	grapple_hurt_box.monitoring = true
	
	set_grapple_position()
	raycast_detection()
	shoot_grapple()
	
	chain_audio_player.play()
	play_audio( grapple_fire_audio )
	pass


## What happens when the player exits this State?
func exit() -> void:
	next_state = null
	grapple_hook.visible = false
	grapple_hurt_box.monitoring = false
	chain_audio_player.stop()
	tween.kill()
	nine_patch_rect.size.y = nine_patch_size
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return next_state


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null



func set_grapple_position() -> void:
	var new_pos : Vector3 = positions[
			pos_map[ player.cardinal_direction ]
	]
	grapple_hook.position = Vector2( new_pos.x, new_pos.y )
	grapple_hook.rotation_degrees = new_pos.z
	if player.cardinal_direction == Vector2.UP:
		grapple_hook.show_behind_parent = true
	else:
		grapple_hook.show_behind_parent = false
	pass


func raycast_detection() -> void:
	collision_type = 0
	collision_distance = grapple_distance
	
	grapple_ray_cast_2d.set_collision_mask_value( 5, false )
	grapple_ray_cast_2d.set_collision_mask_value( 6, true )
	grapple_ray_cast_2d.force_raycast_update()
	if grapple_ray_cast_2d.is_colliding():
		collision_type = 2
		collision_distance = grapple_ray_cast_2d.get_collision_point().distance_to( player.global_position )
		return
	
	grapple_ray_cast_2d.set_collision_mask_value( 5, true )
	grapple_ray_cast_2d.set_collision_mask_value( 6, false )
	grapple_ray_cast_2d.force_raycast_update()
	if grapple_ray_cast_2d.is_colliding():
		collision_type = 1
		collision_distance = grapple_ray_cast_2d.get_collision_point().distance_to( player.global_position )
		return
	pass



func shoot_grapple() -> void:
	if tween:
		tween.kill()
	
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
			nine_patch_rect, "size",
			Vector2( nine_patch_rect.size.x, collision_distance ),
			tween_duration
	)
	
	if collision_type == 2:
		tween.tween_callback( grapple_player )
	else:
		tween.tween_callback( return_grapple )
	pass



func grapple_player() -> void:
	if tween:
		tween.kill()
	play_audio( grapple_stick_audio )
	player.set_collision_mask_value( 4, false )
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
			nine_patch_rect, "size",
			Vector2( nine_patch_rect.size.x, nine_patch_size ),
			tween_duration
	)
	
	var player_target : Vector2 = player.global_position
	player_target += ( player.cardinal_direction * collision_distance )
	player_target -= player.cardinal_direction * nine_patch_size
	
	tween.parallel().tween_property(
		player, "global_position",
		player_target,
		tween_duration
	)
	player.make_invulnerable( tween_duration )
	
	tween.tween_callback( grapple_finished )
	pass



func return_grapple() -> void:
	if tween:
		tween.kill()
	
	if collision_type > 0:
		play_audio( grapple_bounce_audio )
	
	var tween_duration : float = collision_distance / grapple_speed
	tween = create_tween()
	tween.tween_property(
			nine_patch_rect, "size",
			Vector2( nine_patch_rect.size.x, nine_patch_size ),
			tween_duration
	)
	
	tween.tween_callback( grapple_finished )
	pass



func grapple_finished() -> void:
	player.set_collision_mask_value( 4, true )
	next_state = idle
	pass



func play_audio( audio : AudioStream ) -> void:
	player.audio.stream = audio
	player.audio.play()
	pass
