class_name Stats extends PanelContainer

var inventory : InventoryData

@onready var label_level: Label = %Label_lvl
@onready var label_xp: Label = %Label_xp
@onready var label_attack: Label = %Label_attack
@onready var label_defense: Label = %Label_defense
@onready var label_attack_change: Label = %Label_attack_change
@onready var label_defense_change: Label = %Label_defense_change



func _ready() -> void:
	PauseMenu.shown.connect( update_stats )
	PauseMenu.preview_stats_changed.connect( _on_preview_stats_changed )
	inventory = PlayerManager.INVENTORY_DATA
	inventory.equipment_changed.connect( update_stats )


func update_stats() -> void:
	var _p : Player = PlayerManager.player
	label_level.text = str( _p.level )
	
	if _p.level < PlayerManager.level_requirements.size():
		label_xp.text = str( _p.xp ) + "/" + str( PlayerManager.level_requirements[ _p.level ] )
	else:
		label_xp.text = "MAX LVL"
	
	label_attack.text = str( _p.attack + inventory.get_attack_bonus() )
	label_defense.text = str( _p.defense + inventory.get_defense_bonus() )
	pass


func _on_preview_stats_changed( item : ItemData ) -> void:
	label_attack_change.text = ""
	label_defense_change.text = ""
	
	if not item is EquipableItemData:
		return
	
	var equipment : EquipableItemData = item
	var attack_delta : int = inventory.get_attack_bonus_diff( equipment )
	var defense_delta : int = inventory.get_defense_bonus_diff( equipment )
	
	update_change_label( label_attack_change, attack_delta )
	update_change_label( label_defense_change, defense_delta )
	
	pass


func update_change_label( label : Label, value : int ) -> void:
	if value > 0:
		label.text = "+" + str( value )
		label.modulate = Color.LIGHT_GREEN
	elif value < 0:
		label.text = str( value )
		label.modulate = Color.INDIAN_RED
	pass
