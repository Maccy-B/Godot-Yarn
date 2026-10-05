@tool
extends Node3D

@export var grid_width := 5:
	set(value):
		grid_width = value
		_rebuild_grid()
@export var grid_height := 5:
	set(value):
		grid_height = value
		_rebuild_grid()
@export var cell_size: Vector2 = Vector2(1, 1):
	set(value):
		cell_size = value
		_rebuild_grid()
@export var default_color: Color = Color.GRAY

const GRID_CELL = preload("res://Grid/grid_cell.tscn")


func _ready():
	_rebuild_grid()

func _rebuild_grid():
	if not is_inside_tree():
		return
	_remove_grid()
	_create_grid()

func _remove_grid():
	for node in get_children():
		remove_child(node)
		node.queue_free()

func _create_grid():
	for height in range(grid_height):
		for width in range(grid_width):
			var grid_cell = GRID_CELL.instantiate()
			grid_cell.cell_size = cell_size
			grid_cell.default_color = default_color
			add_child(grid_cell)
			grid_cell.position = Vector3(width * cell_size.x, 0, height * cell_size.y)
