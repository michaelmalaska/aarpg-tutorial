@tool
@icon( "res://GUI/dialog_system/icons/question_bubble.svg" )
class_name DialogChoice extends DialogItem

var dialog_branches : Array[ DialogBranch ]



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append( c )



func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_branches() == false:
		return [ "Requires at least 2 DialogBranch nodes." ]
	else:
		return []
	pass


func _check_for_dialog_branches() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogBranch:
			_count += 1
			if _count > 1:
				return true
	return false
