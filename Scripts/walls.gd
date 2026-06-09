extends Node2D

@export var ROTSPEED : float = PI
@onready var main_camera: Camera2D = %MainCamera

func _rotate_world_around_pivot(pivot: Vector2, angle: float) -> void:
	for child in get_children():
		if child is Node2D:
			var node = child as Node2D
			var offset = node.global_position - pivot
			var rotated_offset = offset.rotated(angle)
			node.global_position = pivot + rotated_offset
			node.rotation += angle

func _physics_process(delta: float) -> void:
	var middle = main_camera.get_screen_center_position()
	
	if Input.is_action_pressed("rotateL"):
		_rotate_world_around_pivot(middle, -delta * ROTSPEED)

		
	elif Input.is_action_pressed("rotateR"):
		_rotate_world_around_pivot(middle, delta * ROTSPEED)
	
