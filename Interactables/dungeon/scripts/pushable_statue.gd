class_name PushableStatue extends RigidBody2D

@export var push_speed : float = 30.0
@export var persistent : bool = false
@export var persistent_location : Vector2 = Vector2.ZERO
@export var target_location_size : Vector2 = Vector2( 4, 4 )

var push_direction : Vector2 = Vector2.ZERO : set = _set_push
var on_target : bool = false

@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistent_data_handler: PersistentDataHandler = $OnTarget



func _ready() -> void:
	# Set the location if saved
	if persistent_data_handler.value == true:
		position = persistent_location
	pass



func _physics_process( _delta: float ) -> void:
	linear_velocity = push_direction * push_speed
	if persistent:
		# If the x corrdinate is on target/close enough
		var x_is_on : bool = abs( position.x - persistent_location.x ) < 15 + target_location_size.x
		var y_is_on : bool = abs( position.y - persistent_location.y ) < 6 + target_location_size.y
		if x_is_on and y_is_on and on_target == false:
			on_target = true
			persistent_data_handler.set_value()
		elif ( x_is_on == false or y_is_on == false ) and on_target == true:
			on_target = false
			persistent_data_handler.remove_value()
		pass
	pass



func _set_push( value : Vector2 ) -> void:
	push_direction = value
	if push_direction == Vector2.ZERO:
		audio.stop()
	else:
		audio.play()
	pass
