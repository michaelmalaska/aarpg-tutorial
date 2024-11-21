class_name EnergyOrb extends Node2D


@export var speed : float = 200

@export var shoot_audio : AudioStream
@export var hit_audio : AudioStream


var direction : Vector2 = Vector2.DOWN

@onready var hurt_box: HurtBox = $HurtBox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	hurt_box.did_damage.connect( hit_player )
	play_audio( shoot_audio )
	get_tree().create_timer( 5 ).timeout.connect( destroy )
	direction = global_position.direction_to( PlayerManager.player.global_position )
	flicker()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta: float ) -> void:
	position += direction * speed * delta
	pass



func flicker() -> void:
	modulate.a = randf() * 0.7 + 0.3
	await get_tree().create_timer( 0.05 ).timeout
	flicker()
	pass


func hit_player() -> void:
	play_audio( hit_audio )
	hurt_box.set_deferred( "monitoring", false )
	pass


func play_audio( _a : AudioStream ) -> void:
	audio_stream_player_2d.stream = _a
	audio_stream_player_2d.play()


func destroy() -> void:
	queue_free()
