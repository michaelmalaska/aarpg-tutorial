class_name InventoryUI extends Control

const INVENTORY_SLOT = preload("res://GUI/pause_menu/inventory/inventory_slot.tscn")

var focus_index : int = 0

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
