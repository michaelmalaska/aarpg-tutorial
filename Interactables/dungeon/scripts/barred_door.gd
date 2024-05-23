class_name BarredDoor extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	pass



func open_door() -> void:
	animation_player.play( "open_door" )
	pass


func close_door() -> void:
	animation_player.play( "close_door" )
	pass



