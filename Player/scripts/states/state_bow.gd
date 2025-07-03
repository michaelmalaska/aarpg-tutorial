class_name State_Bow extends State

const ARROW = preload("res://Interactables/arrow/arrow.tscn")

@onready var idle: State = $"../Idle"

var direction : Vector2 = Vector2.ZERO
var next_state : State = null


func _ready():
	pass # Replace with function body.



## What happens when the player enters this State?
func enter() -> void:
	player.update_animation( "bow" )
	player.animation_player.animation_finished.connect( _on_animation_finished )
	direction = player.cardinal_direction
	
	var arrow : Arrow = ARROW.instantiate()
	player.add_sibling( arrow )
	arrow.global_position = player.global_position + ( direction * 32 )
	arrow.fire( direction )
	pass


## What happens when the player exits this State?
func exit() -> void:
	player.animation_player.animation_finished.disconnect( _on_animation_finished )
	next_state = null
	pass


## What happens during the _process update in this State?
func process( _delta : float ) -> State:
	player.velocity = Vector2.ZERO
	return next_state


## What happens during the _physics_process update in this State?
func physics( _delta : float ) -> State:
	return null


## What happens with input events in this State?
func handle_input( _event: InputEvent ) -> State:
	return null



func _on_animation_finished( anim_name : String ) -> void:
	next_state = idle
	pass
