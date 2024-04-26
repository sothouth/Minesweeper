extends Control





func _on_single_pressed():
	get_tree().change_scene_to_file(Path.singlePlayerMenu)


func _on_multi_pressed():
	get_tree().change_scene_to_file(Path.multiPlayerMenu)


func _on_config_pressed():
	get_tree().change_scene_to_file(Path.configMenu)


func _on_quit_pressed():
	get_tree().quit()
