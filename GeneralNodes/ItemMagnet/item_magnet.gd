class_name ItemMagnet extends Area2D


var items : Array[ItemPickup] = []
var speeds : Array[float] = []


@export var magnet_strength : float = 1.0
@export var play_magnet_audio : bool = false

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D



func _ready() -> void:
	area_entered.connect( _on_area_enter )
	pass



func _process(delta: float) -> void:
	for i in range( items.size() - 1, -1, -1 ):
		var _item = items[i]
		if _item == null:
			items.remove_at( i )
			speeds.remove_at( i )
		elif _item.global_position.distance_to( global_position ) > speeds[i]:
			speeds[i] += magnet_strength * delta
			_item.position += _item.global_position.direction_to( global_position ) * speeds[i]
		else:
			_item.global_position = global_position
	pass



func _on_area_enter( _a : Area2D ) -> void:
	if _a.get_parent() is ItemPickup:
		var _new_item = _a.get_parent() as ItemPickup
		items.append( _new_item )
		speeds.append( magnet_strength )
		_new_item.set_physics_process( false )
		if play_magnet_audio:
			audio.play(0)
		pass
	pass

