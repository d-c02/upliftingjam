extends TextureButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
