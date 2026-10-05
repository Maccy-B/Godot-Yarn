extends Area3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var cellSize = Vector2(1, 1)
var defaultColor: Color = Color.GRAY
var full = false

func _ready() -> void:
	mesh_instance_3d.mesh = mesh_instance_3d.mesh.duplicate()
	collision_shape_3d.shape = collision_shape_3d.shape.duplicate()
	
	mesh_instance_3d.mesh.size = cellSize
	collision_shape_3d.shape.size = Vector3(cellSize.x, .01, cellSize.y)
	
	var mat := StandardMaterial3D.new()
	mat.albedo_color = defaultColor
	mesh_instance_3d.material_override = mat

func change_color(newColor: Color):
	(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = newColor

func get_rect():
	var center := Vector2(global_position.x, global_position.z)
	return Rect2(center - cellSize / 2.0, cellSize)
