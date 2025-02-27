class_name FootstepAudio2D extends AudioStreamPlayer2D

var stream_randomizer : AudioStreamRandomizer
@export var footstep_variants : Array[ AudioStream ]


func _ready() -> void:
	stream_randomizer = stream


func play_footstep() -> void:
	get_footstep_type()
	play()


func get_footstep_type() -> void:
	for t in get_tree().get_nodes_in_group( "tilemaps" ):
		if t is TileMapLayer:
			if t.tile_set.get_custom_data_layer_by_name( "footstep_type" ) == -1:
				continue
			var cell : Vector2i = t.local_to_map( t.to_local( global_position ) )
			var data : TileData = t.get_cell_tile_data( cell )
			if data:
				var type = data.get_custom_data( "footstep_type" )
				if type == null:
					continue
				#stream = footstep_variants[ type ]
				stream_randomizer.set_stream( 0, footstep_variants[ type ] )
			pass
		pass
	pass
