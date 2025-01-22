class_name Stats extends PanelContainer

@onready var label_level: Label = $VBoxContainer/HBoxContainer/Label2
@onready var label_xp: Label = $VBoxContainer/HBoxContainer2/Label2
@onready var label_attack: Label = $VBoxContainer/HBoxContainer3/Label2
@onready var label_defense: Label = $VBoxContainer/HBoxContainer4/Label2



func _ready() -> void:
	PauseMenu.shown.connect( update_stats )


func update_stats() -> void:
	var _p : Player = PlayerManager.player
	label_level.text = str( _p.level )
	
	if _p.level < PlayerManager.level_requirements.size():
		label_xp.text = str( _p.xp ) + "/" + str( PlayerManager.level_requirements[ _p.level ] )
	else:
		label_xp.text = "MAX LVL"
	
	label_attack.text = str( _p.attack )
	label_defense.text = str( _p.defense )
	pass
