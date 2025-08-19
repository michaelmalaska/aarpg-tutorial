@tool
class_name ItemPickup extends CharacterBody2D

signal picked_up

@export var item_data : ItemData : set = _set_item_data
@export var item_count : int = 1 : set = _set_item_count

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var count_label: Label = %CountLabel



func _ready() -> void:
	_update_texture()
	_update_count_label()
	if Engine.is_editor_hint():
		return
	area_2d.body_entered.connect( _on_body_entered )



func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4


func _on_body_entered( b ) -> void:
	if b is Player:
		if item_data:
			if item_data.name == "Bomb":
				PlayerManager.player.bomb_count += item_count
				item_picked_up()
			elif item_data.name == "Arrow":
				PlayerManager.player.arrow_count += item_count
				item_picked_up()
			elif PlayerManager.INVENTORY_DATA.add_item( item_data, item_count ) == true:
				item_picked_up()
	pass


func item_picked_up() -> void:
	area_2d.body_entered.disconnect( _on_body_entered )
	audio_stream_player_2d.play()
	visible = false
	picked_up.emit()
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass


func _set_item_count( value : int ) -> void:
	item_count = value
	_update_count_label()
	pass


func _update_count_label() -> void:
	if item_data and count_label:
		count_label.text = ""
		if item_count > 1:
			count_label.text = str( item_count )
	pass
