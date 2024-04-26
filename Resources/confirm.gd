extends ConfirmationDialog


@onready
var cancel:Button=get_cancel_button()
@onready
var accept:Button=get_ok_button()

func _ready():
	$/root.size_changed.connect(_on_need_center)



func _on_need_center():
	set_position((DisplayServer.window_get_size()-get_size_with_decorations())/2)
