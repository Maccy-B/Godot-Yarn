extends Node3D


@onready var grid: Node3D = $Grid

const BIG_HOUSE = preload("res://BigHouse.tscn")
const SMALL_HOUSE = preload("res://SmallHouse.tscn")

var object
var isValid = false
var objectCells

func _ready() -> void:
	$UI.house_selected.connect(start_placing)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place") and object and isValid:
		_place_placement(objectCells)
	
	if object and event.is_action_pressed("rotate_building"):
		object.rotate_y(deg_to_rad(90))

func _process(delta: float) -> void:
	if not object: return
	
	var cell = _get_hovered_cell()
	if cell:
		_reset_highlight()
		objectCells = _get_object_cells(cell)
		isValid = _check_and_highlight_cells(objectCells)
		
		var size := _get_footprint()
		var w := int(round(size.x / grid.cellSize.x))
		var d := int(round(size.y / grid.cellSize.y))
		# Center the building over the block of cells it covers
		object.global_position = cell.global_position + Vector3((w - 1) * grid.cellSize.x / 2.0, 0, (d - 1) * grid.cellSize.y / 2.0)
	
func _get_grid_position():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
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
		child.change_color(grid.defaultColor)

func _get_object_cells(anchor):
	var cells = []
	var size := _get_footprint()
	var w := int(round(size.x / grid.cellSize.x))
	var d := int(round(size.y / grid.cellSize.y))
	
	var index: int = anchor.get_index()
	var col: int = index % grid.gridWidth
	var row: int = index / grid.gridWidth
	
	for r in range(row, row + d):
		for c in range(col, col + w):
			if c < grid.gridWidth and r < grid.gridHeight:
				cells.append(grid.get_child(r * grid.gridWidth + c))
	
	return cells

func _check_and_highlight_cells(cells: Array):
	var valid = true
	var size := _get_footprint()
	var expected_count := int(round(size.x / grid.cellSize.x)) * int(round(size.y / grid.cellSize.y))
	
	if cells.size() != expected_count:
		valid = false
	
	for cell in cells:
		if cell.full:
			valid = false
			cell.change_color(Color.RED)
		else:
			cell.change_color(Color.GREEN)
	
	return valid


func _place_placement(objectCells):
	object = null
	isValid = null
	
	for cell in objectCells:
		cell.full = true
	
	_reset_highlight()

func _get_hovered_cell():
	var mousePositionDepth = 100
	var mousePosition := get_viewport().get_mouse_position()
	var currentCamera := get_viewport().get_camera_3d()
	var params := PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, mousePositionDepth)
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
	# Swap width/depth when rotated 90 or 270 degrees
	var quarter_turns := int(round(object.rotation.y / (PI / 2)))
	if quarter_turns % 2 != 0:
		size = Vector2(size.y, size.x)
	return size

func start_placing(scene: PackedScene) -> void:
	# Replace any building that is currently being placed
	if object:
		object.queue_free()
		object = null
		_reset_highlight()
	
	object = scene.instantiate()
	add_child(object)
