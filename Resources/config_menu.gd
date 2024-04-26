extends Control

signal changed(String,Callable)

@onready
var Confirm:PackedScene=load(Path.confirm)

var language_code=["en","zh_Hans_CN"]
var language_name=["English","简体中文"]
var now_language_code

var accept_action:Dictionary={}

func _ready():
	init_screen_option()
	now_language_code=TranslationServer.get_locale()
	for name in language_name:
		%language.add_item(name)
	%language.selected=language_code.find(now_language_code)
	if %language.selected==-1:
		%language.selected=%language_code.find("en")
	changed.connect(_on_changed)

func _exit_tree():
	save_cfg()


func init_screen_option():
	var screen_mode=DisplayServer.window_get_mode()
	match screen_mode:
		2:
			%screen.selected=%screen.get_item_index(0)
		_:
			%screen.selected=%screen.get_item_index(screen_mode)


func _on_changed(name:String,action:Callable):
	accept_action[name]=action
	%accept.disabled=false


func _on_screen_item_selected(index):
	emit_signal("changed",
	"_on_screen_item_selected",DisplayServer.window_set_mode.bind(%screen.get_item_id(index)))


func _on_language_item_selected(index):
	emit_signal("changed",
	"_on_language_item_selected",TranslationServer.set_locale.bind(language_code[index]))


func _on_accept_pressed():
	%accept.disabled=true
	for action in accept_action.values():
		action.call()
	save_cfg()
	#get_tree().reload_current_scene()


func _on_back_pressed():
	if not accept_action.is_empty():
		var confirm:ConfirmationDialog=Confirm.instantiate()
		add_child(confirm)
		confirm.set_text(tr("TK_The_changes_have_not_been_saved"))
		confirm.accept.pressed.connect(change_to_main)
		confirm.custom_action.connect(_exit_and_save)
		confirm.add_button(tr("TK_exit_and_save"),true,"exit_and_save")
		confirm.popup()
	else:
		change_to_main()

func _exit_and_save(action:String):
	_on_accept_pressed()
	change_to_main()


func change_to_main():
	get_tree().change_scene_to_file(Path.mainMenu)

func save_cfg():
	Global.config.set_value("game_config","display_mode",DisplayServer.window_get_mode())
	Global.config.set_value("game_config","language",TranslationServer.get_locale())
	Global.cfg_save()

