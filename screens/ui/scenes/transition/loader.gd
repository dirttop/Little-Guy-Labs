extends Line2D

@export var width_scale: float = 150.0
@export var detail: int = 150

@export_range(0.0, 1.0) var progress: float = 0.0

@export_range(0.1, 1.0) var snake_length: float = 0.2

var path_points: PackedVector2Array = []

func _process(delta: float) -> void:
	_reshape()
	progress = $Timer.time_left / $Timer.wait_time

func _reshape():
	path_points.clear()
	
	for i in range(detail):
		var t = (float(i) / detail) * TAU
		
		var denom = (1.0 + pow(sin(t), 2))
		var x = (width_scale * cos(t)) / denom
		var y = (width_scale * sin(t) * cos(t)) / denom
		
		path_points.append(Vector2(x, y))
		
	_update_snake()

func _update_snake():
	if path_points.is_empty(): 
		return

	var total = path_points.size()
	var head = int(total * progress)
	var indices = int(total * snake_length)
	var tail = head - indices
	
	var snake_points = PackedVector2Array()

	if tail >= 0:
		snake_points = path_points.slice(tail, head)
	else:
		var real_tail = total + tail
		snake_points.append_array(path_points.slice(real_tail, total))
		snake_points.append_array(path_points.slice(0, head))

	points = snake_points
