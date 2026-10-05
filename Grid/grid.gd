@tool
extends Node3D

@export var gridWidth := 5:
	set(value):
		gridWidth = value
		_rebuild_grid()
@export var gridHeight := 5:
	set(value):
		gridHeight = value
		_rebuild_grid()
@export var cellSize: Vector2 = Vector2(1, 1):
	set(value):
		cellSize = value
		_rebuild_grid()
@export var defaultColor: Color = Color.GRAY

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
	for height in range(gridHeight):
		for width in range(gridWidth):
			var gridCell = GRID_CELL.instantiate()
			gridCell.cellSize = cellSize
			gridCell.defaultColor = defaultColor
			add_child(gridCell)
			gridCell.position = Vector3(width * cellSize.x, 0, height * cellSize.y)
