extends Node3D

func quit():
	get_tree().quit()
	
func play():
	get_tree().change_scene_to_file("res://Scenes/island.tscn")
