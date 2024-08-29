@tool
extends NPCBehavior

const COLORS = [ Color(1,0,0), Color(1,1,0), Color(0,1,0), Color(0,1,1), Color(0,0,1), Color(1,0,1) ]

@export var walk_speed : float = 30.0

var patrol_locations : Array[ PatrolLocation ]
var current_location_index : int = 0
var target : PatrolLocation

var has_started : bool = false
var last_phase : String = ""
var direction : Vector2

@onready var timer: Timer = $Timer




func _ready() -> void:
	gather_patrol_locations()
	if Engine.is_editor_hint():
		child_entered_tree.connect( gather_patrol_locations )
		child_order_changed.connect( gather_patrol_locations )
		return
	super()
	if patrol_locations.size() == 0:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	target = patrol_locations[ 0 ]



func _process( _delta: float ) -> void:
	if Engine.is_editor_hint():
		return
	if npc.global_position.distance_to( target.target_position ) < 1:
		idle_phase()



func gather_patrol_locations( _n : Node = null ) -> void:
	patrol_locations = []
	for c in get_children():
		if c is PatrolLocation:
			patrol_locations.append( c )
	
	if Engine.is_editor_hint():
		if patrol_locations.size() > 0:
			for i in patrol_locations.size():
				var _p = patrol_locations[ i ] as PatrolLocation
				
				if not _p.transform_changed.is_connected( gather_patrol_locations ):
					_p.transform_changed.connect( gather_patrol_locations )
				
				_p.update_label( str(i) )
				_p.modulate = _get_color_by_index( i )
				
				var _next : PatrolLocation
				if i < patrol_locations.size() - 1:
					_next = patrol_locations[ i + 1 ]
				else:
					_next = patrol_locations[ 0 ]
				_p.update_line( _next.position )
	pass



func start() -> void:
	if npc.do_behavior == false or patrol_locations.size() < 2:
		return
	
	if has_started == true:
		if timer.time_left == 0:
			walk_phase()
		return #our idle phase is still waiting for the timer timout
	
	has_started = true
	idle_phase()
	pass


func idle_phase() -> void:
	# IDLE PHASE
	npc.global_position = target.target_position
	npc.state = "idle"
	npc.velocity = Vector2.ZERO
	npc.update_animation()
	
	var wait_time : float = target.wait_time
	
	current_location_index += 1
	if current_location_index >= patrol_locations.size():
		current_location_index = 0
	
	target = patrol_locations[ current_location_index ]
	
	if wait_time > 0:
		timer.start(wait_time)
		await timer.timeout
	
	if npc.do_behavior == false:
		return
	
	walk_phase()
	pass



func walk_phase() -> void:
	npc.state = "walk"
	direction = global_position.direction_to( target.target_position )
	npc.direction = direction
	npc.velocity = walk_speed * direction
	npc.update_direction( target.target_position )
	npc.update_animation()
	pass



func _get_color_by_index( i : int ) -> Color:
	var color_count : int = COLORS.size()
	while i > color_count - 1:
		i -= color_count
	return COLORS[ i ]
