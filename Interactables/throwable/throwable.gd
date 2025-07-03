class_name Throwable extends Area2D

@export var gravity_strength : float = 980
@export var throw_speed : float = 400.0
@export var throw_height_strength : float = 100.0
@export var throw_starting_height : float = 49

var picked_up : bool = false
var prop : Node2D
var throw_direction : Vector2
var object_sprite : Sprite2D
var vertical_velocity : float = 0
var ground_height : float = 0
var animation_player : AnimationPlayer

@onready var hurt_box: HurtBox = $HurtBox
@onready var wall_detect: Area2D = $WallDetect



func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	prop = get_parent()
	setup_collision_boxes()
	
	object_sprite = prop.find_child( "Sprite2D" )
	ground_height = object_sprite.position.y
	animation_player = prop.find_child( "AnimationPlayer" )
	
	set_physics_process( false )



func _physics_process( delta: float ) -> void:
	object_sprite.position.y += vertical_velocity * delta
	if object_sprite.position.y >= ground_height:
		hit_ground()
	vertical_velocity += gravity_strength * delta
	prop.position += throw_direction * throw_speed * delta
	pass


func player_interact() -> void:
	if PlayerManager.interact_handled == true:
		return
	if picked_up == false:
		PlayerManager.interact_handled = true
		disable_collisions( prop )
		if prop.get_parent():
			prop.get_parent().remove_child( prop )
		PlayerManager.player.held_item.add_child( prop )
		prop.position = Vector2.ZERO
		PlayerManager.player.pickup_item( self )
		area_entered.disconnect( _on_area_enter )
		area_exited.disconnect( _on_area_exit )
		pass
	pass



func throw() -> void:
	prop.get_parent().remove_child( prop )
	PlayerManager.player.get_parent().call_deferred( "add_child", prop )
	prop.position = PlayerManager.player.position
	object_sprite.position.y = -throw_starting_height
	vertical_velocity = -throw_height_strength
	set_physics_process( true )
	hurt_box.set_deferred( "monitoring", true )
	hurt_box.did_damage.connect( did_damage )
	wall_detect.body_entered.connect( _on_body_entered )
	pass


func drop() -> void:
	prop.get_parent().call_deferred( "remove_child", prop )
	PlayerManager.player.get_parent().call_deferred( "add_child", prop )
	prop.position = PlayerManager.player.position
	object_sprite.position.y = -50
	vertical_velocity = -200
	throw_speed = 100
	set_physics_process( true )
	wall_detect.body_entered.connect( _on_body_entered )



func destroy() -> void:
	set_physics_process( false )
	if animation_player:
		animation_player.play("destroy")
		await animation_player.animation_finished
	prop.queue_free()
	pass



func disable_collisions( _node : Node ) -> void:
	for c in _node.get_children():
		if c == self:
			continue
		if c is CollisionShape2D:
			c.disabled = true
		else:
			disable_collisions( c )



func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_body_entered( _n : Node2D ) -> void:
	if _n is TileMapLayer:
		did_damage()
	pass


func setup_collision_boxes() -> void:
	hurt_box.monitoring = false
	for c in get_children():
		if c is CollisionShape2D:
			var _col : CollisionShape2D = c.duplicate()
			hurt_box.add_child( _col )
			_col.debug_color = Color(1,0,0,0.5)
			var _col_2 : CollisionShape2D = c.duplicate()
			wall_detect.add_child( _col_2 )


func hit_ground() -> void:
	destroy()
	pass


func did_damage() -> void:
	destroy()
	pass
