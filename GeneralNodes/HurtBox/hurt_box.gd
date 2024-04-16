class_name HurtBox extends Area2D

@export var damage : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect( _area_entered )
	pass # Replace with function body.



func _area_entered( a : Area2D ) -> void:
	if a is HitBox:
		a.take_damage( self )
	pass
