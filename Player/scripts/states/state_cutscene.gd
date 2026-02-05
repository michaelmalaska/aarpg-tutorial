class_name State_Cutscene extends State

@onready var idle: State_Idle = $"../Idle"


func init() -> void:
	DialogSystem.started.connect( _on_dialog_started )
	DialogSystem.finished.connect( _on_dialog_finished )
	pass


## What happens when the player enters this State?
func enter() -> void:
	player.update_animation("idle")
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	pass


## What happens when the player exits this State?
func exit() -> void:
	player.process_mode = Node.PROCESS_MODE_INHERIT
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null


func _on_dialog_started() -> void:
	state_machine.change_state( self )
	pass


func _on_dialog_finished() -> void:
	state_machine.change_state( idle )
	pass
