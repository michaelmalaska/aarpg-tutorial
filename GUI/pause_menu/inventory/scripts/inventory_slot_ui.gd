class_name InventorySlotUI extends Button


var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label



func _ready() -> void:
	texture_rect.texture = null
	label.text = ""
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )


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
	if slot_data:
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
