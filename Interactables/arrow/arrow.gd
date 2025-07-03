class_name Arrow extends Node2D

@export var move_speed : float = 300
@export var fire_audio : AudioStream

var move_dir : Vector2 = Vector2.RIGHT

@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	hurt_box.did_damage.connect( _on_did_damage )
	get_tree().create_timer( 10.0 ).timeout.connect( _on_timeout )
	if fire_audio:
		audio_stream_player_2d.stream = fire_audio
		audio_stream_player_2d.play()
	pass


func _process( delta: float ) -> void:
	position += move_dir * move_speed * delta
	pass


func fire( fire_dir : Vector2 ) -> void:
	move_dir = fire_dir
	rotate_nodes()
	pass


func rotate_nodes() -> void:
	var angle : float = move_dir.angle()
	sprite_2d.rotation = angle
	sprite_2d_2.rotation = angle
	hurt_box.rotation = angle
	pass


func _on_did_damage() -> void:
	queue_free()
	pass


func _on_timeout() -> void:
	queue_free()
	pass
