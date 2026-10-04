@tool
extends Area3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var cellSize = Vector2(1,1)
var full = false

func _ready() -> void:
	mesh_instance_3d.mesh.size = cellSize
	collision_shape_3d.shape.size = Vector3(cellSize.x, .01, cellSize.y)
	
	#change_color(get_parent().defaultColor)

func get_rect():
	return Rect2(Vector2(global_position.x, global_position.z), cellSize)

func change_color(newColor: Color):
	var mat := mesh_instance_3d.get_active_material(0) as StandardMaterial3D
	if mat == null:
		mat = StandardMaterial3D.new()
		mesh_instance_3d.material_override = mat
	mat.albedo_color = newColor
