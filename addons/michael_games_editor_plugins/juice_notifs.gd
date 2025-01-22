@tool
class_name JuiceNotifs extends Control

enum COLOR { WHITE, RED, GREEN, BLUE, YELLOW, ORANGE, PINK, PURPLE }
var colors : Array[Color] = [
	Color(1, 1, 1), #WHITE
	Color(1, 0.257, 0.327), #RED
	Color(0.48, 0.873, 0.442), #GREEN
	Color(0.32, 0.54, 0.901), #BLUE
	Color(1, 0.846, 0.434), #YELLOW
	Color(1, 0.623, 0.401), #ORANGE
	Color(0.968, 0.421, 0.671), #PINK
	Color(0.692, 0.402, 0.955), #PURPLE
]


@onready var panel: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer




func _ready() -> void:
	EditorInterface.get_script_editor().editor_script_changed.connect( on_editor_script_changed )
	animation_player.play( "default" )
	pass



func show_scene_notification( _scene ) -> void:
	if _scene == null:
		label.text = "NEW Scene Created "
		modulate = colors[2]
	else:
		label.text = "scene: " + _scene.name
	modulate = get_color_by_node_type( _scene )
	if animation_player:
		animation_player.play("show_notification")
		animation_player.seek(0)



func on_editor_script_changed( _s : Script ) -> void:
	if _s == null:
		return
	label.text = "script: "
	if _s.get_global_name() != "":
		label.text += _s.get_global_name() + " : "
	label.text += _s.get_path()
	modulate = get_color( COLOR.YELLOW )
	if animation_player:
		animation_player.play("show_notification")
		animation_player.seek(0)
	pass



func get_color( _color : COLOR ) -> Color:
	return colors[ _color ]


func get_color_by_node_type( _n : Node ) -> Color:
	if _n is Node2D:
		return colors[ 3 ]
	elif _n is Control:
		return colors[ 2 ]
	elif _n is Node3D:
		return colors[ 1 ]
	elif _n is AnimationMixer:
		return colors[ 2 ]
	return colors[0]
