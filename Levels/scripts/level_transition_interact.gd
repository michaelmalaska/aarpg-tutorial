@tool
class_name LevelTransitionInteract extends LevelTransition


func _ready() -> void:
	super()
	area_entered.connect( _on_area_entered )
	area_exited.connect( _on_area_exited )


func player_interact() -> void:
	_player_entered( PlayerManager.player )
	pass


func _on_area_entered( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exited( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _update_area() -> void:
	super()
	collision_shape.shape.size = Vector2( 32, 32 )
