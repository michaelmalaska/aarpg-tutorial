@tool
extends Control

const SHORTCUT_LABEL = preload("res://addons/michael_games_editor_plugins/shortcut_label.tscn")

var labels : Array[ ShortcutLabel ]
@onready var stack: VBoxContainer = %ShortcutStack



func _input( event: InputEvent ) -> void:
	if event is InputEventKey:
		var _str = OS.get_keycode_string( event.get_keycode_with_modifiers() )
		if not _str is String:
			return
		if _str.contains( "+" ):
			if _str.right(2).begins_with("+"):
				if is_capitol_letter( _str ):
					return
				if not is_duplicate( _str ):
					var new : ShortcutLabel = SHORTCUT_LABEL.instantiate()
					stack.add_child( new )
					new.set_label( _str )
					new.on_destroy.connect( remove_from_array.bind( new ) )
					labels.append( new )
			pass
		return
	pass
#

func remove_from_array( old : ShortcutLabel ) -> void:
	labels.erase( old )


func is_capitol_letter( _str : String ) -> bool:
	var test = _str.count("+")
	if _str.contains( "Shift" ) and test <= 1:
		return true
	return false


func is_duplicate( _str : String ) -> bool:
	for i in labels:
		if i.val == _str:
			return true
	return false
