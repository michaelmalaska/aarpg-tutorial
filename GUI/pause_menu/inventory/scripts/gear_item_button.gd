extends Button

@export_multiline var description : String = ""


func _ready() -> void:
	focus_entered.connect( _on_focus_entered )


func _on_focus_entered() -> void:
	PauseMenu.update_item_description( description )
