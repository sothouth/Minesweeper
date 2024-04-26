extends VBoxContainer

class_name GameConfigTab

#need fill
var config_section:String

var size_option_data:Array

var map_size_array:Array=["TK_small","TK_medium","TK_large","TK_custom"]

func _ready():
	init_size_option()
	load_cfg()


func init_size_option():
	for i in range(len(map_size_array)):
		%size_option.add_item(tr(map_size_array[i]),i)

func _exit_tree():
	save_cfg()

func save_cfg():
	Global.config.set_value(
		config_section,
		"size_option",
		%size_option.selected
	)
	Global.config.set_value(
		config_section,
		"size",
		Vector2i(%size_x.value,%size_y.value)
	)
	Global.config.set_value(
		config_section,
		"mine_number",
		%mine_number.value
	)
	Global.config.set_value(
		config_section,
		"zoom",
		%zoom.value
	)
	
	Global.cfg_save()


func load_cfg():
	%size_option.selected=Global.config.get_value(
		config_section,
		"size_option",
		0
	)
	var temp:Vector2i=Global.config.get_value(
		config_section,
		"size",
		Vector2i(9,9)
	)
	%size_x.value=temp.x
	%size_y.value=temp.y
	%mine_number.value=Global.config.get_value(
		config_section,
		"mine_number",
		10
	)
	%zoom.value=Global.config.get_value(
		config_section,
		"zoom",
		1
	)


func _on_size_option_item_selected(index:int):
	match index:
		0,1,2:
			%size_x.editable=false
			%size_y.editable=false
			%mine_number.editable=false
			%size_x.value=size_option_data[index][0]
			%size_y.value=size_option_data[index][1]
			%mine_number.value=size_option_data[index][2]
		3:
			%size_x.editable=true
			%size_y.editable=true
			%mine_number.editable=true




