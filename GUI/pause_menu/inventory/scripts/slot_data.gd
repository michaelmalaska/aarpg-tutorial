class_name SlotData extends Resource

@export var item_data : ItemData
@export var quantity : int = 0 : set = set_quantity


func set_quantity( value : int ) -> void:
	quantity = value
	if Engine.is_editor_hint():
		return
	if quantity < 1:
		emit_changed()
