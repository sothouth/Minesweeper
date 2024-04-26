extends Control



func _ready():
	
	#map_size_array
	load_cfg()
	init_mine_shape()

func init_mine_shape():
	for i in %tabs.get_child_count():
		%mine_shape.add_item(tr("TK_"+str(%tabs.get_child(i).name)),i)
	%mine_shape.selected=%tabs.current_tab


func _on_mine_shape_item_selected(index:int):
	%tabs.current_tab=index

func _exit_tree():
	save_cfg()


func _on_accept_pressed():
	get_tree().change_scene_to_file(Path.singleGame[%tabs.get_tab_title(%tabs.current_tab)])
#	match %tabs.current_tab:
#		0:
#			get_tree().change_scene(Path.singleSquaresGame)
#		1:
#			get_tree().change_scene(Path.singleTriangularGame)
#		2:
#			get_tree().change_scene(Path.singleHoneycombGame)
#		_:
#			pass


func _on_back_pressed():
	get_tree().change_scene_to_file(Path.mainMenu)

func save_cfg():
	Global.config.set_value(
		"single_player_config",
		"no_guess",
		%no_guess.button_pressed
	)
	Global.config.set_value(
		"single_player_config",
		"flag_error_prompt",
		%flag_error_prompt.button_pressed
	)
	Global.config.set_value(
		"single_player_config",
		"current_tab",
		%tabs.current_tab
	)
	
	Global.cfg_save()


func load_cfg():
	%no_guess.button_pressed=Global.config.get_value(
		"single_player_config",
		"no_guess",
		true
	)
	%flag_error_prompt.button_pressed=Global.config.get_value(
		"single_player_config",
		"flag_error_prompt",
		true
	)
	%tabs.current_tab=Global.config.get_value(
		"single_player_config",
		"current_tab",
		0
	)


