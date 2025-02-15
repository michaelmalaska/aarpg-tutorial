class_name EquipableItemData extends ItemData

enum Type { WEAPON, ARMOR, AMULET, RING }
@export var type : Type = Type.WEAPON
@export var modifiers : Array[ EquipableItemModifier ]
@export var sprite_texture : Texture
