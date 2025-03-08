class_name InventorySlotUI extends Button


var slot_data : SlotData : set = set_slot_data
var click_pos : Vector2 = Vector2.ZERO
var dragging : bool = false
var drag_texture : Control
var drag_threshold : float = 16.0

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )
	button_down.connect( on_button_down )
	button_up.connect( on_button_up )


func _process( _delta: float ) -> void:
	if dragging == true:
		drag_texture.position = get_local_mouse_position() - Vector2(16,16)
		if outside_drag_threshold() == true:
			drag_texture.modulate.a = 0.5
		else:
			drag_texture.modulate.a = 0.0
	pass


func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	
	if slot_data == null:
		texture_rect.texture = null
		label.text = ""
		return
	
	texture_rect.texture = slot_data.item_data.texture
	if slot_data.item_data is EquipableItemData:
		label.text = ""
	else:
		label.text = str( slot_data.quantity )


func item_focused() -> void:
	PauseMenu.focused_item_changed( slot_data )
	pass


func item_unfocused() -> void:
	PauseMenu.update_item_description( "" )
	pass


func item_pressed() -> void:
	if slot_data and outside_drag_threshold() == false:
		if slot_data.item_data:
			var item = slot_data.item_data
			
			if item is EquipableItemData:
				PlayerManager.INVENTORY_DATA.equip_item( slot_data )
				return
			
			var was_used = item.use()
			if was_used == false:
				return
			slot_data.quantity -= 1
			
			if slot_data == null:
				return
			label.text = str( slot_data.quantity )


func on_button_down() -> void:
	click_pos = get_global_mouse_position()
	dragging = true
	drag_texture = texture_rect.duplicate()
	drag_texture.z_index = 10
	drag_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child( drag_texture )
	pass


func on_button_up() -> void:
	dragging = false
	if drag_texture:
		drag_texture.free()
	pass



func outside_drag_threshold() -> bool:
	if get_global_mouse_position().distance_to( click_pos ) > drag_threshold:
		return true
	return false
