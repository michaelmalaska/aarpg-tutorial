extends Node


var music_audio_player_count : int = 2
var current_music_player : int = 0
var music_players : Array[ AudioStreamPlayer ] = []
var music_bus : String = "Music"

var music_fade_duration : float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in music_audio_player_count:
		var player = AudioStreamPlayer.new()
		add_child( player )
		player.bus = music_bus
		music_players.append( player )
		player.volume_db = -40


func play_music( _audio : AudioStream ) -> void:
	if _audio == music_players[ current_music_player ].stream:
		return
	
	current_music_player += 1
	if current_music_player > 1:
		current_music_player = 0
	
	var current_player : AudioStreamPlayer = music_players[ current_music_player ]
	current_player.stream = _audio
	play_and_fade_in( current_player )
	
	var old_player = music_players[ 1 ]
	if current_music_player == 1:
		old_player = music_players[ 0 ]
	fade_out_and_stop( old_player )



func play_and_fade_in( player : AudioStreamPlayer ) -> void:
	player.play( 0 )
	var tween : Tween = create_tween()
	tween.tween_property( player, 'volume_db', 0, music_fade_duration )
	pass


func fade_out_and_stop( player : AudioStreamPlayer ) -> void:
	var tween : Tween = create_tween()
	tween.tween_property( player, 'volume_db', -40, music_fade_duration )
	await tween.finished
	player.stop()
	pass


