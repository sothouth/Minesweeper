extends Area2D

class_name Block

signal state_changed(block,state)

var blokc_name:String

@onready
var number_font:Font=load(Path.fontNormal)

var is_ready:bool=false

#means this block cannot spawn mine
var except:bool=false

func get_polygon()->PackedVector2Array:
	return %blockCollisionPolygon.polygon
func set_polygon(value:PackedVector2Array):
	%blockCollisionPolygon.polygon=value
#	%number.add_theme_font_size_override(StringName("font_size"),16)
	polyline=Array(value)
	polyline.append(value[0])


var polyline:Array

#var front_center:Vector2=Vector2.ZERO

var number:int

var is_mine:bool=false

var state=Data.NORMAL:
	set=set_state

func set_state(value:int):
	state=value
	match state:
		Data.CLICKED:
			modulate_background=Data.background_modulate[Data.NORMAL]
			if number:
				state=Data.NUMBER
		Data.NUMBER:
			modulate_background=Data.background_modulate[Data.NORMAL]
		Data.NORMAL:
			modulate_background=Data.background_modulate[Data.NORMAL]
		Data.MINE:
			modulate_background=Data.background_modulate[Data.MINE]
		Data.WARN:
			modulate_background=Data.background_modulate[Data.WARN]
			state=Data.NUMBER
		Data.SHOW_ACTION:
			state=Data.NUMBER
		Data.SHOW_STOP:
			state=Data.NUMBER
	queue_redraw()

# _draw related variant
var modulate_background:Color=Color(1,1,1)

#block's neighbor
var neighbor:Array=Array()



func rotation_to(value:float):
	set_polygon(Array(get_polygon()).map(
		get_vector_rotation(value)
	))

func _on_block_input_event(viewport:Node,event:InputEvent,shape_idx:int):
	if not event is InputEventMouseButton:
		return
	match state:
		Data.NORMAL:
			if Input.is_action_just_pressed("right_click"):
				state_changed.emit(self,Data.FLAG)
			elif Input.is_action_just_pressed("left_click"):
				state_changed.emit(self,Data.WAIT)
		Data.WAIT:
			if Input.is_action_just_released("left_click"):
				if is_mine:
					state_changed.emit(self,Data.MINE)
				else:
					state_changed.emit(self,Data.CLICKED)
		Data.FLAG:
			if Input.is_action_just_pressed("right_click"):
				state_changed.emit(self,Data.NORMAL)
		Data.NUMBER:
			if Input.is_action_just_pressed("left_click"):
				state_changed.emit(self,Data.SHOW)
		Data.SHOW:
			if Input.is_action_just_released("left_click"):
				state_changed.emit(self,Data.SHOW_ACTION)



func _on_block_area_entered(area:Area2D):
	neighbor.append(area)

func _on_block_area_exited(area:Area2D):
	neighbor.erase(area)

func _on_block_mouse_entered():
	pass


func _on_block_mouse_exited():
	match state:
		Data.WAIT:
			state_changed.emit(self,Data.NORMAL)
		Data.SHOW:
			state_changed.emit(self,Data.SHOW_STOP)

func _draw():
	match state:
		Data.NORMAL:
			#draw front
			draw_front()
		Data.WAIT:
			#draw background
			draw_background()
		Data.CLICKED:
			#draw background
			draw_background()
		Data.NUMBER:
			#draw background and number
			draw_background()
			draw_number()
		Data.MINE:
			#draw red background and mine
			draw_background()
			draw_mine()
		Data.FLAG:
			#draw front and flag
			draw_front()
			draw_flag()
		Data.SHOW:
			#draw background and number
			draw_background()
			draw_number()


func draw_background():
	draw_colored_polygon(
		Array(get_polygon()).map(get_vector_add(-Data.draw_width_background_line)),
		Data.draw_color_background*modulate_background
	)
	draw_polyline(
		polyline.map(get_vector_add(-Data.draw_width_background_line/2)),
		Data.draw_color_gray*modulate_background,
		Data.draw_width_background_line,
		true
	)

func draw_front():
	draw_colored_polygon(
		Array(get_polygon()).map(get_vector_add(-Data.draw_width_normal_line)),
		Data.draw_color_normal
	)
	draw_polyline_colors(
		polyline.map(get_vector_add(-Data.draw_width_normal_line/2)),
		polyline.map(get_color_from_vector),
		Data.draw_width_normal_line,
		true
	)

func draw_mine():
	draw_colored_polygon(
		Data.draw_array_mine_bottom,
#		Data.draw_array_mine_bottom.map(get_front_pos),
		Data.draw_color_mine_bottom
	)
	draw_colored_polygon(
		Data.draw_array_mine_top,
#		Data.draw_array_mine_top.map(get_front_pos),
		Data.draw_color_mine_top
	)

func draw_flag():
	draw_colored_polygon(
		Data.draw_array_flag_bottom,
#		Data.draw_array_flag_bottom.map(get_front_pos),
		Data.draw_color_flag_bottom
	)
	draw_colored_polygon(
		Data.draw_array_flag_top,
#		Data.draw_array_flag_top.map(get_front_pos),
		Data.draw_color_flag_top
	)

func draw_number():
#	draw_char(
#		number_font,
#		Vector2(-Data.draw_size_font/4,Data.draw_size_font*0.4),
#		str(number),
#		Data.draw_size_font,
#		Data.number_modulate[number]
#	)
	%number.text=str(number)
	%number.modulate=Data.number_modulate[number]
	

func get_vector_rotation(value:float)->Callable:
	return func(vec:Vector2)->Vector2:
		return vec.rotated(value)

func get_vector_add(n:float)->Callable:
	return func(vec:Vector2)->Vector2:
		return vec+vec.normalized()*n

func get_color_from_vector(vector:Vector2)->Color:
	return Data.draw_color_base+\
		pow(abs((vector.angle()-Data.draw_sun_direction))/PI,0.4)*\
		Data.draw_color_addition


#func get_vertical_vector(index:int)->Vector2:
#	var pos1:Vector2=get_polygon()[index]
#	var pos2:Vector2=get_polygon()[(index+1)%get_polygon().size()]
#	var vec2sub1:Vector2=pos2-pos1
##	var temp:Vector2=pos1*vec2sub1
##	var k:float=-(temp.x+temp.y)/vec2sub1.length_squared()
#	var k:float=-(pos1.x*vec2sub1.x+pos1.y*vec2sub1.y)/vec2sub1.length_squared()
#	return k*vec2sub1+pos1



