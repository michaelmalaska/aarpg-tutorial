extends Sprite2D

const FRAME_COUNT : int = 128

@onready var weapon_below: Sprite2D = $Sprite2D_Weapon_Below
@onready var weapon_above: Sprite2D = $Sprite2D_Weapon_Above


func _ready() -> void:
	PlayerManager.INVENTORY_DATA.equipment_changed.connect( _on_equipment_changed )
	SaveManager.game_loaded.connect( _on_equipment_changed )
	pass



func _process( _delta: float ) -> void:
	weapon_below.frame = frame
	weapon_above.frame = frame + FRAME_COUNT
	pass



func _on_equipment_changed() -> void:
	var equipment : Array[ SlotData ] = PlayerManager.INVENTORY_DATA.equipment_slots()
	texture = equipment[ 0 ].item_data.sprite_texture
	weapon_below.texture = equipment[ 1 ].item_data.sprite_texture
	weapon_above.texture = equipment[ 1 ].item_data.sprite_texture
	pass
