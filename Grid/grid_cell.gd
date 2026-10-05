extends Area3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

var cell_size = Vector2(1, 1)
var default_color: Color = Color.GRAY
var full = false

func _ready() -> void:
	mesh_instance_3d.mesh = mesh_instance_3d.mesh.duplicate()
	collision_shape_3d.shape = collision_shape_3d.shape.duplicate()
	
	mesh_instance_3d.mesh.size = cell_size
	collision_shape_3d.shape.size = Vector3(cell_size.x, .01, cell_size.y)
	
	var mat := StandardMaterial3D.new()
	mat.albedo_color = default_color
	mesh_instance_3d.material_override = mat

func change_color(newColor: Color):
	(mesh_instance_3d.material_override as StandardMaterial3D).albedo_color = newColor

func get_rect():
	var center := Vector2(global_position.x, global_position.z)
	return Rect2(center - cell_size / 2.0, cell_size)
