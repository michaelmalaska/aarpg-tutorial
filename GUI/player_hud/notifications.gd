class_name NotificationUI extends Control

var notifcation_queue : Array

@onready var panel_container: PanelContainer = $PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var title_label: Label = $PanelContainer/VBoxContainer/Label
@onready var message_label: Label = $PanelContainer/VBoxContainer/Label2


func _ready() -> void:
	panel_container.visible = false
	animation_player.animation_finished.connect( notificaiton_animation_finished )


func add_notification_to_queue( _title : String, _message : String ) -> void:
	notifcation_queue.append({
			title = _title,
			message = _message
	})
	if animation_player.is_playing():
		return
	display_notification()
	pass


func display_notification() -> void:
	var _n = notifcation_queue.pop_front()
	if _n == null:
		return
	title_label.text = _n.title
	message_label.text = _n.message
	animation_player.play( "show_notification" )
	pass


func notificaiton_animation_finished( _a : String ) -> void:
	display_notification()
