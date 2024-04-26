extends Node


var config:ConfigFile=ConfigFile.new()

func _ready():
	cfg_load()
	game_init()
	

func _exit_tree():
	cfg_save()

func game_init():
	if config.has_section("game_config"):
		TranslationServer.set_locale(config.get_value("game_config","language"))
		DisplayServer.window_set_mode(config.get_value("game_config","display_mode"))

func cfg_load():
	var err=config.load(Path.gameConfig)
	if err!=OK:
		return



func cfg_save():
	config.save(Path.gameConfig)




