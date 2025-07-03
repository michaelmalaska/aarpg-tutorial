class_name ThrowableBomb extends Throwable

@export_category( "Bomb Settings" )
@export_range( 1.0, 10.0, 0.1, "s" ) var fuse_duration : float = 4.0

@export_category( "Bounce Settings" )
@export_range( 0.1, 0.9, 0.05 ) var bounciness : float = 0.5
@export_range( 1, 10, 1 ) var max_bounces : int = 5

var bounce_count : int = 0
var og_throw_speed : float = 0

@onready var explosion_sprite: Sprite2D = $"../ExplosionSprite"


func _ready() -> void:
	super()
	og_throw_speed = throw_speed
	hurt_box.damage = 0
	animation_player.queue( "explode" )
	animation_player.animation_changed.connect( _on_animation_changed )
	animation_player.speed_scale = animation_player.current_animation_length / fuse_duration
	pass


func _physics_process( delta: float ) -> void:
	super( delta )
	explosion_sprite.position = object_sprite.position
	pass


func _on_animation_changed( _old_name : String, _new_name : String ) -> void:
	animation_player.speed_scale = 1.0
	pass


func player_interact() -> void:
	super()
	throw_speed = og_throw_speed
	bounce_count = 0
	pass


func hit_ground() -> void:
	bounce_count += 1
	
	if bounce_count <= max_bounces:
		object_sprite.position.y = ground_height - 1
		vertical_velocity *= -1 * bounciness
		throw_speed *= bounciness
	else:
		set_physics_process( false )
		hurt_box.set_deferred( "monitoring", false )
		hurt_box.did_damage.disconnect( did_damage )
		wall_detect.body_entered.disconnect( _on_body_entered )
		area_entered.connect( _on_area_enter )
		area_exited.connect( _on_area_exit )
	pass


func did_damage() -> void:
	var throw_magnitude : Vector2 = throw_direction.abs()
	if throw_magnitude.x > throw_magnitude.y:
		throw_direction *= Vector2( -1, 1 )
	else:
		throw_direction *= Vector2( 1, -1 )
	throw_speed *= bounciness
	pass


func disable_collisions( _node : Node ) -> void:
	super( _node )
	$"../HurtBox/CollisionShape2D".disabled = false
	pass


func drop() -> void:
	super()
	if animation_player.current_animation == "explode":
		explosion_sprite.position = object_sprite.position
		set_physics_process( false )
