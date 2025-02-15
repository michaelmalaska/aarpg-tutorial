extends Node

const DAMAGE_TEXT = preload("res://00_Globals/global_effects/damage_text.tscn")



func damage_text( _damage : int, _pos : Vector2 ) -> void:
	var _t : DamageText = DAMAGE_TEXT.instantiate()
	add_child( _t )
	_t.start( str( _damage ), _pos )
	pass
