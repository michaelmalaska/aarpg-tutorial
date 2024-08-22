@tool
@icon( "res://GUI/dialog_system/icons/chat_bubble.svg" )
class_name DialogItem extends Node


@export var npc_info : NPCResource


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	check_npc_data()



func check_npc_data() -> void:
	if npc_info == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.npc_resource:
					npc_info = p.npc_resource
					_checking = false
			else:
				_checking = false
