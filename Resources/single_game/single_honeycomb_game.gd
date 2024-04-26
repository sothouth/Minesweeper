extends SingleGame

var cal_honeycomb_size:Vector2i=Vector2i(
	Data.honeycomb_size.x*0.75,
	Data.honeycomb_size.y
)

func _init():
	self_path=Path.singleGame["honeycomb"]



func load_cfg():
	mine_number=Global.config.get_value(
		"single_honeycomb_config",
		"mine_number"
	)
	map_size=Global.config.get_value(
		"single_honeycomb_config",
		"size"
	)
	zoom=Global.config.get_value(
		"single_honeycomb_config",
		"zoom"
	)


func init_rect_size():
	rect_size=cal_honeycomb_size*(map_size-Vector2i.ONE)

func spawn_map_with(map_size:Vector2i):
	for x in range(map_size.x):
		for y in range(map_size.y):
			if x&1:
				spawn_block_with(
					Vector2i(x,y)*cal_honeycomb_size-Vector2i(0,Data.honeycomb_size.y/2),
					Data.honeycomb_polygon
				)
			else:
				spawn_block_with(
					Vector2i(x,y)*cal_honeycomb_size,
					Data.honeycomb_polygon
				)


