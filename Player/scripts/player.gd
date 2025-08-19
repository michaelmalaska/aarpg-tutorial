class_name Player extends CharacterBody2D

signal direction_changed( new_direction: Vector2 )
signal player_damaged( hurt_box: HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

var level : int = 1
var xp : int = 0

var attack : int = 1 :
	set( v ):
		attack = v
		update_damage_values()

var defense : int = 1
var defense_bonus : int = 0

var arrow_count : int = 10 : set = _set_arrow_count
var bomb_count : int = 10 : set = _set_bomb_count

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var audio: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D
@onready var lift: State_Lift = $StateMachine/Lift
@onready var held_item: Node2D = $Sprite2D/HeldItem
@onready var carry: State_Carry = $StateMachine/Carry




# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.damaged.connect( _take_damage )
	update_hp(99)
	update_damage_values()
	PlayerManager.player_leveled_up.connect( _on_player_leveled_up )
	PlayerManager.INVENTORY_DATA.equipment_changed.connect( _on_equipment_changed )
	pass



func change_sprite() -> void:
	sprite.texture = load("res://path/to/sprite.png")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass


func _physics_process( _delta ):
	move_and_slide()



func _unhandled_input( _event: InputEvent ) -> void:
	#if event.is_action_pressed("test"):
		#PlayerManager.shake_camera()
	pass



func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true



func update_animation( state : String ) -> void:
	animation_player.play( state + "_" + anim_direction() )
	pass


func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"



func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	
	if hp > 0:
		var dmg : int = hurt_box.damage
		
		# Simple damage calculation that subtracts defense value
		# will keep damage to a minimum of 1, so we will do an if check
		# to allow 0 to still be passed by a hurt_box if needed
		if dmg > 0:
			dmg = clampi( dmg - defense - defense_bonus, 1, dmg )
		
		update_hp( -dmg )
		player_damaged.emit( hurt_box )
	
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	PlayerHud.update_hp( hp, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass


func pickup_item( _t : Throwable ) -> void:
	state_machine.change_state( lift )
	carry.throwable = _t
	pass



func revive_player() -> void:
	update_hp( 99 )
	state_machine.change_state( $StateMachine/Idle )



func update_damage_values() -> void:
	var damage_value : int = attack + PlayerManager.INVENTORY_DATA.get_attack_bonus()
	%AttackHurtBox.damage = damage_value
	%ChargeSpinHurtBox.damage = damage_value * 2


func _on_player_leveled_up() -> void:
	effect_animation_player.play( "level_up" )
	update_hp( max_hp )
	pass



func _on_equipment_changed() -> void:
	update_damage_values()
	defense_bonus = PlayerManager.INVENTORY_DATA.get_defense_bonus()


func _set_arrow_count( value : int ) -> void:
	arrow_count = value
	PlayerHud.update_arrow_count( value )
	pass


func _set_bomb_count( value : int ) -> void:
	bomb_count = value
	PlayerHud.update_bomb_count( value )
	pass
