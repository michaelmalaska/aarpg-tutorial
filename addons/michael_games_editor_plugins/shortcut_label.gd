@tool
class_name ShortcutLabel extends Control

signal on_destroy

var val : String = ""

@onready var shortcut_label: Label = %ShortcutLabel
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("show")
	timer.timeout.connect( destroy_me )


func set_label( _val : String ) -> void:
	val = _val
	shortcut_label.text = format_text( _val )


func format_text( _str : String ) -> String:
	return _str.replace("+", " + ")


func destroy_me() -> void:
	animation_player.play("hide")
	await animation_player.animation_finished
	on_destroy.emit()
	queue_free()
