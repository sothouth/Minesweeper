extends SingleGame

var half_triangular_size:Vector2i=Vector2i(
	Data.triangular_size.x,
	Data.triangular_size.y*0.5
)

func _init():
	game_name="triangular"
	self_path=Path.singleGame[game_name]


func load_cfg():
	mine_number=Global.config.get_value(
		"single_triangular_config",
		"mine_number"
	)
	map_size=Global.config.get_value(
		"single_triangular_config",
		"size"
	)
	zoom=Global.config.get_value(
		"single_triangular_config",
		"zoom"
	)



func init_rect_size():
	rect_size=half_triangular_size*(map_size-Vector2i.ONE)

func spawn_map_with(map_size:Vector2i):
	for x in range(map_size.x):
		for y in range(map_size.y):
			if (x+y)&1:
				spawn_block_with(
					Vector2i(x,y)*half_triangular_size,
					Data.triangular_polygon,
					PI
				)
			else:
				spawn_block_with(
					Vector2i(x,y)*half_triangular_size+Vector2i(Data.triangular_size.x/3,0),
					Data.triangular_polygon
				)

