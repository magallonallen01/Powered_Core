extends Node2D

func _physics_process(delta):
	turn()
	
func turn():
	var Enemy_Position = get_global_mouse_position()
	get_node("Turret").look_at(Enemy_Position)
