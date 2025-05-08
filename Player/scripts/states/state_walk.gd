class_name State_Walk extends State

@export var move_speed : float = 100.0

@onready var idle : State = $"../Idle"
@onready var attack : State = $"../Attack"
@onready var dash : State = $"../Dash"


## What happens when the player enters this State?
func enter() -> void:
	player.update_animation("walk")
	pass


## What happens when the player exits this State?
func exit() -> void:
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	return null


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	elif _event.is_action_pressed("interact"):
		PlayerManager.interact()
	elif _event.is_action_pressed("dash"):
		return dash
	return null
