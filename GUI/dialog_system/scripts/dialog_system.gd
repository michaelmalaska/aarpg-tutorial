@tool
@icon("res://GUI/dialog_system/icons/star_bubble.svg")
class_name DialogSystemNode extends CanvasLayer

signal finished

var is_active : bool = false

var dialog_items : Array[ DialogItem ]
var dialog_item_index : int = 0


@onready var dialog_ui : Control = $DialogUI
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogUI/NameLabel
@onready var portrait_sprite: Sprite2D = $DialogUI/PortraitSprite
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var dialog_progress_indicator_label: Label = $DialogUI/DialogProgressIndicator/Label




func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child( self )
			return
		return
	hide_dialog()
	pass



func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	if(
			event.is_action_pressed("interact") or
			event.is_action_pressed("attack") or
			event.is_action_pressed("ui_accept")
	):
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	pass



func show_dialog( _items : Array[ DialogItem ] ) -> void:
	is_active = true
	dialog_ui.visible = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	start_dialog()
	pass



func hide_dialog() -> void:
	is_active = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass



func start_dialog() -> void:
	show_dialog_button_indicator( true )
	var _d : DialogItem = dialog_items[ dialog_item_index ]
	set_dialog_data( _d )
	pass



func set_dialog_data( _d : DialogItem ) -> void:
	if _d is DialogText:
		content.text = _d.text
	name_label.text = _d.npc_info.npc_name
	portrait_sprite.texture = _d.npc_info.portrait
	pass



func show_dialog_button_indicator( _is_visible : bool ) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index + 1 < dialog_items.size():
		dialog_progress_indicator_label.text = "NEXT"
	else:
		dialog_progress_indicator_label.text = "END"
