extends Node

func _ready():
	get_node("Main_Menu/M/VB/Start").pressed.connect(on_new_game_pressed)
	get_node("Main_Menu/M/VB/Quit").pressed.connect(on_quit_pressed)
	
func on_new_game_pressed():
	get_node("Main_Menu").queue_free()
	var game_scene_resource = load("res://Scene/MainScene/game_scene.tscn")
	var game_scene_instance = game_scene_resource.instantiate()
	
	add_child(game_scene_instance)

func on_quit_pressed():
	get_tree().quit()
