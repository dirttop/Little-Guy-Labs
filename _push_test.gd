extends Node3D

var platform: Node3D
var box1: Node3D
var box2: Node3D
var button: Node3D
var box_on_button: Node3D
var frame := 0

func _make_floor() -> void:
	var fl := StaticBody3D.new()
	var fcol := CollisionShape3D.new()
	var fshape := BoxShape3D.new()
	fshape.size = Vector3(60, 1, 60)
	fcol.shape = fshape
	fl.add_child(fcol)
	fl.position = Vector3(0, -0.5, 0)  # top at y=0
	add_child(fl)

func _make_wall(x: float) -> void:
	var w := StaticBody3D.new()
	var wcol := CollisionShape3D.new()
	var wshape := BoxShape3D.new()
	wshape.size = Vector3(0.5, 4, 8)
	wcol.shape = wshape
	w.add_child(wcol)
	w.position = Vector3(x, 1, 0)
	add_child(w)

func _ready() -> void:
	_make_floor()
	_make_wall(7.0)  # wall so the chain jams

	# Two boxes in a row: platform -> box1 -> box2 -> wall
	box1 = load("res://elements/rigids/box.tscn").instantiate()
	add_child(box1); box1.global_position = Vector3(2.0, 0.5, 0)
	box2 = load("res://elements/rigids/box.tscn").instantiate()
	add_child(box2); box2.global_position = Vector3(3.05, 0.5, 0)

	platform = load("res://elements/environment/scenes/objects/platform/platform.tscn").instantiate()
	platform.travel = Vector3(10, 0, 0)
	platform.speed = 3.0
	add_child(platform); platform.global_position = Vector3(0, 0.15, 0)
	platform._active_count = 1  # force active

	# Separate: a button with a box resting on it
	button = load("res://elements/environment/scenes/objects/button/button.tscn").instantiate()
	add_child(button); button.global_position = Vector3(-5, 0, 0)  # base sits on floor top 0
	box_on_button = load("res://elements/rigids/box.tscn").instantiate()
	add_child(box_on_button); box_on_button.global_position = Vector3(-5, 0.72, 0)

	print("box.layer=%d box.mask=%d plat.layer=%d plat.mask=%d btn.zone_mask=%d" % [
		box1.collision_layer, box1.collision_mask, platform.collision_layer,
		platform.collision_mask, button.get_node("PressZone").collision_mask])

func _physics_process(_delta: float) -> void:
	frame += 1
	if frame % 12 == 0:
		print("f%3d plat.x=%6.3f box1.x=%6.3f box2.x=%6.3f | btn.pressed=%s (bodies=%d)" % [
			frame, platform.global_position.x, box1.global_position.x, box2.global_position.x,
			str(button.is_pressed()), button._bodies])
	if frame > 140:
		get_tree().quit()
