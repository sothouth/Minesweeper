extends SingleGame

func _init():
	self_path=Path.singleGame["squares_2"]


func load_cfg():
	mine_number=Global.config.get_value(
		"single_squares_2_config",
		"mine_number"
	)
	map_size=Global.config.get_value(
		"single_squares_2_config",
		"size"
	)
	zoom=Global.config.get_value(
		"single_squares_2_config",
		"zoom"
	)

func init_rect_size():
	rect_size=Data.squares_2_size*(map_size-Vector2i.ONE)

func spawn_map_with(map_size:Vector2i):
	for x in range(map_size.x):
		for y in range(map_size.y):
			if (x+y)&1:
				spawn_quarter_squares(Vector2i(x,y)*Data.squares_2_size)
			else:
				spawn_block_with(
					Vector2i(x,y)*Data.squares_2_size,
					Data.squares_2_polygon
				)

func spawn_quarter_squares(pos:Vector2i):
	pos-=Data.squares_size/2
	for i in range(2):
		for j in range(2):
			spawn_block_with(
				pos+Vector2i(i,j)*Data.squares_size,
				Data.squares_polygon
			)



