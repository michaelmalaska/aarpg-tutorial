@tool
class_name DialogPortrait extends Sprite2D


var blink : bool = false : set = _set_blink
var open_mouth : bool = false : set = _set_open_mouth
var mouth_open_frames : int = 0
var audio_pitch_base : float = 1.0

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogSystem.letter_added.connect( check_mouth_open )
	blinker()



func check_mouth_open( l : String ) -> void:
	if 'aeiouy1234567890'.contains( l ):
		open_mouth = true
		mouth_open_frames += 3
		audio_stream_player.pitch_scale = randf_range( audio_pitch_base - 0.04, audio_pitch_base + 0.04 )
		audio_stream_player.play()
	elif '.,!?'.contains( l ):
		audio_stream_player.pitch_scale = audio_pitch_base - 0.1
		audio_stream_player.play()
		mouth_open_frames = 0
	
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
	
	if mouth_open_frames == 0:
		if open_mouth == true:
			open_mouth = false
			audio_stream_player.pitch_scale = randf_range( audio_pitch_base - 0.08, audio_pitch_base + 0.02 )
			audio_stream_player.play()
	
	pass



func update_portrait() -> void:
	if open_mouth == true:
		frame = 2
	else:
		frame = 0
	
	if blink == true:
		frame += 1



func blinker() -> void:
	if blink == false:
		await get_tree().create_timer( randf_range( 0.1, 3 ) ).timeout
	else:
		await get_tree().create_timer( 0.15 ).timeout
	blink = not blink
	blinker()



func _set_blink( _value : bool ) -> void:
	if blink != _value:
		blink = _value
		update_portrait()
	pass


func _set_open_mouth( _value : bool ) -> void:
	if open_mouth != _value:
		open_mouth = _value
		update_portrait()
	pass
