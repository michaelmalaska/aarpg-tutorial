class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn")

var focus_index : int = 0
var hovered_item : InventorySlotUI

@export var data : InventoryData

@onready var inventory_slot_armor: InventorySlotUI = %InventorySlot_Armor
@onready var inventory_slot_amulet: InventorySlotUI = %InventorySlot_Amulet
@onready var inventory_slot_weapon: InventorySlotUI = %InventorySlot_Weapon
@onready var inventory_slot_ring: InventorySlotUI = %InventorySlot_Ring



func _ready() -> void:
	PauseMenu.shown.connect( update_inventory )
	PauseMenu.hidden.connect( clear_inventory )
	clear_inventory()
	data.changed.connect( on_inventory_changed )
	data.equipment_changed.connect( on_inventory_changed )
	pass


func clear_inventory() -> void:
	for c in get_children():
		c.set_slot_data( null )


func update_inventory( apply_focus : bool = true ) -> void:
	clear_inventory()
	
	var inventory_slots : Array[ SlotData ] = data.inventory_slots()
	
	for i in inventory_slots.size():
		var slot : InventorySlotUI = get_child( i )
		slot.set_slot_data( inventory_slots[ i ] )
		connect_item_signals( slot )
	
	# Update equipment slots
	var e_slots : Array[ SlotData ] = data.equipment_slots()
	inventory_slot_armor.set_slot_data( e_slots[ 0 ] )
	inventory_slot_weapon.set_slot_data( e_slots[ 1 ] )
	inventory_slot_amulet.set_slot_data( e_slots[ 2 ] )
	inventory_slot_ring.set_slot_data( e_slots[ 3 ] )
	
	if apply_focus:
		get_child( 0 ).grab_focus()


func item_focused() -> void:
	for i in get_child_count():
		if get_child( i ).has_focus():
			focus_index = i
			return
	pass


func on_inventory_changed() -> void:
	update_inventory( false )


func connect_item_signals( item : InventorySlotUI ) -> void:
	if not item.button_up.is_connected( _on_item_drop ):
		item.button_up.connect( _on_item_drop.bind( item ) )
	
	if not item.mouse_entered.is_connected( _on_item_mouse_entered ):
		item.mouse_entered.connect( _on_item_mouse_entered.bind( item ) )
	
	if not item.mouse_exited.is_connected( _on_item_mouse_exited ):
		item.mouse_exited.connect( _on_item_mouse_exited )
	pass


func _on_item_drop( item : InventorySlotUI ) -> void:
	if item == null or item == hovered_item or hovered_item == null:
		return
	data.swap_items_by_index( item.get_index(), hovered_item.get_index() )
	update_inventory( false )
	pass


func _on_item_mouse_entered( item : InventorySlotUI ) -> void:
	hovered_item = item
	pass


func _on_item_mouse_exited() -> void:
	hovered_item = null
	pass
