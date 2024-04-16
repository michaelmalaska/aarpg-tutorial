class_name HeartGUI extends Control


@onready var sprite = $Sprite2D


var value : int = 2 :
	set( _value ):
		value = _value
		update_sprite()


func update_sprite() -> void:
	sprite.frame = value

