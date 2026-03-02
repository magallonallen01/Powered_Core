extends Node2D

var map_node 

var build_mode = false
var build_valid = false 
var build_location
var build_type 

func _ready():
	map_node = get_node("Level_1")
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))

func _process(_delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	if build_mode:
		if event.is_action_released("ui_cancel"):
			cancel_build_mode()
		if event.is_action_released("ui_accept"):
			verify_and_build()
			cancel_build_mode()

func initiate_build_mode(tower_type):
	build_type = tower_type
	build_mode = true 
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tilemap = map_node.get_node("TowerExclusion")

	var current_tile = tilemap.local_to_map(mouse_position)
	var tile_position = tilemap.to_global(tilemap.map_to_local(current_tile))
	var cell_id = tilemap.get_cell_source_id(0, current_tile)

	if cell_id != -1:
		get_node("UI").update_tower_preview(tile_position, "#ffffff")
		build_valid = true
		build_location = tile_position
	else:
		get_node("UI").update_tower_preview(tile_position, "#000000")
		build_valid = false
		
func cancel_build_mode():
	build_mode = false 
	build_valid = false 
	if get_node("UI").has_node("TowerPreview"):
		get_node("UI/TowerPreview").queue_free()

func verify_and_build():
	if build_valid:
		var path = "res://Scene/Turrets/" + build_type + ".tscn"
		if ResourceLoader.exists(path):
			var tower_scene = load(path)
			var new_tower = tower_scene.instantiate()
			new_tower.global_position = build_location
			map_node.get_node("Turrets").add_child(new_tower)
		else:
			print("Error: Could not find tower scene at " + path)
