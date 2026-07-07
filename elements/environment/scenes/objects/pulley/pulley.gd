class_name Pulley
extends Node3D

## A weight-based counterweight pulley. Two ride-on platforms hang from a shared
## rope: whichever side carries more mass sinks while the other rises by the same
## amount (an Atwood machine). When the two sides balance, the pulley holds
## position. Bodies are weighed by their `mass` property if they have one (the
## player does), otherwise by [member default_weight] (boxes and anything else).

signal moved(a_descent: float)  ## emitted while moving; + = side A descending

## How far each platform can travel from its neutral position, in metres.
@export var max_travel := 2.0
## Platform movement speed while the sides are imbalanced, in metres / second.
@export var speed := 1.5
## Weight assigned to bodies that don't expose a `mass` property (e.g. boxes).
@export var default_weight := 50.0
## Minimum weight difference between the two sides before the pulley moves.
@export var balance_threshold := 0.5

@onready var _a: AnimatableBody3D = $PlatformA
@onready var _b: AnimatableBody3D = $PlatformB
@onready var _sensor_a: Area3D = $PlatformA/LoadSensor
@onready var _sensor_b: Area3D = $PlatformB/LoadSensor

var _a_start := Vector3.ZERO
var _b_start := Vector3.ZERO
# How far side A has descended from neutral. + = A down / B up, - = A up / B down.
var _descent := 0.0


func _ready() -> void:
	_a_start = _a.global_position
	_b_start = _b.global_position


func _physics_process(delta: float) -> void:
	var diff := _load(_sensor_a) - _load(_sensor_b)
	if absf(diff) > balance_threshold:
		# The heavier side (positive diff = A) moves down.
		var next := clampf(_descent + signf(diff) * speed * delta, -max_travel, max_travel)
		if next != _descent:
			_descent = next
			moved.emit(_descent)
	_apply()


func _apply() -> void:
	_a.global_position = _a_start + Vector3.DOWN * _descent
	_b.global_position = _b_start + Vector3.UP * _descent


func _load(sensor: Area3D) -> float:
	var total := 0.0
	for body in sensor.get_overlapping_bodies():
		total += _weight_of(body)
	return total


func _weight_of(body: Node) -> float:
	var m: Variant = body.get("mass")
	if (m is float or m is int) and float(m) > 0.0:
		return float(m)
	return default_weight
