extends Node3D


@onready var grid: Node3D = $Grid

const BIG_HOUSE = preload("res://BigHouse.tscn")
const SMALL_HOUSE = preload("res://SmallHouse.tscn")

var object
var is_valid = false
var object_cells

func _ready() -> void:
	$UI.house_selected.connect(start_placing)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place") and object and is_valid:
		_place_placement(object_cells)
	
	if object and event.is_action_pressed("rotate_building"):
		object.rotate_y(deg_to_rad(90))

func _process(delta: float) -> void:
	if not object: return
	
	var cell = _get_hovered_cell()
	if cell:
		_reset_highlight()
		object_cells = _get_object_cells(cell)
		is_valid = _check_and_highlight_cells(object_cells)
		
		var size := _get_footprint()
		var width := int(round(size.x / grid.cell_size.x))
		var depth := int(round(size.y / grid.cell_size.y))
		object.global_position = cell.global_position + Vector3((width - 1) * grid.cell_size.x / 2.0, 0, (depth - 1) * grid.cell_size.y / 2.0)
	
func _get_grid_position():
	var mouse_position_depth = 100
	var mouse_position := get_viewport().get_mouse_position()
	var current_camera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = current_camera.project_ray_origin(mouse_position)
	params.to = current_camera.project_position(mouse_position, mouse_position_depth)
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if not intersect: return
	
	
	if intersect.collider.get_parent().name == "Grid":
		return intersect.collider.global_position
	else:
		return

func _reset_highlight():
	for child in grid.get_children():
		child.change_color(grid.default_color)

func _get_object_cells(anchor):
	var cells = []
	var size := _get_footprint()
	var w := int(round(size.x / grid.cell_size.x))
	var d := int(round(size.y / grid.cell_size.y))
	
	var index: int = anchor.get_index()
	var col: int = index % grid.grid_width
	var row: int = index / grid.grid_width
	
	for r in range(row, row + d):
		for c in range(col, col + w):
			if c < grid.grid_width and r < grid.grid_height:
				cells.append(grid.get_child(r * grid.grid_width + c))
	
	return cells

func _check_and_highlight_cells(cells: Array):
	var valid = true
	var size := _get_footprint()
	var expectedCount := int(round(size.x / grid.cell_size.x)) * int(round(size.y / grid.cell_size.y))
	
	if cells.size() != expectedCount:
		valid = false
	
	for cell in cells:
		if cell.full:
			valid = false
			cell.change_color(Color.RED)
		else:
			cell.change_color(Color.GREEN)
	
	return valid


func _place_placement(object_cells):
	object = null
	is_valid = null
	
	for cell in object_cells:
		cell.full = true
	
	_reset_highlight()

func _get_hovered_cell():
	var mouse_position_depth = 100
	var mouse_position := get_viewport().get_mouse_position()
	var current_camera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = current_camera.project_ray_origin(mouse_position)
	params.to = current_camera.project_position(mouse_position, mouse_position_depth)
	params.collide_with_bodies = false
	params.collide_with_areas = true
	
	var worldspace := get_world_3d().direct_space_state
	var intersect := worldspace.intersect_ray(params)
	
	if not intersect: return null
	if intersect.collider.get_parent().name == "Grid":
		return intersect.collider
	return null

func _get_footprint() -> Vector2:
	var size: Vector2 = object.size
	var quarterTurns := int(round(object.rotation.y / (PI / 2)))
	if quarterTurns % 2 != 0:
		size = Vector2(size.y, size.x)
	return size

func start_placing(scene: PackedScene) -> void:
	if object:
		object = null
		_reset_highlight()
	
	object = scene.instantiate()
	add_child(object)
