extends SingleGame

func _init():
	game_name="squares"
	self_path=Path.singleGame[game_name]


func load_cfg():
	mine_number=Global.config.get_value(
		"single_squares_config",
		"mine_number"
	)
	map_size=Global.config.get_value(
		"single_squares_config",
		"size"
	)
	zoom=Global.config.get_value(
		"single_squares_config",
		"zoom"
	)

func init_rect_size():
	rect_size=Data.squares_size*(map_size-Vector2i.ONE)

func spawn_map_with(map_size:Vector2i):
	for x in range(map_size.x):
		for y in range(map_size.y):
			spawn_block_with(
				Vector2i(x,y)*Data.squares_size,
				Data.squares_polygon
			)


