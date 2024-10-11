@tool
extends Control

const CLICK_RIGHT_01 = preload("res://addons/juice_my_editor/assets/click_right_01.wav")
const CONFIRM_STYLE_1_006 = preload("res://addons/juice_my_editor/assets/confirm_style_1_006.ogg")
const PRESS_01 = preload("res://addons/juice_my_editor/assets/press-01.wav")
const PRESS_02 = preload("res://addons/juice_my_editor/assets/press-02.wav")
const PRESS_03 = preload("res://addons/juice_my_editor/assets/press-03.wav")
const UI_DELETE = preload("res://addons/juice_my_editor/assets/ui_key_scifi_reverse.wav")
const UI_RETURN = preload("res://addons/juice_my_editor/assets/ui_return.wav")
const UI_SPACE = preload("res://addons/juice_my_editor/assets/ui_space.wav")

var file_system_dock : FileSystemDock
var editor_file_system : EditorFileSystem
var editor_plugin : EditorPlugin

@onready var event_audio: AudioStreamPlayer = $EventAudio
@onready var keyboard_audio: AudioStreamPlayer = $KeyboardAudio
@onready var press_audio: AudioStreamPlayer = $PressAudio
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var key_combo_timer: Timer = $KeyComboTimer



func _ready() -> void:
	#key_combo_timer.timeout.connect( _on_key_combo_timeout )
	file_system_dock = EditorInterface.get_file_system_dock()
	editor_file_system = EditorInterface.get_resource_filesystem()
	editor_file_system.resources_reload.connect( _on_resources_reload )



func _process( _delta: float ) -> void:
	#global_position = get_global_mouse_position()# + Vector2(100,100)
	pass



func _on_button_pressed() -> void:
	#event_audio.play(0)
	pass



#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				##if Input.is_key_pressed(KEY_CTRL):
					##print("CTRL + Click!")
				#_on_mouse_clicked()
				#pass
		#elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#_on_mouse_right_clicked()
			#pass
	#elif event is InputEventKey:
		##if not event.is_echo() and not event.is_released():
			##key_combo_timer.start( 1.0 )
			##play_key_audio()



func play_key_audio() -> void:
	if Input.is_key_pressed(KEY_ENTER):
		press_audio.stream = UI_RETURN
		press_audio.play()
		return
	elif Input.is_key_pressed(KEY_DELETE) or Input.is_key_pressed(KEY_BACKSPACE):
		press_audio.stream = UI_DELETE
		press_audio.play()
		return
	elif Input.is_key_pressed(KEY_SPACE):
		press_audio.stream = UI_SPACE 
		press_audio.play()
		return
	keyboard_audio.pitch_scale = maxf( keyboard_audio.pitch_scale + 0.05, 2.0 )
	keyboard_audio.play()



#func _on_mouse_clicked() -> void:
	#global_position = get_global_mouse_position()
	#animation_player.play("clicked")
	#animation_player.seek(0)
	#pass
#
#
#
#func _on_mouse_right_clicked() -> void:
	#global_position = get_global_mouse_position()
	#animation_player.play("clicked_right")
	#animation_player.seek(0)
	#pass



func _on_key_combo_timeout() -> void:
	keyboard_audio.pitch_scale = 0.8
	



func _on_resources_reload( r : PackedStringArray ) -> void:
	print("test", r)
