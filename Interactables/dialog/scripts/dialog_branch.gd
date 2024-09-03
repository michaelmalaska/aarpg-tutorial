@tool
@icon( "res://GUI/dialog_system/icons/answer_bubble.svg" )
class_name DialogBranch extends DialogItem


@export var text : String = "ok..."

var dialog_items : Array[ DialogItem ]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	pass
