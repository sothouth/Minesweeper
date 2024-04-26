extends Node


#BlockState
enum {NORMAL,WAIT,FLAG,CLICKED,NUMBER,MINE,WARN,SHOW,SHOW_ACTION,SHOW_STOP}
#GameState
enum {READY,RUN,DEAD,COMPLETED,STOP}
#BlockType
enum {SQUARES,TRIANGULAR,HONEYCOMB,BIGSQUARES}

const draw_sun_direction:float=45*PI/180
const draw_width_background_line:float=1.0
const draw_width_normal_line:float=2.0
const draw_color_background:Color=Color8(218,218,218)
const draw_color_normal:Color=Color8(230,230,230)
const draw_color_gray:Color=Color8(157,157,157)
const draw_color_light:Color=Color8(250,250,250)
const draw_color_base:Color=Color8(100,100,100)
const draw_color_addition:Color=draw_color_light-draw_color_base
const draw_size_font:float=20.0
const draw_size_mine:float=1.0
const draw_size_flag:float=1.0
const draw_color_mine_top:Color=Color8(255,255,255)
const draw_array_mine_top:PackedVector2Array=[
	Vector2(-3,-3),
	Vector2(-1,-3),
	Vector2(-1,-2),
	Vector2(-2,-2),
	Vector2(-2,-1),
	Vector2(-3,-1),
]
const draw_color_mine_bottom:Color=Color8(10,10,10)
const draw_array_mine_bottom:PackedVector2Array=[
	Vector2(-2,-8),
	Vector2(-2,-10),
	Vector2(2,-10),
	Vector2(2,-8),
	Vector2(8,-2),
	Vector2(10,-2),
	Vector2(10,2),
	Vector2(8,2),
	Vector2(2,8),
	Vector2(2,10),
	Vector2(-2,10),
	Vector2(-2,8),
	Vector2(-8,2),
	Vector2(-10,2),
	Vector2(-10,-2),
	Vector2(-8,-2),
]
const draw_color_flag_top:Color=Color8(240,20,20)
const draw_array_flag_top:PackedVector2Array=[
	Vector2(2,0),
	Vector2(5,0),
	Vector2(5,-10),
	Vector2(-10,-5),
]
const draw_color_flag_bottom:Color=Color8(10,10,10)
const draw_array_flag_bottom:PackedVector2Array=[
	Vector2(2,0),
	Vector2(5,0),
	Vector2(5,5),
	Vector2(11,10),
	Vector2(-9,10),
	Vector2(2,5),
]

#block data
const squares_size:Vector2i=Vector2i(32,32)
const squares_polygon:PackedVector2Array=[
	Vector2(-16,-16),
	Vector2(16,-16),
	Vector2(16,16),
	Vector2(-16,16),
]
const triangular_size:Vector2i=Vector2i(33,38)
const triangular_polygon:PackedVector2Array=[
	Vector2(-22,0),
	Vector2(11,19),
	Vector2(11,-19),
]
const honeycomb_size:Vector2i=Vector2i(32,28)
const honeycomb_polygon:PackedVector2Array=[
	Vector2(-8,-14),
	Vector2(8,-14),
	Vector2(16,0),
	Vector2(8,14),
	Vector2(-8,14),
	Vector2(-16,0),
]
const squares_2_size:Vector2i=Vector2i(64,64)
const squares_2_polygon:PackedVector2Array=[
	Vector2(-32,-32),
	Vector2(32,-32),
	Vector2(32,32),
	Vector2(-32,32),
]


var number_modulate:Array=[
	Color8(0,0,0,0),#0
	Color8(84,84,241),#1
	Color8(30,140,30),#2
	Color8(248,46,46),#3
	Color8(88,88,164),#4
	Color8(147,46,46),#5
	Color8(40,144,144),#6
	Color8(21,21,21),#7
	Color8(255,255,255),#8
	]


var background_modulate:Dictionary={
	NORMAL:Color8(255,255,255),
	CLICKED:Color8(255,255,255),
	WARN:Color8(250,220,220),
	MINE:Color8(255,25,25),
}
