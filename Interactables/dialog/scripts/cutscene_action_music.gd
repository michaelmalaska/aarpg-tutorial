@tool
class_name CutsceneActionMusic extends CutsceneAction


@export var track : AudioStream
@export var reset_after_cutscene : bool = true

var original_track : AudioStream



func _ready() -> void:
	pass



func play() -> void:
	if reset_after_cutscene:
		original_track = AudioManager.get_current_track()
		DialogSystem.finished.connect( _on_cutscene_finished )
	AudioManager.play_music( track )
	finished.emit()
	pass



func _on_cutscene_finished() -> void:
	AudioManager.play_music( original_track )
	pass
