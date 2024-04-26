extends Control

class_name SingleGame


#need fill

var game_name:String
var self_path:String

@onready
var packedBlock:PackedScene=load(Path.block)

var flag_error_prompt:bool

#normal variant
var start_time:int=0
var game_state:int=Data.READY:
	set(value):
		match value:
			Data.READY:
				%game_state.text=tr("TK_READY")
			Data.RUN:
				start_time=Time.get_ticks_msec()
				%game_state.text=""
			Data.DEAD:
				game_time
				%game_state.text=tr("TK_DEAD")
			Data.COMPLETED:
				game_time
				%game_state.text=tr("TK_COMPLETED")
		game_state=value

var game_time:int:
	get:
		if game_state==Data.RUN:
			game_time=Time.get_ticks_msec()-start_time
		return game_time

var zoom:float:
	set(value):
		zoom=value
		%camera.zoom=Vector2(value,value)

#has clicked block number
var clicked_number:int=0

# has flaged block number
var flag_number:int=0

#vectory condition
var need_click_number:int=0

#game map size
var map_size:Vector2i

#game_rect pixel size
var rect_size:Vector2i

#game mine number
var mine_number:int


func _ready():
	loag_global_cfg()
	load_cfg()
	
	need_click_number-=mine_number
	
	$/root.size_changed.connect(_on_root_size_changed)
	
	
	%time.text="000:00.00"
	%mine_number.text=str(mine_number)
	
	init_game_map()

func load_cfg():
#	mine_number=Global.config.get_value(
#		"single_squares_config",
#		"mine_number"
#	)
#	map_size=Global.config.get_value(
#		"single_squares_config",
#		"size"
#	)
	pass

func loag_global_cfg():
	flag_error_prompt=Global.config.get_value(
		"single_player_config",
		"flag_error_prompt",
		false
	)

func _on_root_size_changed():
	var now_size:Vector2=DisplayServer.window_get_size()/2
	$camera.limit_top=-now_size.y/%camera.zoom.y
	$camera.limit_left=-now_size.x/%camera.zoom.x
	$camera.limit_right=(rect_size.x+now_size.x)/%camera.zoom.x
	$camera.limit_bottom=(rect_size.y+now_size.y)/%camera.zoom.y


func _exit_tree():
	pass


func _process(delta):
	if game_state==Data.RUN:
		%time.text=formatting_time(game_time)
	%flaged.text=str(flag_number)

func formatting_time(msec_time:int)->String:
	var msec=msec_time%1000
	var sec=msec_time/1000%60
	var min=msec_time/60000
	return str(min).lpad(3,"0")+":"+str(sec).lpad(2,"0")+"."+str(msec/10).lpad(2,"0")

func init_game_map():
	spawn_map_with(map_size)
	init_rect_size()
	%camera.position=rect_size/2
	_on_root_size_changed()

func spawn_map_with(map_size:Vector2i):
#	for i in range(map_size.x):
#		for j in range(map_size.y):
#			spawn_block_with(Vector2i(i,j))
	pass

func spawn_block_with(
	position:Vector2i,
	polygon:PackedVector2Array,
	rotation:float=0.0
)->Block:
	var block:Block=packedBlock.instantiate()
	block.position=position
	block.set_polygon(polygon)
	block.rotation_to(rotation)
	%game_rect.add_child(block)
	block.state_changed.connect(_on_block_state_changed)
	need_click_number+=1
	return block

func init_rect_size():
#	rect_size=block_size*(map_size-Vector2i.ONE)
	pass

func _on_block_state_changed(block:Block,new_state):
	if game_state!=Data.READY and game_state!=Data.RUN:
		return
	var old_state=block.state
	block.state=new_state
	match new_state:
		Data.CLICKED:
			if clicked_number==0:
				#game start
				game_state=Data.RUN
				block.except=true
				block.neighbor.map(block_except)
				spawn_mine()
			#normal process click
			clicked_number+=1
			var boundaries:Array=[block]
			while true:
				boundaries=boundaries.filter(
					func(block):
						return block.number==0
				)
				var next_boundaries:Array
				for boundary in boundaries:
					boundary.neighbor.filter(
						block_check_state(Data.NORMAL)
					).map(
						func(block):
							if not next_boundaries.has(block):
								next_boundaries.append(block)
					)
				boundaries=next_boundaries
				if boundaries.is_empty():
					break
				boundaries.map(
					func(block):
						block.state=Data.CLICKED
						clicked_number+=1
				)
			if clicked_number==need_click_number:
				completed()
		Data.NUMBER:
			pass
		Data.MINE:
			dead()
		Data.FLAG:
			flag_number+=1
			if flag_error_prompt:
				block.neighbor.filter(
					func(block):
						return block.state==Data.NUMBER and block.number<block.neighbor.filter(
							block_check_state(Data.FLAG)
						).size()
				).map(
					block_set_state(Data.WARN)
				)
		Data.NORMAL:
			if old_state==Data.FLAG:
				flag_number-=1
				if flag_error_prompt:
					block.neighbor.filter(
						func(block):
							return block.state==Data.NUMBER and block.number>=block.neighbor.filter(
								block_check_state(Data.FLAG)
							).size()
					).map(
						block_set_state(Data.NUMBER)
					)
		Data.WAIT:
			pass
		Data.SHOW:
			block.neighbor.filter(
				block_check_state(Data.NORMAL)
			).map(
				block_set_state(Data.WAIT)
			)
		Data.SHOW_ACTION:
			var flag_neighbor:Array=block.neighbor.filter(
				block_check_state(Data.FLAG)
			)
			if flag_neighbor.size()==block.number:
				block.neighbor.filter(
					block_check_state(Data.WAIT)
				).map(
					func(block):
						block.state_changed.emit(block,Data.CLICKED)
				)
			else:
				block.state_changed.emit(block,Data.SHOW_STOP)
		Data.SHOW_STOP:
			block.neighbor.filter(
				block_check_state(Data.WAIT)
			).map(
				block_set_state(Data.NORMAL)
			)

func dead():
	game_state=Data.DEAD


func completed():
	game_state=Data.COMPLETED

func spawn_mine():
	for i in range(mine_number):
		var block:Block=rand_block()
		while not can_spawn_mine(block):
			block=rand_block()
		block.is_mine=true
		block.neighbor.map(block_add_number)

func rand_block()->Block:
	return %game_rect.get_child(randi()%%game_rect.get_child_count())

func can_spawn_mine(block:Block)->bool:
	if block.is_mine:
		return false
	if block.except:
		return false
	return true

func block_add_number(block:Block):
	block.number+=1

func block_except(block:Block):
	block.except=true

func block_check_state(state:int)->Callable:
	return func(block:Block)->bool:
		return block.state==state

func block_set_state(state:int)->Callable:
	return func(block:Block):
		block.state=state

func _on_quit_pressed():
	get_tree().change_scene_to_file(Path.singlePlayerMenu)


func _on_restart_pressed():
	get_tree().change_scene_to_file(self_path)
