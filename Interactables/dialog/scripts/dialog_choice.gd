@tool
@icon( "res://GUI/dialog_system/icons/question_bubble.svg" )
class_name DialogChoice extends DialogItem

var dialog_branches : Array[ DialogBranch ]



func _ready() -> void:
	super()
	for c in get_children():
		if c is DialogBranch:
			dialog_branches.append( c )



func _set_editor_display() -> void:
	set_related_text()
	
	if dialog_branches.size() < 2:
		return
	example_dialog.set_dialog_choice( self )
	pass



func set_related_text() -> void:
	var _p = get_parent()
	var _t = _p.get_child( self.get_index() - 1 )
	
	if _t is DialogText:
		example_dialog.set_dialog_text( _t )
		example_dialog.content.visible_characters = -1



func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_branches() == false:
		return [ "Requires at least 2 DialogBranch nodes." ]
	else:
		return []



func _check_for_dialog_branches() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogBranch:
			_count += 1
			if _count > 1:
				return true
	return false
