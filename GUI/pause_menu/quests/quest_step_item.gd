class_name QuestStepItem extends Control

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D



func initialize( step : String, is_complete : bool ) -> void:
	label.text = step
	if is_complete == true:
		sprite_2d.frame = 1
	else:
		sprite_2d.frame = 0
	pass
