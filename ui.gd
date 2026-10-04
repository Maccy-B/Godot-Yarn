extends Control


@onready var house = preload("res://smallhouse.tscn")
@onready var bighouse = preload("res://bighouse.tscn")

var camera
var instance
var placing = false
var rango = 1000

func _ready():
	if placing:
		camera = get_viewport().get_mouse_position()

func _process(delta: float) -> void:
	if placing:
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = camera.project_ray_origin(mouse_pos)
		var ray_end = ray_origin + camera.project_ray_normal

func _on_item_list_item_selected(index: int) -> void:
	if index == 0:
		instance = house.instantiate()
	if index == 1:
		instance = bighouse.instantiate()
